SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<26/02/2021>
-- Descripción :		<Permite consultar los recursos asociados a una itineración de Gestión>
-- =============================================================================================================================================================================
-- Modificación:		<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:		<22/03/2021><Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert. Se agregan With(NoLock)>
-- Modificación:		<21/06/2021> <Karol Jiménez S.> <Se ajusta para evitar productos cartesianos al buscar equivalencias>
-- Modificación:		<01/03/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos ClaseAsunto, 
--						TipoIntervencion y MotivoItineracion)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarRecursoGestion]
	@CodItineracion			Uniqueidentifier 
AS
BEGIN
	--Variables 
	DECLARE @L_CodItineracion			Uniqueidentifier = @CodItineracion,	
			@L_XML						XML,
			@L_NumeroExpediente			VARCHAR(14),
			@L_CodContextoDestino		VARCHAR(4);

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SELECT		@L_XML								= VALUE,
				@L_CodContextoDestino				= M.RECIPIENTADDRESS
	FROM		ItineracionesSIAGPJ.dbo.MESSAGES	M	WITH(NOLOCK) 
	INNER JOIN	ItineracionesSIAGPJ.dbo.ATTACHMENTS	A	WITH(NOLOCK) 
	ON			A.ID								=	M.ID
	WHERE		M.ID								= 	@L_CodItineracion;

    -- Se obtiene el # de expediente del XML
	SET @L_NumeroExpediente = @L_XML.value('(/*/DCAR/NUE)[1]','VARCHAR(14)');

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DACOREC AS (
	 SELECT         X.Y.value('(CODREC)[1]',		'VARCHAR(3)')		CODREC,	
					X.Y.value('(CODDEJDES)[1]',		'VARCHAR(4)')		CODDEJDES,							
					X.Y.value('(CODPRESENT)[1]',	'VARCHAR(9)')		CODPRESENT,
					@L_NumeroExpediente									NUMEROEXPEDIENTE,
					X.Y.value('(CODRES)[1]',		'VARCHAR(4)')		CODRES,
					TRY_CONVERT(DATETIME2(3),X.Y.value('(FECESTITI)[1]',' VARCHAR(35)'))		FECESTITI,
					X.Y.value('(ID_NAUTIUS)[1]',	'VARCHAR(255)')		ID_NAUTIUS,
					X.Y.value('(CODESTITI)[1]',		'VARCHAR(1)')		CODESTITI,
					X.Y.value('(IDACO)[1]',			'INT')				IDACO	
		FROM		@L_XML.nodes('(/*/DACOREC)')	AS X(Y)
	),
		DCAR (CODDEJ,FECENT,NUE) AS (
			SELECT	A.B.value('(CODDEJ)[1]', 'VARCHAR(4)'),
					TRY_CONVERT(DATETIME2(3),A.B.value('(FECENT)[1]', 'VARCHAR(35)')),
					A.B.value('(NUE)[1]', 'VARCHAR(14)')
			FROM @L_XML.nodes('(/*/DCAR)') AS A(B)
	)

	-- Consulta de recuros con equivalencias de  de catálogos de SIAGPJ
	SELECT		CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)	AS Codigo,
				ISNULL(B.FECENT, GETDATE())											AS FechaCreacion,
				A.FECESTITI															AS FechaEnvio,
				NULL																AS FechaRecepcion,
				NULL																AS HistoricoItineracion,
				A.IDACO																AS CodigoGestion,
				'SplitClaseAsunto'													AS SplitClaseAsunto,
				ISNULL(C.TN_CodClaseAsunto,Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_ClaseAsuntoPorDefecto',A.CODDEJDES))	AS Codigo, 
				'SplitContextoDestino'												AS SplitContextoDestino,
				D.TC_CodContexto													AS Codigo,
				D.TC_Descripcion													AS Descripcion,
				'SplitTipoIntervencion'												AS SplitTipoIntervencion,
				ISNULL(E.TN_CodTipoIntervencion,Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_TipoIntervencionInter',A.CODDEJDES))	AS Codigo,
				'SplitMotivoItineracion'											AS SplitMotivoItineracion,
				F.TN_CodMotivoItineracion											AS Codigo,
				F.TC_Descripcion													AS Descripcion,
				'SplitEstadoItineracion'											AS SplitEstadoItineracion,
				1																	AS Codigo,
				'SplitOtros'														AS SplitOtros,
				H.TC_CodContexto													AS Codigo,
				H.TC_Descripcion													AS Descripcion,
				A.NUMEROEXPEDIENTE													AS Numero
	FROM		DACOREC						A											
	INNER JOIN	DCAR						B
	ON			A.NUMEROEXPEDIENTE			=	B.NUE
	LEFT JOIN	Catalogo.ClaseAsunto		C	With(NoLock) 
	ON			C.TN_CodClaseAsunto			=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_CodContextoDestino,'ClaseAsunto', A.CODREC,0,0))
	LEFT JOIN	Catalogo.Contexto			D	With(NoLock)
	ON			D.TC_CodContexto			=	A.CODDEJDES
	LEFT JOIN	Catalogo.TipoIntervencion	E	With(NoLock) 
	ON			E.TN_CodTipoIntervencion	=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_CodContextoDestino,'TipoIntervencion', A.CODPRESENT,0,0))
	LEFT JOIN	Catalogo.MotivoItineracion	F	With(NoLock) 
	ON			F.TN_CodMotivoItineracion	=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_CodContextoDestino,'MotivoItineracion', A.CODRES,0,0))
	LEFT JOIN	Catalogo.Contexto			H	With(NoLock)
	ON			H.TC_CodContexto			=	B.CODDEJ;

END
GO
