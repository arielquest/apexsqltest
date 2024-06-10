SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<06/09/2019>
-- Descripción:				<Modifica un registro de resultado legajo>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarResultadoLegajo]
	
	@CodResultadoLegajo smallint,
	@Descripcion varchar(255),	
	@FinVigencia datetime2		
AS  
BEGIN  

	Update	Catalogo.ResultadoLegajo
	Set		TC_Descripcion				=	@Descripcion,		
			TF_FechaFinVigencia			=	@FinVigencia				
	Where	TN_CodResultadoLegajo		=	@CodResultadoLegajo
End

GO
