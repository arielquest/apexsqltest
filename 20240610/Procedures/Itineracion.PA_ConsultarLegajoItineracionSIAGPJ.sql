SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<18/02/2020>
-- Descripción :			<Permite consultar los datos de un Legajo/Legajo Detalle/Movimiento Circulante y lugar de los hechos de
--							 SIAGPJ mapeado a registros de Gestión con sus cat logos respectivos>
-- =====================================================================================================================================================================================================
-- Modificación :			<20/02/2021><Karol Jiménez Sánchez><Se agrega Identity para generar IDFEP de DHISFEP>
-- Modificación :			<22/02/2021> <Richard Zúñiga Segura><Se incorpora la consulta para tabla DACO>
-- Modificación :			<23/02/2021> <Ronny Ramírez Rojas><Se agrega el mapeo del cambio de ubicación del legajo en DACO>
-- Modificación :			<25/02/2021> <Richard Zúñiga Segura><Se agrega condición para agregar movimiento de reentrante en DACO>
-- Modificación :			<25/02/2021> <Ronny Ramírez R.><Se aplican ajustes a las secuencias de DACO y para el reentrante en DACO>
-- Modificación :			<01/03/2021> <Richard Zúñiga Segura><Se ajusta el cambio en fecha y usuario red para @MOVCIRCULANTES, y adicionalmente la consulta de reentrado>
-- Modificación :			<03/03/2021> <Richard Zúñiga Segura><Se ajusta IDACO para @MOVCIRCULANTES y cambio en insersión de DHISFEP y DACO>			
-- Modificación :			<06/04/2021><Karol Jiménez Sánchez><Se ajusta campos PRIORI y AMPLIAR de DACO>
-- Modificación :			<09/04/2021> <Karol Jiménez Sánchez><Se cambia ISNULL para campo FECHA de DHISFEP, para que tome primero la fecha de ExpedienteMovimientoCirculante y no la de la fase>
-- Modificación :			<12/04/2021> <Karol Jiménez Sánchez><Se corrije consecutivo de DACO>
-- Modificación:			<26/08/2021> <Jose Gabriel Cordero Soto> <Se realiza ajuste en DHISFEP por cambio en el MOVCIRCULANTE y los registros por cambios de estado o fase sin registrar Movimiento>
-- Modificación :			<10/09/2021> <Jonathan Aguilar Navarro><Se modifica para que retorne los registros de reentrado correctamente>
-- Modificación:			<01/10/2021> <Karol Jiménez S nchez> <Se aplica cambio para obtención de equivalencias cat logo Estados desde módulo de equivalencias>
-- Modificación:			<28/10/2021> <Ronny Ramírez R.> <Se aplica ajusta para evitar duplicación de IDACOs por falta de rec lculo>
-- Modificación:			<04/01/2022> <Luis Alonso Leiva Tames> <Se cambia el tipo de dato en el campo IDFEP (int --> bigint) >
-- Modificación:			<06/02/2023> <Ronny Ramírez R.> <Se aplica ajuste en los campos de las tablas temporales tipo DATETIME2(3), para que sean DATETIME2(7), y se eliminan actualizaciones de campos de
--							fechas de movimiento de circulante para que no se actualicen con las de las fases relacionadas, adicionalmente se agregan las fases en estado F, que se estaban perdiendo>
-- Modificación:			<01/03/2023> <Jonathan Aguilar Navarro> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos ClaseAsunto, Asunto, Fase, GrupoTrabajo y Prioridad)>
-- =====================================================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarLegajoItineracionSIAGPJ]
	@CodHistoricoItineracion	UNIQUEIDENTIFIER,
	@DacoInicial				INT = 1	
