SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<17/05/2021>
-- Descripción:			<Permite agregar un registro en la tabla: ArchivoComunicacionRegistroAutomatico.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Comunicacion].[PA_AgregarArchivoComunicacionRegistroAutomatico]
	@CodArchivoComunicacionAut		UNIQUEIDENTIFIER,
	@CodComunicacionAut				UNIQUEIDENTIFIER,
	@CodArchivo						UNIQUEIDENTIFIER	= NULL,
	@EsPrincipal					BIT
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodArchivoComunicacionAut		UNIQUEIDENTIFIER		= @CodArchivoComunicacionAut,
			@L_TU_CodComunicacionAut			UNIQUEIDENTIFIER		= @CodComunicacionAut,
			@L_TU_CodArchivo					UNIQUEIDENTIFIER		= @CodArchivo,
			@L_TB_EsPrincipal					BIT						= @EsPrincipal
			
	--Cuerpo
	INSERT INTO	Comunicacion.ArchivoComunicacionRegistroAutomatico	WITH (ROWLOCK)
	(
		TU_CodArchivoComunicacionAut,			TU_CodComunicacionAut,			TU_CodArchivo,			TB_EsPrincipal		
	)
	VALUES
	(
		@L_TU_CodArchivoComunicacionAut,		@L_TU_CodComunicacionAut,		@L_TU_CodArchivo,		@L_TB_EsPrincipal
	)
END
GO
