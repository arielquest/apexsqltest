SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<03/07/2019>
-- Descripción :			<Permite Agregar un nuevo motivo de itineración> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarMotivoItineracion]
	@Descripcion varchar(255),
	@InicioVigencia datetime2,
	@FinVigencia datetime2	

AS  
BEGIN  

	Insert Into Catalogo.MotivoItineracion
	(	
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia )
	Values
	( 
		@Descripcion,		@InicioVigencia,		@FinVigencia )
End
GO
