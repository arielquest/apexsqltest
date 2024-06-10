SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<18/07/2019>
-- Descripción:				<Modifica un registro de motivo de rechazo de itineración>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarMotivoRechazoItineracion]
	
	@CodMotivoRechazoItineracion	smallint,
	@Descripcion					varchar(255),	
	@FinVigencia					datetime2		
AS  
BEGIN  

	Update	Catalogo.MotivoRechazoItineracion
	Set		TC_Descripcion						=	@Descripcion,		
			TF_Fin_Vigencia						=	@FinVigencia				
	Where	TN_CodMotivoRechazoItineracion	=	@CodMotivoRechazoItineracion
End

GO
