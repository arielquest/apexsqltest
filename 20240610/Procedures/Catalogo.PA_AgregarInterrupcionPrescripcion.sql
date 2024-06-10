SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Sigifredo Leitón Luna>
-- Fecha Creación: <25/08/2015>
-- Descripcion:	<Crear un nuevo tipo de interrupcion de prescripcion.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarInterrupcionPrescripcion] 
	@Descripcion varchar(100),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2
AS
BEGIN
	INSERT INTO Catalogo.InterrupcionPrescripcion 
	(
		TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
	)
	VALUES
	(
		@Descripcion,	@FechaActivacion	,@FechaVencimiento
	)
END
GO
