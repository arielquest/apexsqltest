SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<11/10/2018>
-- Descripción :			<Permite agregar una historico de movimiento a un archivo sin expediente> 
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_AgregarMovimientoArchivoSinExpediente]
	@CodArchivo				uniqueidentifier,
	@Movimiento				char(1),
	@CodigoContexto			varchar(4),
	@UsuarioRed				varchar(30),
	@Justificacion			varchar(255)
AS  
BEGIN  
	INSERT INTO	Historico.ArchivoSinExpedienteMovimiento
	(
		TU_CodArchivo,		TF_Movimiento,		TC_Movimiento,		TC_CodContexto,		TC_UsuarioRed,		TC_JustificacionTraslado
	)
	VALUES
	(
		@CodArchivo,		GETDATE(),			@Movimiento,		@CodigoContexto,	@UsuarioRed,		@Justificacion		
	)
END
GO
