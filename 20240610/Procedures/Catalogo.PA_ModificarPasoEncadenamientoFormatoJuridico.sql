SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================
-- Versión:				<1.0>	
-- Autor:				<Johan M. Acosta Ibañez.>
-- Fecha Creación:		<04/11/2021>
-- Descripcion:			<Modificar un paso de un encadenamiento de formato jurídico>
-- =========================================================================================================================================
-- Modificación:		<05/05/2022> <Jorge Isaac Dobles Mata> <Se agrega parámetro de código de operación>
-- =========================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ModificarPasoEncadenamientoFormatoJuridico] 
	@CodEncadenamiento			INT,
	@Orden						TINYINT,
	@CodFormatoJuridico			VARCHAR(8)	= NULL,
	@CodOperacionTramite		SMALLINT	= NULL
AS
BEGIN

	--Variables locales
	DECLARE	@L_CodFormatoJuridico		VARCHAR(8)	=	@CodFormatoJuridico,
			@L_CodEncadenamiento		INT			=	@CodEncadenamiento,
	        @L_Orden					TINYINT		=	@Orden,
			@L_CodOperacionTramite		SMALLINT	=	@CodOperacionTramite


	--Aplicación del update
	UPDATE	Catalogo.PasoEncadenamientoFormatoJuridico
	SET		TC_CodFormatoJuridico					=	@L_CodFormatoJuridico,
			TN_CodOperacionTramite					=	@L_CodOperacionTramite,
			TF_Actualizacion						=	GETDATE()
	WHERE	TN_CodEncadenamientoFormatoJuridico		=	@L_CodEncadenamiento
	AND		TN_Orden								=	@L_Orden

END


GO
