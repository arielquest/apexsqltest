SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<20/11/2018>
-- Descripción :			<Permite actualizar el estado de una solicitud de desacumulación> 
-- =================================================================================================================================================
-- Modificado : Cristian Cerdas Camacho
-- Fecha: 30/04/2021
-- Descripcion: Se realiza cambio para almacenar la fecha y hora de la actualización en cada cambio de estado.
-- =================================================================================================================================================
CREATE Procedure [Historico].[PA_ModificarEstadoSolicitudDesacumulacion]
	@CodSolicitud			uniqueidentifier,
	@EstadoSolicitud		char(1),
	@Observaciones			varchar(255)
As
Begin
	update	Historico.SolicitudDesacumulacion
	set		TC_Estado			= @EstadoSolicitud,
			TC_Observaciones	= @Observaciones,
			TF_Actualizacion	= GETDATE()
	Where	TU_CodSolicitud		= @CodSolicitud	
End
GO
