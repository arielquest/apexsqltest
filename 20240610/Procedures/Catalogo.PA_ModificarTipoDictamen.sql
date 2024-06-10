SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<01/10/2015>
-- Descripcion:		<Modificar un tipo de dictamen.>
-- ==================================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoDictamen] 
	@Codigo smallint, 
	@Descripcion varchar(50),
	@FechaVencimiento datetime2=null
AS
BEGIN
	UPDATE	Catalogo.TipoDictamen
	SET		TC_Descripcion			=	@Descripcion,
			TF_Fin_Vigencia			=	@FechaVencimiento
	WHERE TN_CodTipoDictamen		=	@Codigo
END



GO
