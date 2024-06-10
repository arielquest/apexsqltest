SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Ronny Ramírez>
-- Fecha Creación: <27/06/2017>
-- Descripcion:	<Poder asociar una Resolución a un registro de Cálculo de Interés.>
 -- =============================================
CREATE PROCEDURE [Expediente].[PA_AsignarResolucionCalculoInteres] 
	@Codigo uniqueidentifier,
	@CodResolucion  uniqueidentifier 	 

AS
BEGIN

 
UPDATE [Expediente].[CalculoInteres]
      SET   [TU_CodResolucion] = @CodResolucion
      WHERE
          [TU_CodigoCalculoInteres] = @Codigo  
 
 
END

GO
