SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez R>
-- Fecha de creación:		<17/11/2015>
-- Descripción :			<Permite Consultar telefonos de un intervininte> 
 
-- =================================================================================================================================================
 select * from Expediente.IntervinienteTelefono 
*/
 
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervinienteTelefono]
 @CodInterviniente	uniqueidentifier
 As
 Begin
  
         	Select	TU_CodTelefono	    As	Codigo,			
					TC_Numero	        As	Numero,
					TC_CodArea	        As	CodigoArea,
					TC_Extension        As Extension ,
					'Split' as Split,
					T.TN_CodTipoTelefono	As	Codigo,		
					T.TC_Descripcion     as  Descripcion
			From	 Expediente.IntervinienteTelefono as I With(Nolock) 
			inner join Catalogo.TipoTelefono  as T on I.TN_CodTipoTelefono = T.TN_CodTipoTelefono 
			Where	TU_CodInterviniente		=	@CodInterviniente
	 
	 
 End




GO
