SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<30/12/2020>
-- Descripción:			<Permite agregar un registro en la tabla: Catalogo.>
--
-- Modificacion: [26/01/2021] Miguel Avendaño : Se mueve a esquema configuracion y se agrega enlace con catalodo de sistemas
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Configuracion].[PA_AgregarCatalogo]
	@Sistema			smallint,
	@Descripcion		VARCHAR(150),
	@Controlador		BIT,
	@DescripcionUrl		VARCHAR(255),
	@CatalogoSiagpj		VARCHAR(256)
AS
BEGIN
	--Variables.
	DECLARE @L_TN_CodSistema		smallint		= @Sistema,
			@L_TC_Descripcion		VARCHAR(150)	= @Descripcion,
			@L_TB_Controlador		BIT				= @Controlador,
			@L_TC_DescripcionUrl	VARCHAR(255)	= @DescripcionUrl,
			@L_TC_CatalogoSiagpj	VARCHAR(150)	= @CatalogoSiagpj
	--Lógica.
	INSERT INTO	[Configuracion].[Catalogo] WITH(ROWLOCK)
	(
		TN_CodSistema,			TC_Descripcion,			TB_Controlador,		TC_DescripcionUrl,
		TC_CatalogoSiagpj
	)
	VALUES
	(
		@L_TN_CodSistema,		@L_TC_Descripcion,		@L_TB_Controlador,	@L_TC_DescripcionUrl,
		@L_TC_CatalogoSiagpj
	)
END

GO
