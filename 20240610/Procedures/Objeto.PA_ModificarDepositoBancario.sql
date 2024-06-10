SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<16/01/2020>
-- Descripción:			<Permite actualizar un registro en la tabla: DepositoBancario.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ModificarDepositoBancario]
	@CodObjeto					UNIQUEIDENTIFIER,
	@NumeroTransaccion			VARCHAR(30),
	@NumeroCuenta				VARCHAR(22),
	@NumeroFolio				VARCHAR(10),
	@NombreDepositante			VARCHAR(150)
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto				UNIQUEIDENTIFIER	= @CodObjeto,
			@L_TC_NumeroTransaccion		VARCHAR(30)			= @NumeroTransaccion,
			@L_TC_NumeroCuenta			VARCHAR(22)			= @NumeroCuenta,
			@L_TC_NumeroFolio			VARCHAR(10)			= @NumeroFolio,
			@L_TC_NombreDepositante		VARCHAR(150)		= @NombreDepositante
	--Lógica
	UPDATE	Objeto.DepositoBancario	WITH (ROWLOCK)
	SET		TC_NumeroTransaccion		= @L_TC_NumeroTransaccion,
			TC_NumeroCuenta				= @L_TC_NumeroCuenta,
			TC_NumeroFolio				= @L_TC_NumeroFolio,
			TC_NombreDepositante		= @L_TC_NombreDepositante
	WHERE	TU_CodObjeto				= @L_TU_CodObjeto
END
GO
