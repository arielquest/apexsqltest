SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<22/01/2020>
-- Descripción :			<Permite consultar las resoluciones asociadas a un expediente de una itineración>
-- =============================================================================================================================================================================
-- Modificación:			<09/02/2021><Karol Jiménez Sánchez> <Se modifica para incluir consulta de CARPETA>
-- Modificación:			<14/06/2021><Karol Jiménez Sánchez> <Se corrige bug 197900, campo CODJURIS mal asignado, se asigna CODESTRES>
-- =============================================================================================================================================================================
 CREATE PROCEDURE [Itineracion].[PA_ConsultarResolucionesSIAGPJ]
	@CodHistoricoItineracion	UNIQUEIDENTIFIER
AS 


BEGIN
	--Variables 
	DECLARE	@L_NumeroExpediente			VARCHAR(14),
			@L_CodLegajo				UNIQUEIDENTIFIER	=	NULL,
			@L_Carpeta					VARCHAR(14)			=	NULL,
			@L_ContextoCreaXDefecto		VARCHAR(4)			=	NULL;

	SELECT  @L_NumeroExpediente		= TC_NumeroExpediente,
			@L_CodLegajo			= TU_CodLegajo,
			@L_Carpeta				= CARPETA
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@CodHistoricoItineracion);

	--Definición de tabla 
	DECLARE @DACORES AS TABLE (
	   [CARPETA]			[varchar](14)	not null
      ,[IDACO]				[int]			not null
      ,[CODJURIS]			[varchar](2)	not null
      ,[CODRESUL]			[varchar](9)	null
      ,[CODESTRES]			[varchar](3)	not null
      ,[FECEST]				[datetime2](3)	not null
      ,[CODNUM]				[varchar](9)	null
      ,[CODRES]				[varchar](4)	not null
      ,[VOTNUM]				[varchar](10)	null
      ,[JUEZ]				[varchar](11)	null
      ,[FECDIC]				[datetime2](3)	null
      ,[FECPUB]				[datetime2](3)	null
      ,[RECURRIDA]			[varchar](1)	null
      ,[CODRESREC]			[varchar](9)	null
      ,[SELECCIONADO]		[varchar](1)	null
      ,[CODESTENV]			[varchar](1)	null
      ,[CODPRESENT]			[varchar](9)	null
      ,[IDUSU]				[varchar](25)	null
      ,[HUBOJUICIO]			[varchar](1)	null
      ,[USUREDAC]			[varchar](25)	null	
      ,[IDACOSENDOC]		[int]			null
      ,[FECVOTO]			[datetime2](3)	null
      ,[ACOPORDOC]			[text]			null
      ,[ENVIADO_SINALEVI]	[varchar](1)	null
      ,[RESUMEN]			[text]			null	
      ,[FECVENCE]			[datetime2](3)	null
      ,[OBSER_DATSENSI]		[varchar](250)	null);


	  INSERT INTO @DACORES
		(CARPETA
		,IDACO
		,CODJURIS
		,CODRESUL
		,CODESTRES
		,FECEST
		,CODNUM
		,CODRES
		,VOTNUM
		,JUEZ
		,FECDIC
		,FECPUB
		,RECURRIDA
		,CODRESREC
		,SELECCIONADO
		,CODESTENV
		,CODPRESENT
		,IDUSU
		,HUBOJUICIO
		,USUREDAC
		,IDACOSENDOC
		,FECVOTO
		,ACOPORDOC
		,ENVIADO_SINALEVI
		,RESUMEN
		,FECVENCE
		,OBSER_DATSENSI)
	SELECT 
		@L_Carpeta,					-- [CARPETA]
		null,						-- [IDACO]
		C.TC_CodMateria,			-- [CODJURIS]
		R.TN_CodResultadoResolucion,-- [CODRESUL]
		'999',						-- [CODESTRES]
		E.TF_Fecharesolucion,		-- [FECEST]
		null,						-- [CODNUM]
		T.TN_CodTipoResolucion,		-- [CODRES]
		L.TC_NumeroResolucion,		-- [VOTNUM]		
		null,						-- [JUEZ]
		E.TF_FechaCreacion,			-- [FECDIC]
		null,						-- [FECPUB]
		null,						-- [RECURRIDA]
		null,						-- [CODRESREC]
		E.TC_EstadoEnvioSAS,		-- [SELECCIONADO]
		null,						-- [CODESTENV]
		null,						-- [CODPRESENT]
		null,						-- *[IDUSU] corresponde al usuario que genero el documento que se le va a realizar el registro de resolucion
		null,						-- [HUBOJUICIO]	
		E.USUREDAC,					-- [USUREDAC]
		null,						-- *[IDACOSENDOC] corresponde al idaco del documento(daco) -- Hacer la relacion ***IMPORTANTE CONSULTAR RONNY 
		E.TF_FechaResolucion,		-- [FECVOTO]
		E.TC_PorTanto,				-- [ACOPORDOC]
		CASE						-- [ENVIADO_SINALEVI] Si en SIAGPJ esta marcado corresponde a 'P'(si es N=0 : 1)
			WHEN E.TC_EstadoEnvioSAS = 'N' THEN 'N'
			WHEN E.TC_EstadoEnvioSAS = 'P' THEN 'P'
			WHEN E.TC_EstadoEnvioSAS = 'V' THEN 'E'
			ELSE 'A'
		END	,							
		E.TC_Resumen,				-- [RESUMEN]
		null,						-- [FECVENCE]
		E.TC_DescripcionSensible	-- [OBSER_DATSENSI]
	FROM 
		Expediente.Resolucion E WITH(NOLOCK) INNER JOIN Catalogo.ResultadoResolucion R WITH(NOLOCK)
				ON E.TN_CodResultadoResolucion = R.TN_CodResultadoResolucion
		 INNER JOIN Catalogo.TipoResolucion T WITH(NOLOCK)
				ON E.TN_CodTipoResolucion = T.TN_CodTipoResolucion
		 INNER JOIN Expediente.LibroSentencia L WITH(NOLOCK)
				ON L.TU_CodResolucion = E.TU_CodResolucion
		 INNER JOIN Expediente.Expediente Ex WITH(NOLOCK)
				ON Ex.TC_NumeroExpediente = E.TC_NumeroExpediente
		 INNER JOIN Catalogo.Contexto C WITH(NOLOCK)
				ON C.TC_CodContexto = Ex.TC_CodContexto
	WHERE
		E.TC_NumeroExpediente = @L_NumeroExpediente   
		
END

GO
