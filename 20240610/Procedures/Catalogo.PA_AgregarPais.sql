SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================
-- Autor:			<Sigifredo Leitón Luna>
-- Fecha Creación:	<17/08/2015>
-- Descripcion:		<Crear un nuevo país>
-- =============================================================================================================================
-- Modificacion		<Gerardo Lopez R><16/11/2015> <Agregar campo cod area>
-- Modificación		<Aida Elena Siles R> <23/12/2020> <Se agrega campo TB_RequiereRegionalidad>
-- =============================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarPais] 
	@CodPais				VARCHAR(3), 
	@CodArea				VARCHAR(3), 
	@Descripcion			VARCHAR(70),
	@FechaActivacion		DATETIME2,
	@FechaVencimiento		DATETIME2,
	@RequiereRegionalidad	BIT
AS
BEGIN
--VARIABLES
DECLARE 	@L_CodPais				VARCHAR(3)	= @CodPais, 
			@L_CodArea				VARCHAR(3)	= @CodArea, 
			@L_Descripcion			VARCHAR(70) = @Descripcion,
			@L_FechaActivacion		DATETIME2	= @FechaActivacion,
			@L_FechaVencimiento		DATETIME2	= @FechaVencimiento,
			@L_RequiereRegionalidad	BIT			= @RequiereRegionalidad
--LÓGICA
	INSERT INTO Catalogo.Pais WITH(ROWLOCK)
	(
		TC_CodPais,				TC_CodArea,			TC_Descripcion,		TB_RequiereRegionalidad,
		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	VALUES
	(
		@L_CodPais,				@L_CodArea,			@L_Descripcion,		@L_RequiereRegionalidad,
		@L_FechaActivacion,		@L_FechaVencimiento
	)
END
GO
