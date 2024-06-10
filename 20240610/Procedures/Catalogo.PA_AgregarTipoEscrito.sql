SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Andrew Allen Dawson>
-- Fecha Creación: <19/09/2019>
-- Descripcion:	<Crear un nuevo registro de tipo escrito.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoEscrito] 
	@Descripcion varchar(100),
	@FechaActivacion datetime2,
	@FechaDesactivacion datetime2
AS
BEGIN
	INSERT INTO [Catalogo].[TipoEscrito] 
	(
		TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
	)
	VALUES
	(
		@Descripcion,	@FechaActivacion	,@FechaDesactivacion
	)
END
GO
