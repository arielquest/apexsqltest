SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado pOr:				<Tatiana Flores>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Permite eliminar participantes parciales de lAs fechAs de evento [AgEnda].[[PA_EliminarParticipanteParcial]].>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_EliminarParticipanteParcial]
@CodigoParticipaciOn Uniqueidentifier,
@CodigoFechaEvento Uniqueidentifier

As
Begin

	Delete 
	From		[AgEnda].[FechaParticipanteParcial] 
	Where       [TU_CodParticipaciOn]	=	@CodigoParticipaciOn 
    And			[TU_CodFechaEvento]		=	@CodigoFechaEvento
			
End

GO
