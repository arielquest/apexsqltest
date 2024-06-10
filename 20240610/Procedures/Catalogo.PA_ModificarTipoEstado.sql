SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<19/08/2015>
-- Descripción :			<Permite Modificar un tipo estado en la tabla Catalogo.TipoEstado> 
-- Modificado :				<Alejandro Villalta, 14/12/2015, Se modifica el tipo de dato del codigo de tipo estado.> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarTipoEstado]
	@CodTipoEstado smallint,
	@Descripcion varchar(150),	
	@FinVigencia datetime2	
AS  
BEGIN  

	Update	Catalogo.TipoEstado
	Set		TC_Descripcion					=	@Descripcion,		
			TF_Fin_Vigencia					=	@FinVigencia				
	Where	TN_CodTipoEstado				=	@CodTipoEstado
End




GO
