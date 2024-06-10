SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<11/05/2021>
-- Descripción:			<Permite agregar un registro en la tabla: FormatoJuriComunicacionContexto.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Catalogo].[PA_AgregarFormatoJuriComunicacionContexto]
	@CodFormatoJuridico		VARCHAR(8),
	@CodContexto			VARCHAR(4),
	@Inicio_Vigencia		DATETIME2(7)

AS
BEGIN
	--Variables
	DECLARE	@L_TC_CodFormatoJuridico		VARCHAR(8)			= @CodFormatoJuridico,
			@L_TC_CodContexto				VARCHAR(4)			= @CodContexto,
			@L_TF_Inicio_Vigencia			DATETIME2(7)		= @Inicio_Vigencia

	--Cuerpo
	INSERT INTO	Catalogo.FormatoJuriComunicacionContexto	WITH (ROWLOCK)
	(
		TC_CodFormatoJuridico,			TC_CodContexto,			TF_Inicio_Vigencia			
	)
	VALUES
	(
		@L_TC_CodFormatoJuridico,		@L_TC_CodContexto,		@L_TF_Inicio_Vigencia			
	)
END
GO
