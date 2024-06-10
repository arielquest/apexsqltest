SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Johan Acosta Ibañez>
-- Fecha Creación: <19/08/2015>
-- Descripcion:	<Modificar un grupo de trabajo>
-- Modificación: <Jonathan Aguilar Navarro> <10/04/2018> Se cambia el parametro @CodOficina por @CodContexto y se cambia el campo de la tabla TC_CodOficina por TC_CodContexto
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarGrupoTrabajo] 
	@Codigo smallint, 
	@Descripcion varchar(255),
    @CodContexto varchar(4),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.GrupoTrabajo
	SET		TC_Descripcion			=	@Descripcion,
			TF_Fin_Vigencia			=	@FechaVencimiento,
			TC_CodContexto           =   @CodContexto 
	WHERE TN_CodGrupoTrabajo	    =	@Codigo
END





GO
