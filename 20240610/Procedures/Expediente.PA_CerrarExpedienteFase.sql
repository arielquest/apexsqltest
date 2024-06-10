SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<19/06/2020>
-- Descripcion:			<Cierra la fase actual de un expediente.>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_CerrarExpedienteFase] 
	@CodFaseExpediente			uniqueidentifier
AS

BEGIN

	DECLARE	@L_TU_CodExpedienteFase		uniqueidentifier	= @CodFaseExpediente

	UPDATE		Historico.ExpedienteFase	SET
	TF_Fase					        =	GETDATE(),
	TF_Actualizacion				=	GETDATE()

	WHERE TU_CodExpedienteFase		=	@L_TU_CodExpedienteFase

END
GO
