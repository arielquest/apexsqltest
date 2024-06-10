SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramí­rez Rojas>
-- Fecha de creación:	<25/01/2020>
-- Descripción :		<Permite consultar el histórico de itineraciones de un expediente de SIAGPJ mapeado a registros de Gestión 
--						 con sus catálogos respectivos>
-- =============================================================================================================================================================================
-- Modificación:		<09/02/2021> <Karol Jiménez Sánchez> <Se modifica para incluir consulta de CARPETA>
-- Modificación:		<24/02/2021> <Karol Jiménez Sánchez> <Se modifica para enviar ID_NAUTIUS>
-- Modificación:		<04/03/2021> <Karol Jiménez Sánchez> <Se modifica para evitar duplicidad por varios registros detalle del expediente>
-- Modificación:		<18/03/2021> <Karol Jiménez Sánchez> <Se agrega registro DHIISTI de entrada en contexto destino de Gestión, porque es requerido para Gestión este registro, no lo crean ellos>
-- Modificación:		<09/07/2021> <Jose Gabriel Cordero Soto> <Se modifica consulta para inconrporar NUMACUM y CODEJDES en el registro>
-- Modificación:		<19/07/2021> <Jose Gabriel Cordero Soto> <Se realiza ajuste en DHISITI con respecto campo DHISITI en campo NUEACUM y CODDEJDES>
-- Modificación:		<07/03/2023><Karol Jiménez S.><Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos Clase, MotivoItineracion y
--						EstadoItineracion)>
-- Modificación:		<12/05/2023> <Luis Alonso Leiva Tames> <Se realiza ajuste en la consulta de ExpedienteDetalle ya que el contexto al ser itinerado, no aplica el Inner>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarHistoricoExpedienteItineracionSIAGPJ]	
	@CodHistoricoItineracion	UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	
	--Variables 
	DECLARE	@L_NumeroExpediente							VARCHAR(14),
			@L_CodLegajo								UNIQUEIDENTIFIER	= NULL,
			@L_Carpeta									VARCHAR(14)			= NULL,
			@L_ValorDefectoCodigoClaseItineracion		VARCHAR(9)			= NULL,
			@L_CodContextoOrigen						VARCHAR(4);

	-- Se Obtiene el número de expediente y código de legajo si el histórico está relacionado a un legajo
	SELECT  @L_NumeroExpediente		= TC_NumeroExpediente,
			@L_CodLegajo			= TU_CodLegajo,
			@L_Carpeta				= CARPETA,
			@L_CodContextoOrigen	= TC_CodContextoOrigen
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@CodHistoricoItineracion);

	/*SE OBTIENEN VALORES POR DEFECTO, SEGÚN CONFIGURACIONES*/
	SELECT	@L_ValorDefectoCodigoClaseItineracion	= Itineracion.FN_ConsultarValorDefectoConfiguracion('U_ITIG_CodClaseItineracion','');

	--Definición de tabla DHISITI
	DECLARE @DHISITI AS TABLE (
			[CARPETA]		[varchar](14)		NOT NULL,
			[IDITI]			[int]				NOT NULL 	IDENTITY(1,1),
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
	SELECT		@L_Carpeta											--CARPETA 
				,H.TC_CodContexto 									--CODDEJ
				,H.TF_Entrada 										--FECENT
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'MotivoItineracion', H.TN_CodMotivoItineracion,0,0)--CODMOT
				,H.TF_Salida 										--FECSAL
				,ISNULL(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Clase', ED.TN_CodClase,0,0),@L_ValorDefectoCodigoClaseItineracion)	--CODCLAITI ?? REQUERIDO - Qué se pone por defecto?
				,NULL 												--CODCLR 
				,NULL 												--IDACO
				,H.TC_CodContextoDestino 							--CODDEJDES
				,ISNULL(	Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'EstadoItineracion', I.TN_CodEstadoItineracion,0,0),
						CASE 
							WHEN H.TF_Salida IS NULL THEN NULL 
							ELSE 'I' 
						END
				) 													--CODESTITI
				,I.TF_FechaEstado 									--FECESTITI 
				,Z.TC_NumeroExpedienteAcumula						--NUEACUM 	??
				,ISNULL(H.TU_CodHistoricoItineracion, H.ID_NAUTIUS)	--ID_NAUTIUS
				,NULL 												--CODJUDEC
				,NULL 												--CODJUTRA
	FROM		Historico.ExpedienteEntradaSalida	H WITH(NOLOCK)
	INNER JOIN	Expediente.Expediente				E WITH(NOLOCK)	
	ON			E.TC_NumeroExpediente				= H.TC_NumeroExpediente
	OUTER APPLY (
			SELECT		TOP 1 ExD.TN_CodClase 
			FROM		Expediente.ExpedienteDetalle	ExD WITH(NOLOCK)
			WHERE		ExD.TC_NumeroExpediente			= E.TC_NumeroExpediente
			ORDER BY	ExD.TF_Entrada DESC
	) ED
	LEFT JOIN	Historico.Itineracion				I WITH(NOLOCK)
	ON			I.TU_CodHistoricoItineracion		= H.TU_CodHistoricoItineracion
	OUTER APPLY (
					SELECT  Y.TC_NumeroExpedienteAcumula
					FROM	Historico.ExpedienteAcumulacion Y WITH(NOLOCK)
					WHERE   Y.TC_NumeroExpediente			= @L_NumeroExpediente						
				) Z

	WHERE		H.TC_NumeroExpediente				= @L_NumeroExpediente
	ORDER BY	H.TF_CreacionItineracion			ASC

	--SE CREA REGISTRO DE ENTRADA EN CONTEXTO DESTINO DE GESTIÃ“N
	INSERT INTO @DHISITI
			   ([CARPETA]
			   ,[CODDEJ]
			   ,[FECENT]
			   ,[CODCLAITI]
			   ,[CODDEJDES]
			   ,[NUEACUM])
	SELECT		TOP 1
				@L_Carpeta		--CARPETA 
			   ,H.CODDEJDES	    --CODDEJ
			   ,FECSAL 			--FECENT
			   ,H.CODCLAITI		--CODCLAITI
			   ,H.CODDEJDES     --CODDEJDES
			   ,H.NUEACUM      	--NUEACUM								
	FROM		@DHISITI	H
	ORDER BY	IDITI		DESC
				
	--SE LIMPIA EL NUEACUM DEL ULTIMO REGISTRO DE LA TABLA

	--VERIFICA SI TIENE ACUMULACION
	IF (EXISTS (SELECT   X.TU_CodAcumulacion
			   FROM		Historico.ExpedienteAcumulacion X WITH(NOLOCK)
			   WHERE 	X.TC_NumeroExpediente			= @L_NumeroExpediente))
		BEGIN
			UPDATE @DHISITI 
			SET	   NUEACUM = NULL
			WHERE  IDITI = (SELECT MAX(IDITI) FROM @DHISITI)
		END
	ELSE 
		BEGIN
			UPDATE @DHISITI 
			SET	   NUEACUM = NULL, CODDEJDES = NULL	
			WHERE  IDITI = (SELECT MAX(IDITI) FROM @DHISITI)
		END				

	SELECT * FROM @DHISITI;
END
GO
