SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<13/09/2019>
-- Descripción :			<Permite Consultar los tipos de itineracion activos para asociar  .
-- =================================================================================================================================================
-- Modificación:			<Andrew Allen Dawson> <05/11/2019> <Se reorganizan los campos TB_PorDefecto y TF_Inicio_Vigencia para que coincidan con el orden de las entidades>
-- Modificación:			<Aida Elena Siles R> <21/09/2020> <Se modifica el nombre de los campos fecha de la tabla Catalogo.TipoItineracion para que cumplan con el estándar.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoItineracionResultadoLegajo]
    @CodTipoItineracion	SMALLINT	= NULL,
	@CodResultadoLegajo	SMALLINT	= NULL,
	@FechaAsociacion	DATETIME2	= NULL,
    @PorDefecto			BIT			= NULL
AS
BEGIN
--Variables.
	DECLARE	@L_CodTipoItineracion		SMALLINT		= @CodTipoItineracion,
			@L_CodResultadoLegajo		SMALLINT		= @CodResultadoLegajo,
			@L_FechaAsociacion			DATETIME2		= @FechaAsociacion,
			@L_PorDefecto				BIT				= @PorDefecto

	SELECT		B.TN_CodTipoItineracion  				   AS Codigo, 
				B.TC_Descripcion						   AS Descripcion, 
				B.TF_Inicio_Vigencia					   AS FechaActivacion, 
				B.TF_Fin_Vigencia						   AS FechaDesactivacion,
				'Split_TipoItineracion'					   AS Split_TipoItineracion, 
       			C.TN_CodResultadoLegajo					   AS Codigo, 
				A.TF_Inicio_Vigencia					   AS FechaAsociacion,
				C.TC_Descripcion						   AS Descripcion, 
				C.TF_FechaInicioVigencia				   AS FechaActivacion,
				A.TB_PorDefecto							   AS PorDefecto, 
				C.TF_FechaFinVigencia					   AS FechaDesactivacion 				 
	FROM		Catalogo.TipoItineracionResultadoLegajo    AS A WITH (NOLOCK) 
	INNER JOIN	Catalogo.TipoItineracion      			   AS B WITH (NOLOCK)
	ON			B.TN_CodTipoItineracion						= A.TN_CodTipoItineracion
	INNER JOIN	Catalogo.ResultadoLegajo 				   AS C WITH (NOLOCK)
	ON			C.TN_CodResultadoLegajo						= A.TN_CodResultadoLegajo
	WHERE		(A.TN_CodTipoItineracion					= @L_CodTipoItineracion
	OR			A.TN_CodResultadoLegajo						= @L_CodResultadoLegajo)
	AND			A.TF_Inicio_Vigencia						<= CASE WHEN @L_FechaAsociacion IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
	AND			A.TB_PorDefecto								= COALESCE(@L_PorDefecto, A.TB_PorDefecto)
	ORDER BY	B.TC_Descripcion, C.TC_Descripcion;

END
GO
