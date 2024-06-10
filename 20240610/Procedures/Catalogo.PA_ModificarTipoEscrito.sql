SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Andrew Allen Dawson>
-- Fecha Creación: <19/09/2019>
-- Descripcion:	<Modificar un tipo de escrito>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoEscrito] 
	@Codigo smallint, 
	@Descripcion varchar(100),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.TipoEscrito
	SET		TC_Descripcion			=	@Descripcion,
			[TF_Fin_Vigencia]		=	@FechaVencimiento
	WHERE TN_CodTipoEscrito		=	@Codigo
END
GO