AS
BEGIN
	SET NOCOUNT ON;
	
	---******************************************************************************************************************************************************************
	--  DEFINICION Y CARGA DE DATOS INICIAL
	---******************************************************************************************************************************************************************
	
	Declare	@L_TC_NumeroExpediente		CHAR(14),
			@L_TU_CodLegajo				UNIQUEIDENTIFIER	= NULL,
			@L_TC_CodContextoOrigen		VARCHAR(4)			= NULL,
			@L_Carpeta					VARCHAR(14),
			@L_CodHistoricoItineracion	UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
			@L_DacoInicial				INT					= @DacoInicial;

	-- Se obtiene el # de expediente asociado al código de histórico de itineración
    SELECT  @L_TC_NumeroExpediente	= TC_NumeroExpediente,
			@L_TU_CodLegajo			= TU_CodLegajo,
			@L_TC_CodContextoOrigen = TC_CodContextoOrigen,
			@L_Carpeta				= CARPETA
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodHistoricoItineracion);
	
	---******************************************************************************************************************************************************************
	--  DECLARACION TABLAS
	---******************************************************************************************************************************************************************

	--Definición de tabla DCAR
	DECLARE @DCAR AS TABLE(
			[CARPETA] 			[varchar](14) 		NOT NULL,
			[NUE] 				[varchar](14) 		NOT NULL,
			[CODASU] 			[varchar](3) 		NOT NULL,
			[CODCLAS] 			[varchar](9) 		NOT NULL,
			[CODMAT] 			[varchar](5) 		NOT NULL,
			[FECENT] 			[datetime2](7) 		NOT NULL,
			[FECULTACT] 		[datetime2](7) 		NOT NULL,
			[CODDEJ] 			[varchar](4) 		NOT NULL,
			[CODJURIS] 			[varchar](2) 		NOT NULL,
			[CODPRO] 			[varchar](5) 		NULL,
			[CODJUDEC] 			[varchar](11) 		NULL,
			[CODJUTRA] 			[varchar](11) 		NULL,
			[CODFAS] 			[varchar](6) 		NULL,
			[FECFASE] 			[datetime2](7) 		NULL,
			[CODESTASU] 		[varchar](9) 		NULL,
			[FECEST] 			[datetime2](7) 		NULL,
			[CODGT] 			[varchar](11) 		NULL,
			[DESCRIP] 			[varchar](255) 		NOT NULL,
			[cuantia] 			[numeric](12, 2) 	NULL,
			[CODCUANTIA] 		[varchar](2) 		NULL,
			[PIEZA] 			[int] 				NULL,
			[NUMFOL] 			[int] 				NULL,
			[CODPRI] 			[varchar](9) 		NULL,
			[IDACOUBI] 			[int] 				NULL,
			[CODCLR] 			[varchar](9) 		NULL,
			[TENGOACUM] 		[varchar](1) 		NULL,
			[CARPETAACUM] 		[varchar](14) 		NULL,
			[ES_FINEST] 		[varchar](1) 		NULL,
			[codubi] 			[varchar](25) 		NULL,
			[ubica] 			[varchar](255) 		NULL,
			[fecubi] 			[datetime2](3) 		NULL,
			[codsubest] 		[varchar](9) 		NULL,
			[fecsubest] 		[datetime2](7) 		NULL,
			[FECPLAZO] 			[datetime2](3) 		NULL,
			[FOLCUAN] 			[int] 				NULL,
			[CODSECTOR] 		[char](2) 			NULL,
			[FECTURNMAG] 		[datetime2](3) 		NULL,
			[CODESC] 			[varchar](11) 		NULL,
			[CODMON] 			[varchar](3) 		NULL,
			[ESELECTRONICO] 	[bit] 				NOT NULL,
			[CODTAREA] 			[varchar](10) 		NULL,
			[CODACTUBI] 		[varchar](10) 		NULL,
			[CODSECCION]		[varchar](4)		NULL,
			[CASORELEVANTE] 	[varchar](1)		NULL,
			EMBARGOF			BIT					NOT NULL DEFAULT 0);

	--Definición de tabla DCARMASD
	DECLARE @DCARMASD AS TABLE(
			[CARPETA] 			[varchar](14) 		NOT NULL,
			[CODMASD] 			[varchar](9) 		NOT NULL,
			[COLDAT] 			[varchar](2) 		NOT NULL,
			[IDATR] 			[int] 				NOT NULL,
			[VALOR] 			[varchar](255) 		NULL);
							
	--Definición de tabla DNUE
	DECLARE @DNUE AS TABLE(
			[NUE]				[varchar](14)		NOT NULL,
			[FEININUE]			[datetime2](7) 		NOT NULL,
			[INDBOR]			[varchar](1)		NOT NULL);

	--Definición de tabla de Movimientos Circulantes
	DECLARE @MOVCIRCULANTES AS TABLE(
			--Datos de DACO
			[CARPETA]		[varchar](14)		NOT NULL,
			[IDACO]			[int]				NULL,
			[CODDEJ]		[varchar](4)		NOT NULL,
			[FECHA]			[datetime2](7)		NOT NULL,
			[TEXTO]			[varchar](255)		NULL,
			[CODACO]		[varchar](9)		NOT NULL,
			[NUMACO]		[varchar](10)		NULL,
			[FECSYS]		[datetime2](7)		NOT NULL,
			[IDUSU]			[varchar](25)		NOT NULL,
			[CODDEJUSR]		[varchar](4)		NOT NULL,
			[CODESTACO]		[varchar](1)		NULL,
			[FECEST]		[datetime2](7)		NULL,
			[NUMFOL]		[int]				NULL,
			[NUMFOLINI]		[int]				NULL,
			[PIEZA]			[int]				NULL,
			[CODPRO]		[varchar](5)		NULL,
			[CODJUDEC]		[varchar](11)		NULL,
			[CODJUTRA]		[varchar](11)		NULL,
			[CODTRAM]		[varchar](12)		NULL,
			[CODESTADIST]	[varchar](5)		NULL,
			[CODTIDEJ]		[varchar](2)		NOT NULL,
			[IDACOREL]		[int]				NULL,
			[CODREL]		[varchar](3)		NULL,
			[PRIORI]		[int]				NULL,
			[CODICO]		[varchar](9)		NULL,
			[AMPLIAR]		[varchar](100)		NULL,
			[CANT]			[int]				NULL,
			[CODGT]			[varchar](9)		NULL,
			[CODESC]		[varchar](11)		NULL,
			[FECENTRDD]		[datetime2](3)		NULL,
			[CODTIPDOC]		[varchar](12)		NULL,
			[OTRGEST]		[bit]				NOT NULL,			   
			[IDENTREGA]		[varchar](20)		NULL,
			[FINALIZAEXP]	[varchar](2)		NULL,
			--- Datos de DHISFEP
			[FECPRO]		[datetime2](3)		NULL,
			[CODFAS]		[varchar](6)		NULL,
			[FECFASE]		[datetime2](7)		NULL,
			[CODESTASU]		[varchar](9)		NULL,
			[FECESTASU]		[datetime2](7)		NULL,
			[FINEST]		[varchar](1)		NULL,
			[CODSUBEST]		[varchar](9)		NULL,
			[FECSUBEST]		[datetime2](7)		NULL,
			[TU_CodArchivo]	UNIQUEIDENTIFIER	NULL,
			[TN_CodLegajoMovimientoCirculante] BIGINT	NULL);

	DECLARE @MOVCIRCULANTES2 AS TABLE(
			--Datos de DACO
			[CARPETA]		[varchar](14)		NOT NULL,
			[IDACO]			[int]				NULL,
			[CODDEJ]		[varchar](4)		NOT NULL,
			[FECHA]			[datetime2](7)		NOT NULL,
			[TEXTO]			[varchar](255)		NULL,
			[CODACO]		[varchar](9)		NOT NULL,
			[NUMACO]		[varchar](10)		NULL,
			[FECSYS]		[datetime2](7)		NOT NULL,
			[IDUSU]			[varchar](25)		NOT NULL,
			[CODDEJUSR]		[varchar](4)		NOT NULL,
			[CODESTACO]		[varchar](1)		NULL,
			[FECEST]		[datetime2](7)		NULL,
			[NUMFOL]		[int]				NULL,
			[NUMFOLINI]		[int]				NULL,
			[PIEZA]			[int]				NULL,
			[CODPRO]		[varchar](5)		NULL,
			[CODJUDEC]		[varchar](11)		NULL,
			[CODJUTRA]		[varchar](11)		NULL,
			[CODTRAM]		[varchar](12)		NULL,
			[CODESTADIST]	[varchar](5)		NULL,
			[CODTIDEJ]		[varchar](2)		NOT NULL,
			[IDACOREL]		[int]				NULL,
			[CODREL]		[varchar](3)		NULL,
			[PRIORI]		[int]				NULL,
			[CODICO]		[varchar](9)		NULL,
			[AMPLIAR]		[varchar](100)		NULL,
			[CANT]			[int]				NULL,
			[CODGT]			[varchar](9)		NULL,
			[CODESC]		[varchar](11)		NULL,
			[FECENTRDD]		[datetime2](3)		NULL,
			[CODTIPDOC]		[varchar](12)		NULL,
			[OTRGEST]		[bit]				NOT NULL,			   
			[IDENTREGA]		[varchar](20)		NULL,
			[FINALIZAEXP]	[varchar](2)		NULL,
			--- Datos de DHISFEP
			[FECPRO]		[datetime2](3)		NULL,
			[CODFAS]		[varchar](6)		NULL,
			[FECFASE]		[datetime2](7)		NULL,
			[CODESTASU]		[varchar](9)		NULL,
			[FECESTASU]		[datetime2](7)		NULL,
			[FINEST]		[varchar](1)		NULL,
			[CODSUBEST]		[varchar](9)		NULL,
			[FECSUBEST]		[datetime2](7)		NULL,
			[TU_CodArchivo]	UNIQUEIDENTIFIER	NULL,
			[TN_CodLegajoMovimientoCirculante] BIGINT	NULL);

	--Definición de tabla DHISFEP
	DECLARE @DHISFEP AS TABLE (
			[CARPETA]		[varchar](14)		NOT NULL,
			[IDFEP]			[bigint]			NOT NULL IDENTITY(1,1),
			[IDACO]			[int]				NULL,
			[FECHA]			[datetime2](7)		NOT NULL,
			[CODTIDEJ]		[varchar](2)		NULL,
			[CODDEJ]		[varchar](4)		NOT NULL,
			[CODPRO]		[varchar](5)		NULL,
			[FECPRO]		[datetime2](3)		NULL,
			[CODFAS]		[varchar](6)		NULL,
			[FECFASE]		[datetime2](7)		NULL,
			[CODESTASU]		[varchar](9)		NULL,
			[FECESTASU]		[datetime2](7)		NULL,
			[FINEST]		[varchar](1)		NULL,
			[CODSUBEST]		[varchar](9)		NULL,
			[FECSUBEST]		[datetime2](7)		NULL,
			[TU_CodArchivo]	UNIQUEIDENTIFIER	NULL);

	--Definición de tabla DACO
	DECLARE @DACO AS TABLE (
			[CARPETA]		[varchar](14)		NOT NULL,
			[IDACO]			[int]				NOT NULL,
			[CODDEJ]		[varchar](4)		NOT NULL,
			[FECHA]			[datetime2](7)		NOT NULL,
			[TEXTO]			[varchar](255)		NULL,
			[CODACO]		[varchar](9)		NOT NULL,
			[NUMACO]		[varchar](10)		NULL,
			[FECSYS]		[datetime2](7)		NOT NULL,
			[IDUSU]			[varchar](25)		NOT NULL,
			[CODDEJUSR]		[varchar](4)		NOT NULL,
			[CODESTACO]		[varchar](1)		NULL,
			[FECEST]		[datetime2](7)		NULL,
			[NUMFOL]		[int]				NULL,
			[NUMFOLINI]		[int]				NULL,
			[PIEZA]			[int]				NULL,
			[CODPRO]		[varchar](5)		NULL,
			[CODJUDEC]		[varchar](11)		NULL,
			[CODJUTRA]		[varchar](11)		NULL,
			[CODTRAM]		[varchar](12)		NULL,
			[CODESTADIST]	[varchar](5)		NULL,
			[CODTIDEJ]		[varchar](2)		NOT NULL,
			[IDACOREL]		[int]				NULL,
			[CODREL]		[varchar](3)		NULL,
			[PRIORI]		[int]				NULL,
			[CODICO]		[varchar](9)		NULL,
			[AMPLIAR]		[varchar](100)		NULL,
			[CANT]			[int]				NULL,
			[CODGT]			[varchar](9)		NULL,
			[CODESC]		[varchar](11)		NULL,
			[FECENTRDD]		[datetime2](3)		NULL,
			[CODTIPDOC]		[varchar](12)		NULL,
			[OTRGEST]		[bit]				NOT NULL,			   
			[IDENTREGA]		[varchar](20)		NULL,
			[FINALIZAEXP]	[varchar](2)		NULL)
	
	---******************************************************************************************************************************************************************
	--  CARGAR TABLAS
	---******************************************************************************************************************************************************************

	INSERT INTO @DCAR
			   ([CARPETA]
			   ,[NUE]
			   ,[CODASU]
			   ,[CODCLAS]
			   ,[CODMAT]
			   ,[FECENT]
			   ,[FECULTACT]
			   ,[CODDEJ]
			   ,[CODJURIS]
			   ,[CODPRO]
			   ,[CODJUDEC]
			   ,[CODJUTRA]
			   ,[CODFAS]
			   ,[FECFASE]
			   ,[CODESTASU]
			   ,[FECEST]
			   ,[CODGT]
			   ,[DESCRIP]
			   ,[cuantia]
			   ,[CODCUANTIA]
			   ,[PIEZA]
			   ,[NUMFOL]
			   ,[CODPRI]
			   ,[IDACOUBI]
			   ,[CODCLR]
			   ,[TENGOACUM]
			   ,[CARPETAACUM]
			   ,[ES_FINEST]
			   ,[codubi]
			   ,[ubica]
			   ,[fecubi]
			   ,[CODSUBEST]
			   ,[FECSUBEST]
			   ,[FECPLAZO]
			   ,[FOLCUAN]
			   ,[CODSECTOR]
			   ,[CODESC]
			   ,[FECTURNMAG]
			   ,[CODMON]
			   ,[ESELECTRONICO]
			   ,[CODTAREA]
			   ,[CODACTUBI]
			   ,[CODSECCION]
			   ,[CASORELEVANTE]
			   ,[EMBARGOF])
	SELECT		@L_Carpeta					--CARPETA
			   ,E.TC_NumeroExpediente		--NUE
			   ,COALESCE(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Asunto', ED.TN_CodAsunto,0,0),'')--CODASU
			   ,COALESCE(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'ClaseAsunto', ED.TN_CodClaseAsunto,0,0),'')--CODCLAS
			   ,'M1'						--CODMAT
			   ,ED.TF_Entrada				--FECENT
			   ,GETDATE()					--FECULTACT
			   ,ED.TC_CodContexto			--CODDEJ
			   ,CT.TC_CodMateria			--CODJURIS
			   ,NULL						--CODPRO
			   ,NULL						--CODJUDEC
			   ,NULL						--CODJUTRA
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Fase', EF.TN_CodFase,0,0) --CODFAS
			   ,EF.TF_Fase					--FECFASE
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Estado', MC.TN_CodEstado,0,0)--CODESTASU
			   ,MC.TF_Fecha					--FECEST
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'GrupoTrabajo', ED.TN_CodGrupoTrabajo,0,0)--CODGT
			   ,COALESCE(NULLIF(E.TC_Descripcion, ''), 'Sin Observaciones')	--DESCRIP
			   ,NULL						--CUANTIA
			   ,NULL						--CODCUANTIA
			   ,1							--PIEZA
			   ,NULL						--NUMFOL
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Prioridad', E.TN_CodPrioridad,0,0)--CODPRI
			   ,NULL						--IDACOUBI
			   ,NULL						--CODCLR
			   ,NULL						--TENGOACUM - 1 si es pap 
			   ,NULL						--CARPETAACUM - Carpeta de Pap 
			   ,'S'							--ES_FINEST - Si ya est  terminado
			   ,NULL						--CODUBI
			   ,'Recepción de itineración'	--UBICA
			   ,NULL						--FECUBI
			   ,NULL						--CODSUBEST
			   ,NULL						--FECSUBEST
			   ,NULL						--FECPLAZO
			   ,NULL						--FOLCUAN
			   ,NULL						--CODSECTOR
			   ,NULL						--CODESC
			   ,NULL						--FECTURNMAG
			   ,NULL						--CODMON
			   ,1							--ESELECTRONICO
			   ,NULL						--CODTAREA
			   ,NULL						--CODACTUBI
			   ,NULL						--CODSECCION
			   ,NULL						--CASORELEVANTE
			   ,E.TB_EmbargosFisicos		--EMBARGOF								
	FROM		Expediente.LegajoDetalle		ED	WITH (NOLOCK)
	INNER JOIN	Expediente.Legajo				E	WITH (NOLOCK)
	ON			E.TU_CodLegajo					=	ED.TU_CodLegajo	
	INNER JOIN	Catalogo.Contexto				CT	WITH (NOLOCK)
	ON			CT.TC_CodContexto				=	ED.TC_CodContexto
	LEFT JOIN	Historico.LegajoMovimientoCirculante MC WITH (NOLOCK)
	ON			MC.TU_CodLegajo					=	ED.TU_CodLegajo
	AND			MC.TF_Fecha						=	(	
														SELECT	MAX(TF_Fecha)
														FROM	Historico.LegajoMovimientoCirculante WITH (NOLOCK)
														WHERE	TU_CodLegajo	= ED.TU_CodLegajo
													)

	LEFT JOIN	Historico.LegajoFase			EF	WITH (NOLOCK)
	ON			EF.TU_CodLegajo					=	ED.TU_CodLegajo
	AND			EF.TF_Fase						=	(	
														SELECT	MAX(TF_Fase)
														FROM	Historico.LegajoFase WITH (NOLOCK)
														WHERE	TU_CodLegajo	= ED.TU_CodLegajo
													)
	WHERE		ED.TU_CodLegajo					=	@L_TU_CodLegajo
	AND			ED.TC_CodContexto				=	@L_TC_CodContextoOrigen;
		
	-- Fecha Incio del Proceso
	INSERT INTO @DNUE
			   ([NUE]
			   ,[FEININUE]
			   ,[INDBOR])
	SELECT TOP 1
				 MC.TC_NumeroExpediente		--NUE
				,MC.TF_Fecha				--FEININUE
				,'N'						--INDBOR
	FROM		Historico.LegajoMovimientoCirculante		MC	WITH (NOLOCK)
	WHERE		MC.TU_CodLegajo								=	@L_TU_CodLegajo
	AND			MC.TC_Movimiento							=	'E'
	ORDER BY	MC.TF_Fecha									ASC;

	-- Consulta de registros en tabla temporal de movimientos circulantes
	INSERT INTO @MOVCIRCULANTES
				--Datos de DACO
				([CARPETA]
				,[IDACO]
				,[CODDEJ]	
				,[FECHA]
				,[TEXTO]
				,[CODACO]
				,[NUMACO]
				,[FECSYS]
				,[IDUSU]
				,[CODDEJUSR]
				,[CODESTACO]
				,[FECEST]
				,[NUMFOL]
				,[NUMFOLINI]
				,[PIEZA]
				,[CODPRO]
				,[CODJUDEC]
				,[CODJUTRA]
				,[CODTRAM]
				,[CODESTADIST]
				,[CODTIDEJ]
				,[IDACOREL]
				,[CODREL]
				,[PRIORI]
				,[CODICO]
				,[AMPLIAR]
				,[CANT]
				,[CODGT]
				,[CODESC]
				,[FECENTRDD]
				,[CODTIPDOC]
				,[OTRGEST]
				,[IDENTREGA]
				,[FINALIZAEXP]
				--- Datos de DHISFEP
				,[FECPRO]
				,[CODFAS]
				,[FECFASE]
				,[CODESTASU]
				,[FECESTASU]
				,[FINEST]
				,[CODSUBEST]
				,[FECSUBEST]
				,[TU_CodArchivo]
				,[TN_CodLegajoMovimientoCirculante])
	SELECT		@L_Carpeta																						-- [CARPETA]
				,CASE
					WHEN MC.TC_Movimiento = 'E' THEN NULL
					ELSE ISNULL(ROW_NUMBER() over (order by MC.TF_Particion ASC) + @L_DacoInicial -1 -
					(select COUNT(isnull(IDACO,1)) from @MOVCIRCULANTES),@L_DacoInicial
					)
				 END																							-- [IDACO]
				,MC.TC_CodContexto																				-- [CODDEJ]
				,MC.TF_Fecha																					-- [FECHA]
				,CASE
					WHEN MC.TC_Movimiento = 'R' THEN 'Carpeta Reentrada//'
					ELSE 'Actualizar fase, estado y subestado/Actualizar fase, estados y subestado'					
				END																								-- [TEXTO]
				,CASE
					WHEN MC.TC_Movimiento = 'R' THEN 'REENT'
					ELSE 'WAFE'				
				END																								-- [CODACO]	
				,CASE
					WHEN MC.TC_Movimiento = 'E' THEN NULL
					ELSE ISNULL(ROW_NUMBER() over (order by MC.TF_Particion ASC) + @L_DacoInicial -1 -
					(select COUNT(isnull(IDACO,1)) from @MOVCIRCULANTES),@L_DacoInicial
					)
				 END																							-- [NUMACO]
				,MC.TF_Fecha																					-- [FECHASYS]
				,USU.TC_UsuarioRed																				-- [IDUSU]
				,@L_TC_CodContextoOrigen																		-- [CODDEJSUR] -- quien itineró código oficina origen
				,5																								-- [CODESTACO]
				,NULL																							-- [FECEST]
				,NULL																							-- [NUMFOL]
				,NULL																							-- [NUMFOLINI]
				,NULL																							-- [PIEZA]
				,NULL																							-- [CODPRO]
				,NULL																							-- [CODJUDEC]			
				,NULL																							-- [CODJUTRA]
				,CASE
					WHEN MC.TC_Movimiento = 'R' THEN 'CARPREENT'
					ELSE 'A_FAST_EST'			
					END																										-- [CODTRAM]
				,NULL																										-- [CODESTADIST]
				,C.CODTIDEJ																									-- [CODTIDEJ]
				,NULL																										-- [IDACOREL]
				,NULL																										-- [CODREL]
				,0																											-- [PRIORI]
				,NULL 																										-- [CODICO]
				,NULL		 																								-- [AMPLIAR]
				,NULL 																										-- [CANT]
				,NULL 																										-- [CODGT]
				,NULL																										-- [CODESC]
				,NULL 																										-- [FECENTRDD]		
				,NULL 																										-- [CODTIPDOC]	
				,0																											-- [OTRGEST]
				,NULL 																										-- [IDENTREGA]
				,NULL																										-- [FINALIZAEXP]
				,NULL																										-- [FECPRO]
				,NULL																										-- [CODFAS]
				,NULL																										-- [FECFASE]
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(MC.TC_CodContexto,'Estado', MC.TN_CodEstado,0,0)	-- [CODESTASU]
				,MC.TF_Fecha																								-- [FECESTASU]
				,CASE
					WHEN MC.TC_Movimiento = 'E' THEN 'C'
					WHEN MC.TC_Movimiento = 'F' THEN 'F'
					WHEN MC.TC_Movimiento = 'R' THEN 'R'
					ELSE NULL
					END																										-- [FINEST]
				,NULL																										-- [CODSUBEST]
				,NULL																										-- [FECSUBEST]
				,MC.TU_CodArchivo																							-- [TU_CodArchivo] Llave Documento SIAGPJ para sustituir IDACO de documento
				,MC.TN_CodLegajoMovimientoCirculante																		-- [TN_CodExpedienteMovimientoCirculante]
	FROM		Historico.LegajoMovimientoCirculante		MC	WITH (NOLOCK)
	LEFT JOIN	Catalogo.Contexto							C	WITH (NOLOCK)
	ON			C.TC_CodContexto							=	MC.TC_CodContexto
	LEFT JOIN	Catalogo.Oficina							O	WITH (NOLOCK)
	ON			O.TC_CodOficina								=	C.TC_CodOficina
	LEFT JOIN	Catalogo.TipoOficina						T	WITH (NOLOCK)
	ON			T.TN_CodTipoOficina							=	O.TN_CodTipoOficina	
	OUTER APPLY
	(
		SELECT	TC_UsuarioRed 
		FROM	Catalogo.PuestoTrabajoFuncionario	WITH(NOLOCK)
		WHERE	TU_CodPuestoFuncionario				= MC.TU_CodPuestoFuncionario
	)USU
	WHERE		MC.TU_CodLegajo								=	@L_TU_CodLegajo
	ORDER BY	MC.TF_Fecha									ASC;

	--******************************************************************************************************************************************************************
	--ACTUALIZACION DE REGISTROS PARA INCLUIR CAMBIOS DE FASE Y ESTADO	
	-- NOTA: tomar en cuenta que algunos DACOs se brincan porque se eliminan movimientos circulantes repetidos mas abajo																												 
	--******************************************************************************************************************************************************************

	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + 1
	SELECT @L_DacoInicial =  (COUNT(*) + @L_DacoInicial ) FROM @MOVCIRCULANTES;

	--CARGA REGISTROS DE MOVIMIENTO FASE DEL REGISTRO CON FINNEST "C"
	INSERT INTO @MOVCIRCULANTES2
	SELECT		A.CARPETA,																						--[CARPETA]				
				ISNULL(ROW_NUMBER() over (order by A.FECHA ASC) + @L_DacoInicial -1,@L_DacoInicial),			-- [IDACO]
				A.CODDEJ, 
				B.TF_Fecha,																						-- [FECHA]
				A.TEXTO,
				A.CODACO,
				ISNULL(ROW_NUMBER() over (order by A.FECHA ASC) + @L_DacoInicial -1,@L_DacoInicial),			-- [NUMACO]
				B.TF_Fecha,																						-- [FECHASYS]
				A.IDUSU,
				A.CODDEJUSR,
				A.CODESTACO,				
				B.TF_Fecha,																						-- [FECEST] 
				A.NUMFOL, 
				A.NUMFOLINI,
				A.PIEZA,
				A.CODPRO,
				A.CODJUDEC,
				A.CODJUTRA,
				A.CODTRAM, 
				A.CODESTADIST,
				A.CODTIDEJ,
				A.IDACOREL,
				A.CODREL,
				A.PRIORI,
				A.CODICO,
				A.AMPLIAR,
				A.CANT,
				A.CODGT,
				A.CODESC,
				A.FECENTRDD,
				A.CODTIPDOC,
				A.OTRGEST,
				A.IDENTREGA, 
				A.FINALIZAEXP,
				A.FECPRO,
				A.CODFAS,
				B.TF_Fecha,																						-- [FECFASE] 
				A.CODESTASU,
				B.TF_Fecha,																						-- [FECESTASU]
				NULL,																							-- [FINEST]
				A.CODSUBEST,
				A.FECSUBEST, 
				NULL, 
				A.TN_CodLegajoMovimientoCirculante
	FROM		@MOVCIRCULANTES									A	
	LEFT JOIN	Historico.LegajoMovimientoCirculanteFase		B	WITH (NOLOCK)
	ON			B.TN_CodLegajoMovimientoCirculante				=	A.TN_CodLegajoMovimientoCirculante	
	WHERE		B.TC_NumeroExpediente							=	@L_TC_NumeroExpediente
	AND			A.FINEST										=	'C'	
	ORDER BY	B.TF_Fecha										ASC;
		
	--UPDATE SOBRE REGISTRO DE CREACION
	UPDATE		A
	SET			A.FECFASE	= B.FECFASE,
				A.FECEST	= B.FECEST
	FROM		@MOVCIRCULANTES									A
	INNER JOIN  @MOVCIRCULANTES2								B
	ON			A.TN_CodLegajoMovimientoCirculante				= B.TN_CodLegajoMovimientoCirculante;

	--ELIMINA EL PRIMER DATO DE LA CONSULTA PORQUE YA ESTA INCLUIDO, EN CASO DE ESTAR REPETIDO MAS DE 1 VEZ
	IF ((SELECT Count(*) FROM @MOVCIRCULANTES2) > 1)
	BEGIN
		WITH DATO AS 
		( 
			SELECT TOP	1 * 
			FROM		@MOVCIRCULANTES2 
			ORDER BY	FECHA ASC 
		) 	
		DELETE FROM DATO
	END

	--INGRESA LOS REGISTROS DE FASE 
	INSERT INTO @MOVCIRCULANTES
	SELECT * FROM @MOVCIRCULANTES2

	SELECT @L_DacoInicial =  (COUNT(*) + @L_DacoInicial ) FROM @MOVCIRCULANTES;																		
	--LIMPIA TABLA TEMPORAL
	DELETE FROM @MOVCIRCULANTES2

	--CARGA REGISTROS DE MOVIMIENTO FASE DEL REGISTRO CON FINNEST "F"
	INSERT INTO @MOVCIRCULANTES2
	SELECT		A.CARPETA,																						--[CARPETA]				
				ISNULL(ROW_NUMBER() over (order by A.FECHA ASC) + @L_DacoInicial -1,@L_DacoInicial),			-- [IDACO]
				A.CODDEJ, 
				B.TF_Fecha,																						-- [FECHA]
				A.TEXTO,
				A.CODACO,
				ISNULL(ROW_NUMBER() over (order by A.FECHA ASC) + @L_DacoInicial -1,@L_DacoInicial),			-- [NUMACO]
				B.TF_Fecha,																						-- [FECHASYS]
				A.IDUSU,
				A.CODDEJUSR,
				A.CODESTACO,				
				B.TF_Fecha,																						-- [FECEST] 
				A.NUMFOL, 
				A.NUMFOLINI,
				A.PIEZA,
				A.CODPRO,
				A.CODJUDEC,
				A.CODJUTRA,
				A.CODTRAM, 
				A.CODESTADIST,
				A.CODTIDEJ,
				A.IDACOREL,
				A.CODREL,
				A.PRIORI,
				A.CODICO,
				A.AMPLIAR,
				A.CANT,
				A.CODGT,
				A.CODESC,
				A.FECENTRDD,
				A.CODTIPDOC,
				A.OTRGEST,
				A.IDENTREGA, 
				A.FINALIZAEXP,
				A.FECPRO,
				A.CODFAS,
				B.TF_Fecha,																						-- [FECFASE] 
				A.CODESTASU,
				B.TF_Fecha,																						-- [FECESTASU]
				NULL,																							-- [FINEST]
				A.CODSUBEST,
				A.FECSUBEST, 
				NULL, 
				A.TN_CodLegajoMovimientoCirculante
	FROM		@MOVCIRCULANTES									A
	LEFT JOIN	Historico.LegajoMovimientoCirculanteFase		B	WITH (NOLOCK)
	ON			B.TN_CodLegajoMovimientoCirculante				=	A.TN_CodLegajoMovimientoCirculante		
	WHERE		B.TC_NumeroExpediente							=	@L_TC_NumeroExpediente
	AND			A.FINEST										=	'F'		
	ORDER BY	B.TF_Fecha										ASC;

	--UPDATE SOBRE REGISTRO DE FINALIZACION
	UPDATE		A
	SET			A.FECFASE	= B.FECFASE,
				A.FECEST	= B.FECEST
	FROM		@MOVCIRCULANTES									A
	INNER JOIN  @MOVCIRCULANTES2								B
	ON			A.TN_CodLegajoMovimientoCirculante				= B.TN_CodLegajoMovimientoCirculante;

	--ELIMINA EL PRIMER DATO DE LA CONSULTA PORQUE YA ESTA INCLUIDO
	IF ((SELECT COUNT(*) FROM @MOVCIRCULANTES2) > 1) 
	BEGIN
		WITH DATO AS 
		( 
			SELECT TOP	1 * 
			FROM		@MOVCIRCULANTES2 
			ORDER BY	FECHA ASC 
		) 	
		DELETE FROM DATO
	END

	--INGRESA LOS REGISTROS DE FASE 
	INSERT INTO @MOVCIRCULANTES
	SELECT * FROM @MOVCIRCULANTES2

	SELECT @L_DacoInicial =  (COUNT(*) + @L_DacoInicial ) FROM @MOVCIRCULANTES;															
	--LIMPIA TABLA TEMPORAL
	DELETE FROM @MOVCIRCULANTES2

	--CARGA REGISTROS DE MOVIMIENTO FASE DEL REGISTRO CON FINNEST "R"
	INSERT INTO @MOVCIRCULANTES2
	SELECT		A.CARPETA,																						--[CARPETA]				
				ISNULL(ROW_NUMBER() over (order by A.FECHA ASC) + @L_DacoInicial -1,@L_DacoInicial),			-- [IDACO]
				A.CODDEJ, 
				B.TF_Fecha,																						-- [FECHA]
				A.TEXTO,
				A.CODACO,
				ISNULL(ROW_NUMBER() over (order by A.FECHA ASC) + @L_DacoInicial -1,@L_DacoInicial),			-- [NUMACO]
				B.TF_Fecha,																						-- [FECHASYS]
				A.IDUSU,
				A.CODDEJUSR,
				A.CODESTACO,				
				B.TF_Fecha,																						-- [FECEST] 
				A.NUMFOL, 
				A.NUMFOLINI,
				A.PIEZA,
				A.CODPRO,
				A.CODJUDEC,
				A.CODJUTRA,
				A.CODTRAM, 
				A.CODESTADIST,
				A.CODTIDEJ,
				A.IDACOREL,
				A.CODREL,
				A.PRIORI,
				A.CODICO,
				A.AMPLIAR,
				A.CANT,
				A.CODGT,
				A.CODESC,
				A.FECENTRDD,
				A.CODTIPDOC,
				A.OTRGEST,
				A.IDENTREGA, 
				A.FINALIZAEXP,
				A.FECPRO,
				A.CODFAS,
				B.TF_Fecha,																						-- [FECFASE] 
				A.CODESTASU,
				B.TF_Fecha,																						-- [FECESTASU]
				NULL,																							-- [FINEST]
				A.CODSUBEST,
				A.FECSUBEST, 
				NULL, 
				A.TN_CodLegajoMovimientoCirculante
	FROM		@MOVCIRCULANTES									A
	LEFT JOIN	Historico.LegajoMovimientoCirculanteFase		B	WITH (NOLOCK)
	ON			B.TN_CodLegajoMovimientoCirculante				=	A.TN_CodLegajoMovimientoCirculante	
	WHERE		B.TC_NumeroExpediente							=	@L_TC_NumeroExpediente
	AND			A.FINEST										=	'R'	
	
	--UPDATE SOBRE REGISTRO DE REENTRADO
	UPDATE		A
	SET			A.FECFASE							= B.FECFASE,
				A.FECEST							= B.FECEST
	FROM		@MOVCIRCULANTES						A
	INNER JOIN  @MOVCIRCULANTES2					B
	ON			A.TN_CodLegajoMovimientoCirculante	= B.TN_CodLegajoMovimientoCirculante;

	--ELIMINA EL PRIMER DATO DE LA CONSULTA PORQUE YA ESTA INCLUIDO, EN CASO DE ESTAR REPETIDO MAS DE 1 VEZ
	IF ((SELECT Count(*) FROM @MOVCIRCULANTES2) > 1)
	BEGIN
		WITH DATO AS 
		( 
			SELECT TOP	1 * 
			FROM		@MOVCIRCULANTES2 
			ORDER BY	FECHA ASC 
		) 	
		DELETE FROM DATO
	END

	--INSERTA REGISTROS EN MOVCIRCULANTE
	INSERT INTO @MOVCIRCULANTES
	SELECT * FROM @MOVCIRCULANTES2

	SELECT @L_DacoInicial =  (COUNT(*) + @L_DacoInicial ) FROM @MOVCIRCULANTES;																		
	--LIMPIA TABLA TEMPORAL
	DELETE FROM @MOVCIRCULANTES2

	INSERT INTO @MOVCIRCULANTES2
	SELECT		A.CARPETA,																						--[CARPETA]				
				ISNULL(ROW_NUMBER() over (order by A.FECHA ASC) + @L_DacoInicial -1,@L_DacoInicial),			-- [IDACO]
				A.CODDEJ, 
				B.TF_Fecha,																						-- [FECHA]
				A.TEXTO,
				A.CODACO,
				ISNULL(ROW_NUMBER() over (order by A.FECHA ASC) + @L_DacoInicial -1,@L_DacoInicial),			-- [NUMACO]
				B.TF_Fecha,																						-- [FECHASYS]
				A.IDUSU,
				A.CODDEJUSR,
				A.CODESTACO,				
				B.TF_Fecha,																						-- [FECEST] 
				A.NUMFOL, 
				A.NUMFOLINI,
				A.PIEZA,
				A.CODPRO,
				A.CODJUDEC,
				A.CODJUTRA,
				A.CODTRAM, 
				A.CODESTADIST,
				A.CODTIDEJ,
				A.IDACOREL,
				A.CODREL,
				A.PRIORI,
				A.CODICO,
				A.AMPLIAR,
				A.CANT,
				A.CODGT,
				A.CODESC,
				A.FECENTRDD,
				A.CODTIPDOC,
				A.OTRGEST,
				A.IDENTREGA, 
				A.FINALIZAEXP,
				A.FECPRO,
				A.CODFAS,
				B.TF_Fecha,																						-- [FECFASE] 
				A.CODESTASU,
				B.TF_Fecha,																						-- [FECESTASU]
				NULL,																							-- [FINEST]
				A.CODSUBEST,
				A.FECSUBEST, 
				NULL, 
				A.TN_CodLegajoMovimientoCirculante
	FROM		@MOVCIRCULANTES									A
	LEFT JOIN	Historico.LegajoMovimientoCirculanteFase		B	WITH (NOLOCK)
	ON			B.TN_CodLegajoMovimientoCirculante				=	A.TN_CodLegajoMovimientoCirculante
	WHERE		B.TC_NumeroExpediente							=	@L_TC_NumeroExpediente	
	AND			A.FECFASE										IS NULL 	
	ORDER BY	B.TF_Fecha										ASC;

	--UPDATE SOBRE REGISTRO DE SON DE CAMBIOS DE ESTADO
	UPDATE		A
	SET			A.FECFASE	= B.FECFASE,
				A.FECEST	= B.FECEST	
	FROM		@MOVCIRCULANTES									A
	INNER JOIN  @MOVCIRCULANTES2								B
	ON			A.TN_CodLegajoMovimientoCirculante				= B.TN_CodLegajoMovimientoCirculante;

	--LIMPIA TABLA TEMPORAL
	DELETE FROM @MOVCIRCULANTES2

	--******************************************************************************************************************************************************************
	-- FIN ACTUALIZACION DE REGISTROS
	--******************************************************************************************************************************************************************

	-- Movimiento Circulante
	INSERT INTO @DHISFEP
			   ([CARPETA]
			   ,[IDACO]
			   ,[FECHA]
			   ,[CODTIDEJ]
			   ,[CODDEJ]
			   ,[CODPRO]
			   ,[FECPRO]
			   ,[CODFAS]
			   ,[FECFASE]
			   ,[CODESTASU]
			   ,[FECESTASU]
			   ,[FINEST]
			   ,[CODSUBEST]
			   ,[FECSUBEST]
			   ,[TU_CodArchivo])
	SELECT		CARPETA		
				,IDACO		
				,FECHA		
				,CODTIDEJ	
				,CODDEJ		
				,NULL		
				,NULL		
				,CODFAS		
				,FECFASE	
				,CODESTASU	
				,FECESTASU	
				,FINEST		
				,CODSUBEST	
				,FECSUBEST	
				,TU_CodArchivo		-- Llave Documento SIAGPJ para sustituir IDACO de documento
	FROM		@MOVCIRCULANTES

	-- Movimiento Circulante Fase y Estado -- DACO
	INSERT INTO @DACO
			   ([CARPETA]
			   ,[IDACO]
			   ,[CODDEJ]
			   ,[FECHA]
			   ,[TEXTO]
			   ,[CODACO]
			   ,[NUMACO]
			   ,[FECSYS]
			   ,[IDUSU]
			   ,[CODDEJUSR]
			   ,[CODESTACO]
			   ,[FECEST]
			   ,[NUMFOL]
			   ,[NUMFOLINI]
			   ,[PIEZA]
			   ,[CODPRO]
			   ,[CODJUDEC]
			   ,[CODJUTRA]
			   ,[CODTRAM]
			   ,[CODESTADIST]
			   ,[CODTIDEJ]
			   ,[IDACOREL]
			   ,[CODREL]
			   ,[PRIORI]
			   ,[CODICO]
			   ,[AMPLIAR]
			   ,[CANT]
			   ,[CODGT]
			   ,[CODESC]
			   ,[FECENTRDD]
			   ,[CODTIPDOC]
			   ,[OTRGEST]			   
			   ,[IDENTREGA]
			   ,[FINALIZAEXP])
	SELECT		CARPETA
			   ,IDACO
			   ,CODDEJ
			   ,FECHA
			   ,TEXTO
			   ,CODACO
			   ,NUMACO
			   ,FECSYS
			   ,IDUSU
			   ,CODDEJUSR
			   ,CODESTACO
			   ,FECEST
			   ,NUMFOL
			   ,NUMFOLINI
			   ,PIEZA
			   ,CODPRO
			   ,CODJUDEC
			   ,CODJUTRA
			   ,CODTRAM
			   ,CODESTADIST
			   ,CODTIDEJ
			   ,IDACOREL
			   ,CODREL
			   ,PRIORI
			   ,CODICO
			   ,AMPLIAR
			   ,CANT
			   ,CODGT
			   ,CODESC
			   ,FECENTRDD
			   ,CODTIPDOC
			   ,OTRGEST		   
			   ,IDENTREGA
			   ,FINALIZAEXP
	FROM		@MOVCIRCULANTES
	WHERE		IDACO IS NOT NULL

	-- Histórico de DACO de cambio de ubicación de un legajo		
	INSERT INTO @DACO
			   ([CARPETA]
			   ,[IDACO]
			   ,[CODDEJ]
			   ,[FECHA]
			   ,[TEXTO]
			   ,[CODACO]
			   ,[NUMACO]
			   ,[FECSYS]
			   ,[IDUSU]
			   ,[CODDEJUSR]
			   ,[CODESTACO]
			   ,[FECEST]
			   ,[NUMFOL]
			   ,[NUMFOLINI]
			   ,[PIEZA]
			   ,[CODPRO]
			   ,[CODJUDEC]
			   ,[CODJUTRA]
			   ,[CODTRAM]
			   ,[CODESTADIST]
			   ,[CODTIDEJ]
			   ,[IDACOREL]
			   ,[CODREL]
			   ,[PRIORI]
			   ,[CODICO]
			   ,[AMPLIAR]
			   ,[CANT]
			   ,[CODGT]
			   ,[CODESC]
			   ,[FECENTRDD]
			   ,[CODTIPDOC]
			   ,[OTRGEST]			   
			   ,[IDENTREGA]
			   ,[FINALIZAEXP])			  
	Select 		@L_Carpeta,																					-- [CARPETA]
				ISNULL(ROW_NUMBER() over (order by EU.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial),-- [IDACO]
				EU.TC_CodContexto,																			-- [CODDEJ]
				EU.TF_FechaUbicacion,																		-- [FECHA]
				'Gestión de Ubicaciones/Control Ubicaciones',												-- [TEXTO]
				'UBI',																						-- [CODACO]	
				ISNULL(ROW_NUMBER() over (order by EU.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial),-- [NUMACO]
				EU.TF_FechaUbicacion,																		-- [FECSYS]
				EU.TC_UsuarioRed, 																			-- [IDUSU]
				@L_TC_CodContextoOrigen,																	-- [CODDEJSUR] -- quien itineró código oficina origen
				5,																							-- [CODESTACO]
				EU.TF_FechaUbicacion,																		-- [FECEST]
				NULL,																						-- [NUMFOL]
				NULL,																						-- [NUMFOLINI]
				NULL,																						-- [PIEZA]
				NULL,																						-- [CODPRO]
				NULL,																						-- [CODJUDEC]			
				NULL,																						-- [CODJUTRA]
				'GESTUBI',																					-- [CODTRAM]
				NULL,																						-- [CODESTADIST]
				C.CODTIDEJ,																					-- [CODTIDEJ]
				NULL,																						-- [IDACOREL]
				NULL,																						-- [CODREL]
				0,																							-- [PRIORI]
				NULL, 																						-- [CODICO]
				'5;',	 																					-- [AMPLIAR]
				NULL, 																						-- [CANT]
				NULL, 																						-- [CODGT]
				NULL,																						-- [CODESC]
				NULL, 																						-- [FECENTRDD]		
				NULL, 																						-- [CODTIPDOC]	
				0,																							-- [OTRGEST]
				NULL, 																						-- [IDENTREGA]
				NULL																						-- [FINALIZAEXP]
	FROM		Historico.LegajoUbicacion					EU	WITH (NOLOCK)	
	INNER JOIN	Catalogo.Contexto							C	WITH (NOLOCK)
	ON			C.TC_CodContexto							=	EU.TC_CodContexto
	WHERE		EU.TU_CodLegajo								=	@L_TU_CodLegajo

	-- Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO para el movimiento circulante + 1
	SELECT @L_DacoInicial = ISNULL((SELECT MAX(IDACO) + 1 FROM @DACO WHERE IDACO IS NOT NULL), @L_DacoInicial);

	-- Se inserta en DACO el registro de reentrante si el despacho de destino existe dentro de la lista de movimientos circulantes
	INSERT INTO @DACO
				([CARPETA]
				,[IDACO]
				,[CODDEJ]
				,[FECHA]
				,[TEXTO]
				,[CODACO]
				,[NUMACO]
				,[FECSYS]
				,[IDUSU]
				,[CODDEJUSR]
				,[CODESTACO]
				,[FECEST]
				,[NUMFOL]
				,[NUMFOLINI]
				,[PIEZA]
				,[CODPRO]
				,[CODJUDEC]
				,[CODJUTRA]
				,[CODTRAM]
				,[CODESTADIST]
				,[CODTIDEJ]
				,[IDACOREL]
				,[CODREL]
				,[PRIORI]
				,[CODICO]
				,[AMPLIAR]
				,[CANT]
				,[CODGT]
				,[CODESC]
				,[FECENTRDD]
				,[CODTIPDOC]
				,[OTRGEST]			   
				,[IDENTREGA]
				,[FINALIZAEXP])
	SELECT		@L_Carpeta,																						-- [CARPETA]
				ISNULL(ROW_NUMBER() over (order by HI.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial),	-- [IDACO]
				HI.TC_CodContextoDestino,																		-- [CODDEJ]
				HI.TF_FechaEstado,																				-- [FECHA]
				'Carpeta Reentrada//',																			-- [TEXTO]
				'REENT',																						-- [CODACO]	
				ISNULL(ROW_NUMBER() over (order by HI.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial),	-- [NUMACO]
				HI.TF_FechaEstado,																				-- [FECSYS]
				HI.TC_UsuarioRed, 																				-- [IDUSU]
				HI.TC_CodContextoOrigen,																		-- [CODDEJSUR]
				5,																								-- [CODESTACO]
				HI.TF_FechaEstado,																				-- [FECEST]
				NULL,																							-- [NUMFOL]
				NULL,																							-- [NUMFOLINI]
				NULL,																							-- [PIEZA]
				NULL,																							-- [CODPRO]
				NULL,																							-- [CODJUDEC]			
				NULL,																							-- [CODJUTRA]
				'CARPREENT',																					-- [CODTRAM]
				NULL,																							-- [CODESTADIST]
				C.CODTIDEJ,																						-- [CODTIDEJ]
				NULL,																							-- [IDACOREL]
				NULL,																							-- [CODREL]
				0,																								-- [PRIORI]
				NULL, 																							-- [CODICO]
				NULL,	 																						-- [AMPLIAR]
				NULL, 																							-- [CANT]
				NULL, 																							-- [CODGT]
				NULL,																							-- [CODESC]
				NULL, 																							-- [FECENTRDD]		
				NULL, 																							-- [CODTIPDOC]	
				0,																								-- [OTRGEST]
				NULL, 																							-- [IDENTREGA]
				NULL																							-- [FINALIZAEXP]								
	FROM		Historico.Itineracion			HI	WITH (NOLOCK)
	LEFT JOIN	Catalogo.Contexto				C	WITH (NOLOCK)
	ON			HI.TC_CodContextoDestino		=	C.TC_CodContexto
	WHERE		HI.TU_CodHistoricoItineracion	=	@L_CodHistoricoItineracion
	AND			EXISTS (
					SELECT		MC.CODDEJ
					FROM		@MOVCIRCULANTES					MC
					INNER JOIN	Historico.Itineracion 			I	WITH (NOLOCK)	
					ON			MC.CODDEJ						=	I.TC_CodContextoDestino 
					AND			I.TU_CodHistoricoItineracion	=	@L_CodHistoricoItineracion
				)

	-- Tablas a devolver
	SELECT * FROM @DCAR;

	SELECT * FROM @DHISFEP ORDER BY FECFASE ASC;	
	
	SELECT * FROM @DCARMASD;

	SELECT * FROM @DNUE;

	SELECT * FROM @DACO;
END
GO
