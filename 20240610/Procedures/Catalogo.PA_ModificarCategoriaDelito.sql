SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Pablo Alvarez>
-- Fecha Creación: <19/08/2015>
-- Descripcion:	<Modificar datos de una categoria de delito>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarCategoriaDelito] 
	@CodCategoriaDelito int, 
	@Descripcion varchar(255),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.CategoriaDelito
	SET		TC_Descripcion	=	@Descripcion,
			TF_Fin_Vigencia	=	@FechaVencimiento
	WHERE	TN_CodCategoriaDelito =	@CodCategoriaDelito
END
GO
