SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Andrés Espinoza Rojas>
-- Fecha creación:	<05/04/2023>
-- Descripción:		<SP que	permite eliminar un registro del historico de labores de personal judicial>
-- =================================================================================================================================================

CREATE   PROCEDURE  [Historico].[PA_EliminarHistoricoLaborPersonalJudicial]
	@CodLabor UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE @L_TU_CodLabor UNIQUEIDENTIFIER = @CodLabor
	
	DELETE 
		Historico.LaborRealizadaPersonalJudicial
	WHERE
		TU_CodLabor = @L_TU_CodLabor	 
END
GO
