SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jefry Hernández>
-- Fecha de creación:		<14/05/2017>
-- Descripción :			<Permite eliminar registros de [Expediente].[SolicitudDefensorInterviniente]
--							asociados al código de solicitud recibido por parámetro
-- =================================================================================================================================================
 
CREATE PROCEDURE [Expediente].[PA_EliminarSolicitudDefensorInterviniente]
     @CodSolicitudDefensor	Uniqueidentifier,
	 @CodInterviniente Uniqueidentifier = null	  


As  
Begin
	
	Delete 
	From [Expediente].[SolicitudDefensorInterviniente] 
	Where TU_CodSolicitudDefensor = @CodSolicitudDefensor	and 
	      TU_CodInterviniente =Coalesce( @CodInterviniente,TU_CodInterviniente)

End

  



GO
