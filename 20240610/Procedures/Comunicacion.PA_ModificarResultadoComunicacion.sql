SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jefry Hernández>
-- Fecha de creación:		<15/03/2017>
-- Descripción:				<Permite modificar el resultado de una comunicación.> 
-----------------------------------------------------------------------------------------------------------------==================
-- Fecha :					<31/10/2017>
-- Modificado por:			<Diego Navarrete>
-- Descripción :			<Se agrega el campo [TF_Actualizacion] para actualizarlo>
-- =================================================================================================================================
-- Modificación:			<29/09/2021> <Aida Elena Siles R> <Se agrega parámetro @IdNotiEntidadJuridica>
-- Modificación:			<14/04/2023> <Isaac Dobles Mata> <Se coloca campos [TC_MensajeUsuario] y [TC_MensajeError] en NULL>
-- Modificación:			<18/01/2024> <Isaac Dobles Mata> <Se agrega parámetro @FechaDevolucion>
-- =================================================================================================================================
CREATE     PROCEDURE [Comunicacion].[PA_ModificarResultadoComunicacion]
(
	@CodigoComunicacion		UNIQUEIDENTIFIER,
	@CodMotivoResultado		SMALLINT,
	@Resultado				CHAR,
	@FechaResultado			DATETIME2,
	@Estado					CHAR,
	@IdNotiEntidadJuridica	BIGINT = NULL,
	@FechaDevolucion		DATETIME2 = NULL
)
As
Begin
--Variables
DECLARE	@L_CodigoComunicacion		UNIQUEIDENTIFIER	=	@CodigoComunicacion,
		@L_CodMotivoResultado		SMALLINT			=	@CodMotivoResultado,
		@L_Resultado				CHAR				=	@Resultado,
		@L_FechaResultado			DATETIME2			=	@FechaResultado,
		@L_Estado					CHAR				=	@Estado,
		@L_IdNotiEntidadJuridica	BIGINT				=	@IdNotiEntidadJuridica,
		@L_FechaDevolucion			DATETIME2			=	@FechaDevolucion

--Lógica
	UPDATE	[Comunicacion].[Comunicacion] WITH(ROWLOCK)
	SET		[TC_Resultado]				= @L_Resultado,
			[TN_CodMotivoResultado]		= @L_CodMotivoResultado,
			[TF_FechaResultado]			= @L_FechaResultado,
			[TC_Estado]					= @L_Estado,
			[TF_Actualizacion]			= GETDATE(),
			[TN_IdNotiEntidadJuridica]	= COALESCE(@L_IdNotiEntidadJuridica, TN_IdNotiEntidadJuridica),
			[TC_MensajeUsuario]			= NULL,
			[TC_MensajeError]			= NULL,
			[TF_FechaDevolucion]		= @L_FechaDevolucion
	WHERE
			[TU_CodComunicacion]	= @L_CodigoComunicacion

END

GO
