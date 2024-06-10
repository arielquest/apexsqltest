SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<22/01/2018>
-- Descripción :			<Consulta en que tablas de catálogo se encuentra asociado un valor de un catálogo.> 
-- =================================================================================================================================================
-- Modificación:			
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarCatalogoAsociacion]
	@Esquema		VARCHAR(50),
	@Tabla			VARCHAR(50),
	@Codigo			VARCHAR(50)
AS
BEGIN

	DECLARE	--CONSTANTES
		@ConstraintLlavePrimaria	VARCHAR(11)	= 'PRIMARY KEY',
		@NombreParametroCodigo		VARCHAR(50)	= '@ParamCodigo',
		@NombreParametroRegistros	VARCHAR(50)	= '@ParamRegistros';
	DECLARE	--CONSTANTES
		@DefinicionParametros		NVARCHAR(256) = @NombreParametroCodigo + ' VARCHAR(100), ' + @NombreParametroRegistros + ' INT OUTPUT';

	DECLARE	
		@TotalRegistros		INT				= 0,
		@Indice				INT				= 0,
		@SQL				NVARCHAR(MAX)	= NULL,
		@ParametroRegistros	INT				= NULL;

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
	HAVING		COUNT(*) = 1;

	DECLARE @Resultado AS TABLE
	(
		SQLString		NVARCHAR(MAX)		NOT NULL,
		Esquema			NVARCHAR(256)		NOT NULL,
		Tabla			NVARCHAR(256)		NOT NULL,
		Registros		INT					NULL
	);

	INSERT INTO	@Resultado
	SELECT		'SELECT ' + @NombreParametroRegistros + ' = COUNT(*) FROM ' + FKC.TABLE_SCHEMA + '.' + FKC.TABLE_NAME + ' WHERE ' + FKC.COLUMN_NAME + ' = ' + @NombreParametroCodigo + ';',
				FKC.TABLE_SCHEMA,
				FKC.TABLE_NAME,
				NULL
	FROM		@LlavePrimaria								PK
	INNER JOIN	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS	FK WITH(NOLOCK)
	ON			FK.UNIQUE_CONSTRAINT_CATALOG				= PK.CONSTRAINT_CATALOG
	AND			FK.UNIQUE_CONSTRAINT_SCHEMA					= PK.CONSTRAINT_SCHEMA
	AND			FK.UNIQUE_CONSTRAINT_NAME					= PK.CONSTRAINT_NAME
	INNER JOIN	INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE	FKC WITH(NOLOCK)
	ON			FKC.CONSTRAINT_NAME							= FK.CONSTRAINT_NAME
	WHERE		FK.CONSTRAINT_SCHEMA						= @Esquema

	SET @TotalRegistros = (SELECT COUNT(*) FROM @Resultado);
	IF (@TotalRegistros > 0)
	BEGIN
		WHILE @Indice < @TotalRegistros
		BEGIN
			SET @SQL = (SELECT SQLString FROM @Resultado ORDER BY SQLString OFFSET @Indice ROWS FETCH NEXT 1 ROWS ONLY);
		
			EXEC sp_executesql 
				@stmt				= @SQL, 
				@params				= N'@ParamCodigo VARCHAR(100), @ParamRegistros INT OUTPUT',
				@ParamRegistros		= @ParametroRegistros OUTPUT,
				@ParamCodigo		= @Codigo;

			IF (@ParametroRegistros > 0)
			BEGIN
				UPDATE	@Resultado
				SET		Registros		= @ParametroRegistros
				WHERE	SQLString		= @SQL;
			END

			SET @Indice = @Indice + 1;
		END

		DELETE	@Resultado
		WHERE	Registros IS NULL;
	END

	SELECT Esquema + '.' + Tabla AS Tabla, 'Split' AS Split, Registros FROM @Resultado;
END
GO
