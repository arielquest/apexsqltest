SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<18/02/2020>
-- Descripción:			<Permite agregar un registro en la tabla: DestinoEvidencia.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_AgregarDestinoEvidencia]
	@CodObjeto					UNIQUEIDENTIFIER,
	@Fiscal						VARCHAR(200),
	@FechaDisposicion			DATETIME2(7),
	@Disposicion				CHAR(1),
	@OrdenDe					CHAR(1),
	@Destino					CHAR(1),
	@FechaEntrega				DATETIME2(7),
	@UsuarioRed					VARCHAR(30)

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto			UNIQUEIDENTIFIER		= @CodObjeto,
			@L_TC_Fiscal			VARCHAR(200)			= @Fiscal,
			@L_TF_Disposicion		DATETIME2(7)			= @FechaDisposicion,
			@L_TC_Disposicion		CHAR(1)					= @Disposicion,
			@L_TC_OrdenDe			CHAR(1)					= @OrdenDe,
			@L_TC_Destino			CHAR(1)					= @Destino,
			@L_TF_Entrega			DATETIME2(7)			= @FechaEntrega,
			@L_TC_UsuarioRed		VARCHAR(30)				= @UsuarioRed
	--Cuerpo
	INSERT INTO	Objeto.DestinoEvidencia	WITH (ROWLOCK)
	(
		TU_CodObjeto,					TC_Fiscal,						TF_Disposicion,					TC_Disposicion,					
		TC_OrdenDe,						TC_Destino,						TF_Entrega,						TC_UsuarioRed
	)
	VALUES
	(
		@L_TU_CodObjeto,				@L_TC_Fiscal,					@L_TF_Disposicion,				@L_TC_Disposicion,				
		@L_TC_OrdenDe,					@L_TC_Destino,					@L_TF_Entrega,					@L_TC_UsuarioRed
	)
END
GO
