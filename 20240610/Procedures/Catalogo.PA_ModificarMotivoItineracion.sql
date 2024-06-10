SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<12/07/2019>
-- Descripción:				<Modifica un registro de motivo de itineración>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarMotivoItineracion]
	
	@CodMotivoItineracion smallint,
	@Descripcion varchar(255),	
	@FinVigencia datetime2		
AS  
BEGIN  

	Update	Catalogo.MotivoItineracion
	Set		TC_Descripcion				=	@Descripcion,		
			TF_Fin_Vigencia				=	@FinVigencia				
	Where	TN_CodMotivoItineracion		=	@CodMotivoItineracion
End

GO
