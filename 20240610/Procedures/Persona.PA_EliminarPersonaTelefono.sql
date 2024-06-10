SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez R>
-- Fecha de creación:		<17/11/2015>
-- Descripción :			<Permite eliminar telefonos de un intervininte> 
 
-- =================================================================================================================================================
 
*/
 
CREATE PROCEDURE [Persona].[PA_EliminarPersonaTelefono]
 @CodPersona	uniqueidentifier,
 @CodTelefono	uniqueidentifier
 As
 Begin
  
         	Delete
			From	 Persona.Telefono  
			Where	TU_CodPersona		=	@CodPersona
			and     TU_CodTelefono      =   @CodTelefono
	 
	 
 End





GO
