SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<06/03/2020>
-- Descripción:			<Permite agregar un registro en la tabla: SolicitudTransferencia.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_AgregarSolicitudTransferencia]
	@Codigo								UNIQUEIDENTIFIER,
	@CodObjeto							UNIQUEIDENTIFIER,
	@UsuarioRedRealizaSolicitud			VARCHAR(30),
	@CodOficina_Destino					VARCHAR(4),
	@CodOficina_Genera_Solicitud		VARCHAR(4),
	@Fecha								DATETIME2(7),
	@Observaciones						VARCHAR(250),
	@Estado								CHAR(1)

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodSolicitudTransferencia			UNIQUEIDENTIFIER		= @Codigo,
			@L_TU_CodObjeto							UNIQUEIDENTIFIER		= @CodObjeto,
			@L_TC_UsuarioRedRealizaSolicitud		VARCHAR(30)				= @UsuarioRedRealizaSolicitud,
			@L_TC_CodOficina_Destino				VARCHAR(4)				= @CodOficina_Destino,
			@L_TC_CodOficina_Genera_Solicitud		VARCHAR(4)				= @CodOficina_Genera_Solicitud,
			@L_TF_Fecha								DATETIME2(7)			= @Fecha,
			@L_TC_Observaciones						VARCHAR(250)			= @Observaciones,
			@L_TC_Estado							CHAR(1)					= @Estado
	--Cuerpo
	INSERT INTO	Objeto.SolicitudTransferencia	WITH (ROWLOCK)
	(
		TU_CodSolicitudTransferencia,			TU_CodObjeto,					TC_UsuarioRedRealizaSolicitud,				TC_CodOficina_Destino,			
		TC_CodOficina_Genera_Solicitud,			TF_Fecha,						TC_Observaciones,							TC_Estado
	)
	VALUES
	(
		@L_TU_CodSolicitudTransferencia,			@L_TU_CodObjeto,				@L_TC_UsuarioRedRealizaSolicitud,		@L_TC_CodOficina_Destino,			
		@L_TC_CodOficina_Genera_Solicitud,			@L_TF_Fecha,					@L_TC_Observaciones,					@L_TC_Estado
	)
END
GO
