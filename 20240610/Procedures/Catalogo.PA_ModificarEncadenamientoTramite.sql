SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================
-- Autor:				<Jefferson Parker Cortes>
-- Fecha Creación:		<22/06/2016>
-- Descripcion:			<Modificar Encadenamiento tramite>
-- =========================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarEncadenamientoTramite] 
    @CodEncadenamientoTramite			uniqueidentifier,
	@Nombre								Varchar(255),
	@Descripcion						Varchar(150),
	@Inicio_Vigencia					datetime2(7),
	@Fin_Vigencia						datetime2(7),
	@Actualizacion						datetime2(7)
	
AS
BEGIN
	
	--Variables locales
	DECLARE @L_CodEncadenamientoTramite		uniqueidentifier	= @CodEncadenamientoTramite,
			@L_Nombre						Varchar(255)		= @Nombre,
			@L_Descripcion					Varchar(150)		= @Descripcion,
			@L_Inicio_Vigencia				datetime2(7)		= @Inicio_Vigencia,
			@L_Fin_Vigencia 				datetime2(7)		= @Fin_Vigencia,
			@L_Actualizacion				datetime2(7)		= @Actualizacion

    --Aplicación de modificación
	UPDATE Catalogo.EncadenamientoTramite
	SET 
		TC_Nombre					=	@L_Nombre,
		TC_Descripcion				=	@L_Descripcion,
		TF_Inicio_Vigencia			=	@L_Inicio_Vigencia,
		TF_Fin_Vigencia				=	@L_Fin_Vigencia,
		TF_Actualizacion			=   @L_Actualizacion
		
	WHERE TU_CodEncadenamientoTramite	=	@L_CodEncadenamientoTramite

END
GO
