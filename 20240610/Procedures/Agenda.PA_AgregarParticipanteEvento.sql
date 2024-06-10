SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Permite agregar un registro a [AgEnda].[PA_AgregarParticipanteEvento].>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_AgregarParticipanteEvento]
	 @CodigoParticipacion Uniqueidentifier,
	 @CodigoEvento Uniqueidentifier,
	 @CodigoPuestoTrabajo Varchar(14),
	 @CodigoEstadoParticipacion Smallint,
	 @Observaciones Varchar(200)
As
Begin

	Insert Into [AgEnda].[ParticipanteEvento]
	(
		TU_CodParticipacion, 
		TU_CodEvento, 
		TC_CodPuestoTrabajo, 
		TN_CodEstadoParticipacion, 
		TC_Observaciones
	)
	Values
	(
		 @CodigoParticipacion,
		 @CodigoEvento,
		 @CodigoPuestoTrabajo,
		 @CodigoEstadoParticipacion,
		 @Observaciones
	)

End

GO
