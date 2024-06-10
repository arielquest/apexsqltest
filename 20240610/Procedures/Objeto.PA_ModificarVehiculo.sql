SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<18/12/2019>
-- Descripción:			<Permite actualizar un registro en la tabla: Vehiculo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ModificarVehiculo]
	@CodObjeto					UNIQUEIDENTIFIER,
	@CodTipoVehiculo			SMALLINT,
	@CodTipoPlaca				SMALLINT,
	@Placa						VARCHAR(20),
	@CodEstiloVehiculo			SMALLINT,
	@CodMarcaVehiculo			SMALLINT,
	@Cilindraje					VARCHAR(100),
	@Anno						VARCHAR(4),
	@Cubicaje					VARCHAR(50)		= Null,
	@NumeroMotor				VARCHAR(100),
	@NumeroChasis				VARCHAR(100),
	@NumeroVin					VARCHAR(100)
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto				UNIQUEIDENTIFIER		= @CodObjeto,
			@L_TN_CodTipoVehiculo		SMALLINT				= @CodTipoVehiculo,
			@L_TN_CodTipoPlaca			SMALLINT				= @CodTipoPlaca,
			@L_TC_Placa					VARCHAR(20)				= @Placa,
			@L_TN_CodEstiloVehiculo		SMALLINT				= @CodEstiloVehiculo,
			@L_TN_CodMarcaVehiculo		SMALLINT				= @CodMarcaVehiculo,
			@L_TC_Cilindraje			VARCHAR(100)			= @Cilindraje,
			@L_TC_Anno					VARCHAR(4)				= @Anno,
			@L_TC_Cubicaje				VARCHAR(50)				= @Cubicaje,
			@L_TC_NumeroMotor			VARCHAR(100)			= @NumeroMotor,
			@L_TC_NumeroChasis			VARCHAR(100)			= @NumeroChasis,
			@L_TC_NumeroVin				VARCHAR(100)			= @NumeroVin
	--Lógica
	UPDATE	Objeto.Vehiculo	WITH (ROWLOCK)
	SET		TN_CodTipoVehiculo			= @L_TN_CodTipoVehiculo,
			TN_CodTipoPlaca				= @L_TN_CodTipoPlaca,
			TC_Placa					= @L_TC_Placa,
			TN_CodEstiloVehiculo		= @L_TN_CodEstiloVehiculo,
			TN_CodMarcaVehiculo			= @L_TN_CodMarcaVehiculo,
			TC_Cilindraje				= @L_TC_Cilindraje,
			TC_Anno						= @L_TC_Anno,
			TC_Cubicaje					= @L_TC_Cubicaje,
			TC_NumeroMotor				= @L_TC_NumeroMotor,
			TC_NumeroChasis				= @L_TC_NumeroChasis,
			TC_NumeroVin				= @L_TC_NumeroVin
	WHERE	TU_CodObjeto				= @L_TU_CodObjeto
END
GO
