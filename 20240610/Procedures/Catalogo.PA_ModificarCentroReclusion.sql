SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Johan Acosta Ibañez>
-- Fecha Creación: <02/09/2015>
-- Descripcion:	<Modificar un Centro de reclusión.>
-- Modificado : Pablo Alvarez
-- Fecha: 08/12/2015
-- Descripcion: Se cambia la llave a tinyint sequence
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarCentroReclusion] 
	@Codigo tinyint, 
	@Descripcion varchar(255),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.CentroReclusion
	SET		TC_Descripcion				=	@Descripcion,
			TF_Fin_Vigencia				=	@FechaVencimiento
	WHERE TN_CodCentroReclusion			=	@Codigo
END




GO
