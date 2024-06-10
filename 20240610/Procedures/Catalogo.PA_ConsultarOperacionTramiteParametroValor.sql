SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Rafa Badilla Alvarado>
-- Fecha de creación:	<20/04/2022>
-- Descripción:			<Permite consultar un registro en la tabla: OperacionTramiteParametro y el valor asignado. Según los parámetros definidos>
-- ==================================================================================================================================================================================
-- Modificación:		<02/05/2022><Karol Jiménez Sánchez><Se modifica para solo obtener parámetros vigentes>
-- Modificación:		<04/05/2022><Jose Gabriel Cordero Soto><Se modifica consulta dinamica por problema a la hora de falta de comillas en la consulta por el TC_Valor>
-- Modificación:		<05/05/2022><Isaac Dobles Mata><Se modifica para obtener TN_CodPasoEncadenamientoOperacionParametro de tabla PasoEncadenamientoOperacionParametro>
-- Modificación:		<18/05/2022><Karol Jiménez Sánchez><Se corrije duplicidades al consultar parámetros si el encadenamiento es nuevo, solución bug 255539>
-- ==================================================================================================================================================================================
CREATE       PROCEDURE [Catalogo].[PA_ConsultarOperacionTramiteParametroValor]
     @CodEncadenamiento		INT	= NULL,
	 @Orden					TINYINT	= NULL,
	 @CodOperacionTramite	TINYINT	= NULL
AS
BEGIN
	--Variables.
	DECLARE		@L_CodEncadenamiento			INT				= @CodEncadenamiento,
				@L_Orden						TINYINT			= @Orden,
				@L_CodOperacionTramite			TINYINT			= @CodOperacionTramite,
				@L_SentenciaSQL					NVARCHAR(MAX),
				@L_DescripcionValor				NVARCHAR(MAX),
				@L_TotalRegistros				SMALLINT		= 0,
				@L_Contador						SMALLINT		= 1
	
	--Lógica.
	DECLARE @TABLA  TABLE (
		TN_NumeroLinea									SMALLINT		NOT NULL IDENTITY(1,1),
		TN_CodOperacionTramiteParametro					SMALLINT		NOT NULL,
		TN_CodPasoEncadenamientoOperacionParametro		SMALLINT		NULL,
		TN_CodOperacionTramite							SMALLINT		NOT NULL,
		TC_Nombre										VARCHAR(255)	NOT NULL,
		TC_NombreEstructura								VARCHAR(255)	NOT NULL,
		TC_CampoIdentificador							VARCHAR(100)	NOT NULL,
		TC_CampoMostrar									VARCHAR(100)	NOT NULL,
		TF_Inicio_Vigencia								DATETIME2(7)	NOT NULL,
		TF_Fin_Vigencia									DATETIME2(7)	NULL,
		TC_Valor										VARCHAR(255)	NULL,
		TC_SentenciaSQL									VARCHAR(1000)	NULL,
		TC_DescripcionValor								VARCHAR(255)	NULL
	);

	--Lógica.
	INSERT INTO @TABLA
				(TN_CodOperacionTramiteParametro,
				TN_CodPasoEncadenamientoOperacionParametro,
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
				PE.TN_CodPasoEncadenamientoOperacionParametro,
				A.TN_CodOperacionTramite,				
				A.TC_Nombre,					
				A.TC_NombreEstructura,					
				A.TC_CampoIdentificador,					
				A.TC_CampoMostrar,						
				A.TF_Inicio_Vigencia,					
				A.TF_Fin_Vigencia,						
				PE.TC_Valor,
				CASE WHEN (PE.TC_Valor IS NOT NULL)
					THEN
						'SELECT		@internalVariable = CAST(A.' + A.TC_CampoMostrar		+ ' AS VARCHAR(255))' +
						' FROM		Catalogo.' + A.TC_NombreEstructura	+ ' A WITH(NOLOCK)' +
						' WHERE		CAST(A.' + + A.TC_CampoIdentificador  + ' AS VARCHAR(40)) = CAST(''' + PE.TC_Valor  + ''' AS VARCHAR(40)) '
					ELSE NULL
				END
	FROM		Catalogo.OperacionTramiteParametro				A WITH(NOLOCK)
	Left Join	Catalogo.PasoEncadenamientoOperacionParametro	PE WITH(NOLOCK)
	On			PE.TN_CodOperacionTramiteParametro				= A.TN_CodOperacionTramiteParametro
	and			PE.TN_Orden										= @L_Orden
	AND			PE.TN_CodEncadenamientoFormatoJuridico			= @L_CodEncadenamiento
	WHERE		A.TN_CodOperacionTramite						= COALESCE(@L_CodOperacionTramite, A.TN_CodOperacionTramite)
	AND			A.TF_Inicio_Vigencia							< GETDATE()
	AND			(
					A.TF_Fin_Vigencia							IS NULL
				OR
					A.TF_Fin_Vigencia							>= GETDATE()
				)
	ORDER BY	A.TC_Nombre

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
			A.TN_CodPasoEncadenamientoOperacionParametro	CodigoPasoEncadenamientoOperacionParametro,
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
			A.TC_DescripcionValor							Descripcion
	FROM	@TABLA A;
END
GO
