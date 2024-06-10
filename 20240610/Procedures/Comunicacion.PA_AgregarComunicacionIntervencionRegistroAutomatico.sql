SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<17/05/2021>
-- Descripción:			<Permite agregar un registro en la tabla: ComunicacionIntervencionRegistroAutomatico.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Comunicacion].[PA_AgregarComunicacionIntervencionRegistroAutomatico]
	@CodComunicacionAut			UNIQUEIDENTIFIER,
	@CodInterviniente			UNIQUEIDENTIFIER,
	@EsPrincipal				BIT	

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodComunicacionAut		UNIQUEIDENTIFIER		= @CodComunicacionAut,
			@L_TU_CodInterviniente			UNIQUEIDENTIFIER		= @CodInterviniente,
			@L_TB_EsPrincipal				BIT						= @EsPrincipal
			
	--Cuerpo
	INSERT INTO	Comunicacion.ComunicacionIntervencionRegistroAutomatico	WITH (ROWLOCK)
	(
		TU_CodComunicacionAut,			TU_CodInterviniente,			TB_EsPrincipal					
	)
	VALUES
	(
		@L_TU_CodComunicacionAut,		@L_TU_CodInterviniente,			@L_TB_EsPrincipal
	)
END
GO
