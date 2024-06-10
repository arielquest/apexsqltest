SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de creación:	<12/07/2021>
-- Descripción:			<Permite agregar un registro en la tabla: CriterioRepartoManual.>
-- =======================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarCriterioRepartoManual]
	@Descripcion				VARCHAR(120),
	@FechaActivacion			DATETIME2(3),
	@FechaVencimiento			DATETIME2(3) = NULL
AS
BEGIN
	--Variables
	DECLARE	@L_Descripcion			VARCHAR(120)	=	@Descripcion,
			@L_TF_FechaActivacion	DATETIME2(3)	=	@FechaActivacion,
			@L_TF_FechaVencimiento	DATETIME2(3)	=	@FechaVencimiento
	--Cuerpo
	INSERT INTO	Catalogo.CriterioRepartoManual	
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia				
	)
	VALUES
	(
		@L_Descripcion,		@L_TF_FechaActivacion,	@L_TF_FechaVencimiento			
	)
END
GO
