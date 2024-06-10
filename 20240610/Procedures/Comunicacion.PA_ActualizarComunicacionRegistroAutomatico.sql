SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<10/06/2022>
-- Descripción :			<Permite actualizar el registro de comunicacion automático con el codigo de >
--							<asignación de firmado>
-- =================================================================================================================================================
 
CREATE   PROCEDURE [Comunicacion].[PA_ActualizarComunicacionRegistroAutomatico]
 @CodAsignacionFirmado	uniqueidentifier,
 @CodComunicacionAut	uniqueidentifier
 As
 Begin
 --Variables
 DECLARE @L_CodAsignacionFirmado	uniqueidentifier = @CodAsignacionFirmado
 DECLARE @L_CodComunicacionAut		uniqueidentifier = @CodComunicacionAut
  
 --Logica
 UPDATE		Comunicacion.ComunicacionRegistroAutomatico
 SET		TU_CodAsignacionFirmado					= @L_CodAsignacionFirmado
 WHERE		TU_CodComunicacionAut					= @L_CodComunicacionAut	

	 
End
GO
