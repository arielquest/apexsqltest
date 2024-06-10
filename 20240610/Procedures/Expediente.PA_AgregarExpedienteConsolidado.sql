SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================================================== 
-- Versión:				<1.0> 
-- Creado por:			<Ricardo Gutiérrez Peña> 
-- Fecha de creación:	<16/02/2021> 
-- Descripción:			<Permite agregar un registro en la tabla: ExpedienteConsolidado.> 
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarExpedienteConsolidado]  
	@CodSolicitudDocumentoConsolidado				UNIQUEIDENTIFIER, 
	@NumeroExpediente								CHAR(14), 
	@CodContexto									VARCHAR(4), 
	@CodLegajo										UNIQUEIDENTIFIER = NULL, 
	@FechaSolicitud									DATETIME2(7), 
	@Sistema										VARCHAR(7), 
	@UsuarioRed										VARCHAR(30), 
	@Estado											CHAR(1),  
	@FechaGenerado									DATETIME2(7) = NULL, 
	@FechaVencimiento								DATETIME2(7) = NULL, 
	@CodDocumentoConsolidado						VARCHAR(100) = NULL 

AS 
BEGIN  
	--Variables 
	DECLARE @L_TU_CodSolicitudDocumentoConsolidado  UNIQUEIDENTIFIER	= @CodSolicitudDocumentoConsolidado,   
			@L_TC_NumeroExpediente					CHAR(14)			= @NumeroExpediente,   
			@L_TC_CodContexto						VARCHAR(4)			= @CodContexto,   
			@L_TU_CodLegajo							UNIQUEIDENTIFIER	= @CodLegajo,    
			@L_TF_FechaSolicitud					DATETIME2(7)		= @FechaSolicitud,   
			@L_TN_Sistema							VARCHAR(7)			= @Sistema,    
			@L_TC_UsuarioRed						VARCHAR(30)			= @UsuarioRed,    
			@L_TC_Estado							CHAR(1)				= @Estado,   
			@L_TF_FechaGenerado						DATETIME2(7)		= @FechaGenerado,   
			@L_TF_FechaVencimiento					DATETIME2(7)		= @FechaVencimiento,   
			@L_TC_CodDocumentoConsolidado			VARCHAR(100)		= @CodDocumentoConsolidado  

	--Cuerpo  
	INSERT INTO Expediente.ExpedienteConsolidado WITH (ROWLOCK)  
	(   
		TU_CodSolicitudDocumentoConsolidado,			TC_NumeroExpediente,					TC_CodContexto,						TU_CodLegajo,        
		TF_FechaSolicitud,								TN_Sistema,								TC_UsuarioRed,						TC_Estado,         
		TF_FechaGenerado,								TF_FechaVencimiento,					TC_CodDocumentoConsolidado     
	)  

	VALUES  (   
		@L_TU_CodSolicitudDocumentoConsolidado,			@L_TC_NumeroExpediente,					@L_TC_CodContexto,					@L_TU_CodLegajo,      
		@L_TF_FechaSolicitud,							@L_TN_Sistema,							@L_TC_UsuarioRed,					@L_TC_Estado,       
		@L_TF_FechaGenerado,							@L_TF_FechaVencimiento,					@L_TC_CodDocumentoConsolidado     
	) 

END
GO
