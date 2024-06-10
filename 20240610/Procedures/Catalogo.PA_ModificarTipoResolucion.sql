SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Donald Vargas>
-- Fecha Creación:	<12/05/2016>
-- Descripcion:		<Modificar datos de un tipo de resolucion>
--
-- Modificación:	<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodTipoResolucion a TN_CodTipoResolucion de acuerdo al tipo de dato.>
-- =============================================
-- Modificado :		<Johan Acosta> <05/12/2016> <Se cambio nombre de TC a TN> 
-- Modificación		<Jonathan Aguilar Navarro> <20/06/2018> <Se elimina el parametro @TipoOficina> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoResolucion] 
	@Codigo SMALLINT = NULL, 
	@Descripcion VARCHAR(100) = NULL,
	@FechaDesactivacion DATETIME2(7) = NULL,
	@EnvioSCIJ BIT = NULL
AS
BEGIN
	UPDATE	Catalogo.TipoResolucion
	SET		TC_Descripcion				=	@Descripcion,
			TF_Fin_Vigencia				=	@FechaDesactivacion,
			TB_EnvioSCIJ				=	@EnvioSCIJ
	WHERE	TN_CodTipoResolucion		=	@Codigo
END


GO
