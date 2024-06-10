SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<07/04/2022>
-- Descripción:			<Permite agregar un registro en la tabla: OperacionTramiteParametro.>
-- ==================================================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_AgregarOperacionTramiteParametro]
	@CodOperacionTramite			SMALLINT,
	@Nombre							VARCHAR(255),
	@NombreEstructura				VARCHAR(255),
	@CampoIdentificador				VARCHAR(100),
	@CampoMostrar					VARCHAR(100),
	@Inicio_Vigencia				DATETIME2(7),
	@Fin_Vigencia					DATETIME2(7)	= NULL

AS
BEGIN
	--Variables
	DECLARE	@L_TN_CodOperacionTramite			SMALLINT			= @CodOperacionTramite,
			@L_TC_Nombre						VARCHAR(255)		= @Nombre,
			@L_TC_NombreEstructura				VARCHAR(255)		= @NombreEstructura,
			@L_TC_CampoIdentificador			VARCHAR(100)		= @CampoIdentificador,
			@L_TC_CampoMostrar					VARCHAR(100)		= @CampoMostrar,
			@L_TF_Inicio_Vigencia				DATETIME2(7)		= @Inicio_Vigencia,
			@L_TF_Fin_Vigencia					DATETIME2(7)		= @Fin_Vigencia

	--Cuerpo
	INSERT INTO	Catalogo.OperacionTramiteParametro	WITH (ROWLOCK)
	(
		TN_CodOperacionTramite,		TC_Nombre,				TC_NombreEstructura,			TC_CampoIdentificador,				
		TC_CampoMostrar,			TF_Inicio_Vigencia,		TF_Fin_Vigencia			
	)
	VALUES
	(
		@L_TN_CodOperacionTramite,	@L_TC_Nombre,			@L_TC_NombreEstructura,			@L_TC_CampoIdentificador,			
		@L_TC_CampoMostrar,			@L_TF_Inicio_Vigencia,	@L_TF_Fin_Vigencia			
	)
END
GO
