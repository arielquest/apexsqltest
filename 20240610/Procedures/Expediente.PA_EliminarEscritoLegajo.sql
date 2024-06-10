SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<12/11/2019>
-- Descripción :			<Permite eliminar registros de Expediente.EscritoLegajo.>
-- ===========================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarEscritoLegajo]
	@CodEscrito		uniqueidentifier,
	@CodLegajo		uniqueidentifier
As
Begin

DELETE FROM [Expediente].[EscritoLegajo]
      WHERE [TU_CodEscrito] = @CodEscrito
	  AND	[TU_CodLegajo] =  @CodLegajo

End


GO
