SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Karol Jiménez >
-- Fecha de creación:		<06/01/2021>
-- Descripción :			<Permite consultar representaciones de una Itineración de Gestión con catálogos o tablas equivalentes del SIAGPJ>
-- =============================================================================================================================================================================
-- Modificación:			<Jonathan Aguilar Navarro> <23/02/2021> <Se agrega que cuando la fecha "FECFIN" es nula, se le sume una año a dicha fecha>
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<22/03/2021><Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:			<28/02/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo TipoRepresentacion)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarRepresentacionesGestion]
	@CodItineracion			Uniqueidentifier
AS 

BEGIN
	--Variables 
	DECLARE	@L_CodItineracion					Uniqueidentifier	= @CodItineracion, 
			@L_ContextoDestino					VARCHAR(4),
			@L_XML								XML,
			@L_ValorDefectoTipoRepresentacion	SMALLINT			= NULL

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SELECT	@L_XML								= VALUE 
	FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS	WITH(NOLOCK) 
	WHERE	ID									= @L_CodItineracion;

	SELECT	@L_ContextoDestino					= RECIPIENTADDRESS
	FROM	ItineracionesSIAGPJ.DBO.[MESSAGES]	WITH(NOLOCK) 
	WHERE	ID									= @L_CodItineracion;

	/*SE OBTIENEN VALORES POR DEFECTO, SEGÚN CONFIGURACIONES*/
	SELECT	@L_ValorDefectoTipoRepresentacion	= CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_TipoRepresentacion',@L_ContextoDestino));

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DINTREP AS (
		SELECT		X.Y.value('(CARPETA)[1]',		'VARCHAR(14)')							CARPETA,
					X.Y.value('(IDINT)[1]',			'INT')									IDINT,
					X.Y.value('(IDINTREP)[1]',		'INT')									IDINTREP,
					X.Y.value('(CODREP)[1]',		'VARCHAR(3)')							CODREP,
					TRY_CONVERT(DATETIME2(3),X.Y.value('(FECINI)[1]',	'VARCHAR(35)'))		FECINI,
					TRY_CONVERT(DATETIME2(3),X.Y.value('(FECFIN)[1]',	'VARCHAR(35)'))		FECFIN,
					A.B.value('(CODMEDCOM)[1]',		'VARCHAR(1)')							CODMEDCOM
		FROM		@L_XML.nodes('(/*/DINTREP)')	AS X(Y)
		OUTER APPLY	@L_XML.nodes('(/*/DINT)')		AS A(B)
		WHERE		X.Y.value('(IDINT)[1]',			'INT')	=  A.B.value('(IDINT)[1]', 'INT')
	)
	SELECT		1									Principal,
				CASE
					WHEN A.CODMEDCOM = '5' THEN 1 
					ELSE 0
				END									NotificaRepresentante,
				A.FECINI							FechaActivacion,
				ISNULL(A.FECFIN, dateadd(year,1,GETDATE()))	FechaDesactivacion,
				'SplitTipoRepresentacion'			SplitTipoRepresentacion,
				ISNULL(B.TN_CodTipoRepresentacion,  @L_ValorDefectoTipoRepresentacion) Codigo,
				'SplitIntervencionRepresentado'		SplitIntervencionRepresentado,
				A.IDINT								CodigoIntervinienteGestion,
				'SplitIntervencionRepresentante'	SplitIntervencionRepresentante,
				A.IDINTREP							CodigoIntervinienteGestion 
	FROM		DINTREP								A
	LEFT JOIN	Catalogo.TipoRepresentacion			B	WITH(NOLOCK)
	ON			B.TN_CodTipoRepresentacion			=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'TipoRepresentacion', A.CODREP,0,0))

END
GO
