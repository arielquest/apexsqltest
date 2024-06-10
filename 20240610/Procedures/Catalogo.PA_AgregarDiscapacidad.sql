SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Sigifredo Leitón Luna>
-- Fecha Creación: <28/08/2015>
-- Descripcion:	<Crear un nuevo registro de discapacidad.>
-- Modificado:	<Alejandro Villalta, 09-12-2015,Autogenerar el campo codigo de discapacidad.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarDiscapacidad] 
	@Descripcion varchar(100),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2
AS
BEGIN
	INSERT INTO Catalogo.Discapacidad 
	(
		TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
	)
	VALUES
	(
		@Descripcion,	@FechaActivacion	,@FechaVencimiento
	)
END
GO
