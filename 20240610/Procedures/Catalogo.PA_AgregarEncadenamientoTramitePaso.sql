SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<16/06/2022>
-- Descripción:			<Permite agregar un registro en la tabla: EncadenamientoTramitePaso.>
-- ==================================================================================================================================================================================
CREATE    PROCEDURE	[Catalogo].[PA_AgregarEncadenamientoTramitePaso]
	@CodEncadenamientoTramitePaso	UNIQUEIDENTIFIER,
	@CodEncadenamientoTramite		UNIQUEIDENTIFIER,
	@CodOperacionTramite			SMALLINT,
	@Orden							TINYINT
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodEncadenamientoTramitePaso	UNIQUEIDENTIFIER		= @CodEncadenamientoTramitePaso,
			@L_TU_CodEncadenamientoTramite		UNIQUEIDENTIFIER		= @CodEncadenamientoTramite,
			@L_TN_CodOperacionTramite			SMALLINT				= @CodOperacionTramite,
			@L_TN_Orden							TINYINT					= @Orden

	--Cuerpo
	INSERT INTO	Catalogo.EncadenamientoTramitePaso	WITH (ROWLOCK)
	(
		TU_CodEncadenamientoTramitePaso,		TU_CodEncadenamientoTramite,		TN_CodOperacionTramite,		TN_Orden
	)
	VALUES
	(
		@L_TU_CodEncadenamientoTramitePaso,		@L_TU_CodEncadenamientoTramite,		@L_TN_CodOperacionTramite,	@L_TN_Orden
	)
END
GO
