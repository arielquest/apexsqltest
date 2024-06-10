SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Andrés Espinoza Rojas>
-- Fecha creación:	<03/05/2023>
-- Descripción:		<SP que	permite modificar un registro de las labores de facilitador judicial>
-- =================================================================================================================================================

CREATE   PROCEDURE  [Catalogo].[PA_ModificarLaborFacilitador]
	@CodLaborFacilitador     SMALLINT,
	@Descripcion             VARCHAR(255),
	@InicioVigencia          DATETIME2(7),
	@FinVigencia             DATETIME2(7),
	@ContabilizaGenero       BIT
	
AS
BEGIN
	--Variables
	
	DECLARE @L_TN_CodLaborFacilitador     SMALLINT     = @CodLaborFacilitador,
            @L_TC_Descripcion             VARCHAR(255) = @Descripcion,
	        @L_TF_InicioVigencia          DATETIME2(7) = @InicioVigencia,
	        @L_TF_FinVigencia             DATETIME2(7) = @FinVigencia,
	        @L_TB_ContabilizaGenero       BIT          = @ContabilizaGenero
			
			UPDATE Catalogo.LaborFacilitadorJudicial     WITH (ROWLOCK)  
			SET TC_Descripcion         	                 = @L_TC_Descripcion,         
				TF_InicioVigencia      	                 = @L_TF_InicioVigencia,      
				TF_FinVigencia         	                 = @L_TF_FinVigencia,
				TB_ContabilizaGenero   	                 = @L_TB_ContabilizaGenero   
			WHERE
				TN_CodLaborFacilitador                   = @L_TN_CodLaborFacilitador
END
GO
