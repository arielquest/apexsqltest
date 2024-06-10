SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<04/04/2022>
-- Descripción:				<Modifica un registro de operacíón de trámite>
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_ModificarOperacionTramite]	
	@CodOperacionTramite	SMALLINT,
	@Nombre					VARCHAR(100),
	@Descripcion			VARCHAR(255),
	@FechaActivacion		DATETIME2(7),
	@FechaVencimiento		DATETIME2(7),
	@Pantalla				TINYINT
AS  
BEGIN  
	
	--Variables locales
	DECLARE @L_CodOperacionTramite		SMALLINT		= @CodOperacionTramite,
			@L_Nombre					VARCHAR(100)	= @Nombre,
			@L_Descripcion				VARCHAR(255)	= @Descripcion,
			@L_FechaActivacion			DateTime2(7)	= @FechaActivacion,
			@L_FechaVencimiento			DateTime2(7)	= @FechaVencimiento,
	        @L_Pantalla					TinyInt			= @Pantalla

	--Aplicación de actualización
	UPDATE	[Catalogo].[OperacionTramite]
	SET		[TC_Nombre]								=	@L_Nombre,
			[TC_Descripcion]						=	@L_Descripcion,
			[TF_Inicio_Vigencia]					=	@L_FechaActivacion,
			[TF_Fin_Vigencia]						=	@L_FechaVencimiento,
			[TN_Pantalla]							=	@L_Pantalla
	WHERE	[TN_CodOperacionTramite]				=	@L_CodOperacionTramite
End
GO
