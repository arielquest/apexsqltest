SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<30/12/2020>
-- Descripción:			<Permite modificar un registro en la tabla: Catalogo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarCatalogo]
	@CodCatalogo		SMALLINT,
	@Descripcion		VARCHAR(150),
	@Controlador		BIT,
	@DescripcionUrl		VARCHAR(255),
	@CatalogoSiagpj		VARCHAR(150),
	@FinVigencia		DATETIME2(3)	= NULL
AS
BEGIN
	--Variables.
	DECLARE	@L_TN_CodCatalogo		SMALLINT		= @CodCatalogo,
			@L_TB_Controlador		BIT				= @Controlador,
			@L_TC_DescripcionUrl	VARCHAR(255)	= @DescripcionUrl,
			@L_TC_CatalogoSiagpj	VARCHAR(150)	= @CatalogoSiagpj,
			@L_TC_Descripcion		VARCHAR(150)	= @Descripcion,
			@L_TF_Fin_Vigencia		DATETIME2(3)	= @FinVigencia
	--Lógica.
	UPDATE	Catalogo.Catalogo		WITH(ROWLOCK)
	SET		TC_Descripcion			= @L_TC_Descripcion,
			TB_Controlador			= @L_TB_Controlador,
			TC_DescripcionUrl		= @L_TC_DescripcionUrl,
			TC_CatalogoSiagpj		= @L_TC_CatalogoSiagpj,
			TF_Fin_Vigencia			= @L_TF_Fin_Vigencia
	WHERE	TN_CodCatalogo			= @L_TN_CodCatalogo
END
GO
