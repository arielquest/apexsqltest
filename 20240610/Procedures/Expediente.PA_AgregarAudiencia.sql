SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<30/01/2020>
-- Descripción:			<Permite agregar un registro en la tabla: Audiencia.>
-- ==================================================================================================================================================================================
-- Modificación:		<05/02/2020> <Andrew Allen Dawson> <Se agrega comando para que se devuelva el código de la audiencia recién agregada>
-- Modificación:		<20/04/2020> <Isaac Dobles Mata> <Se agrega consecutivo para Historial Procesal>
-- ==================================================================================================================================================================================
-- Modificación:		<05/10/2020> <Ronny Ramírez R.> <Se agrega campo que indica la cantidad de archivos que componen la audiencia>
-- Modificación:		<15/10/2020> <Aida Elena Siles R> <Se agrega parámetro EstadoPublicacion para registrar el estado al desacumular expediente-Copiar Audiencia>
-- Modificación:		<28/10/2020> <Aida Elena Siles R> <Ajuste en el tipo de dato del parámetro FechaCrea se pasa a DATETIME2(2) por observación de Fabian Sequeira>
-- Modificación:		<22/06/2021> <Jonthan Aguilar Navarro> <Se agrega campos IDacoOriginal y Sistema.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_AgregarAudiencia]
	@NumeroExpediente		CHAR(14),
	@Estado					CHAR(1),
	@Descripcion			VARCHAR(255),
	@NombreArchivo			VARCHAR(255)	= NULL,
	@CodTipoAudiencia		SMALLINT,
	@CodContextoCrea		VARCHAR(4),
	@UsuarioRedCrea			VARCHAR(30)		= NULL,
	@Duracion				VARCHAR(11),
	@FechaCrea				DATETIME2(2),
	@Consecutivo			INT				= NULL,
	@CantidadArchivos		TINYINT,
	@EstadoPublicacion		SMALLINT,
	@IDacoOriginal			bigint,
	@Sistema				char	


AS
BEGIN
	--Variables
	DECLARE	@L_TC_NumeroExpediente		CHAR(14)		= @NumeroExpediente,
			@L_TC_Estado				CHAR(1)			= @Estado,
			@L_TC_Descripcion			VARCHAR(255)	= @Descripcion,
			@L_TC_NombreArchivo			VARCHAR(255)	= @NombreArchivo,
			@L_TN_CodTipoAudiencia		SMALLINT		= @CodTipoAudiencia,
			@L_TC_CodContextoCrea		VARCHAR(4)		= @CodContextoCrea,
			@L_TC_UsuarioRedCrea		VARCHAR(30)		= @UsuarioRedCrea,
			@L_TC_Duracion				VARCHAR(11)		= @Duracion,
			@L_TF_FechaCrea				DATETIME2(6)	= @FechaCrea,
			@L_TN_EstadoPublicacion		SMALLINT		= @EstadoPublicacion,
			@L_TN_Consecutivo			INT				= @Consecutivo,
			@L_TN_CantidadArchivos		TINYINT			= @CantidadArchivos,
			@L_IDacoOriginal			bigint			= @IDacoOriginal,
			@L_Sistema					char			= @Sistema		
	--Cuerpo

	INSERT INTO	Expediente.Audiencia WITH (ROWLOCK)
	(
		TC_NumeroExpediente,			TC_Estado,					TC_Descripcion,				TC_NombreArchivo,			
		TN_CodTipoAudiencia,			TC_CodContextoCrea,			TC_UsuarioRedCrea,			TC_Duracion,				
		TF_FechaCrea,					TN_EstadoPublicacion,		TN_Consecutivo,				TN_CantidadArchivos,
		IDACO_ORIGINAL,					SISTEMA
	) OUTPUT INSERTED.TN_CodAudiencia
	VALUES
	(
		@L_TC_NumeroExpediente,			@L_TC_Estado,					@L_TC_Descripcion,				@L_TC_NombreArchivo,			
		@L_TN_CodTipoAudiencia,			@L_TC_CodContextoCrea,			@L_TC_UsuarioRedCrea,			@L_TC_Duracion,			
		@L_TF_FechaCrea,				@L_TN_EstadoPublicacion,		@L_TN_Consecutivo,				@L_TN_CantidadArchivos,
		@L_IDacoOriginal,				@L_Sistema	
	)
END
GO
