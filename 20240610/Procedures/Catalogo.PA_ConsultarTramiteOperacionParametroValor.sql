SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Isaac Dobles Mata>
-- Fecha de creación:	<30/06/2022>
-- Descripción:			<Permite consultar los parámetros y sus respectivos valores de una operación en un encadenamiento de trámites>
-- ==================================================================================================================================================================================
-- Modificación:		<22/07/2022><Karol Jiménez Sánchez><Ajustes para obtener parámetros cuando es un encadenamiento existente y cuando es uno nuevo, de forma diferenciada>
-- Modificación:		<31/10/2022><Isaac Dobles Mata><Se modifica consulta en caso que venga el código de encadenamiento para que retorne el t.oficina y materia del parmámetro>
-- ==================================================================================================================================================================================

CREATE     PROCEDURE [Catalogo].[PA_ConsultarTramiteOperacionParametroValor]
     @CodEncadenamientoTramite		Uniqueidentifier	= NULL,
	 @CodOperacionTramite			Tinyint				= NULL,
	 @CodMateria					Varchar(5)			= NULL,
	 @CodTipoOficina				Smallint			= NULL
AS
BEGIN
	--Variables.
	DECLARE		@L_CodEncadenamientoTramite			Uniqueidentifier	= @CodEncadenamientoTramite,
				@L_CodOperacionTramite				Tinyint				= @CodOperacionTramite,
				@L_CodTipoOficina					Smallint			= @CodTipoOficina,
				@L_CodMateria						Varchar(5)			= @CodMateria,
				@L_SentenciaSQL						Nvarchar(MAX),
				@L_DescripcionValor					Nvarchar(MAX),
				@L_TotalRegistros					Smallint			= 0,
				@L_Contador							Smallint			= 1
	
	--Lógica.
	DECLARE @TABLA  TABLE (
		TN_NumeroLinea									SMALLINT		NOT NULL IDENTITY(1,1),
		TN_CodOperacionTramiteParametro					SMALLINT		NOT NULL,
		TN_CodOperacionTramite							SMALLINT		NOT NULL,
		TC_Nombre										VARCHAR(255)	NOT NULL,
		TC_NombreEstructura								VARCHAR(255)	NOT NULL,
		TC_CampoIdentificador							VARCHAR(100)	NOT NULL,
		TC_CampoMostrar									VARCHAR(100)	NOT NULL,
		TF_Inicio_Vigencia								DATETIME2(7)	NOT NULL,
		TF_Fin_Vigencia									DATETIME2(7)	NULL,
		TC_Valor										VARCHAR(255)	NULL,
		TC_SentenciaSQL									VARCHAR(1000)	NULL,
		TC_DescripcionValor								VARCHAR(255)	NULL,
		TC_CodMateria									VARCHAR(5)		NULL,
		TN_CodTipoOficina								SMALLINT		NULL
	);

	--Lógica.
	IF (@L_CodEncadenamientoTramite IS NULL)
	BEGIN 
		INSERT INTO @TABLA
					(TN_CodOperacionTramiteParametro,
					TN_CodOperacionTramite,
					TC_Nombre,						
					TC_NombreEstructura,				
					TC_CampoIdentificador,			
					TC_CampoMostrar,					
					TF_Inicio_Vigencia,				
					TF_Fin_Vigencia,				
					TC_Valor,
					TC_SentenciaSQL)
		SELECT		A.TN_CodOperacionTramiteParametro,
					A.TN_CodOperacionTramite,				
					A.TC_Nombre,					
					A.TC_NombreEstructura,					
					A.TC_CampoIdentificador,					
					A.TC_CampoMostrar,						
					A.TF_Inicio_Vigencia,					
					A.TF_Fin_Vigencia,						
					NULL,
					NULL
		FROM		Catalogo.OperacionTramiteParametro				A WITH(NOLOCK)
		WHERE		A.TN_CodOperacionTramite						= COALESCE(@L_CodOperacionTramite, A.TN_CodOperacionTramite)
		AND			A.TF_Inicio_Vigencia							< GETDATE()
		AND			(
						A.TF_Fin_Vigencia							IS NULL
					OR
						A.TF_Fin_Vigencia							>= GETDATE()
					)
		ORDER BY	A.TC_Nombre
	END
	ELSE
	BEGIN
		INSERT INTO @TABLA
					(TN_CodOperacionTramiteParametro,
					TN_CodOperacionTramite,
					TC_Nombre,						
					TC_NombreEstructura,				
					TC_CampoIdentificador,			
					TC_CampoMostrar,					
					TF_Inicio_Vigencia,				
					TF_Fin_Vigencia,				
					TC_Valor,
					TC_CodMateria,
					TN_CodTipoOficina,
					TC_SentenciaSQL)
		SELECT		A.TN_CodOperacionTramiteParametro,
					A.TN_CodOperacionTramite,				
					A.TC_Nombre,					
					A.TC_NombreEstructura,					
					A.TC_CampoIdentificador,					
					A.TC_CampoMostrar,						
					A.TF_Inicio_Vigencia,					
					A.TF_Fin_Vigencia,						
					PE.TC_Valor,
					PE.TC_CodMateria,
					PE.TN_CodTipoOficina,
					CASE WHEN (PE.TC_Valor IS NOT NULL)
						THEN
							'SELECT		@internalVariable = CAST(A.' + A.TC_CampoMostrar		+ ' AS VARCHAR(255))' +
							' FROM		Catalogo.' + A.TC_NombreEstructura	+ ' A WITH(NOLOCK)' +
							' WHERE		CAST(A.' + + A.TC_CampoIdentificador  + ' AS VARCHAR(40)) = CAST(''' + PE.TC_Valor  + ''' AS VARCHAR(40)) '
						ELSE NULL
					END
		FROM		Catalogo.OperacionTramiteParametro				A WITH(NOLOCK)
		LEFT JOIN	Catalogo.EncadenamientoTramitePaso				ET WITH(NOLOCK)
		ON			ET.TN_CodOperacionTramite						= A.TN_CodOperacionTramite
		AND			ET.TU_CodEncadenamientoTramite					= COALESCE(@L_CodEncadenamientoTramite, ET.TU_CodEncadenamientoTramite)
		LEFT JOIN	Catalogo.EncadenamientoTramitePasoParametro		PE WITH(NOLOCK)
		ON			PE.TU_CodEncadenamientoTramitePaso				=	ET.TU_CodEncadenamientoTramitePaso
		AND			PE.TN_CodOperacionTramiteParametro				= A.TN_CodOperacionTramiteParametro
		AND			PE.TN_CodTipoOficina							= COALESCE(@L_CodTipoOficina, PE.TN_CodTipoOficina)
		AND			PE.TC_CodMateria								= COALESCE(@L_CodMateria, PE.TC_CodMateria)
		WHERE		A.TN_CodOperacionTramite						= COALESCE(@L_CodOperacionTramite, A.TN_CodOperacionTramite)
		AND			A.TF_Inicio_Vigencia							< GETDATE()
		AND			(
						A.TF_Fin_Vigencia							IS NULL
					OR
						A.TF_Fin_Vigencia							>= GETDATE()
					)
		ORDER BY	A.TC_Nombre
	END

	SET @L_TotalRegistros = @@ROWCOUNT;

	WHILE (@L_Contador <= @L_TotalRegistros)
	BEGIN 
		
		SELECT @L_SentenciaSQL = TC_SentenciaSQL FROM @TABLA WHERE TN_NumeroLinea = @L_Contador;

		IF (@L_SentenciaSQL IS NOT NULL)
		BEGIN 
			exec sp_executesql	@L_SentenciaSQL, 
								N'@internalVariable varchar(255) output', 
								@internalVariable = @L_DescripcionValor output 

			UPDATE	@TABLA
			SET		TC_DescripcionValor = @L_DescripcionValor
			WHERE	TN_NumeroLinea		= @L_Contador;
		END

		SET @L_DescripcionValor = NULL;
		SET @L_Contador = @L_Contador + 1;
	END;

	SELECT	A.TN_CodOperacionTramiteParametro				Codigo,
			A.TC_Nombre										Nombre,
			A.TC_NombreEstructura							NombreEstructura,
			A.TC_CampoIdentificador							CampoIdentificador,
			A.TC_CampoMostrar								CampoMostrar,
			A.TF_Inicio_Vigencia							FechaActivacion,
			A.TF_Fin_Vigencia								FechaDesactivacion,
			'SplitOperacion'								SplitOperacion,
			A.TN_CodOperacionTramite						Codigo,
			'SplitValor'									SplitValor,
			A.TC_Valor										Identificador,
			A.TC_DescripcionValor							Descripcion,
			'SplitMateria'									SplitMateria,
			A.TC_CodMateria									Codigo,
			'SplitTipoOficina'								SplitTipoOficina,
			A.TN_CodTipoOficina								Codigo
	FROM	@TABLA A;
END
GO
