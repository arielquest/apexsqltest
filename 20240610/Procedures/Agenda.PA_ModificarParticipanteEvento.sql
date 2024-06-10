SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado pOr:				<Tatiana Flores>
-- Fecha de creación:		<27/12/2016>
-- Descripción:				<Permite modIificar un regIstro a [Agenda].[PA_ModificarParticipanteEvento].>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_ModificarParticipanteEvento]
	 @CodigoParticipacion Uniqueidentifier,
	 @CodigoEvento Uniqueidentifier,
	 @CodigoPuestoTrabajo Varchar(14),
	 @CodigoEstadoParticipaciOn SmallInt,
	 @Observaciones Varchar(200)
As
Begin

	Update [AgEnda].[ParticipanteEvento]
	Set
		TC_CodPuestoTrabajo			=	@CodigoPuestoTrabajo, 
		TN_CodEstadoParticipaciOn	=	@CodigoEstadoParticipacion, 
		TC_Observaciones			=	@Observaciones
	
	Where  
		TU_CodParticipacion			=	@CodigoParticipacion
	And TU_CodEvento				=	@CodigoEvento
	
End
GO
