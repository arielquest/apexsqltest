SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Stefany Quesada CAscante>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Permite eliminar participante de evento [AgEnda].[PA_EliminarParticipanteEvento]>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_EliminarParticipanteEvento]
	
@CodigoParticipaciOn Uniqueidentifier,
@CodigoEvento Uniqueidentifier

As
Begin

	Delete 
	From [Agenda].[FechaParticipanteParcial]
	Where		[TU_CodParticipacion] = @CodigoParticipaciOn

	Delete 
	From [Agenda].[ParticipanteFechaEvento]
	Where		[TU_CodParticipacion] = @CodigoParticipaciOn

	Delete 
	From [AgEnda].[ParticipanteEvento] 
	Where		[TU_CodParticipaciOn]=@CodigoParticipaciOn  
	And			[TU_CodEvento]=@CodigoEvento
	
End
GO
