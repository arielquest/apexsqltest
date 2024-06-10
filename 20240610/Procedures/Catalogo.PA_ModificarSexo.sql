SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<19/08/2015>
-- Descripción :			<Permite Modificar un Sexo en la tabla Catalogo.Sexo> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarSexo]

	@CodSexo varchar(9),
	@Descripcion varchar(150),	
	@FinVigencia datetime2	
	

AS  
BEGIN  

	Update	Catalogo.Sexo
	Set		TC_Descripcion		=	@Descripcion,		
			TF_Fin_Vigencia		=	@FinVigencia				
	Where	TC_CodSexo			=	@CodSexo
End


GO
