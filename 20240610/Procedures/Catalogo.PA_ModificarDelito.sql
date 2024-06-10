SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Pablo Alvarez>
-- Fecha Creación: <20/08/2015>
-- Descripcion:	<Modificar datos de un delito>
-- Modificado:	<Alejandro Villalta, cambiar codigo de delito, 08/12/15>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarDelito] 
	@CodDelito int, 
	@CodCategoriaDelito int, 
	@Descripcion varchar(255),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.Delito
	SET		TN_CodCategoriaDelito =	@CodCategoriaDelito,
	        TC_Descripcion		  =	@Descripcion,
			TF_Fin_Vigencia		  =	@FechaVencimiento
	WHERE	TN_CodDelito		  =	@CodDelito
END
GO
