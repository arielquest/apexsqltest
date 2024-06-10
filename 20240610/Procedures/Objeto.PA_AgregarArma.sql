SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<08/01/2020>
-- Descripción:			<Permite agregar un registro en la tabla: Arma.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_AgregarArma]
	@CodObjeto					UNIQUEIDENTIFIER,
	@CodTipoArma				SMALLINT,
	@Calibre					VARCHAR(10),
	@Dif						VARCHAR(100)	= NULL

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto			UNIQUEIDENTIFIER		= @CodObjeto,
			@L_TN_CodTipoArma		SMALLINT				= @CodTipoArma,
			@L_TC_Calibre			VARCHAR(10)				= @Calibre,
			@L_TC_Dif				VARCHAR(100)			= @Dif
	--Cuerpo
	INSERT INTO	Objeto.Arma	WITH (ROWLOCK)
	(
		TU_CodObjeto,					TN_CodTipoArma,					TC_Calibre,						TC_Dif							
	)
	VALUES
	(
		@L_TU_CodObjeto,				@L_TN_CodTipoArma,				@L_TC_Calibre,					@L_TC_Dif						
	)
END
GO
