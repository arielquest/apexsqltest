SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<07/01/2020>
-- Descripción:			<Permite actualizar un registro en la tabla: BienInmueble.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ModificarBienInmueble]
	@CodObjeto					UNIQUEIDENTIFIER,
	@NumeroFinca				VARCHAR(10),
	@CodProvincia				SMALLINT,
	@CodCanton					SMALLINT,
	@CodTipoMedida				SMALLINT
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto			UNIQUEIDENTIFIER	= @CodObjeto,
			@L_TC_NumeroFinca		VARCHAR(10)			= @NumeroFinca,
			@L_TN_CodProvincia		SMALLINT			= @CodProvincia,
			@L_TN_CodCanton			SMALLINT			= @CodCanton,
			@L_TN_CodTipoMedida		SMALLINT			= @CodTipoMedida
	--Lógica
	UPDATE	Objeto.BienInmueble	WITH (ROWLOCK)
	SET		TC_NumeroFinca			= @L_TC_NumeroFinca,
			TN_CodProvincia			= @L_TN_CodProvincia,
			TN_CodCanton			= @L_TN_CodCanton,
			TN_CodTipoMedida		= @L_TN_CodTipoMedida
	WHERE	TU_CodObjeto			= @L_TU_CodObjeto
END
GO
