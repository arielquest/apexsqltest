SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado pOr:				<Tatiana Flores>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Permite eliminar participantes fechAs de evento>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_EliminarParticipanteFechaEvento]
	
@CodigoParticipaciOn Uniqueidentifier,
@CodigoFechaEvento Uniqueidentifier

As
Begin

    Delete 
	From		[Agenda].[FechaParticipanteParcial]
	Where       [TU_CodParticipaciOn]	=	@CodigoParticipaciOn  
	And			[TU_CodFechaEvento]		=	@CodigoFechaEvento

	Delete 
	From		[AgEnda].[ParticipanteFechaEvento]
	Where       [TU_CodParticipaciOn]	=	@CodigoParticipaciOn  
	And			[TU_CodFechaEvento]		=	@CodigoFechaEvento
	
End
GO
