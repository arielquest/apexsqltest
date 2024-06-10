SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<12/01/2021>
-- Descripción :			<Permite consultar los delitos asociados a un interviniente de un expediente de Gestión con catálogos del SIAGPJ>
-- =============================================================================================================================================================================
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<22/03/2021><Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:			<28/02/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo Delito)>
-- =============================================================================================================================================================================
 CREATE PROCEDURE [Itineracion].[PA_ConsultarDelitosIntervinienteGestion]
	@CodItineracion Uniqueidentifier
AS 

BEGIN
	--Variables 
	DECLARE	@L_CodItineracion		Uniqueidentifier	=	@CodItineracion,
			@L_XML					XML,
			@L_ContextoDestino		VARCHAR(4);

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SELECT		@L_XML								=	VALUE,
				@L_ContextoDestino					=	M.RECIPIENTADDRESS
	FROM		ItineracionesSIAGPJ.dbo.MESSAGES	M	WITH(NOLOCK) 
	INNER JOIN	ItineracionesSIAGPJ.dbo.ATTACHMENTS A	WITH(NOLOCK) 
	ON			A.ID								=	M.ID
	WHERE		M.ID								=	@L_CodItineracion;

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DINTDEL (IDINT, CODDEL, FECCAL) AS (
		SELECT	A.B.value('(IDINT)[1]', 'INT'),
				A.B.value('(CODDEL)[1]', 'VARCHAR(9)'),				
				TRY_CONVERT(DATETIME2(3),	A.B.value('(FECCAL)[1]', 'VARCHAR(35)'))
		FROM @L_XML.nodes('(/*/DINTDEL)') AS A(B)
	)
	
	-- Consulta de registros de interviniente delito y relacionados con equivalencias de catálogos de SIAGPJ
	SELECT		A.FECCAL						FechaCalificacion,
				0								CrimenOrganizado,
				GETDATE()						FechaHecho, 
				NULL							FechaPrescripcion,
				0								Indagado,
				'SplitInterviniente'			SplitInterviniente,
				CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)	Codigo,
				A.IDINT							CodigoIntervinienteGestion,
				'SplitDelito'					SplitDelito,
				B.TN_CodDelito					Codigo,							 
				B.TC_Descripcion				Descripcion,
				'SplitCategoriaDelito'			SplitCategoriaDelito,
				C.TN_CodCategoriaDelito			Codigo,							 
				C.TC_Descripcion				Descripcion
	FROM		DINTDEL							A	-- Datos Delitos Interviniente
	LEFT JOIN	Catalogo.Delito					B	WITH(NOLOCK)	
	ON			B.TN_CodDelito					=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Delito', A.CODDEL,0,0))
	LEFT JOIN	Catalogo.CategoriaDelito		C	WITH(NOLOCK)	
	ON			B.TN_CodCategoriaDelito			=	C.TN_CodCategoriaDelito;

END
GO
