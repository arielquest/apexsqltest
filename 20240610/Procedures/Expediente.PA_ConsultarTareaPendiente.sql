SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<23/11/2020>
-- Descripción:			<Permite consultar un registro en la tabla: TareaPendiente.>
-- ==================================================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero soto><24/11/2020><Se ingresa la consulta por split>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ConsultarTareaPendiente]
	@CodTareaPendiente			UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodTareaPendiente		UNIQUEIDENTIFIER		= @CodTareaPendiente

	--Lógica
	SELECT		A.TU_CodTareaPendiente						Codigo,
				A.TF_Recibido								FechaRecibido,	
				A.TF_Vence									FechaVence,
				'splitOtros'								splitOtros,	
				A.TC_Mensaje								Mensaje,
				A.TC_CodPuestoTrabajoOrigen					CodPuestoTrabajoOrigen,
				A.TC_UsuarioRedOrigen						UsuarioRedOrigen,
				A.TN_CodTarea								CodTarea,
				A.TC_CodPuestoTrabajoDestino				CodPuestoTrabajoDestino,
				A.TU_CodTareaPendienteAnterior				CodTareaPendienteAnterior,
				A.TF_Finalizacion							Finalizacion,
				A.TC_UsuarioRedFinaliza						UsuarioRedFinaliza,
				A.TC_CodPuestoTrabajoFinaliza				CodPuestoTrabajoFinaliza,
				A.TF_Reasignacion							Reasignacion,
				A.TC_UsuarioRedReasigna						UsuarioRedReasigna,
				A.TC_CodPuestoTrabajoReasigna				CodPuestoTrabajoReasigna				
				
	FROM	Expediente.TareaPendiente						A 
	WHERE	TU_CodTareaPendiente							= @L_TU_CodTareaPendiente
END
GO
