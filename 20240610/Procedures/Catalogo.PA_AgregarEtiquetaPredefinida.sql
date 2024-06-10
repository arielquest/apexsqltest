SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<04/12/2019>
-- Descripción:			<Permite agregar un registro en la tabla: EtiquetaPredefinida.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarEtiquetaPredefinida]
	@Descripcion		VARCHAR(150),
	@InicioVigencia		DATETIME2(3),
	@FinVigencia		DATETIME2(3)	= NULL
AS
BEGIN
	--Variables.
DECLARE @L_TC_Descripcion		VARCHAR(150)	= @Descripcion,
		@L_TF_Inicio_Vigencia	DATETIME2(3)	= @InicioVigencia,
		@L_TF_Fin_Vigencia		DATETIME2(3)	= @FinVigencia
	--Lógica.
	INSERT INTO	Catalogo.EtiquetaPredefinida WITH(ROWLOCK)
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	VALUES
	(
		@L_TC_Descripcion,	@L_TF_Inicio_Vigencia,	@L_TF_Fin_Vigencia
	)
END
GO
