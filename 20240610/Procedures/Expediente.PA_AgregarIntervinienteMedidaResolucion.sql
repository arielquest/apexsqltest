SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================
-- Autor: 			<Rafa Badilla Alvarado> 
-- Fecha Creación:  <19/010/2022> 
-- Descripcion:	    <Permite agregar una resolución a una medida de un interviniente>
-- =================================================================================================================================================

CREATE      PROCEDURE [Expediente].[PA_AgregarIntervinienteMedidaResolucion] 
@CodResolucion		uniqueidentifier, 
@CodMedida			uniqueidentifier
AS
BEGIN

Declare @L_TU_CodResolucion		uniqueidentifier = @CodResolucion,
@L_TU_CodMedida			uniqueidentifier = @CodMedida

INSERT INTO [Expediente].[IntervinienteMedidaResolucion]
           ([TU_CodResolucion]
           ,[TU_CodMedida])
     VALUES
           (@L_TU_CodResolucion
           ,@L_TU_CodMedida)
END
GO
