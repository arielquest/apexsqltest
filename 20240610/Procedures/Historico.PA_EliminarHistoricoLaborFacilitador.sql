SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Andrés Espinoza Rojas>
-- Fecha creación:	<23/03/2023>
-- Descripción:		<SP que	permite eliminar un registro del historico de labores de facilitador judicial>
-- =================================================================================================================================================

CREATE   PROCEDURE  [Historico].[PA_EliminarHistoricoLaborFacilitador]
	@CodLaborRealizada    UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	
	DECLARE @L_TU_CodLaborRealizada	   UNIQUEIDENTIFIER = @CodLaborRealizada

			DELETE 
				Historico.LaborRealizadaFacilitador
			WHERE
				TU_CodLaborRealizada    = @L_TU_CodLaborRealizada	 
END
GO
