SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Alejandro Villalta Ruiz>
-- Fecha Creación:  <10/08/2015>
-- Descripcion:		<Crear un nuevo tipo de despacho>
-- Modificado:		<Alejandro Villalta Ruiz><18/12/2015><Autogenerar el codigo del tipo de oficina>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoOficina] 
	@Codigo smallint, 
	@Descripcion varchar(255),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE Catalogo.TipoOficina
	SET TC_Descripcion      = @Descripcion,
		TF_Fin_Vigencia     = @FechaVencimiento
	WHERE TN_CodTipoOficina = @Codigo
END


GO
