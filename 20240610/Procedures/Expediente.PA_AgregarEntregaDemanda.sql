SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<10/07/2020>
-- Descripción:			<Permite agregar un registro en la tabla: EntregaDemanda.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_AgregarEntregaDemanda]
	@CodEntregaDemanda			UNIQUEIDENTIFIER,
	@NumeroExpediente			CHAR(14),
	@FechaIngresoRDD			DATETIME2(3),
	@Estado						CHAR(1),
	@FechaRecibido				DATETIME2(3),
	@FechaEstadoExpediente		DATETIME2(3)	= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodEntregaDemanda		UNIQUEIDENTIFIER	= @CodEntregaDemanda,
			@L_TC_NumeroExpediente		CHAR(14)			= @NumeroExpediente,
			@L_TF_FechaIngresoRDD		DATETIME2(3)		= @FechaIngresoRDD,
			@L_TC_Estado				CHAR(1)				= @Estado,
			@L_TF_FechaRecibido			DATETIME2(3)		= @FechaRecibido,
			@L_TF_FechaEstadoExpediente	DATETIME2(3)		= @FechaEstadoExpediente,
			@L_TF_Actualizacion			DATETIME2(3)		= getdate()
	--Cuerpo
	INSERT INTO	Expediente.EntregaDemanda	WITH (ROWLOCK)
	(
		TU_CodEntregaDemanda,			TC_NumeroExpediente,			TF_FechaIngresoRDD,				TC_Estado,						
		TF_FechaRecibido,				TF_FechaEstadoExpediente,			TF_Actualizacion					
	)
	VALUES
	(
		@L_TU_CodEntregaDemanda,		@L_TC_NumeroExpediente,			@L_TF_FechaIngresoRDD,			@L_TC_Estado,					
		@L_TF_FechaRecibido,			@L_TF_FechaEstadoExpediente,	@L_TF_Actualizacion					
	)
END
GO
