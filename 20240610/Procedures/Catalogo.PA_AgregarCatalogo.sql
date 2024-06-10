SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<30/12/2020>
-- Descripción:			<Permite agregar un registro en la tabla: Catalogo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarCatalogo]
	@Descripcion		VARCHAR(150),
	@Controlador		BIT,
	@DescripcionUrl		VARCHAR(255),
	@CatalogoSiagpj		VARCHAR(150),
	@InicioVigencia		DATETIME2(3),
	@FinVigencia		DATETIME2(3)	= NULL
AS
BEGIN
	--Variables.
DECLARE @L_TC_Descripcion		VARCHAR(150)	= @Descripcion,
		@L_TB_Controlador		BIT				= @Controlador,
		@L_TC_DescripcionUrl	VARCHAR(255)	= @DescripcionUrl,
		@L_TC_CatalogoSiagpj	VARCHAR(150)	= @CatalogoSiagpj,
		@L_TF_Inicio_Vigencia	DATETIME2(3)	= @InicioVigencia,
		@L_TF_Fin_Vigencia		DATETIME2(3)	= @FinVigencia
	--Lógica.
	INSERT INTO	Catalogo.Catalogo WITH(ROWLOCK)
	(
		TC_Descripcion,			TB_Controlador,		TC_DescripcionUrl,		TC_CatalogoSiagpj,
		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	VALUES
	(
		@L_TC_Descripcion,		@L_TB_Controlador,	@L_TC_DescripcionUrl,	@L_TC_CatalogoSiagpj,
		@L_TF_Inicio_Vigencia,	@L_TF_Fin_Vigencia
	)
END
GO
