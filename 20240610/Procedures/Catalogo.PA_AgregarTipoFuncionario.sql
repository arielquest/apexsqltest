SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Alejandro Villalta Ruiz>
-- Fecha Creación:	<11/08/2015>
-- Descripcion:		<Crear un nuevo tipo de funcionario>
-- Modificado por:	<Sigifredo Leitón Luna.>
-- Fecha:			<06/01/2016>
-- Descripcion:		<Se modifica para autogenerar el código de tipo de funcionario - item 5678.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoFuncionario]
	@Descripcion varchar(255),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2
AS
BEGIN
	INSERT INTO Catalogo.TipoFuncionario
	(
		TC_Descripcion,TF_Inicio_Vigencia,TF_Fin_Vigencia
	)
	VALUES
	(
		@Descripcion,@FechaActivacion,@FechaVencimiento
	)
END

GO
