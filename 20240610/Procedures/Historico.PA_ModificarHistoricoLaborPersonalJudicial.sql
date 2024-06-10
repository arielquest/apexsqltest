SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Andrés Espinoza Rojas>
-- Fecha creación:	<18/04/2023>
-- Descripción:		<SP que	permite modificar un registro del historico de labores de personal judicial>
-- =================================================================================================================================================

CREATE   PROCEDURE  [Historico].[PA_ModificarHistoricoLaborPersonalJudicial]
	@CodLabor                 UNIQUEIDENTIFIER,
	@CodLaborPersonalJudicial SMALLINT,
	@HorasOficina             SMALLINT,
	@HorasFueraOficina        SMALLINT
	
	
AS
BEGIN
	--Variables
	
	DECLARE @L_TU_CodLabor                 UNIQUEIDENTIFIER  = @CodLabor,                    	
	        @L_TN_CodLaborPersonalJudicial SMALLINT          = @CodLaborPersonalJudicial,
	        @L_TN_HorasOficina             SMALLINT          = @HorasOficina,         
	        @L_TN_HorasFueraOficina        SMALLINT          = @HorasFueraOficina    
			
			update Historico.LaborRealizadaPersonalJudicial  WITH (ROWLOCK)  
			SET TN_CodLaborPersonalJudicial	                 = @L_TN_CodLaborPersonalJudicial,
				TN_HorasOficina            	                 = @L_TN_HorasOficina,            
				TN_HorasFueraOficina       	                 = @L_TN_HorasFueraOficina,
				TF_Actualizacion							 = GETDATE()
			WHERE
				TU_CodLabor                                  = @L_TU_CodLabor
END
GO
