SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Gerardo Lopez>
-- Fecha Creación: <15/06/2016>
-- Descripcion:	<Poder asociar un documento a un registro resolucion de expediente.>
 -- =============================================
CREATE PROCEDURE [Expediente].[PA_AsignarArchivoResolucion] 
	@CodResolucion  uniqueidentifier, 
	@CodArchivo  uniqueidentifier	 

AS
BEGIN

 
UPDATE [Expediente].[Resolucion]
      SET   [TU_CodArchivo] =@CodArchivo
      WHERE
          [TU_CodResolucion] = @CodResolucion  
 
 
END
GO
