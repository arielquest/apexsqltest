SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jeffry Hernández>
-- Fecha de creación:	<03/05/2018>
-- Descripción:			<Permite agregar un registro a la tabla Configuracion.ConfiguracionValor>
-- ======================================================================================================
-- Modificación:        <Tatiana Flores><17/08/2018> Se cambia el código de la oficina por código de contexto 
-- Modificación:		<26/04/2021> <Aida Elena Siles R> <Se aumenta el tamaño del parámetro valor y se agrega variables locales>
-- ======================================================================================================
CREATE PROCEDURE [Configuracion].[PA_AgregarConfiguracionValor]
	@Codigo					UNIQUEIDENTIFIER,
	@CodConfiguracion		VARCHAR(27),
	@CodContexto			VARCHAR(4),
	@FechaCreacion			DATETIME2,
	@FechaActivacion		DATETIME2,
	@FechaCaducidad			DATETIME2,
	@Valor					VARCHAR(255)
AS
BEGIN
	--Variables
	DECLARE	@L_TU_Codigo				UNIQUEIDENTIFIER	= @Codigo,
			@L_TC_CodConfiguracion		VARCHAR(27)			= @CodConfiguracion,
			@L_TC_CodContexto			VARCHAR(4)			= @CodContexto,
			@L_TF_FechaCreacion			DATETIME2			= @FechaCreacion,
			@L_TF_FechaActivacion		DATETIME2			= @FechaActivacion,
			@L_TF_FechaCaducidad		DATETIME2			= @FechaCaducidad,
			@L_TC_Valor					VARCHAR(255)		= @Valor

	INSERT INTO Configuracion.ConfiguracionValor WITH (ROWLOCK)
	(
		TU_Codigo,					TC_CodConfiguracion,		TC_CodContexto,		TF_FechaCreacion,
		TF_FechaActivacion,			TF_FechaCaducidad,			TC_Valor
	)
	VALUES
	(
		@L_TU_Codigo,				@L_TC_CodConfiguracion,		@L_TC_CodContexto,	@L_TF_FechaCreacion,
		@L_TF_FechaActivacion,		@L_TF_FechaCaducidad,		@L_TC_Valor
	) 
END
GO
