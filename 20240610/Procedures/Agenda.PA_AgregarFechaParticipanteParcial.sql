SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Permite agregar un registro a [AgEnda].[PA_AgregarFechaParticipanteParcial.>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_AgregarFechaParticipanteParcial]
	 @CodigoParticipacion Uniqueidentifier,
	 @CodigoFechaEvento Uniqueidentifier,
	 @FechaInicioParticipacion Datetime2(7),
	 @FechaFinParticipacion Datetime2(7)
As
Begin

	Insert Into [AgEnda].[FechaParticipanteParcial]
	(
		TU_CodParticipacion, 
		TU_CodFechaEvento, 
		TF_FechaInicioParticipacion,
		TF_FechaFinParticipacion
	)
	Values
	(
		 @CodigoParticipacion,
		 @CodigoFechaEvento,
		 @FechaInicioParticipacion,
		 @FechaFinParticipacion
	)

End


GO
