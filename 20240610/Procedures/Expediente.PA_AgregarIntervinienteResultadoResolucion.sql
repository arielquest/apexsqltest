SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Gerardo Lopez>
-- Fecha Creación:		<09/06/2016>
-- Descripcion:			<Agregar un resultado de resolucion para un interviniente>
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarIntervinienteResultadoResolucion] 
          @Codigo  uniqueidentifier, 
          @CodigoInterviniente uniqueidentifier, 
		  @CodigoResolucion uniqueidentifier, 
          @CodigoResultadoResolucion smallint        
      
AS
BEGIN
	INSERT INTO Expediente.ResultadoResolucionInterviniente
	(TU_CodResultadoResolucionInterviniente , TU_CodInterviniente, TU_CodResolucion, TN_CodResultadoResolucion,  TF_Actualizacion )
	VALUES
	(@Codigo, @CodigoInterviniente,	@CodigoResolucion,		@CodigoResultadoResolucion,   GETDATE() )
	
END


GO
