SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<26/02/2020>
-- Descripción:			<Permite agregar un registro en la tabla: OficinaBodega.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Catalogo].[PA_AgregarOficinaBodega]
	@CodOficina			VARCHAR(4),
	@CodBodega			SMALLINT,
	@Inicio_Vigencia	DATETIME2(7)

AS
BEGIN
	--Variables
	DECLARE	@L_TC_CodOficina			VARCHAR(4)			= @CodOficina,
			@L_TN_CodBodega				SMALLINT			= @CodBodega,
			@L_TF_Inicio_Vigencia		DATETIME2(7)		= @Inicio_Vigencia
	--Cuerpo
	INSERT INTO	Catalogo.OficinaBodega	WITH (ROWLOCK)
	(
		TC_CodOficina,				TN_CodBodega,				TF_Inicio_Vigencia			
	)
	VALUES
	(
		@L_TC_CodOficina,			@L_TN_CodBodega,			@L_TF_Inicio_Vigencia			
	)
END
GO
