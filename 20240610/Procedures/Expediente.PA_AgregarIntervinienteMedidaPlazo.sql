SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================
-- Autor: <Rafa Badilla Alvarado> Fecha Creación: <19/010/2022> Descripcion:	<Permite agregar un nuevo plazo a una medida de un interviniente>
-- =================================================================================================================================================

CREATE      PROCEDURE [Expediente].[PA_AgregarIntervinienteMedidaPlazo] 
@CodPlazo		uniqueidentifier, 
@CodMedida		uniqueidentifier, 
@FechaInicio	datetime2(3) = NULL,
@FechaFin		datetime2(3) = NULL	
AS
BEGIN

Declare @L_TU_CodPlazo		uniqueidentifier = @CodPlazo,
@L_TU_CodMedida		uniqueidentifier = @CodMedida,
@L_TF_FechaInicio	datetime2(3)= @FechaInicio,
@L_TF_FechaFin		datetime2(3) = @FechaFin


INSERT INTO [Expediente].[IntervinienteMedidaPlazo]
           ([TU_CodPlazo]
           ,[TU_CodMedida]
           ,[TF_FechaInicio]
           ,[TF_FechaFin])
     VALUES
           (@L_TU_CodPlazo
           ,@L_TU_CodMedida
           ,@L_TF_FechaInicio
           ,@L_TF_FechaFin)
END
GO
