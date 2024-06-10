SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Fabian Sequeira G>
-- Fecha de creación:	<23/11/2020>
-- Descripción:			<Permite agregar un registro en la tabla: LegajoUbicacion.>
-- Modificación:		<10/02/2023> <Josué Quirós Batista> <Actualización del tipo de dato del campo CodUbicacion.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_AgregarLegajoUbicacion]
	@CodLegajoUbicacion			UNIQUEIDENTIFIER,
	@NumeroExpediente			CHAR(14),
	@TU_CodLegajo				uniqueidentifier,
	@FechaUbicacion				DATETIME2(7),
	@CodUbicacion				INT,
	@Descripcion				VARCHAR(255),
	@UsuarioRed					VARCHAR(30),
	@CodContexto				VARCHAR(4)

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodExpedienteUbicacion		UNIQUEIDENTIFIER	= @CodLegajoUbicacion,
			@L_TC_NumeroExpediente		        CHAR(14)		    = @NumeroExpediente,
			@L_TU_CodLegajo						UNIQUEIDENTIFIER	= @TU_CodLegajo,
			@L_TF_FechaUbicacion		        DATETIME2(7)		= @FechaUbicacion,
			@L_TN_CodUbicacion		            INT				    = @CodUbicacion,
			@L_TC_Descripcion		            VARCHAR(255)		= @Descripcion,
			@L_TC_UsuarioRed			        VARCHAR(30)		    = @UsuarioRed,
			@L_TC_CodContexto		            VARCHAR(4)		    = @CodContexto

	--Cuerpo
	INSERT INTO	Historico.LegajoUbicacion	WITH (ROWLOCK)
	(
		TU_CodLegajoUbicacion,				TC_NumeroExpediente,				TU_CodLegajo,					TF_FechaUbicacion,								
		TN_CodUbicacion,					TC_Descripcion,					    TC_UsuarioRed,					TC_CodContexto					
	)
	VALUES
	(
		@L_TU_CodExpedienteUbicacion,		 @L_TC_NumeroExpediente,			@L_TU_CodLegajo,				@L_TF_FechaUbicacion,							
		@L_TN_CodUbicacion,					 @L_TC_Descripcion,				    @L_TC_UsuarioRed,				@L_TC_CodContexto				
	)
END
GO
