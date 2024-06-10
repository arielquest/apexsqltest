SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Jonathan Aguilar Navarro>
-- Fecha Creación:	<06/09/2018>
-- Descripcion:		<Modificar datos de una categoría resolución>

CREATE PROCEDURE [Catalogo].[PA_ModificarCategoriaResolucion] 
	@Codigo				Int				= NULL, 
	@Descripcion		Varchar(100)	= NULL,
	@FechaDesactivacion Datetime2(7)	= NULL

AS
BEGIN
	UPDATE	Catalogo.CategoriaResolucion
	SET		TC_Descripcion				=	@Descripcion,
			TF_Fin_Vigencia				=	@FechaDesactivacion
	WHERE	TN_CodCategoriaResolucion	=	@Codigo
END


GO
