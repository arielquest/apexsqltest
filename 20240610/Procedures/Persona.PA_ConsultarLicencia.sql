SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<02/10/2015>
-- Descripción :			<Permite Consultar Licencias> 
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================

  
CREATE PROCEDURE [Persona].[PA_ConsultarLicencia]
	@CodPersona		uniqueidentifier
 As
 Begin
  
	Select			A.TF_Expedicion			As	FechaExpedicion,
					A.TF_Caducidad			As	FechaCaducidad,		A.TF_Tramite	As	FechaTramite,
					'Split'					As	Split,				A.TU_CodPersona	As	CodigoPersona,
					A.TN_CodTipoLicencia	As	CodigoTipoLicencia,
					C.TC_Descripcion		as DescripcionTipoLicencia
	From			Persona.Licencia		As	A	With(Nolock)
	Inner Join		Persona.PersonaFisica	As	B	With(Nolock)
	On				B.TU_CodPersona			=	A.TU_CodPersona
	Inner Join		Catalogo.TipoLicencia	As	C	With(Nolock)
	on			    C.TN_CodTipoLicencia   	=  A.TN_CodTipoLicencia
	Where			A.TU_CodPersona			=	@CodPersona 

 End




GO
