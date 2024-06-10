SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez R>
-- Fecha de creación:		<17/11/2015>
-- Descripción :			<Permite Consultar telefonos de un intervininte> 
 -- Modificación:	<21/09/2018> <Juan Ramírez V> <Se agrega el campo SMS y se modifica la estructura a Persona.Telefono>
-- =================================================================================================================================================
*/
 
CREATE PROCEDURE [Persona].[PA_ConsultarPersonaTelefono]
 @CodPersona	uniqueidentifier
 As
 Begin
  
         	Select	TU_CodTelefono	    As	Codigo,			
					TC_Numero	        As	Numero,
					TC_CodArea	        As	CodigoArea,
					TC_Extension        As 	Extension,
					TB_SMS				As  SMS,
					'Split' as Split,
					T.TN_CodTipoTelefono	As	Codigo,		
					T.TC_Descripcion     as  Descripcion
			From	 Persona.Telefono as I With(Nolock) 
			inner join Catalogo.TipoTelefono  as T on I.TN_CodTipoTelefono = T.TN_CodTipoTelefono 
			Where	TU_CodPersona		=	@CodPersona
	 
	 
 End





GO
