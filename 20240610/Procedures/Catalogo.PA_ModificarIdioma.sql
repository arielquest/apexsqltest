SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Pablo Alvarez>
-- Fecha Creación: <31/08/2015>
-- Descripcion:	<Modificar datos de un idioma
-- =============================================
-- Modificacion:  08/12/2015  Modificar tipo dato CodMoneda a smallint

CREATE PROCEDURE [Catalogo].[PA_ModificarIdioma] 
	@CodIdioma smallint, 
	@Descripcion varchar(150),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.Idioma
	SET		TC_Descripcion	=	@Descripcion,
			TF_Fin_Vigencia	=	@FechaVencimiento
	WHERE	TN_CodIdioma =	@CodIdioma
END
GO
