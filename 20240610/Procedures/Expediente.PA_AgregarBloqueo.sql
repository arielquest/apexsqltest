SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Henry Méndez Ch>
-- Fecha de creación:	<17/07/2020>
-- Descripción:			<Permite agregar un registro en la tabla: Bloqueo.>
-- ==================================================================================================================================================================================

CREATE PROCEDURE	[Expediente].[PA_AgregarBloqueo]
	@Codigo					uniqueidentifier,
	@NumeroExpediente		char(14)			=	Null,
	@CodLegajo				uniqueidentifier	=	Null,	
	@CodContexto			varchar(4),
	@UsuarioRed				varchar(30)

AS
BEGIN
	--Variables
	DECLARE	@L_Codigo				uniqueidentifier	=	@Codigo,			 
			@L_NumeroExpediente		char(14)			=	@NumeroExpediente,
			@L_CodLegajo			uniqueidentifier	=	@CodLegajo,			
			@L_CodContexto			varchar(4)			=	@CodContexto,		
			@L_UsuarioRed			varchar(30)			=	@UsuarioRed,			
			@L_FechaBloqueo			datetime2(3) 		=	GetDate()			 
	--Cuerpo
	INSERT INTO	Expediente.Bloqueo WITH (ROWLOCK)
	(
		TU_CodBloqueo,				TC_NumeroExpediente,			TU_CodLegajo,				TC_CodContexto,
		TC_UsuarioRed,				TF_FechaBloqueo
	) 
	VALUES
	(
		@L_Codigo,					@L_NumeroExpediente,			@L_CodLegajo,				@L_CodContexto,
		@L_UsuarioRed,				@L_FechaBloqueo
	)
END
GO
