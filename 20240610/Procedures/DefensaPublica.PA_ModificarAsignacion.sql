SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<15/10/2019>
-- Descripción :			<Permite modificar una asignación>
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_ModificarAsignacion]
	@CodAsignacion			uniqueidentifier,
	@CodRepresentacion		uniqueidentifier,
	@CodMotivoFinalizacion	smallint	
As
Begin
	Update	DefensaPublica.Asignacion
	Set		TN_CodMotivoFinalizacion	= @CodMotivoFinalizacion,			
			TF_Fin_Vigencia				= GETDATE(),
			TF_Actualizacion			= GETDATE()
	Where	TU_CodRepresentacion		= @CodRepresentacion
	And		TU_CodAsignacion			= @CodAsignacion	
End
GO
