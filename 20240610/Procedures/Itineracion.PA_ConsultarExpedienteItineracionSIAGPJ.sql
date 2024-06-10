SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<27/01/2020>
-- Descripción :			<Permite consultar los datos de un Expediente/Expediente Detalle/Movimiento Circulante y lugar de los hechos de
--							 SIAGPJ mapeado a registros de Gestión con sus catálogos respectivos>
-- ==============================================================================================================================================================================================================
-- Modificación:			<09/02/2021> <Karol Jiménez Sánchez> <Se modifica para incluir consulta de CARPETA>
-- Modificación:			<17/02/2021> <Ronny Ramírez R.> <Se modifica para filtrar por el contexto del Expediente Detalle y se comenta DCARMASD mientras se define COLDAT>
-- Modificación :			<22/02/2021> <Karol Jiménez Sánchez><Se agrega Identity para generar IDFEP de DHISFEP>
-- Modificación :			<22/02/2021> <Richard Zúñiga Segura><Se incorpora la consulta para tabla DACO>
-- Modificación :			<22/02/2021> <Ronny Ramírez Rojas><Se agrega el mapeo de acumulación del expediente en DACO>
-- Modificación :			<23/02/2021> <Ronny Ramírez Rojas><Se agrega el mapeo del histórico de acumulación/desacumulación y cambio de ubicación del expediente en DACO>
-- Modificación :			<23/02/2021> <Ronny Ramírez Rojas><Se eliminan los filtros por contexto de los históricos para que traiga todos los registros>
-- Modificación :			<23/02/2021> <Richard Zúñiga Segura><Se modifican las fechas de mov circulante y de fase. Adcionamente se cambia el CODDEJUSR de la inserción en 
--							@MOVCIRCULANTES>
-- Modificación :			<25/02/2021> <Richard Zúñiga Segura><Se agrega condición para agregar movimiento de reentrante en DACO>
-- Modificación :			<25/02/2021> <Ronny Ramírez Rojas><Se aplican ajustes a las secuencias de DACO y se agrega para el reentrante>
-- Modificación :			<01/03/2021> <Richard Zúñiga Segura><Se ajusta el cambio en fecha y usuario red para @MOVCIRCULANTES, y adicionalmente la consulta de reentrado>
-- Modificación :			<02/03/2021> <Richard Zúñiga Segura><Se ajusta IDACO para @MOVCIRCULANTES y cambio en insersión de DHISFEP y DACO>
-- Modificación:			<19/03/2021> <Karol Jiménez S.> <Se ajusta valor caso relevante a S-N>
-- Modificación:			<22/03/2021> <Ronny Ramírez R.> <Se agregan los datos de pensión alimentaria al DCARMASD>
-- Modificado:				<06/04/2021> <Karol Jiménez Sánchez><Se ajusta campos PRIORI y AMPLIAR de DACO>
-- Modificado:				<09/04/2021> <Karol Jiménez Sánchez><Se cambia ISNULL para campo FECHA de DHISFEP, para que tome primero la fecha de ExpedienteMovimientoCirculante 
--							y no la de la fase>
-- Modificación:			<25/06/2021> <Ronny Ramírez R.> <Se agrega el dato de moneda CODMON a DCAR>
-- Modificación:			<29/06/2021> <Ronny Ramírez R.> <Se aplica recálculo de IDACO luego de agregar los registros de acumulación>
-- Modificación:            <13/07/2021> <Jose Gabriel Cordero Soto> <Se aplica ajuste para agregar movimiento en circulante cuando se envia expediente acumulado hijo 
--                                                                    y se logre ver tema de cierre estadístico en oficina destino>
-- Modificación:            <14/07/2021> <Jose Gabriel Cordero Soto> <Se aplica ajuste en movimientos circulante para mostrar FECENTRADA > 
-- Modificación:			<19/07/2021> <Jose Gabriel Cordero Soto> <Se eliminan registros en DHISFEP con respecto al despacho destino, esto por motivo de registro en EV actualmente>
-- Modificación:			<26/08/2021> <Jose Gabriel Cordero Soto> <Se realiza ajuste en DHISFEP por cambio en el MOVCIRCULANTE y los registros por cambios de estado o fase sin registrar Movimiento>
--Modificacion:				<10/09/2021> <Jonathan Aguilar Navarro><Se realzan modificaciones para que retorne correctamente los registros de reentrados.>
-- Modificación:			<17/09/2021> <Ronny Ramírez R.> <Se aplica ajusta para evitar duplicación de DACOs por falta de recálculo>
-- Modificación:			<21/09/2021> <Ronny Ramírez R.> <Se aplica corrección para evitar que se consulten registros de movimiento circulante del expediente cascarón>
-- Modificación:			<01/10/2021> <Karol Jiménez Sánchez> <Se aplica cambio para obtención de equivalencias catálogo Estados desde módulo de equivalencias>
-- Modificación:			<17/12/2021> <Isaac Santiago Méndez Castillo> <	Se cambia la manera la cual se genera el próximo IDACO para los registros insertados en
--																			@MOVCIRCULANTES2. Incidente: 229615>
-- Modificación:			<04/01/2022> <Luis Alonso Leiva Tames> <Se cambia el tipo de dato en el campo IDFEP (int --> bigint) Inicidente #231491 >
-- Modificación:			<29/04/2022> <Luis Alonso Leiva Tames> <Se corrige la asignacion del IDACO ya que se puede insertar NULL en la tabla DACO >
-- Modificación:			<23/12/2022> <Josué Quirós Batista> <Se agrega la actualización de la variable @L_DacoInicial previo a insertar en DACO los movimientos obtenidos de Historico.ExpedienteAcumulacion>
-- Modificación:			<06/02/2023> <Ronny Ramírez R.> <Se aplica ajuste en los campos de las tablas temporales tipo DATETIME2(3), para que sean DATETIME2(7), y se eliminan actualizaciones de campos de
--							fechas de movimiento de circulante para que no se actualicen con las de las fases relacionadas, adicionalmente se agregan las fases en estado F, que se estaban perdiendo>
-- Modificación:			<01/03/2023> <Jonathan Aguilar Navarro> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos Clase, Proceso, Fase, GrupoTrabajo, 
--							TipoCuantia, Prioridad, Moneda, Delito, Provincia)>
-- Modificación:			<10/10/2023> <Karol Jiménez S.> <PBI 347803 Se agrega el mapeo del campo DCAR.EMBARGOF>
-- ==============================================================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarExpedienteItineracionSIAGPJ]
	@CodHistoricoItineracion	UNIQUEIDENTIFIER,
	@DacoInicial				INT = 1
