SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Permite agregar un registro a [AgEnda].[PA_AgregarParticipanteFechaEvento].>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_AgregarParticipanteFechaEvento]
	 @CodigoParticipacion Uniqueidentifier,
	 @CodigoFechaEvento Uniqueidentifier,
	 @ParticipacionParcial Bit
As
Begin

	Insert Into [AgEnda].[ParticipanteFechaEvento]
	(
		TU_CodParticipacion, 
		TU_CodFechaEvento, 
		TB_ParticipacionParcial
	)
	Values
	(
		 @CodigoParticipacion,
		 @CodigoFechaEvento,
		 @ParticipacionParcial
	)

End

GO
