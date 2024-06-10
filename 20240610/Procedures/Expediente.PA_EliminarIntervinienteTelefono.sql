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
 
CREATE PROCEDURE [Expediente].[PA_EliminarIntervinienteTelefono]
 @CodInterviniente	uniqueidentifier,
  @CodTelefono	uniqueidentifier
 As
 Begin
  
         	Delete
			From	 Expediente.IntervinienteTelefono  
			Where	TU_CodInterviniente		=	@CodInterviniente
			and     TU_CodTelefono          =   @CodTelefono
	 
	 
 End




GO
