SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Autor:			<Sigifredo Leitón Luna>
-- Fecha Creación:  <06/08/2015>
-- Descripcion:		<Crear una nueva clase de asunto>
-- Modificado:		<Alejandro Villalta><17/12/2015><Autogenerar el codigo de clase de asunto>
-- Modificado:		<Roger Lara><11/05/2021><Se elimina el campo Asunto>
-- ==========================================================================================
-- Modificado:		<Jonathan Aguilar Navarro><21/02/2019><Se agrega el parametro Asunto para ser insertado en la tabla>

CREATE PROCEDURE [Catalogo].[PA_AgregarClaseAsunto]	 
	@Descripcion		varchar(200),
	@FechaActivacion	datetime2,
	@FechaVencimiento	datetime2
AS
BEGIN
	INSERT INTO Catalogo.ClaseAsunto
	(
		TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
	) 
	VALUES
	(
		@Descripcion,	@FechaActivacion,	@FechaVencimiento
	)
END


GO
