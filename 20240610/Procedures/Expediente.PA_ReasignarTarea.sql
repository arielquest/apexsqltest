SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<02/11/2020>
-- Descripción:			<Permite registrar la reasingnación de una tarea, modificando la fecha y el usuario que reasigna>
-- ==================================================================================================================================================================================
-- Modificación:		<13/11/2020> <Henry Mendez Ch> <Se modifica para que actualice el puesto de trabajo que Reasigna>  
-- ==================================================================================================================================================================================

CREATE Procedure	[Expediente].[PA_ReasignarTarea]
	@TareaPendiente				uniqueidentifier,
	@UsuarioReasigna			varchar(30),
	@CodPuestoTrabajoReasigna	varchar(14)
AS
Begin
	--Variables
	Declare	@L_TareaPendiente				uniqueidentifier	= @TareaPendiente,
			@L_UsuarioReasigna				varchar(30)			= @UsuarioReasigna,
			@L_CodPuestoTrabajoReasigna		varchar(14)			= @CodPuestoTrabajoReasigna

	--Lógica
	Update	Expediente.TareaPendiente
	Set		TF_Reasignacion					=	GetDate(), 
			TC_UsuarioRedReasigna			=	@L_UsuarioReasigna,
			TC_CodPuestoTrabajoReasigna		=	@L_CodPuestoTrabajoReasigna	
	Where	TU_CodTareaPendiente			=	@L_TareaPendiente	

END
GO
