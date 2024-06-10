SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Luis Alonso Leiva Tames>
-- Fecha de creación:	<16/12/2020>
-- Descripción :		<Permite consultar los escritos de una Itineración de Gestión con cat logos o tablas equivalentes del SIAGPJ   >
-- =============================================================================================================================================================================
-- Modificación:		<18/02/2021><Isaac Dobles Mata> <Se corrigen mapeos>
-- Modificación:		<19/02/2021><Luis Alonso Leiva Tames> <Se hace cambio relacionado al documento en el campo codtram indique "DOC_DEMAN">
-- Modificación:		<23/02/2021><Jonathan Aguilar Navarro> <Se quita el inner join con talba Migracion.Valroes por defecto por que no se estaba utlizando.>
-- Modificación:		<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, seg£n acuerdo con BT>
-- Modificación:		<22/03/2021><Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:		<21/06/2021><Karol Jiménez S.> <Se ajusta para evitar productos cartesianos al buscar equivalencias>
-- Modificación:		<19/02/2021><Luis Alonso Leiva Tames> <Se hace cambio relacionado a la Fecha de RDD si viene NULL se envia Fecha incorporo el documento ">
-- Modificación:		<10/08/2021><Ronny Ram¡rez R.> <Se aplica ajuste para que se devuelvan los estados reales de los escritos desde Gestión>
-- Modificación:		<01/03/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo TipoEscrito)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarDetalleItineracionEscritosGestion]
	@CodItineracion Uniqueidentifier = null
AS 
BEGIN
	--Variables 
	DECLARE	@L_CodDemandaInicial	VARCHAR(10),
			@L_CodItineracion		VARCHAR(36)			= @CodItineracion,
			@L_XML					XML,
			@L_NumeroExpediente		VARCHAR(14),
			@L_ContextoDestino		VARCHAR(4);
		
	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SET @L_XML = (
					SELECT	VALUE 
					FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS WITH(NOLOCK) 
					WHERE	ID = @L_CodItineracion
				);

	--Se consulta el contexto destino de la itineracion para el mapeo de datos
	SET @L_ContextoDestino =	(	
									SELECT		A.RECIPIENTADDRESS
									FROM		ItineracionesSIAGPJ.dbo.MESSAGES A WITH(NOLOCK)
									WHERE		A.ID = @L_CodItineracion
								)

	-- Se obtiene el # de expediente del XML
	SET @L_NumeroExpediente = @L_XML.value('(/*/DCAR/NUE)[1]','VARCHAR(14)');
	
	--Obtener el valor de configuracion para los escritos demanda inicial 
	SELECT	@L_CodDemandaInicial				= A.TC_Valor
	FROM	Configuracion.ConfiguracionValor	A WITH(NOLOCK)
	WHERE	A.TC_CodConfiguracion				= 'C_TipoEscritoDemandaInicial';

	WITH DACO (IDACO,CODTIPDOC, CODDEJ, TEXTO, FECSYS, FECENTRDD,FECHA,CODACO,CODTRAM) AS (
		SELECT	A.B.value('(IDACO)[1]', 'int'),
				A.B.value('(CODTIPDOC)[1]', 'VARCHAR(12)'),
				A.B.value('(CODDEJ)[1]', 'VARCHAR(4)'),
				A.B.value('(TEXTO)[1]', 'VARCHAR(255)'),
				TRY_CONVERT(DATETIME2(3),A.B.value('(FECSYS)[1]', 'VARCHAR(35)')),
				TRY_CONVERT(DATETIME2(3),A.B.value('(FECENTRDD)[1]', 'VARCHAR(35)')),
				TRY_CONVERT(DATETIME2(3),A.B.value('(FECHA)[1]', 'VARCHAR(35)')),
				A.B.value('(CODACO)[1]', 'VARCHAR(9)'),
				A.B.value('(CODTRAM)[1]', 'VARCHAR(12)')
		FROM @L_XML.nodes('(/*/DACO)') AS A(B)
	),
	DACODOCR(IDACO,TRAMITADO) AS(
		SELECT  A.B.value('(IDACO)[1]', 'int'),
				A.B.value('(TRAMITADO)[1]', 'VARCHAR(4)')
			FROM @L_XML.nodes('(/*/DACODOCR)') AS A(B)
	)

	SELECT 
		CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)							AS		Codigo,
		TEXTO																						AS		Descripcion,
		FECSYS																						AS		FechaIngresoOficina,
		CASE WHEN FECENTRDD IS NULL THEN FECHA ELSE FECENTRDD END 									AS		FechaEnvio,
		CASE WHEN FECENTRDD IS NULL THEN FECSYS ELSE FECENTRDD END 									AS		FechaRegistro,
		0																							AS		VariasGestiones,
		A.IDACO																						AS		CodigoGestion,
		'SplitExpediente'																			AS		SplitExpediente,
		@L_NumeroExpediente																			AS		Numero,
		'SplitTipoEscrito'																			AS		SplitTipoEscrito,
		CASE WHEN A.CODTRAM = 'DOC_DEMAN' THEN @L_CodDemandaInicial ELSE TE.TN_CodTipoEscrito END	AS		Codigo,
		TE.TC_Descripcion																			AS		Descripcion,
		'SplitContexto'																				AS		SplitContexto,
		CODDEJ																						AS		Codigo,
		'SplitArchivo'																				AS		SplitArchivo,
		CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)							AS		Codigo,
		'SplitOtros'																				AS		SplitOtros,
		CASE
            WHEN B.TRAMITADO = '0001' THEN 'P'	-- Pendiente
            WHEN B.TRAMITADO = '0002' THEN 'T'	-- Tramitandose
            WHEN B.TRAMITADO = '0003' THEN 'T'	-- Tramitandose
            WHEN B.TRAMITADO = '0004' THEN 'R'	-- Resuelto            
            ELSE 'R'							-- Si no se conoce el estado, se pasan resueltos.
        END																							AS		EstadoEscrito
	FROM		DACO							A	
	LEFT JOIN	DACODOCR						B 
	ON			A.IDACO							=	B.IDACO 
	LEFT JOIN	Catalogo.TipoEscrito			TE	With(NoLock) 
	ON			TE.TN_CodTipoEscrito			=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'TipoEscrito', A.CODTIPDOC,0,0))
	LEFT JOIN	Catalogo.TipoEscritoTipoOficina	TETO WITH(NOLOCK)
	ON			TETO.TN_CodTipoEscrito			= TE.TN_CodTipoEscrito
	AND			TETO.TN_CodTipoOficina			=	(	
													SELECT		TOF.TN_CodTipoOficina
													FROM		Catalogo.TipoOficina			TOF WITH(NOLOCK)
													INNER JOIN  Catalogo.Oficina				OFI WITH(NOLOCK)
													ON			TOF.TN_CodTipoOficina			=	OFI.TN_CodTipoOficina
													INNER JOIN  Catalogo.Contexto				CON WITH(NOLOCK)
													ON			CON.TC_CodOficina				=	OFI.TC_CodOficina
													WHERE		CON.TC_CodContexto				=	@L_ContextoDestino
													)
	AND			TETO.TC_CodMateria				=	(
														SELECT		M.TC_CodMateria
														FROM		Catalogo.Materia				M WITH(NOLOCK)
														INNER JOIN  Catalogo.Contexto				CON WITH(NOLOCK)
														ON			CON.TC_CodMateria			=	M.TC_CodMateria
														WHERE		CON.TC_CodContexto			=	@L_ContextoDestino
													)
	WHERE		A.CODACO						=	'ESC' 
END
GO
