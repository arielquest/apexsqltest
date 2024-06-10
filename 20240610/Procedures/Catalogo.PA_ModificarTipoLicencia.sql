SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Johan Acosta Ibañez>
-- Fecha Creación: <21/09/2015>
-- Descripcion:	<Modificar un tipo de licencia>
-- =============================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoLicencia] 
	@Codigo smallint, 
	@Descripcion varchar(150),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.TipoLicencia
	SET		TC_Descripcion				=	@Descripcion,
			TF_Fin_Vigencia				=	@FechaVencimiento
	WHERE	TN_CodTipoLicencia			=	@Codigo
END


GO
