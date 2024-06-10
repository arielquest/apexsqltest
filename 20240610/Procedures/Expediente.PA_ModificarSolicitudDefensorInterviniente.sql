SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Tatiana Flores>
-- Fecha de creación:		<16/08/2017>
-- Descripción:				<Permite modificar el interviniente de una solicitud >
-- ===========================================================================================
CREATE Procedure [Expediente].[PA_ModificarSolicitudDefensorInterviniente]
	 @CodigoSolicitudDefensor     Uniqueidentifier,		
	 @CodigoInterviniente         Uniqueidentifier,
	 @Sustitucion                 bit,
	 @Declaro                     bit
	 
As
Begin
	update  [Expediente].[SolicitudDefensorInterviniente]
	set	
	
		TB_Sustitucion  =    @Sustitucion, 
		TB_Declaro      =    @Declaro
	where
	TU_CodSolicitudDefensor         =    @CodigoSolicitudDefensor And
	TU_CodInterviniente             =    @CodigoInterviniente
End

GO
