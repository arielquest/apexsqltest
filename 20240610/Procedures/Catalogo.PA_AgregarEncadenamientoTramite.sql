SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<16/06/2022>
-- Descripción:			<Permite agregar un registro en la tabla: EncadenamientoTramite.>
-- ==================================================================================================================================================================================
CREATE    PROCEDURE	[Catalogo].[PA_AgregarEncadenamientoTramite]
	@CodEncadenamientoTramite		UNIQUEIDENTIFIER,
	@CodGrupoEncadenamientoTramite	UNIQUEIDENTIFIER,
	@Nombre							VARCHAR(255),
	@Descripcion					VARCHAR(150),
	@Inicio_Vigencia				DATETIME2(7),
	@Fin_Vigencia					DATETIME2(7)	= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodEncadenamientoTramite			UNIQUEIDENTIFIER	= @CodEncadenamientoTramite,
			@L_TU_CodGrupoEncadenamientoTramite		UNIQUEIDENTIFIER	= @CodGrupoEncadenamientoTramite,
			@L_TC_Nombre							VARCHAR(255)		= @Nombre,
			@L_TC_Descripcion						VARCHAR(150)		= @Descripcion,
			@L_TF_Inicio_Vigencia					DATETIME2(7)		= @Inicio_Vigencia,
			@L_TF_Fin_Vigencia						DATETIME2(7)		= @Fin_Vigencia

	--Cuerpo
	INSERT INTO	Catalogo.EncadenamientoTramite	WITH (ROWLOCK)
	(
		TU_CodEncadenamientoTramite,	TU_CodGrupoEncadenamientoTramite,		TC_Nombre,		TC_Descripcion,					
		TF_Inicio_Vigencia,				TF_Fin_Vigencia			
	)
	VALUES
	(
		@L_TU_CodEncadenamientoTramite,	@L_TU_CodGrupoEncadenamientoTramite,	@L_TC_Nombre,	@L_TC_Descripcion,				
		@L_TF_Inicio_Vigencia,			@L_TF_Fin_Vigencia		
	)
END
GO
