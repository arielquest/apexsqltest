SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<19/12/2019>
-- Descripción:			<Permite agregar un registro en la tabla: BienInmueble.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_AgregarBienInmueble]
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
	--Cuerpo
	INSERT INTO	Objeto.BienInmueble	WITH (ROWLOCK)
	(
		TU_CodObjeto,					TC_NumeroFinca,					TN_CodProvincia,				TN_CodCanton,					
		TN_CodTipoMedida				
	)
	VALUES
	(
		@L_TU_CodObjeto,				@L_TC_NumeroFinca,				@L_TN_CodProvincia,				@L_TN_CodCanton,				
		@L_TN_CodTipoMedida				
	)
END
GO
