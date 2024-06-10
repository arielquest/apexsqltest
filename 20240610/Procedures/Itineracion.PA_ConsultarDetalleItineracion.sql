SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<10/12/2020>
-- Descripción :			<Permite consultar el detalle de un registro de Itineración de Gestión con catálogos del SIAGPJ>
-- =============================================================================================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<04/01/2021>
-- Descripción:				<Se modifica para hacerlo coincidir con cambios en tablas de catálogos de Clase y Proceso>
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<28/05/2021><Jonathan Aguilar Navarro> <Se quita el campo MesajeError del split de Contexto, ya que no se mostraba>
-- Modificación:			<21/06/2021> <Karol Jiménez S.> <Se ajusta para evitar productos cartesianos al buscar equivalencias>
-- Modificación:			<12/07/2021> <Ronny Ramírez R.> <Se aplica ajuste para incluir la información de itineración del legajo en caso de corresponder>
-- Modificación:			<24/02/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Clase, Proceso, Asunto y ClaseAsunto)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarDetalleItineracion]
	@CodItineracion Uniqueidentifier = null
AS 

BEGIN
	--Variables 
	DECLARE	@L_CodItineracion			Uniqueidentifier		= @CodItineracion,
			@L_XML						XML,
			@L_CodContextoRecepcion		VARCHAR(4)

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez y el contexto recepción
	SELECT		@L_XML									=	A.VALUE,
				@L_CodContextoRecepcion					=	M.RECIPIENTADDRESS
	FROM		ItineracionesSIAGPJ.dbo.MESSAGES		M	WITH(NOLOCK) 
	INNER JOIN 	ItineracionesSIAGPJ.dbo.ATTACHMENTS		A	WITH(NOLOCK) 
	ON			M.ID									=	A.ID
	WHERE		M.ID									=	@L_CodItineracion;

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DCAR AS (
		SELECT	@L_CodItineracion													CodItineracion,
				X.Y.value('(NUE)[1]',				'VARCHAR(14)')					NUE,
				X.Y.value('(DESCRIP)[1]',			'VARCHAR(255)')					DESCRIPCION,
				X.Y.value('(CODCLAS)[1]',			'VARCHAR(9)')					CLASEASUNTO,
				X.Y.value('(CODPRO)[1]',			'VARCHAR(5)')					PRIORIDAD,
				X.Y.value('(CODASU)[1]',			'VARCHAR(9)')					ASUNTO
		FROM	@L_XML.nodes('(/*/DCAR)')			AS X(Y)
	),
	DCARMASD AS (
		SELECT	A.B.value('(CODMASD)[1]', 'VARCHAR(9)')								CODMASD,
				A.B.value('(VALOR)[1]', 'VARCHAR(255)')								VALOR
		FROM @L_XML.nodes('(/*/DCARMASD)') AS A(B)
	)


	-- Detalle primera itineración de Gestión (puede que salgan repeticiones por el catálogo de Clase)
	SELECT		TOP 1
				CAST(A.ID AS UNIQUEIDENTIFIER)							CodigoItineracionGestion,
				A.TIMESENT												FechaEnvio,
				A.ERRORDESCRIPTION										MensajeError,
				'SplitClase'											SplitClase,
				C.TN_CodClase											Codigo,
				C.TC_Descripcion										Descripcion,
				'SplitProceso'											SplitProceso,
				P.TN_CodProceso											Codigo,
				P.TC_Descripcion										Descripcion,
				'SplitExpediente'										SplitExpediente,
				X.NUE													Numero,
				X.DESCRIPCION											Descripcion,
				CASE 
					WHEN EXISTS (
						SELECT		T.*
						FROM		DCARMASD	T	WITH(NOLOCK)
						WHERE		T.CODMASD	= 'CONFIDENC'
						AND			T.VALOR		IN ( -- Se busca valores verdaderos para campo confidencial en tabla de migraciones
														SELECT	TC_ValoresActuales 
														FROM	Migracion.ValoresDefecto WITH(NOLOCK)
														WHERE	TC_NombreCampo		=	'TB_Confidencial'
														AND		TC_ValorPorDefecto	=	1
													) 
					)
					THEN	1
					ELSE	0
				END														Confidencial,
				'SplitContextoOrigen'									SplitContextoOrigen,
				CO.TC_CodContexto										Codigo,
				CO.TC_Descripcion										Descripcion,
				'SplitLegajo'											SplitLegajo,
				X.DESCRIPCION											Descripcion,
				'SplitAsuntoLegajo'										SplitAsuntoLegajo,
				D.TN_CodAsunto											Codigo,
				D.TC_Descripcion										Descripcion,
				'SplitClaseAsuntoLegajo'								SplitClaseAsuntoLegajo,
				E.TN_CodClaseAsunto										Codigo,
				E.TC_Descripcion										Descripcion
	FROM		ItineracionesSIAGPJ.dbo.MESSAGES		A 	WITH(NOLOCK)	
	INNER JOIN	DCAR 									X	WITH(NOLOCK)
	ON			X.CodItineracion						=	A.ID
	LEFT JOIN	Catalogo.Clase							C	WITH(NOLOCK)
	ON			C.TN_CodClase							=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_CodContextoRecepcion,'Clase', X.CLASEASUNTO,0,0))
	LEFT JOIN	Catalogo.Proceso						P	WITH(NOLOCK)
	ON			P.TN_CodProceso							=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_CodContextoRecepcion,'Proceso', X.PRIORIDAD,0,0))
	OUTER APPLY	(	SELECT			Z.TN_CodAsunto,
									Z.TC_Descripcion
					FROM			Catalogo.Asunto		Z WITH(NOLOCK) 
					WHERE			Z.TN_CodAsunto		=	(
																SELECT 			ISNULL(Y.TN_CodAsunto, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_AsuntoTipoLegajo', A.RECIPIENTADDRESS))
																FROM			Catalogo.Asunto		Y	WITH(NOLOCK) 
																WHERE			Y.TN_CodAsunto		=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_CodContextoRecepcion,'Asunto', X.ASUNTO,0,0))
															)					
				) D
	LEFT JOIN	Catalogo.ClaseAsunto					E	WITH(NOLOCK) 
	ON			E.TN_CodClaseAsunto						=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_CodContextoRecepcion,'ClaseAsunto', X.CLASEASUNTO,0,0))
	LEFT JOIN	Catalogo.Contexto						CO	WITH(NOLOCK)
	ON			CO.TC_CodContexto						=	A.SENDERADDRESS	COLLATE DATABASE_DEFAULT
	WHERE		A.ID									=	@L_CodItineracion
END
GO
