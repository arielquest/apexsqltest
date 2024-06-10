SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<06/02/2018>
-- Descripción :			<Consulta en que tablas de catálogo se encuentra asociado un valor de un catálogo intermedio.> 
-- =================================================================================================================================================
-- Modificación:			
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarCatalogoIntermedioAsociacion]
	@Esquema		VARCHAR(50),
	@Tabla			VARCHAR(50),
	@Codigo1		VARCHAR(50),
	@Codigo2		VARCHAR(50)
AS
BEGIN

	DECLARE	--CONSTANTES
		@ConstraintLlavePrimaria	VARCHAR(11)	= 'PRIMARY KEY',
		@NombreParametroCodigo1		VARCHAR(50)	= '@ParamCodigo1',
		@NombreParametroCodigo2		VARCHAR(50)	= '@ParamCodigo2',
		@NombreParametroRegistros	VARCHAR(50)	= '@ParamRegistros';
	DECLARE	--CONSTANTES
		@DefinicionParametros		NVARCHAR(256) = @NombreParametroCodigo1 + ' VARCHAR(100), ' + @NombreParametroCodigo2 + ' VARCHAR(100), ' + @NombreParametroRegistros + ' INT OUTPUT';

	DECLARE	
		@TotalRegistros			INT				= 0,
		@Indice					INT				= 0,
		@SQL1					NVARCHAR(MAX)	= NULL,
		@SQL2					NVARCHAR(MAX)	= NULL,
		@ParametroRegistros1	INT				= NULL,
		@ParametroRegistros2	INT				= NULL;

	DECLARE @LlavePrimaria AS TABLE
	(
		CONSTRAINT_CATALOG		NVARCHAR(256)		NOT NULL,
		CONSTRAINT_SCHEMA		NVARCHAR(256)		NOT NULL,
		CONSTRAINT_NAME			NVARCHAR(256)		NOT NULL,
		TABLE_NAME				NVARCHAR(256)		NOT NULL
	);

	INSERT		@LlavePrimaria
	SELECT		PK.CONSTRAINT_CATALOG,
				PK.CONSTRAINT_SCHEMA,
				PK.CONSTRAINT_NAME,
				PK.TABLE_NAME
	FROM		INFORMATION_SCHEMA.TABLE_CONSTRAINTS		PK WITH(NOLOCK)
	INNER JOIN	INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE	PKC WITH(NOLOCK)
	ON			PK.CONSTRAINT_CATALOG						= PKC.CONSTRAINT_CATALOG
	AND			PK.CONSTRAINT_SCHEMA						= PKC.CONSTRAINT_SCHEMA
	AND			PK.CONSTRAINT_NAME							= PKC.CONSTRAINT_NAME
	AND			PK.TABLE_NAME								= PKC.TABLE_NAME
	WHERE		PK.TABLE_NAME								= @Tabla
	AND			PK.CONSTRAINT_TYPE							= @ConstraintLlavePrimaria
	GROUP BY	PK.CONSTRAINT_CATALOG,
				PK.CONSTRAINT_SCHEMA,
				PK.CONSTRAINT_NAME,
				PK.TABLE_NAME
	HAVING		COUNT(*) = 2;

	DECLARE @Resultado AS TABLE
	(
		SQLString1		NVARCHAR(MAX)		NULL,
		SQLString2		NVARCHAR(MAX)		NULL,
		Esquema			NVARCHAR(256)		NOT NULL,
		Tabla			NVARCHAR(256)		NOT NULL,
		Referencia		NVARCHAR(256)		NOT NULL,
		Registros		INT					NULL
	);

	INSERT INTO	@Resultado
	SELECT		NULL,
				NULL,
				FKC.TABLE_SCHEMA,
				FKC.TABLE_NAME,
				FKC.CONSTRAINT_NAME,
				NULL
	FROM		@LlavePrimaria								PK
	INNER JOIN	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS	FK WITH(NOLOCK)
	ON			FK.UNIQUE_CONSTRAINT_CATALOG				= PK.CONSTRAINT_CATALOG
	AND			FK.UNIQUE_CONSTRAINT_SCHEMA					= PK.CONSTRAINT_SCHEMA
	AND			FK.UNIQUE_CONSTRAINT_NAME					= PK.CONSTRAINT_NAME
	INNER JOIN	INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE	FKC WITH(NOLOCK)
	ON			FKC.CONSTRAINT_NAME							= FK.CONSTRAINT_NAME
	WHERE		FK.CONSTRAINT_SCHEMA						= @Esquema
	GROUP BY	FKC.TABLE_SCHEMA, FKC.TABLE_NAME, FKC.CONSTRAINT_NAME;

	UPDATE		@Resultado
	SET			SQLString1 = 'SELECT ' + @NombreParametroRegistros + ' = COUNT(*) FROM ' + Esquema + '.' + Tabla + ' WHERE ' + 
								(SELECT TOP 1 'CAST(' + C.COLUMN_NAME + ' AS VARCHAR)' FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE C WITH(NOLOCK) WHERE C.CONSTRAINT_NAME = Referencia ORDER BY C.COLUMN_NAME ASC) + ' = ' + @NombreParametroCodigo1 + ' AND ' +
								(SELECT TOP 1 'CAST(' + C.COLUMN_NAME + ' AS VARCHAR)' FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE C WITH(NOLOCK) WHERE C.CONSTRAINT_NAME = Referencia ORDER BY C.COLUMN_NAME DESC) + ' = ' + @NombreParametroCodigo2 + ';'
				,
				SQLString2 = 'SELECT ' + @NombreParametroRegistros + ' = COUNT(*) FROM ' + Esquema + '.' + Tabla + ' WHERE ' + 
								(SELECT TOP 1 'CAST(' + C.COLUMN_NAME + ' AS VARCHAR)' FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE C WITH(NOLOCK) WHERE C.CONSTRAINT_NAME = Referencia ORDER BY C.COLUMN_NAME DESC) + ' = ' + @NombreParametroCodigo1 + ' AND ' +
								(SELECT TOP 1 'CAST(' + C.COLUMN_NAME + ' AS VARCHAR)' FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE C WITH(NOLOCK) WHERE C.CONSTRAINT_NAME = Referencia ORDER BY C.COLUMN_NAME ASC) + ' = ' + @NombreParametroCodigo2 + ';'

	SET @TotalRegistros = (SELECT COUNT(*) FROM @Resultado);
	IF (@TotalRegistros > 0)
	BEGIN
		WHILE @Indice < @TotalRegistros
		BEGIN
			SELECT @SQL1 = SQLString1, @SQL2 = SQLString2 FROM @Resultado ORDER BY SQLString1 OFFSET @Indice ROWS FETCH NEXT 1 ROWS ONLY;
		
			EXEC sp_executesql 
				@stmt				= @SQL1, 
				@params				= @DefinicionParametros,
				@ParamRegistros		= @ParametroRegistros1 OUTPUT,
				@ParamCodigo1		= @Codigo1,
				@ParamCodigo2		= @Codigo2;

			EXEC sp_executesql 
				@stmt				= @SQL2, 
				@params				= @DefinicionParametros,
				@ParamRegistros		= @ParametroRegistros2 OUTPUT,
				@ParamCodigo1		= @Codigo1,
				@ParamCodigo2		= @Codigo2;

			IF (@ParametroRegistros1 > 0 OR @ParametroRegistros2 > 0)
			BEGIN
				UPDATE	@Resultado
				SET		Registros		= @ParametroRegistros1 + @ParametroRegistros2
				WHERE	SQLString1		= @SQL1;
			END

			SET @Indice = @Indice + 1;
		END

		DELETE	@Resultado
		WHERE	Registros IS NULL;
	END

	SELECT Esquema + '.' + Tabla AS Tabla, 'Split' AS Split, Registros FROM @Resultado;
END
GO