AS
BEGIN
	---******************************************************************************************************************************************************************
	--  DEFINICION Y CARGA DE DATOS INICIAL
	---******************************************************************************************************************************************************************

	Declare	@L_TC_NumeroExpediente		CHAR(14),
			@COLDAT						VARCHAR(2),
			@L_TC_CodContextoOrigen		VARCHAR(4)			= NULL,
			@L_Carpeta					VARCHAR(14),
			@L_CodHistoricoItineracion	UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
			@L_DacoInicial				INT					= @DacoInicial,
			@L_ContextoDestino			VARCHAR(4)			= NULL;

	-- Se obtiene el # de expediente asociado al código de histórico de itineración
    SELECT  @L_TC_NumeroExpediente	= TC_NumeroExpediente,
			@L_TC_CodContextoOrigen = TC_CodContextoOrigen,
			@L_Carpeta				= CARPETA
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodHistoricoItineracion);

	--SE OBTIENE EL CONTEXTO DESTINO DE LA ITINERACION
	SELECT  @L_ContextoDestino			= TC_CodContextoDestino
	FROM    Historico.Itineracion		WITH(NOLOCK)
	WHERE   TU_CodHistoricoItineracion	= @L_CodHistoricoItineracion

	-- TODO: Johanna debe definir valor del COLDAT para su uso en DCARMASD 
	-- Se obtiene el valor de los campos COLDAT y CARPETA, según la materia del expediente
	SELECT		@COLDAT		=	CASE 
									C.TC_CodMateria WHEN 'PJ' THEN 'F2' 
									ELSE 'F1' 
								END
	FROM		Expediente.ExpedienteDetalle	ED	WITH(NoLock)
	INNER JOIN	Catalogo.Contexto				C	WITH(nolock)
	ON			C.TC_CodContexto				=	ED.TC_CodContexto
	WHERE		ED.TC_NumeroExpediente			=	@L_TC_NumeroExpediente
	AND			ED.TC_CodContexto				=	@L_TC_CodContextoOrigen
	
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

	--Definición de tabla MOVCIRCULANTES
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
			[TN_CodExpedienteMovimientoCirculante] BIGINT	NULL);

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
			[TN_CodExpedienteMovimientoCirculante] BIGINT	NULL);

	--Definición de tabla DHISFEP
	DECLARE @DHISFEP AS TABLE (
			[CARPETA]		[varchar](14)		NOT NULL,
			[IDFEP]			[Bigint]			NOT NULL IDENTITY(1,1),
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
			   ,[CASORELEVANTE],
			   EMBARGOF)
	SELECT
			    @L_Carpeta					--CARPETA
			   ,ED.TC_NumeroExpediente		--NUE
			   ,'PRI'						--CODASU
			   ,COALESCE(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Clase', ED.TN_CodClase,0,0), '')--CODCLAS
			   ,'M1'						--CODMAT
			   ,ED.TF_Entrada				--FECENT
			   ,GETDATE()					--FECULTACT
			   ,ED.TC_CodContexto			--CODDEJ
			   ,CT.TC_CodMateria			--CODJURIS
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Proceso', ED.TN_CodProceso,0,0) --CODPRO
			   ,NULL						--CODJUDEC
			   ,NULL						--CODJUTRA
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Fase', ED.TN_CodFase,0,0) --CODFAS
			   ,EF.TF_Fase					--FECFASE
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Estado', MC.TN_CodEstado,0,0)--CODESTASU
			   ,MC.TF_Fecha					--FECEST
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'GrupoTrabajo', ED.TN_CodGrupoTrabajo,0,0) --CODGT
			   ,COALESCE(NULLIF(E.TC_Descripcion, ''), 'Sin Observaciones')	--DESCRIP
			   ,E.TN_MontoCuantia			--CUANTIA
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'TipoCuantia', E.TN_CodTipoCuantia,0,0)--CODCUANTIA
			   ,1							--PIEZA
			   ,NULL						--NUMFOL
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Prioridad', E.TN_CodPrioridad,0,0)--CODPRI
			   ,NULL						--IDACOUBI
			   ,NULL						--CODCLR
			   ,CASE 
					WHEN EXISTS (
							SELECT	Historico.ExpedienteAcumulacion.TU_CodAcumulacion
							FROM	Historico.ExpedienteAcumulacion WITH (NOLOCK)
							WHERE	TC_NumeroExpedienteAcumula		=	ED.TC_NumeroExpediente
							AND		TF_FinAcumulacion				IS NULL
						) THEN 1
					ELSE NULL
				END							--TENGOACUM - 1 si es papá 
			   ,(
					SELECT	CARPETA
					FROM	Expediente.Expediente	WITH (NOLOCK)
					WHERE	TC_NumeroExpediente		= EA.TC_NumeroExpedienteAcumula
			    )							--CARPETAACUM - Carpeta de Papá
			   ,'S'							--ES_FINEST - Si ya está terminado
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
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Moneda', E.TN_CodMoneda,0,0)--CODMON
			   ,1							--ESELECTRONICO
			   ,NULL						--CODTAREA
			   ,NULL						--CODACTUBI
			   ,NULL						--CODSECCION
			   ,CASE 
					WHEN E.TB_CasoRelevante = 1 
						THEN 'S' 
					ELSE 'N'	
				END,							--CASORELEVANTE
				E.TB_EmbargosFisicos		    --EMBARGOF					
	FROM		Expediente.ExpedienteDetalle	ED	WITH (NOLOCK)
	INNER JOIN	Expediente.Expediente			E	WITH (NOLOCK)
	ON			E.TC_NumeroExpediente			=	ED.TC_NumeroExpediente
	INNER JOIN	Catalogo.Contexto				CT	WITH (NOLOCK)
	ON			CT.TC_CodContexto				=	ED.TC_CodContexto
	LEFT JOIN	Historico.ExpedienteMovimientoCirculante MC WITH (NOLOCK)
	ON			MC.TC_NumeroExpediente			=	ED.TC_NumeroExpediente
	AND			MC.TF_Fecha						=	(	
														SELECT	MAX(TF_Fecha)
														FROM	Historico.ExpedienteMovimientoCirculante	WITH (NOLOCK)
														WHERE	TC_NumeroExpediente							= ED.TC_NumeroExpediente
													)
	LEFT JOIN	Historico.ExpedienteFase		EF	WITH (NOLOCK)
	ON			EF.TC_NumeroExpediente			=	ED.TC_NumeroExpediente
	AND			EF.TF_Fase						=	(	
														SELECT	MAX(TF_Fase)
														FROM	Historico.ExpedienteFase	WITH (NOLOCK)
														WHERE	TC_NumeroExpediente			= ED.TC_NumeroExpediente
													)
	LEFT JOIN	Historico.ExpedienteAcumulacion	EA	WITH (NOLOCK)
	ON			EA.TC_NumeroExpediente			=	ED.TC_NumeroExpediente
	AND			EA.TC_CodContexto				=	ED.TC_CodContexto
	AND			EA.TF_InicioAcumulacion			=	(
														SELECT	MAX(TF_InicioAcumulacion)
														FROM	Historico.ExpedienteAcumulacion	WITH (NOLOCK)
														WHERE	TC_NumeroExpediente = ED.TC_NumeroExpediente
														AND		TF_FinAcumulacion IS NULL
													)
	WHERE		ED.TC_NumeroExpediente			=	@L_TC_NumeroExpediente
	AND			ED.TC_CodContexto				=	@L_TC_CodContextoOrigen;

	/*
	-- TODO: Se comenta mientras se define el valor de COLDAT a utilizar en la tabla @DCARMASD, Johanna lo va a definir

	-- Delito de Expediente
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT
				@L_Carpeta		--CARPETA
				,'CODDELEST'	--CODMASD
				,@COLDAT		--COLDAT
				,'1'			--IDATR
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Delito', C.TN_CodDelito,0,0) --VALOR
	FROM		Expediente.Expediente			C	WITH (NOLOCK)
	WHERE		C.TC_NumeroExpediente			=	@L_TC_NumeroExpediente;

	
	-- Es confidencial	
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT
				@L_Carpeta		--CARPETA
				,'CONFIDENC'	--CODMASD
				,@COLDAT		--COLDAT
				,'1'			--IDATR
				,CASE	
					WHEN C.TB_Confidencial = 1	
					THEN	'S' 
					ELSE	'N'
				 END			--VALOR
	FROM		Expediente.Expediente			C	WITH (NOLOCK)	
	WHERE		C.TC_NumeroExpediente			=	@L_TC_NumeroExpediente;

	-- Fecha de Hechos de Expediente
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT
				@L_Carpeta				--CARPETA
				,'FECHECHO'				--CODMASD
				,@COLDAT				--COLDAT
				,'1'					--IDATR
				,Convert(varchar(10),CONVERT(date,C.TF_Hechos,106),103) --VALOR
	FROM		Expediente.Expediente			C	WITH (NOLOCK)
	WHERE		C.TC_NumeroExpediente			=	@L_TC_NumeroExpediente
	AND			TF_Hechos IS NOT NULL;
	
	
	-- Lugar de los Hechos
	-- SACAR PROVINCIA, CANTÓN Y DISTRITO POR SEPARADO Y SEÑAS por separado??

	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT 
				@L_Carpeta				--CARPETA
				,'CODLUGAR'				--CODMASD
				,@COLDAT				--COLDAT              
				,'1'					--IDATR
				,ISNULL(A.TC_Señas, 'DESCONOCIDO')	-- VALOR
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	-- Se agrega el código de Provincia
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT 
				@L_Carpeta				--CARPETA
				,'PROVH'				--CODMASD
				,@COLDAT				--COLDAT              
				,'1'					--IDATR
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Provincia', A.TN_CodProvincia,0,0) --VALOR
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente;

	-- Se agrega el código de Cantón
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT 
				@L_Carpeta				--CARPETA
				,'CANTH'				--CODMASD
				,@COLDAT				--COLDAT              
				,'1'					--IDATR
				,C.CODCANTON			--VALOR
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	INNER JOIN   Catalogo.Canton		C	WITH (NOLOCK)
	ON          C.TN_CodCanton			=	A.TN_CodCanton
	AND         C.TN_CodProvincia		=	A.TN_CodProvincia
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	-- Se agrega el código de Distrito
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT 
				@L_Carpeta				--CARPETA
				,'DISTH'				--CODMASD
				,@COLDAT				--COLDAT              
				,'1'					--IDATR
				,D.CODDISTRITO			--VALOR
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	INNER JOIN   Catalogo.Distrito		D	WITH (NOLOCK)
	ON			D.TN_CodDistrito		=	A.TN_CodDistrito 	
	AND			D.TN_CodCanton			=	A.TN_CodCanton
	AND			D.TN_CodProvincia		=	A.TN_CodProvincia 
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente
	
	-- Se agrega el código de Barrio
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT 
				@L_Carpeta				--CARPETA
				,'BARRH'				--CODMASD
				,@COLDAT				--COLDAT              
				,'1'					--IDATR
				,B.CODBARRIO			--VALOR
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	INNER JOIN  Catalogo.Barrio			B	WITH (NOLOCK)
	ON			B.TN_CodBarrio			=	A.TN_CodBarrio
	AND			B.TN_CodDistrito		=	A.TN_CodDistrito 	
	AND			B.TN_CodCanton			=	A.TN_CodCanton
	AND			B.TN_CodProvincia		=	A.TN_CodProvincia 
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente
	
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT		@L_Carpeta				 --CARPETA
				,'LUGORI'				 --CODMASD
				,@COLDAT				 --COLDAT
				,'99'					 --IDATR
				,@L_TC_CodContextoOrigen --VALOR
		

	--	Testimonio de Piezas ??
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	
	SELECT	@L_Carpeta	--CARPETA
			,'TESTPIE'	--CODMASD
			,@COLDAT	--COLDAT		
			,'1'		--IDATR
			,CASE 
				WHEN	EXISTS (
							SELECT		A.TC_NumeroExpediente
							FROM		Expediente.ExpedienteDetalle	A	WITH (NOLOCK)
							WHERE		A.TC_NumeroExpediente			=	@L_TC_NumeroExpediente
							AND			A.TC_TestimonioPiezas			IS NOT NULL
							AND			A.TC_CodContexto				=	@L_TC_CodContextoOrigen
						)
				THEN	'S' 
				ELSE	'N'
			 END		--VALOR	
	
	TODO: esperar confirmación de Johanna para ver si se deja o no
	--Fecha entrada a la Fiscalia
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])

	SELECT		@L_Carpeta												--CARPETA
				,'FECENTFIS'											--CODMASD
				,@COLDAT												--COLDAT		
				,'1'													--IDATR
				,Convert(varchar(10),CONVERT(date,A.TF_Fecha,106),103)	--VALOR			
	FROM		Historico.ExpedienteMovimientoCirculante			A	WITH (NOLOCK)
	WHERE		A.TC_Movimiento										=	'E'
	AND			A.TC_CodContexto									=	@L_TC_CodContextoOrigen
	AND			A.TC_NumeroExpediente 								=	@L_TC_NumeroExpediente

	
	-- Datos de pensión alimentaria
	-- Monto Mensual
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT 
				@L_Carpeta				--CARPETA
				,'CUORDIN'				--CODMASD
				,@COLDAT				--COLDAT              
				,'1'					--IDATR
				,A.TN_MontoMensual		-- VALOR
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente
	AND			A.TN_MontoMensual		IS NOT NULL

	-- Monto Aguinaldo
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT 
				@L_Carpeta				--CARPETA
				,'AGUINAL'				--CODMASD
				,@COLDAT				--COLDAT              
				,'1'					--IDATR
				,A.TN_MontoAguinaldo	-- VALOR
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente
	AND			A.TN_MontoAguinaldo		IS NOT NULL

	-- Monto Salario Escolar
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT 
				@L_Carpeta					--CARPETA
				,'SALESCO'					--CODMASD
				,@COLDAT					--COLDAT              
				,'1'						--IDATR
				,A.TN_MontoSalarioEscolar	-- VALOR
	FROM		Expediente.Expediente		A	WITH (NOLOCK)
	WHERE		A.TC_NumeroExpediente		=	@L_TC_NumeroExpediente
	AND			A.TN_MontoSalarioEscolar	IS NOT NULL
*/	
	
	--	Fecha Incio del Proceso ??
	INSERT INTO @DNUE
			   ([NUE]
			   ,[FEININUE]
			   ,[INDBOR])
	SELECT TOP 1
				 MC.TC_NumeroExpediente		--NUE
				,MC.TF_Fecha				--FEININUE
				,'N'						--INDBOR
	FROM		Historico.ExpedienteMovimientoCirculante	MC	WITH (NOLOCK)
	WHERE		MC.TC_NumeroExpediente						=	@L_TC_NumeroExpediente
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
			,[TN_CodExpedienteMovimientoCirculante])
	SELECT
			@L_Carpeta																											-- [CARPETA]
			,CASE
				WHEN MC.TC_Movimiento = 'E' THEN NULL
				ELSE ISNULL(ROW_NUMBER() over (order by MC.TF_Particion ASC) + @L_DacoInicial -1 -
				(select COUNT(isnull(IDACO,1)) from @MOVCIRCULANTES),@L_DacoInicial
				)
				END																												-- [IDACO]
			,MC.TC_CodContexto																									-- [CODDEJ]
			,MC.TF_Fecha/*ISNULL(MC.TF_Fecha, EMF.TF_Fecha)*/																	-- [FECHA]
			,CASE
				WHEN MC.TC_Movimiento = 'R' THEN 'Carpeta Reentrada//'
				ELSE 'Actualizar fase, estado y subestado/Actualizar fase, estados y subestado'									
				END																												-- [TEXTO]
			,CASE
				WHEN MC.TC_Movimiento = 'R' THEN 'REENT'
				ELSE 'WAFE'				
				END																												-- [CODACO]	
			,NULL																												-- [NUMACO]
			,MC.TF_Fecha/*ISNULL(MC.TF_Fecha, EMF.TF_Fecha)*/																	-- [FECHASYS]
			,USU.TC_UsuarioRed/*ISNULL(EF.TC_UsuarioRed,USU.TC_UsuarioRed)*/													-- [IDUSU]
			,@L_TC_CodContextoOrigen																							-- [CODDEJSUR] -- quien itineró código oficina origen ????
			,5																													-- [CODESTACO]
			,NULL/*EMF.TF_Fecha*/																								-- [FECEST]
			,NULL																												-- [NUMFOL]
			,NULL																												-- [NUMFOLINI]
			,NULL																												-- [PIEZA]
			,NULL																												-- [CODPRO]
			,NULL																												-- [CODJUDEC]			
			,NULL																												-- [CODJUTRA]
			,CASE
				WHEN MC.TC_Movimiento = 'R' THEN 'CARPREENT'
				ELSE 'A_FAST_EST'			
				END																												-- [CODTRAM]
			,NULL																												-- [CODESTADIST]
			,C.CODTIDEJ																											-- [CODTIDEJ]
			,NULL																												-- [IDACOREL]
			,NULL																												-- [CODREL]
			,0																													-- [PRIORI]
			,NULL 																												-- [CODICO]
			,NULL		 																										-- [AMPLIAR]
			,NULL 																												-- [CANT]
			,NULL 																												-- [CODGT]
			,NULL																												-- [CODESC]
			,NULL 																												-- [FECENTRDD]		
			,NULL 																												-- [CODTIPDOC]	
			,0																													-- [OTRGEST]
			,NULL 																												-- [IDENTREGA]
			,NULL																												-- [FINALIZAEXP]
			,NULL																												-- [FECPRO]
			,NULL/*F.CODFAS*/																									-- [CODFAS]
			,NULL/*EMF.TF_Fecha*/																								-- [FECFASE]
			,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(MC.TC_CodContexto,'Estado', MC.TN_CodEstado,0,0)		-- [CODESTASU]
			,MC.TF_Fecha																										-- [FECESTASU]
			,CASE
				WHEN MC.TC_Movimiento = 'E' THEN 'C'
				WHEN MC.TC_Movimiento = 'F' THEN 'F'
				WHEN MC.TC_Movimiento = 'R' THEN 'R'
				ELSE NULL
				END												-- [FINEST]
			,NULL												-- [CODSUBEST]
			,NULL												-- [FECSUBEST]
			,MC.TU_CodArchivo									-- [TU_CodArchivo] Llave Documento SIAGPJ para sustituir IDACO de documento
			,MC.TN_CodExpedienteMovimientoCirculante			-- [TN_CodExpedienteMovimientoCirculante]
	FROM		Historico.ExpedienteMovimientoCirculante	MC	WITH (NOLOCK)
	LEFT JOIN	Catalogo.Contexto							C	WITH (NOLOCK)
	ON			C.TC_CodContexto							=	MC.TC_CodContexto
	LEFT JOIN	Catalogo.Oficina							O	WITH (NOLOCK)
	ON			O.TC_CodOficina								=	C.TC_CodOficina
	LEFT JOIN	Catalogo.TipoOficina						T	WITH (NOLOCK)
	ON			T.TN_CodTipoOficina							=	O.TN_CodTipoOficina		
	OUTER APPLY
	(
		SELECT	TC_UsuarioRed 
		FROM	Catalogo.PuestoTrabajoFuncionario	WITH (NOLOCK)
		WHERE	TU_CodPuestoFuncionario				=	MC.TU_CodPuestoFuncionario
	) USU
	WHERE		MC.TC_NumeroExpediente						=	@L_TC_NumeroExpediente
	AND			MC.TC_CodContexto							<>	'0000' -- Se excluyen registros de Expediente cascarón
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
				A.NUMACO,
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
				A.TN_CodExpedienteMovimientoCirculante

	FROM		@MOVCIRCULANTES									A
	LEFT JOIN	Historico.ExpedienteMovimientoCirculanteFase	B	WITH (NOLOCK)
	ON			B.TN_CodExpedienteMovimientoCirculante			=	A.TN_CodExpedienteMovimientoCirculante		
	WHERE		B.TC_NumeroExpediente							=	@L_TC_NumeroExpediente
	AND			A.FINEST										=	'C'	
	
	ORDER BY	B.TF_Fecha										ASC;		
	   	 
	--UPDATE SOBRE REGISTRO DE CREACION
	UPDATE		A
	SET			A.FECFASE			= B.FECFASE,
				A.FECEST			= B.FECEST	
	FROM		@MOVCIRCULANTES		A
	INNER JOIN  @MOVCIRCULANTES2	B
	ON			A.TN_CodExpedienteMovimientoCirculante = B.TN_CodExpedienteMovimientoCirculante;

	--ELIMINA EL PRIMER DATO DE LA CONSULTA PORQUE YA ESTA INCLUIDO
	IF ((SELECT COUNT(*) FROM @MOVCIRCULANTES2) > 1) 
	BEGIN
		WITH DATO AS 
		( 
			SELECT		TOP 1 * 
			FROM		@MOVCIRCULANTES2 
			ORDER BY	FECHA ASC 
		) 	
		DELETE FROM DATO
	END

	--INGRESA LOS REGISTROS DE FASE 
	INSERT INTO @MOVCIRCULANTES
	SELECT * FROM @MOVCIRCULANTES2

	--If ( (SELECT COUNT(*) FROM @MOVCIRCULANTES2) > 1) BEGIN
	SELECT @L_DacoInicial =  MAX(IDACO) + 1 FROM @MOVCIRCULANTES2;
	--END	
	
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
				A.NUMACO,
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
				A.TN_CodExpedienteMovimientoCirculante
	FROM		@MOVCIRCULANTES									A
	LEFT JOIN	Historico.ExpedienteMovimientoCirculanteFase	B	WITH (NOLOCK)
	ON			B.TN_CodExpedienteMovimientoCirculante			=	A.TN_CodExpedienteMovimientoCirculante	
	WHERE		B.TC_NumeroExpediente							=	@L_TC_NumeroExpediente
	AND			A.FINEST										=	'F'	
	ORDER BY	B.TF_Fecha										ASC;

	--UPDATE SOBRE REGISTRO DE FINALIZACION
	UPDATE		A
	SET			A.FECFASE			= B.FECFASE,
				A.FECEST			= B.FECEST
	FROM		@MOVCIRCULANTES		A
	INNER JOIN  @MOVCIRCULANTES2	B
	ON			A.TN_CodExpedienteMovimientoCirculante = B.TN_CodExpedienteMovimientoCirculante;

	--ELIMINA EL PRIMER DATO DE LA CONSULTA PORQUE YA ESTA INCLUIDO
	IF ((SELECT COUNT(*) FROM @MOVCIRCULANTES2) > 1) 
	BEGIN
		WITH DATO AS 
		( 
			SELECT		TOP 1 * 
			FROM		@MOVCIRCULANTES2 
			ORDER BY	FECHA ASC 
		) 	
		DELETE FROM DATO
	END

	-- TODO REVISAR SI ESTE DEBE QUEDAR
	IF((SELECT COUNT(*) FROM @MOVCIRCULANTES2) > 1)
	BEGIN
		SELECT @L_DacoInicial =  MAX(IDACO) + 1 FROM @MOVCIRCULANTES2;
	END

	--INGRESA LOS REGISTROS DE FASE 
	INSERT INTO @MOVCIRCULANTES
	SELECT * FROM @MOVCIRCULANTES2
		
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
				A.NUMACO,
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
				A.TN_CodExpedienteMovimientoCirculante
	FROM		@MOVCIRCULANTES									A
	LEFT JOIN	Historico.ExpedienteMovimientoCirculanteFase	B	WITH (NOLOCK)
	ON			B.TN_CodExpedienteMovimientoCirculante			=	A.TN_CodExpedienteMovimientoCirculante	
	WHERE		B.TC_NumeroExpediente							=	@L_TC_NumeroExpediente
	AND			A.FINEST										=	'R'		
	ORDER BY	B.TF_Fecha									ASC;

	--UPDATE SOBRE REGISTRO DE REENTRADO
	UPDATE		A
	SET			A.FECFASE			= B.FECFASE,
				A.FECEST			= B.FECEST
	FROM		@MOVCIRCULANTES		A
	INNER JOIN  @MOVCIRCULANTES2	B
	ON			A.TN_CodExpedienteMovimientoCirculante = B.TN_CodExpedienteMovimientoCirculante;		
	
	--ELIMINA EL PRIMER DATO DE LA CONSULTA PORQUE YA ESTA INCLUIDO
	IF ((SELECT COUNT(*) FROM @MOVCIRCULANTES2) > 1) 
	BEGIN
		WITH DATO AS 
		( 
			SELECT		TOP 1 * 
			FROM		@MOVCIRCULANTES2 
			ORDER BY	FECHA ASC 
		) 	
		DELETE FROM DATO
	END

	IF((SELECT COUNT(*) FROM @MOVCIRCULANTES2) > 1)
	BEGIN
		--INGRESA LOS REGISTROS DE FASE 
		INSERT INTO @MOVCIRCULANTES
		SELECT * FROM @MOVCIRCULANTES2
	END

	if ( (SELECT COUNT(*) FROM @MOVCIRCULANTES2) > 1) BEGIN
		SELECT @L_DacoInicial =  MAX(IDACO) + 1 FROM @MOVCIRCULANTES2;
	END

	--LIMPIA TABLA TEMPORAL
	DELETE FROM @MOVCIRCULANTES2

	INSERT INTO @MOVCIRCULANTES2
	SELECT		A.CARPETA,																						--[CARPETA]				
				ISNULL(ROW_NUMBER() over (order by A.FECHA ASC) + @L_DacoInicial -1,@L_DacoInicial),			-- [IDACO]
				A.CODDEJ, 
				B.TF_Fecha,																						-- [FECHA]
				A.TEXTO,
				A.CODACO,
				A.NUMACO,
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
				A.TN_CodExpedienteMovimientoCirculante

	FROM		@MOVCIRCULANTES									A
	LEFT JOIN	Historico.ExpedienteMovimientoCirculanteFase	B	WITH (NOLOCK)
	ON			B.TN_CodExpedienteMovimientoCirculante			=	A.TN_CodExpedienteMovimientoCirculante		
	WHERE		B.TC_NumeroExpediente							=	@L_TC_NumeroExpediente	
	AND			A.FECFASE										IS NULL 	
	ORDER BY	B.TF_Fecha										ASC;

	--UPDATE SOBRE REGISTRO DE SON DE CAMBIOS DE ESTADO
	UPDATE		A
	SET			A.FECFASE			= B.FECFASE,
				A.FECEST			= B.FECEST
	FROM		@MOVCIRCULANTES		A
	INNER JOIN  @MOVCIRCULANTES2	B
	ON			A.TN_CodExpedienteMovimientoCirculante = B.TN_CodExpedienteMovimientoCirculante;

	--LIMPIA TABLA TEMPORAL
	DELETE FROM @MOVCIRCULANTES2

	--******************************************************************************************************************************************************************
	-- FIN ACTUALIZACION DE REGISTROS
	--******************************************************************************************************************************************************************

	-- Movimiento Circulante del expediente acumulado en oficina destino
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
				,TU_CodArchivo		--TU_CodArchivo Llave Documento SIAGPJ para sustituir IDACO de documento
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
			   ,IDACO
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
	
	-- Histórico de DACO de acumulación de un expediente en otro
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
	SELECT 		@L_Carpeta,																					-- [CARPETA]
				ISNULL(ROW_NUMBER() over (order by EA.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial),-- [IDACO]
				EA.TC_CodContexto,																			-- [CODDEJ]
				CASE 
					WHEN EA.TF_FinAcumulacion IS NULL
					THEN EA.TF_InicioAcumulacion
					ELSE EA.TF_FinAcumulacion
				END,																						-- [FECHA]
				CASE 
					WHEN EA.TF_FinAcumulacion IS NULL
					THEN 'Acumular NUE/Acumular Carpetas/'
					ELSE 'Carpeta Desacumulada//'
				END,																						-- [TEXTO]
				CASE 
					WHEN EA.TF_FinAcumulacion IS NULL
					THEN 'ACUM'
					ELSE 'DES-ACUM'
				END,																						-- [CODACO]	
				ISNULL(ROW_NUMBER() over (order by EA.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial),-- [NUMACO]
				CASE 
					WHEN EA.TF_FinAcumulacion IS NULL
					THEN EA.TF_InicioAcumulacion
					ELSE EA.TF_FinAcumulacion
				END,																						-- [FECSYS]
				PF.TC_UsuarioRed, 																			-- [IDUSU]
				@L_TC_CodContextoOrigen,																	-- [CODDEJSUR] -- quien itineró código oficina origen
				5,																							-- [CODESTACO]
				CASE 
					WHEN EA.TF_FinAcumulacion IS NULL
					THEN EA.TF_InicioAcumulacion
					ELSE EA.TF_FinAcumulacion
				END,																						-- [FECEST]
				NULL,																						-- [NUMFOL]
				NULL,																						-- [NUMFOLINI]
				NULL,																						-- [PIEZA]
				NULL,																						-- [CODPRO]
				NULL,																						-- [CODJUDEC]			
				NULL,																						-- [CODJUTRA]
				CASE 
					WHEN EA.TF_FinAcumulacion IS NULL
					THEN 'ACUM_ASU'
					ELSE 'CARPDESACU'
				END,																						-- [CODTRAM]
				NULL,																						-- [CODESTADIST]
				C.CODTIDEJ,																					-- [CODTIDEJ]
				NULL,																						-- [IDACOREL]
				NULL,																						-- [CODREL]
				0,																							-- [PRIORI]
				NULL, 																						-- [CODICO]
				NULL,	 																					-- [AMPLIAR]
				NULL, 																						-- [CANT]
				NULL, 																						-- [CODGT]
				NULL,																						-- [CODESC]
				NULL, 																						-- [FECENTRDD]		
				NULL, 																						-- [CODTIPDOC]	
				0,																							-- [OTRGEST]
				NULL, 																						-- [IDENTREGA]
				NULL																						-- [FINALIZAEXP]
	FROM		Historico.ExpedienteAcumulacion				EA	WITH (NOLOCK)
	INNER JOIN	Catalogo.PuestoTrabajoFuncionario			PF	WITH (NOLOCK)
	ON			PF.TU_CodPuestoFuncionario					=	EA.TU_CodPuestoTrabajoFuncionario	
	INNER JOIN	Catalogo.Contexto							C	WITH (NOLOCK)
	ON			C.TC_CodContexto							=	EA.TC_CodContexto
	WHERE		EA.TC_NumeroExpediente						=	@L_TC_NumeroExpediente

	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + 1
	SELECT @L_DacoInicial = ISNULL((SELECT MAX(IDACO) + 1 FROM @DACO WHERE IDACO IS NOT NULL), @L_DacoInicial);

	
	-- Histórico de DACO de cambio de ubicación de un expediente
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
	SELECT 		@L_Carpeta,																					-- [CARPETA]
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
	FROM		Historico.ExpedienteUbicacion				EU	WITH (NOLOCK)	
	INNER JOIN	Catalogo.Contexto							C	WITH (NOLOCK)
	ON			C.TC_CodContexto							=	EU.TC_CodContexto
	WHERE		EU.TC_NumeroExpediente						=	@L_TC_NumeroExpediente

	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + 1
	SELECT @L_DacoInicial = ISNULL((SELECT MAX(IDACO) + 1 FROM @DACO WHERE IDACO IS NOT NULL), @L_DacoInicial);
		
	-- HU para insertar en la tabla DACO actualizar reentrado de un expediente
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
		SELECT
					@L_Carpeta,																						-- [CARPETA]
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
