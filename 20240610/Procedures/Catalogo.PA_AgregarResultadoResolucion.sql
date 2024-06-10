SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Sigifredo Leitón Luna>
-- Fecha Creación: <18/08/2015>
-- Descripcion:	<Crear un nuevo resultado de resolución>
-- Modificado:	<Johan Acosta, 16/12/2015, Cambio tipo smallint código >
-- Modificado:	<Gerardo Lopez  , 06/05/2016, Agregar campo TC_CodTipoOficina>
-- Modificado:	<Johan Acosta, 08/06/2016, Se quita el campo tipo oficina >
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarResultadoResolucion] 
	@Descripcion varchar(150),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2
AS
BEGIN
	INSERT INTO Catalogo.ResultadoResolucion 
	(
		TC_Descripcion, TF_Inicio_Vigencia,	TF_Fin_Vigencia
	)
	VALUES
	(
		@Descripcion,	@FechaActivacion,	@FechaVencimiento
	)
END
GO
