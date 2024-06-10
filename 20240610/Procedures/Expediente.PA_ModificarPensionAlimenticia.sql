SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================================================================
-- Autor:		   <Ronny Ramírez R.>
-- Fecha Creación: <12/03/2021>
-- Descripcion:	   <Modifica datos relacionados de la pensión alimenticia>
-- ===================================================================================================================================
-- Modificación:	<Isaac Santiago Méndez Castillo> <06/07/2021> <Se agrega campo a modificar TN_MontoEmbargo>
-- ===================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarPensionAlimenticia]
	@NumeroExpediente		char(14), 
	@MontoMensual			decimal(18,2) = NULL,
	@MontoAguinaldo			decimal(18,2) = NULL,
	@MontoSalarioEscolar	decimal(18,2) = NULL,
	@MontoEmbargo			decimal(18,2) = NULL
AS
BEGIN
	--Variables        
	DECLARE	@L_TC_NumeroExpediente		char(14)		=	@NumeroExpediente,
			@L_TN_MontoMensual			decimal(18,2)	=	@MontoMensual,
			@L_TN_MontoAguinaldo		decimal(18,2)	=	@MontoAguinaldo,
			@L_TN_MontoSalarioEscolar	decimal(18,2)	=	@MontoSalarioEscolar,			
			@L_TN_MontoEmbargo			decimal(18,2)	=	@MontoEmbargo			

	UPDATE  Expediente.Expediente
	SET		TN_MontoMensual			=	@L_TN_MontoMensual,	
			TN_MontoAguinaldo		=	@L_TN_MontoAguinaldo,	
			TN_MontoSalarioEscolar	=	@L_TN_MontoSalarioEscolar,
			TN_MontoEmbargo			=   @L_TN_MontoEmbargo,
			TF_Actualizacion		=	GETDATE()
	WHERE	TC_NumeroExpediente		=	@L_TC_NumeroExpediente

END
GO
