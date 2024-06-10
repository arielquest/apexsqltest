SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Alejandro Villalta Ruiz>
-- Fecha Creación: <06/08/2015>
-- Descripcion:	<Crear un nuevo tipo de despacho>
-- Modificado:	<Alejandro Villalta Ruiz><18/12/2015><Autogenerar el codigo del tipo de oficina>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoOficina] 
	@Descripcion varchar(255),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2
AS
BEGIN
	INSERT INTO Catalogo.TipoOficina
	(
		TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
	) 
	VALUES
	(
		@Descripcion,	@FechaActivacion,	@FechaVencimiento
	)
END
GO
