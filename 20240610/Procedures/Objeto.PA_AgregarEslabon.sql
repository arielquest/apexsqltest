SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<21/01/2020>
-- Descripción:			<Permite agregar un registro en la tabla: Eslabon.>
-- ==================================================================================================================================================================================
-- Modificación:		<28/01/2020> <Ronny Ramírez R.> <Se agregan valores NULL por defecto a campos no requeridos>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_AgregarEslabon]
	@Codigo								UNIQUEIDENTIFIER,
	@CodObjeto							UNIQUEIDENTIFIER,
	@CodOficina_Entrega					VARCHAR(4)	= NULL,
	@CodTipoIdentificacionEntrega		SMALLINT,
	@IdentificacionEntrega				VARCHAR(21),
	@NombreCompletoEntrega				VARCHAR(150),
	@UsuarioRedEntrega					VARCHAR(30)	= NULL,
	@CodOficina_Recibe					VARCHAR(4),
	@CodTipoIdentificacionRecibe		SMALLINT,
	@IdentificacionRecibe				VARCHAR(21),
	@NombreCompletoRecibe				VARCHAR(150),
	@UsuarioRedRecibe					VARCHAR(30),
	@Tomo								VARCHAR(10)	= NULL,
	@Folio								VARCHAR(10)	= NULL,
	@Fecha								DATETIME2(7),
	@Observaciones						VARCHAR(250) = NULL

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodEslabon						UNIQUEIDENTIFIER		= @Codigo,
			@L_TU_CodObjeto							UNIQUEIDENTIFIER		= @CodObjeto,
			@L_TC_CodOficina_Entrega				VARCHAR(4)				= @CodOficina_Entrega,
			@L_TN_CodTipoIdentificacionEntrega		SMALLINT				= @CodTipoIdentificacionEntrega,
			@L_TC_IdentificacionEntrega				VARCHAR(21)				= @IdentificacionEntrega,
			@L_TC_NombreCompletoEntrega				VARCHAR(150)			= @NombreCompletoEntrega,
			@L_TC_UsuarioRedEntrega					VARCHAR(30)				= @UsuarioRedEntrega,
			@L_TC_CodOficina_Recibe					VARCHAR(4)				= @CodOficina_Recibe,
			@L_TN_CodTipoIdentificacionRecibe		SMALLINT				= @CodTipoIdentificacionRecibe,
			@L_TC_IdentificacionRecibe				VARCHAR(21)				= @IdentificacionRecibe,
			@L_TC_NombreCompletoRecibe				VARCHAR(150)			= @NombreCompletoRecibe,
			@L_TC_UsuarioRedRecibe					VARCHAR(30)				= @UsuarioRedRecibe,
			@L_TC_Tomo								VARCHAR(10)				= @Tomo,
			@L_TC_Folio								VARCHAR(10)				= @Folio,
			@L_TF_Fecha								DATETIME2(7)			= @Fecha,
			@L_TC_Observaciones						VARCHAR(250)			= @Observaciones
	--Cuerpo
	INSERT INTO	Objeto.Eslabon	WITH (ROWLOCK)
	(
		TU_CodEslabon,							TU_CodObjeto,						TC_CodOficina_Entrega,				TN_CodTipoIdentificacionEntrega,			
		TC_IdentificacionEntrega,				TC_NombreCompletoEntrega,			TC_UsuarioRedEntrega,				TC_CodOficina_Recibe,			
		TN_CodTipoIdentificacionRecibe,			TC_IdentificacionRecibe,			TC_NombreCompletoRecibe,			TC_UsuarioRedRecibe,			
		TC_Tomo,								TC_Folio,							TF_Fecha,							TC_Observaciones
	)
	VALUES
	(
		@L_TU_CodEslabon,						@L_TU_CodObjeto,					@L_TC_CodOficina_Entrega,			@L_TN_CodTipoIdentificacionEntrega,			
		@L_TC_IdentificacionEntrega,			@L_TC_NombreCompletoEntrega,		@L_TC_UsuarioRedEntrega,			@L_TC_CodOficina_Recibe,			
		@L_TN_CodTipoIdentificacionRecibe,		@L_TC_IdentificacionRecibe,			@L_TC_NombreCompletoRecibe,			@L_TC_UsuarioRedRecibe,			
		@L_TC_Tomo,								@L_TC_Folio,						@L_TF_Fecha,						@L_TC_Observaciones
	)
END
GO
