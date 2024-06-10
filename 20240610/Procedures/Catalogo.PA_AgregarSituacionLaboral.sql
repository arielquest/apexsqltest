SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:				<Sigifredo Leitón Luna>
-- Fecha Creación:		<17/08/2015>
-- Descripcion:			<Crear una nueva situacion laboral>
-- Modificado por:		<Alejandro Villalta>
-- Fecha de creación:	<10/12/2015>
-- Descripción :		<Autogenerar el codigo del catalogo situación laboral.> 
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarSituacionLaboral] 
	@Descripcion varchar(100),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2
AS
BEGIN
	INSERT INTO Catalogo.SituacionLaboral 
	(
		TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
	)
	VALUES
	(
		@Descripcion,	@FechaActivacion	,@FechaVencimiento
	)
END
GO
