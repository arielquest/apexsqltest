SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.1>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<03/11/2020>
-- Descripción:			<Permite registrar la finalización de una tarea, modificando la fecha y el usuario que Finaliza>
-- ==================================================================================================================================================================================
-- Modificación:		<13/11/2020> <Henry Mendez Ch> <Se modifica para que actualice el puesto de trabajo que finaliza>  
-- ==================================================================================================================================================================================


CREATE Procedure	[Expediente].[PA_FinalizarTarea]
	@CodTareaPendiente			uniqueidentifier,
	@UsuarioFinaliza			varchar(30),
	@CodPuestoTrabajoFinaliza	varchar(14)
AS
Begin
	--Variables
	Declare	@L_TareaPendiente				uniqueidentifier	= @CodTareaPendiente,
			@L_UsuarioFinaliza				varchar(30)			= @UsuarioFinaliza,
			@L_CodPuestoTrabajoFinaliza		varchar(14)			= @CodPuestoTrabajoFinaliza

	--Lógica
	Update	Expediente.TareaPendiente		WITH (ROWLOCK)
	Set		TF_Finalizacion					=	GetDate(), 
			TC_UsuarioRedFinaliza			=	@L_UsuarioFinaliza,
			TC_CodPuestoTrabajoFinaliza		=	@L_CodPuestoTrabajoFinaliza	
	Where	TU_CodTareaPendiente			=	@L_TareaPendiente	

END
GO
