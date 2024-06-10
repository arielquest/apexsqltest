SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Karol Jiménez S.>
-- Fecha de creación:		<05/03/2021>
-- Descripción :			<Permite consultar la información de un resultado de recurso de una itineración de Gestión>
-- =============================================================================================================================================================================
-- Modificación :			<08/03/2021><Karol Jiménez S.><Modificación al obtener contexto origen y IDUSU asociado al resultado>
-- Modificación:			<22/03/2021><Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:			<25/03/2021><Karol Jiménez S.> <Quitar uso Outer Apply de Xquery, y usar Left Join>
-- Modificación:			<24/06/2021><Ronny Ramírez R.> <Se aplica filtro por número de expediente en join con tabla RecursoExpediente para que traiga un solo resultado>
-- Modificación:			<05/07/2023><Ronny Ramírez R.> <Se agrega código de Legajo al que está asociado el recurso, en caso de haber sido creado dentro de uno>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarResultadoRecursoGestion]
	@CodItineracion			Uniqueidentifier, 
	@UsuarioCreaXDefecto	VARCHAR(30)
AS
BEGIN
	--Variables 
	DECLARE @L_CodItineracion					Uniqueidentifier	= @CodItineracion,	
			@L_UsuarioCreaXDefecto				VARCHAR(30)			= @UsuarioCreaXDefecto,
			@L_XML								XML,
			@L_NumeroExpediente					VARCHAR(14),
			@L_CodContextoOrigenResultado		VARCHAR(14),
			@L_ValorDefectoResultadoLegajo		VARCHAR(20)			= 'Itinerado',
			@L_CodResultadoLegajoItineracion	SMALLINT
			
	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SET	@L_XML = (
					SELECT  VALUE 
					FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS	WITH(NOLOCK) 
					WHERE	ID						= 		@CodItineracion
				);	

	SET @L_CodContextoOrigenResultado = (	SELECT	RECIPIENTADDRESS
											FROM	ItineracionesSIAGPJ.dbo.MESSAGES	WITH(NOLOCK) 
											WHERE	ID									= @CodItineracion)			

	-- Se obtiene el # de expediente del XML
	SET @L_NumeroExpediente = @L_XML.value('(/*/DCAR/NUE)[1]','VARCHAR(14)');

	IF (NOT EXISTS (SELECT	* 
					FROM	Catalogo.ResultadoLegajo	WITH(NOLOCK) 
					WHERE	TC_Descripcion				= @L_ValorDefectoResultadoLegajo))
	BEGIN
		DECLARE @SiguenteIDResultadoLegajo SMALLINT;

		SET  @SiguenteIDResultadoLegajo =	(SELECT	COUNT(*) + 1  
											FROM	Catalogo.ResultadoLegajo WITH(NOLOCK));

		INSERT INTO Catalogo.ResultadoLegajo 
				(TN_CodResultadoLegajo,			TC_Descripcion,					TF_FechaInicioVigencia,	TF_FechaFinVigencia) 
		VALUES	(@SiguenteIDResultadoLegajo,	@L_ValorDefectoResultadoLegajo,	GETDATE(),				GETDATE())
	END

	SET @L_CodResultadoLegajoItineracion = (SELECT TOP 1 TN_CodResultadoLegajo FROM Catalogo.ResultadoLegajo WHERE TC_Descripcion = @L_ValorDefectoResultadoLegajo);

	-- Consulta de resultado recurso con equivalencias de  de catálogos de SIAGPJ
	SELECT			NEWID()																										AS Codigo,
					COALESCE(TRY_CONVERT(DATETIME2(3),X.Y.value('(FECDEVOL)[1]',	'VARCHAR(35)')),
							TRY_CONVERT(DATETIME2(3),X.Y.value('(FECESTITI)[1]',	'VARCHAR(35)')),
							GETDATE())																							AS FechaCreacion,
					COALESCE(TRY_CONVERT(DATETIME2(3),X.Y.value('(FECESTITI)[1]',	'VARCHAR(35)')),
							TRY_CONVERT(DATETIME2(3),X.Y.value('(FECDEVOL)[1]',		'VARCHAR(35)')),
							GETDATE())																							AS FechaEnvio,
					GETDATE()																									AS FechaRecepcion,											
					'SplitResultadoLegajo'																						AS SplitResultadoLegajo,
					@L_CodResultadoLegajoItineracion																			AS Codigo,
					'SplitContextoOrigen'																						AS SplitContextoOrigen,
					@L_CodContextoOrigenResultado																				AS Codigo,
					'SplitMotivoItineracion'																					AS SplitMotivoItineracion,
					CONVERT(SMALLINT,Itineracion.FN_ConsultarValorDefectoConfiguracion('C_MotivoItineracDevolucion', ''))		AS Codigo,
					'SplitEstadoItineracion'																					AS SplitEstadoItineracion,
					CONVERT(SMALLINT,Itineracion.FN_ConsultarValorDefectoConfiguracion('C_EstadoItineracionRecibida', ''))		AS Codigo,
					'SplitRecursoExpediente'																					AS SplitRecursoExpediente,
					R.TU_CodRecurso																								AS Codigo,
					'SplitRecursoExpedienteLegajo'																				AS SplitRecursoExpedienteLegajo,
					R.TU_CodLegajo																								AS Codigo,
					'SplitOtros'																								AS SplitOtros,
					COALESCE(F.TC_UsuarioRed, @L_UsuarioCreaXDefecto)															AS UsuarioRed
		FROM		@L_XML.nodes('(/*/DCARTD6)')		AS X(Y)
		LEFT JOIN	@L_XML.nodes('(/*/DACO)')			AS A(B)
		ON			X.Y.value('(IDACORES)[1]','INT')	=  A.B.value('(IDACO)[1]', 'INT')
		INNER JOIN	Expediente.RecursoExpediente		AS R WITH(NOLOCK)
		ON			R.IDACO								=  X.Y.value('(IDACOREC)[1]', 'INT')
		AND			R.TC_NumeroExpediente				=  @L_NumeroExpediente
		LEFT JOIN	Catalogo.Funcionario				AS F WITH(NOLOCK)
		ON			F.TC_UsuarioRed						=  A.B.value('(IDUSU)[1]',	'VARCHAR(25)')
		
END
GO
