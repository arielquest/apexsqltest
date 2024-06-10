SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Andrés Espinoza Rojas>
-- Fecha creación:	<09/05/2023>
-- Descripción:		<SP que	permite modificar un registro de las labores de personal judicial>
-- =================================================================================================================================================

CREATE   PROCEDURE  [Catalogo].[PA_ModificarLaborPersonalJudicial]
	@CodLaborPersonalJudicial SMALLINT,
	@Descripcion              VARCHAR(255),
	@InicioVigencia           DATETIME2(7),
	@FinVigencia              DATETIME2(7)
	
AS
BEGIN
	--Variables
	DECLARE @L_TN_CodLaborPersonalJudicial  SMALLINT     = @CodLaborPersonalJudicial,
            @L_TC_Descripcion               VARCHAR(255) = @Descripcion,
	        @L_TF_InicioVigencia            DATETIME2(7) = @InicioVigencia,
	        @L_TF_FinVigencia               DATETIME2(7) = @FinVigencia
			
			UPDATE Catalogo.LaborPersonalJudicial         WITH (ROWLOCK)  
			SET TC_Descripcion         	                 = @L_TC_Descripcion,         
				TF_InicioVigencia      	                 = @L_TF_InicioVigencia,      
				TF_FinVigencia         	                 = @L_TF_FinVigencia
			WHERE
				TN_CodLaborPersonalJudicial              = @L_TN_CodLaborPersonalJudicial
END
GO
