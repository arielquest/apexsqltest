SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Diego GB>
-- Fecha de creación:		<15/05/2017>
-- Descripción:				<Realiza el envio de la solucitud cambia su estado de registrada a Enviada.>
-- Modificado por:          <Tatiana Flores>
-- Descripción:             <Se renombró el PA>
-- Modificación				<Aida E Siles> <07/02/2020>	<Se agrega el estado pendiente de procesar al momento de enviarse la solicitud a la defensa>
-- ==================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EnviarSolicitudDefensor]
	@CodigoSolicitudDefensor	UNIQUEIDENTIFIER,
	@EstadoRegistrado			VARCHAR(1),
	@EstadoEnviado				VARCHAR(1),
	@UsuarioRed					VARCHAR(30),
	@EstadoPendienteProcesar	CHAR(1)
As
Begin
	BEGIN TRY

		UPDATE	[Expediente].[SolicitudDefensor]
		SET		[TC_EstadoSolicitudDefensor]	= @EstadoEnviado, 
				[TF_FechaEnvio]					= GETDATE(),
				[TU_UsuarioRedSolicita]			= @UsuarioRed,
				[TC_EstadoSolicitudDefensa]		= @EstadoPendienteProcesar
		WHERE	[TU_CodSolicitudDefensor]		= @CodigoSolicitudDefensor 
		AND		[TC_EstadoSolicitudDefensor]	= @EstadoRegistrado	
		
	END TRY  
	BEGIN CATCH  	   
  		return 0
    END CATCH  
End
GO
