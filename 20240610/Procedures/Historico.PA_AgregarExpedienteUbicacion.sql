SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Roger Lara Hernandez>
-- Fecha de creación:	<19/11/2020>
-- Descripción:			<Permite agregar un registro en la tabla: ExpedienteUbicacion.>
-- Modificación:		<10/02/2023> <Josué Quirós Batista> <Actualización del tipo de dato del campo CodUbicacion.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_AgregarExpedienteUbicacion]
	@CodExpedienteUbicacion		UNIQUEIDENTIFIER,
	@NumeroExpediente			CHAR(14),
	@FechaUbicacion				DATETIME2(7),
	@CodUbicacion				INT,
	@Descripcion				VARCHAR(255),
	@UsuarioRed					VARCHAR(30),
	@CodContexto				VARCHAR(4)

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodExpedienteUbicacion		UNIQUEIDENTIFIER	= @CodExpedienteUbicacion,
			@L_TC_NumeroExpediente		        CHAR(14)		    = @NumeroExpediente,
			@L_TF_FechaUbicacion		        DATETIME2(7)		= @FechaUbicacion,
			@L_TN_CodUbicacion		            INT				    = @CodUbicacion,
			@L_TC_Descripcion		            VARCHAR(255)		= @Descripcion,
			@L_TC_UsuarioRed			        VARCHAR(30)		    = @UsuarioRed,
			@L_TC_CodContexto		            VARCHAR(4)		    = @CodContexto

	--Cuerpo
	INSERT INTO	Historico.ExpedienteUbicacion	WITH (ROWLOCK)
	(
		TU_CodExpedienteUbicacion,			TC_NumeroExpediente,			TF_FechaUbicacion,				TN_CodUbicacion,				
		TC_Descripcion,					    TC_UsuarioRed,					TC_CodContexto					
	)
	VALUES
	(
		@L_TU_CodExpedienteUbicacion,			@L_TC_NumeroExpediente,			@L_TF_FechaUbicacion,			@L_TN_CodUbicacion,				
		@L_TC_Descripcion,				        @L_TC_UsuarioRed,				@L_TC_CodContexto				
	)
END
GO
