SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<10/06/2022>
-- Descripción :			<Permite Consultar un registro de comunicación automática por el código de > 
--							<asignación de firmado>
-- =================================================================================================================================================
 
CREATE   PROCEDURE [Comunicacion].[PA_ConsultarComunicacionRegistroAutomatico]
 @CodAsignacionFirmado	uniqueidentifier
 As
 Begin
 --Variables
 DECLARE @L_CodAsignacionFirmado uniqueidentifier = @CodAsignacionFirmado
  
 --Logica
 SELECT		C.TU_CodComunicacionAut						As CodigoComunicacionAutomatica,		
			F.TU_CodAsignacionFirmado					AS CodigoAsignacionFirmado
 FROM		Comunicacion.ComunicacionRegistroAutomatico	AS C With(Nolock) 
 INNER JOIN Archivo.AsignacionFirmado					AS F With(Nolock)
 ON			C.TU_CodAsignacionFirmado				=	F.TU_CodAsignacionFirmado		
 Where		F.TU_CodAsignacionFirmado				=	@L_CodAsignacionFirmado
	 
End
GO
