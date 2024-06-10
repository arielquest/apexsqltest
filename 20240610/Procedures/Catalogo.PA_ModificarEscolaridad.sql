SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<25/08/2015>
-- Descripción :			<Permite Modificar una Escolaridad en la tabla Catalogo.Escolaridad> 

-- Modificado por:			<Olger Gamboa castillo>
-- Fecha de creación:		<14/12/2015>
-- Descripción :			<se modifica para que el código sea smallint> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarEscolaridad]

	@CodEscolaridad smallint,
	@Descripcion varchar(150),	
	@FinVigencia datetime2(7)	
	

AS  
BEGIN  

	Update	Catalogo.Escolaridad
	Set		TC_Descripcion		=	@Descripcion,		
			TF_Fin_Vigencia		=	@FinVigencia				
	Where	TN_CodEscolaridad	=	@CodEscolaridad
End









GO
