SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<30/01/2020>
-- Descripción:			<Permite agregar un registro en la tabla: EtiquetaAudiencia.>
-- ==================================================================================================================================================================================
-- Modificación:		<05/10/2020> <Ronny Ramírez R.> <Se agregan campos requeridos de tiempo y nombre de archivo a la etiqueta de la audiencia>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_AgregarEtiquetaAudiencia]
	@CodEtiqueta				UNIQUEIDENTIFIER,
	@TiempoMilisegundos			BIGINT,
	@Etiqueta					VARCHAR(255),
	@TipoEtiqueta				BIT,
	@CodAudiencia				BIGINT,
	@TiempoArchivo				VARCHAR(11),
	@NombreArchivo				VARCHAR(255)
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodEtiqueta			UNIQUEIDENTIFIER	= @CodEtiqueta,
			@L_TN_TiempoMilisegundos	BIGINT				= @TiempoMilisegundos,
			@L_TC_Etiqueta				VARCHAR(255)		= @Etiqueta,
			@L_TB_TipoEtiqueta			BIT					= @TipoEtiqueta,
			@L_TN_CodAudiencia			BIGINT				= @CodAudiencia,
			@L_TC_TiempoArchivo			VARCHAR(11)			= @TiempoArchivo,
			@L_TC_NombreArchivo			VARCHAR(255)		= @NombreArchivo
	--Cuerpo
	INSERT INTO	Expediente.EtiquetaAudiencia	WITH (ROWLOCK)
	(
		TU_CodEtiqueta,					TN_TiempoMilisegundos,			TC_Etiqueta,					TB_TipoEtiqueta,				
		TN_CodAudiencia,				TC_TiempoArchivo,				TC_NombreArchivo
	)
	VALUES
	(
		@L_TU_CodEtiqueta,				@L_TN_TiempoMilisegundos,			@L_TC_Etiqueta,					@L_TB_TipoEtiqueta,				
		@L_TN_CodAudiencia,				@L_TC_TiempoArchivo,				@L_TC_NombreArchivo
	)
END
GO
