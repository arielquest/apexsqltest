SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================
-- Autor:			<Sigifredo Leitón Luna>
-- Fecha Creación:	<17/08/2015>
-- Descripcion:		<Modificar datos de un país>
-- =============================================================================================================================
-- Modificacion		<Gerardo Lopez R> <16/11/2015> <Agregar campo cod area>
-- Modificación		<Aida Elena Siles R> <23/12/2020> <Se agrega campo TB_RequiereRegionalidad>
-- =============================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarPais] 
	@CodPais				VARCHAR(3), 
	@CodArea				VARCHAR(3), 
	@Descripcion			VARCHAR(70),
	@FechaVencimiento		DATETIME2,
	@RequiereRegionalidad	BIT
AS
BEGIN
--VARIABLES
DECLARE 	@L_CodPais				VARCHAR(3)	= @CodPais, 
			@L_CodArea				VARCHAR(3)	= @CodArea, 
			@L_Descripcion			VARCHAR(70) = @Descripcion,
			@L_FechaVencimiento		DATETIME2	= @FechaVencimiento,
			@L_RequiereRegionalidad	BIT			= @RequiereRegionalidad
--LÓGICA
	UPDATE	Catalogo.Pais			WITH(ROWLOCK)
	SET		TC_Descripcion			=	@L_Descripcion,
	        TC_CodArea				=   @L_CodArea,
			TF_Fin_Vigencia			=	@L_FechaVencimiento,
			TB_RequiereRegionalidad =	@L_RequiereRegionalidad
	WHERE	TC_CodPais				=	@L_CodPais
END
GO
