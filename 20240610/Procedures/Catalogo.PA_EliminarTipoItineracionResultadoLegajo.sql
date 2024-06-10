SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<25/10/2019>
-- Descripción :			<Permite desasociar un tipo de itineración a un resultado de legajo>.
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarTipoItineracionResultadoLegajo]
    @CodTipoItineracion	smallint	= Null,
	@CodResultadoLegajo	smallint	= Null
As
Begin

	DELETE FROM [Catalogo].[TipoItineracionResultadoLegajo]
		   WHERE TN_CodTipoItineracion		= @CodTipoItineracion
		   AND	 TN_CodResultadoLegajo		= @CodResultadoLegajo

End
GO
