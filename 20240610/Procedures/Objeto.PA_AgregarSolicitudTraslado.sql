SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<04/03/2020>
-- Descripción:			<Permite agregar un registro en la tabla: SolicitudTraslado.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_AgregarSolicitudTraslado]
	@Codigo								UNIQUEIDENTIFIER,
	@CodObjeto							UNIQUEIDENTIFIER,
	@UsuarioRedRealizaSolicitud			VARCHAR(30),
	@CodOficina_Destino					VARCHAR(4),
	@CodOficina_Genera_Solicitud		VARCHAR(4),
	@NombreCompletoRealizaTraslado		VARCHAR(150),
	@Fecha								DATETIME2(7),
	@Observaciones						VARCHAR(250)
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodSolicitudTraslado				UNIQUEIDENTIFIER		= @Codigo,
			@L_TU_CodObjeto							UNIQUEIDENTIFIER		= @CodObjeto,
			@L_TC_UsuarioRedRealizaSolicitud		VARCHAR(30)				= @UsuarioRedRealizaSolicitud,
			@L_TC_CodOficina_Destino				VARCHAR(4)				= @CodOficina_Destino,
			@L_TC_CodOficina_Genera_Solicitud		VARCHAR(4)				= @CodOficina_Genera_Solicitud,
			@L_TC_NombreCompletoRealizaTraslado		VARCHAR(150)			= @NombreCompletoRealizaTraslado,
			@L_TF_Fecha								DATETIME2(7)			= @Fecha,
			@L_TC_Observaciones						VARCHAR(250)			= @Observaciones
	--Cuerpo
	INSERT INTO	Objeto.SolicitudTraslado	WITH (ROWLOCK)
	(
		TU_CodSolicitudTraslado,				TU_CodObjeto,								TC_UsuarioRedRealizaSolicitud,			TC_CodOficina_Destino,			
		TC_CodOficina_Genera_Solicitud,			TC_NombreCompletoRealizaTraslado,			TF_Fecha,								TC_Observaciones
	)
	VALUES
	(
		@L_TU_CodSolicitudTraslado,				@L_TU_CodObjeto,							@L_TC_UsuarioRedRealizaSolicitud,		@L_TC_CodOficina_Destino,			
		@L_TC_CodOficina_Genera_Solicitud,		@L_TC_NombreCompletoRealizaTraslado,		@L_TF_Fecha,							@L_TC_Observaciones
	)
END
GO
