SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:				<Gerardo Lopez>
-- Fecha Creación:		<02/06/2016>
-- Descripcion:			<Quitar un resultado de resolucion para un interviniente>
-- =============================================
CREATE PROCEDURE [Expediente].[PA_EliminarIntervinienteResultadoResolucion] 
          @Codigo  uniqueidentifier  
      
AS
BEGIN
	
	Delete From Expediente.ResultadoResolucionInterviniente
      Where TU_CodResultadoResolucionInterviniente      =  @Codigo
 
	
END

GO
