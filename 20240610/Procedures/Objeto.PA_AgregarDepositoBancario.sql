SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<13/01/2020>
-- Descripción:			<Permite agregar un registro en la tabla: DepositoBancario.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_AgregarDepositoBancario]
	@CodObjeto					UNIQUEIDENTIFIER,
	@FechaDeposito				DATETIME,
	@NumeroTransaccion			VARCHAR(30),
	@NumeroCuenta				VARCHAR(22),
	@NumeroFolio				VARCHAR(10),
	@NombreDepositante			VARCHAR(150)

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto				UNIQUEIDENTIFIER		= @CodObjeto,
			@L_TF_FechaDeposito			DATETIME				= @FechaDeposito,
			@L_TC_NumeroTransaccion		VARCHAR(30)				= @NumeroTransaccion,
			@L_TC_NumeroCuenta			VARCHAR(22)				= @NumeroCuenta,
			@L_TC_NumeroFolio			VARCHAR(10)				= @NumeroFolio,
			@L_TC_NombreDepositante		VARCHAR(150)			= @NombreDepositante
	--Cuerpo
	INSERT INTO	Objeto.DepositoBancario	WITH (ROWLOCK)
	(
		TU_CodObjeto,					TF_FechaDeposito,				TC_NumeroTransaccion,			TC_NumeroCuenta,				
		TC_NumeroFolio,					TC_NombreDepositante			
	)
	VALUES
	(
		@L_TU_CodObjeto,				@L_TF_FechaDeposito,			@L_TC_NumeroTransaccion,			@L_TC_NumeroCuenta,				
		@L_TC_NumeroFolio,				@L_TC_NombreDepositante			
	)
END
GO
