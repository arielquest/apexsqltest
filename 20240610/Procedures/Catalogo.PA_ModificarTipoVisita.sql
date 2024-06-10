SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<24/08/2015>
-- Descripción :			<Permite Modificar un tipo de visita en la tabla Catalogo.TipoVisita> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de modificación:	<05/01/2016>
-- Descripción :			<Generar automáticamente el codigo de tipo de visita - item 5782.> 	
--
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodTipoVisita a TN_CodTipoVisita de acuerdo al tipo de dato.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoVisita]
	@CodTipoVisita	smallint,
	@Descripcion	varchar(150),	
	@FinVigencia	datetime2
AS  
BEGIN
	Update	Catalogo.TipoVisita
	Set		TC_Descripcion		=	@Descripcion,		
			TF_Fin_Vigencia		=	@FinVigencia				
	Where	TN_CodTipoVisita	=	@CodTipoVisita
End






GO
