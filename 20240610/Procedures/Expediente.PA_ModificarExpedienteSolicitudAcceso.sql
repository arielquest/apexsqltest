SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<25/09/2019>
-- Descripción :			<Permite modificar un registro de solicitud a la tabla Expediente.ExpedienteSolicitudAcceso> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarExpedienteSolicitudAcceso] 
     @CodigoSolicitud								uniqueidentifier,
     @EstadoSolicitudAccesoExpediente				char(1),
	 @CodContextoRevision							varchar(4),
	 @CodPuestoTabajoFuncionarioRevision			uniqueidentifier,
	 @MotivoRechazo									varchar(225) = null

As  
Begin
  
  	UPDATE Expediente.ExpedienteSolicitudAcceso 
	
	SET
	TC_EstadoSolicitudAccesoExpediente				= @EstadoSolicitudAccesoExpediente,
	TC_CodContextoRevision							= @CodContextoRevision,
	TU_CodPuestoFuncionarioRevision					= @CodPuestoTabajoFuncionarioRevision,
	TF_Revision										= GETDATE(),
	TC_MotivoRechazo								= @MotivoRechazo
		
	WHERE
	TU_CodSolicitudAccesoExpediente					= @CodigoSolicitud
End
GO
