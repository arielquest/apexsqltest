SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<19/02/2020>
-- Descripción :		<Permite consultar el histórico de itineraciones de un legajo de SIAGPJ mapeado a registros de Gestión 
--						con sus catálogos respectivos>
-- =============================================================================================================================================================================
-- Modificado por:		<24/02/2021><Jose Gabriel Cordero><Se modifica procedimiento para enviar el ID_NAUTIUS en el campo correspondiente>
-- Modificación:		<04/03/2021><Karol Jiménez Sánchez><Se modifica para evitar duplicidad por varios registros detalle del legajo>
-- Modificación:		<18/03/2021> <Karol Jiménez Sánchez> <Se agrega registro DHIISTI de entrada en contexto destino de Gestión, porque es requerido para Gestión este registro, no lo crean ellos>
-- Modificación:		<08/03/2023><Karol Jiménez S.><Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos Clase, MotivoItineracion y
--						EstadoItineracion)>
-- Modificación:		<12/05/2023> <Luis Alonso Leiva Tames> <Se realiza ajuste en la consulta de LegajoDetalle ya que el contexto al ser itinerado, no aplica el Inner>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarHistoricoLegajoItineracionSIAGPJ]	
	@CodHistoricoItineracion	UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	
	--Variables 
	DECLARE	@L_NumeroExpediente							VARCHAR(14),
			@L_CodLegajo								UNIQUEIDENTIFIER	= NULL,
			@L_TC_CodContextoOrigen						VARCHAR(4)			= NULL,
			@L_Carpeta									VARCHAR(14)			= NULL,
			@L_ValorDefectoCodigoClaseItineracion		VARCHAR(9)			= NULL;

	-- Se Obtiene el número de expediente y código de legajo si el histórico está relacionado a un legajo
	SELECT  @L_NumeroExpediente		= TC_NumeroExpediente,
			@L_CodLegajo			= TU_CodLegajo,
			@L_TC_CodContextoOrigen = TC_CodContextoOrigen,
			@L_Carpeta				= CARPETA
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@CodHistoricoItineracion);

	/*SE OBTIENEN VALORES POR DEFECTO, SEGÚN CONFIGURACIONES*/
	SELECT	@L_ValorDefectoCodigoClaseItineracion	= Itineracion.FN_ConsultarValorDefectoConfiguracion('U_ITIG_CodClaseItineracion','');

	--Definición de tabla DHISITI
	DECLARE @DHISITI AS TABLE (
			[CARPETA]		[varchar](14)		NOT NULL,
			[IDITI]			[int]				NOT NULL	IDENTITY(1,1),
			[CODDEJ]		[varchar](4)		NOT NULL,
			[FECENT]		[datetime2](3)		NULL,
			[CODMOT]		[varchar](9)		NULL,
			[FECSAL]		[datetime2](3)		NULL,
			[CODCLAITI]		[varchar](9)		NOT NULL,
			[CODCLR]		[varchar](9)		NULL,
			[IDACO]			[int]				NULL,
			[CODDEJDES]		[varchar](4)		NULL,
			[CODESTITI]		[varchar](1)		NULL,
			[FECESTITI]		[datetime2](3)		NULL,
			[NUEACUM]		[varchar](14)		NULL,
			[ID_NAUTIUS]	[varchar](255)		NULL,
			[CODJUDEC]		[varchar](11)		NULL,
			[CODJUTRA]		[varchar](11)		NULL);

	INSERT INTO @DHISITI
			   ([CARPETA]
			   ,[CODDEJ]
			   ,[FECENT]
			   ,[CODMOT]
			   ,[FECSAL]
			   ,[CODCLAITI]
			   ,[CODCLR]
			   ,[IDACO]
			   ,[CODDEJDES]
			   ,[CODESTITI]
			   ,[FECESTITI]
			   ,[NUEACUM]
			   ,[ID_NAUTIUS]
			   ,[CODJUDEC]
			   ,[CODJUTRA])
	SELECT
			   @L_Carpeta						--CARPETA 
			   ,H.TC_CodContexto 				--CODDEJ
			   ,H.TF_Entrada 					--FECENT
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'MotivoItineracion', H.TN_CodMotivoItineracion,0,0)--CODMOT
			   --,M.CODMOT						--CODMOT
			   ,H.TF_Salida 					--FECSAL
			   ,ISNULL(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'ClaseAsunto', LD.TN_CodClaseAsunto,0,0),@L_ValorDefectoCodigoClaseItineracion)	--CODCLAITI ?? REQUERIDO - Qué se pone por defecto?
			   ,NULL 							--CODCLR 
			   ,NULL 							--IDACO
			   ,H.TC_CodContextoDestino 		--CODDEJDES
			   ,ISNULL(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'EstadoItineracion', I.TN_CodEstadoItineracion,0,0),
						CASE 
							WHEN H.TF_Salida IS NULL THEN NULL 
							ELSE 'I' 
						END
				) 								--CODESTITI
			   ,I.TF_FechaEstado 				--FECESTITI 
			   ,NULL 							--NUEACUM 	??
			   ,H.ID_NAUTIUS					--ID_NAUTIUS
			   ,NULL 							--CODJUDEC
			   ,NULL 							--CODJUTRA
	FROM		Historico.LegajoEntradaSalida		H WITH(NOLOCK)
	INNER JOIN	Expediente.Legajo					L WITH(NOLOCK)
	ON			l.TU_CodLegajo						= H.TU_CodLegajo
	OUTER APPLY (
				SELECT TOP	1 DT.TN_CodClaseAsunto
				FROM		Expediente.LegajoDetalle	DT WITH(NOLOCK)
				WHERE		DT.TU_CodLegajo				= L.TU_CodLegajo
				ORDER BY	DT.TF_Entrada DESC
	) LD
	LEFT JOIN	Historico.Itineracion				I WITH(NOLOCK)
	ON			I.TU_CodHistoricoItineracion		= H.TU_CodHistoricoItineracion
	WHERE		H.TU_CodLegajo						= @L_CodLegajo
	ORDER BY	H.TF_CreacionItineracion			ASC;

	--SE CREA REGISTRO DE ENTRADA EN CONTEXTO DESTINO DE GESTIÓN
	INSERT INTO @DHISITI
			   ([CARPETA]
			   ,[CODDEJ]
			   ,[FECENT]
			   ,[CODCLAITI])
	SELECT		TOP 1
				@L_Carpeta		--CARPETA 
			   ,H.CODDEJDES		--CODDEJ
			   ,FECSAL 			--FECENT
			   ,H.CODCLAITI		--CODCLAITI
	FROM		@DHISITI	H
	ORDER BY	IDITI		DESC
	
	SELECT * FROM @DHISITI;
END
GO
