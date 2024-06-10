SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<10/01/2020>
-- Descripción:			<Permite actualizar un registro en la tabla: Arma.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ModificarArma]
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
	--Lógica
	UPDATE	Objeto.Arma	WITH (ROWLOCK)
	SET		 TN_CodTipoArma				= @L_TN_CodTipoArma,
			TC_Calibre					= @L_TC_Calibre,
			TC_Dif						= @L_TC_Dif
	WHERE	TU_CodObjeto				= @L_TU_CodObjeto
END
GO
