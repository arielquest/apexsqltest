SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<23/02/2021>
-- Descripción :			<Permite consultar el histórico de itineraciones de un expediente de Gestion mapeado a registros de Siagpj
--							 con sus catálogos respectivos>
-- =============================================================================================================================================================================
-- Modificado por:			<24-02-2021><Jose Gabriel Cordero Soto><Se realiza ajuste de valor de retorno ID_NAUTIUS>
-- Modificación:			<01/03/2021><Karol Jiménez S.><Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<11/03/2021><Karol Jiménez S.><Se excluye de la consulta el último registro de DHISITI porque ese lo crea SIAGPJ al recibir>
-- Modificación:			<22/03/2021><Karol Jiménez S.><Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:			<15/04/2021><Karol Jiménez S.><Se corrije forma de obtener contexto destino: letra incorrecta del select de join>
-- Modificación:			<25/06/2021><Jose Gabriel Cordero Soto><Se realiza ajuste con el mapeo de la FechaSalida para expediente y legajo>
-- Modificación:			<27/02/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo MotivoItineracion y
--							EstadoItineracion)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarHistoricoExpedienteLegajoItineracionGestion]
(
	@CodItineracion			UNIQUEIDENTIFIER,
	@EsExpediente			BIT
)
AS
BEGIN
	DECLARE @L_CodItineracion		UNIQUEIDENTIFIER  =	@CodItineracion,
			@L_EsExpediente			BIT				  = @EsExpediente,
			@L_NumeroExpediente		VARCHAR(14),
			@L_XML					XML,
			@L_ContextoDestino		VARCHAR(4);

	--Se obtiene los registros de XML segun Codigo itineracion
	SELECT		@L_XML								= VALUE,
				@L_ContextoDestino					= M.RECIPIENTADDRESS
	FROM		ItineracionesSIAGPJ.dbo.ATTACHMENTS A WITH(NOLOCK) 
	INNER JOIN	ItineracionesSIAGPJ.dbo.MESSAGES	M WITH(NOLOCK) 
	ON			M.ID								= A.ID
	WHERE		A.ID = @L_CodItineracion;
	

	IF (@L_EsExpediente = 1)
	BEGIN
		 -- Se obtiene el # de expediente del XML Consultado
		 SET @L_NumeroExpediente = @L_XML.value('(/*/DCAR/NUE)[1]','VARCHAR(14)');

	     --SE OBTIENE INFORMACION DE GESTION CON BASE EN EL XML Consultado
		 WITH DHISITI (IDITI, CODDEJ, FECENT, CODMOT, CODDEJDES, CODESTITI, FECESTITI, FECSAL, ID_NAUTIS) AS
		 (
		 SELECT	C.D.value('(IDITI)[1]','INT'),		  
				C.D.value('(CODDEJ)[1]','VARCHAR(4)'),
				TRY_CONVERT(DATETIME2(3),C.D.value('(FECENT)[1]','VARCHAR(35)')),
				C.D.value('(CODMOT)[1]','VARCHAR(9)'),								
				C.D.value('(CODDEJDES)[1]','VARCHAR(4)'),
				C.D.value('(CODESTITI)[1]','VARCHAR(1)'),
				TRY_CONVERT(DATETIME2(3),C.D.value('(FECESTITI)[1]','VARCHAR(35)')),		
				TRY_CONVERT(DATETIME2(3),C.D.value('(FECSAL)[1]','VARCHAR(35)')),
				C.D.value('(ID_NAUTIUS)[1]','VARCHAR(255)')		
		 FROM   @L_XML.nodes('(/*/DHISITI)') AS C(D)
		 )
		 
		 --RESULTADO FINAL DEL MAPEO		 
		 SELECT   		A.IDITI,
						CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER) Codigo,
						CASE   
							WHEN A.FECENT IS NOT NULL THEN A.FECENT
							WHEN A.FECENT IS NULL     THEN TRY_CONVERT(DATETIME2(3),@L_XML.value('(/*/DCAR/FECENT)[1]','VARCHAR(35)')) 
						END									FechaEntrada,
						A.FECENT							FechaCreacion,
						ISNULL(A.FECSAL, A.FECESTITI)	    FechaSalida,
						A.ID_NAUTIS							IdNautius,
						'splitExpedienteDetalle'			splitExpedienteDetalle,
						@L_NumeroExpediente					Numero,	
						'splitContexto'						splitContexto,
						B.TC_CodContexto					Codigo,		
						B.TC_Descripcion					Descripcion,
						'splitContextoDestino'				splitContextoDestino,
						C.TC_CodContexto					Codigo,
						C.TC_Descripcion					Descripcion,	
						'splitMotivoItineracion'			splitMotivoItineracion,
						D.TN_CodMotivoItineracion			Codigo, 
						D.TC_Descripcion					Descripcion,
						'splitHistoricoItineracion'			splitHistoricoItineracion,												
						E.TN_CodEstadoItineracion			EstadoItineracion,
						A.FECESTITI							FechaEstado
		 FROM			DHISITI						A 
		 LEFT JOIN		Catalogo.Contexto			B WITH(NOLOCK)
		 ON				B.TC_CodContexto			= A.CODDEJ		
		 LEFT JOIN		Catalogo.Contexto			C WITH(NOLOCK)
		 ON				C.TC_CodContexto			= A.CODDEJDES	
		 OUTER APPLY	(	SELECT	Y.TN_CodMotivoItineracion, Y.TC_Descripcion
							FROM	Catalogo.MotivoItineracion		Y	WITH(NOLOCK) 
							WHERE	Y.TN_CodMotivoItineracion		=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'MotivoItineracion', A.CODMOT,0,0))
						) D
		 OUTER APPLY	(	SELECT 	Y.TN_CodEstadoItineracion
							FROM	Catalogo.EstadoItineracion		Y	WITH(NOLOCK) 
							WHERE	Y.TN_CodEstadoItineracion		=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'EstadoItineracion', A.CODESTITI,0,0))
						) E
		 OUTER APPLY	(	SELECT MAX(IDITI) IDITI_MAX
							FROM	DHISITI D 
						) F
		 WHERE			A.IDITI						<> IDITI_MAX
		 ORDER BY		IDITI ASC
	END
	ELSE  --SI ES PARA LEGAJO
	BEGIN
		--SE OBTIENE INFORMACION DE GESTION CON BASE EN EL XML Consultado
		 WITH DHISITI (IDITI, CODDEJ, FECENT, CODMOT, CODDEJDES, CODESTITI, FECESTITI, FECSAL, ID_NAUTIS) AS
		 (
		 SELECT	C.D.value('(IDITI)[1]','INT'),		  
				C.D.value('(CODDEJ)[1]','VARCHAR(4)'),
				TRY_CONVERT(DATETIME2(3),C.D.value('(FECENT)[1]','VARCHAR(35)')),
				C.D.value('(CODMOT)[1]','VARCHAR(9)'),								
				C.D.value('(CODDEJDES)[1]','VARCHAR(4)'),
				C.D.value('(CODESTITI)[1]','VARCHAR(1)'),
				TRY_CONVERT(DATETIME2(3),C.D.value('(FECESTITI)[1]','VARCHAR(35)')),	
				TRY_CONVERT(DATETIME2(3),C.D.value('(FECSAL)[1]','VARCHAR(35)')),
				C.D.value('(ID_NAUTIUS)[1]','VARCHAR(255)')		
		 FROM   @L_XML.nodes('(/*/DHISITI)') AS C(D)
		 )

		 --RESULTADO FINAL DEL MAPEO
		 SELECT			CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER) Codigo,
						CASE   
							WHEN A.FECENT IS NOT NULL THEN A.FECENT
							WHEN A.FECENT IS NULL     THEN TRY_CONVERT(DATETIME2(3),@L_XML.value('(/*/DCAR/FECENT)[1]','VARCHAR(35)')) 
						END									FechaEntrada,
						A.FECENT							FechaCreacion,
						ISNULL(A.FECSAL, A.FECESTITI)	    FechaSalida,
						A.ID_NAUTIS							IdNautius,
						'splitLegajoDetalle'				splitLegajoDetalle,
						CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER) Codigo,
						@L_NumeroExpediente					Numero,	
						'splitContexto'						splitContexto,
						B.TC_CodContexto					Codigo,		
						B.TC_Descripcion					Descripcion,
						'splitContextoDestino'				splitContextoDestino,
						C.TC_CodContexto					Codigo,
						C.TC_Descripcion					Descripcion,	
						'splitMotivoItineracion'			splitMotivoItineracion,
						D.TN_CodMotivoItineracion			Codigo, 
						D.TC_Descripcion					Descripcion,
						'splitHistoricoItineracion'			splitHistoricoItineracion,												
						E.TN_CodEstadoItineracion			EstadoItineracion,
						A.FECESTITI							FechaEstado											
		 FROM			DHISITI						A 
		 LEFT JOIN		Catalogo.Contexto			B WITH(NOLOCK)
		 ON				A.CODDEJ					= B.TC_CodContexto
		 LEFT JOIN		Catalogo.Contexto			C WITH(NOLOCK)
		 ON				A.CODDEJDES					= C.TC_CodContexto
		 LEFT JOIN		Catalogo.MotivoItineracion	D	WITH(NOLOCK) 
		 ON				D.TN_CodMotivoItineracion	=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'MotivoItineracion', A.CODMOT,0,0))
		 LEFT JOIN		Catalogo.EstadoItineracion	E	WITH(NOLOCK) 
		 ON 			E.TN_CodEstadoItineracion	=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'EstadoItineracion', A.CODESTITI,0,0))
		 OUTER APPLY	(	SELECT MAX(IDITI) IDITI_MAX
							FROM	DHISITI D )		F
		 WHERE			A.IDITI						<> IDITI_MAX
		 ORDER BY		IDITI ASC
	END
 END
GO
