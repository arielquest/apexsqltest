SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Fabian Sequeira Gamboa> 
-- Fecha de creación:		<04/02/2021>
-- Descripción:				<Se consultan tod l equivalenci>
-- ===========================================================================================
CREATE PROCEDURE [Configuracion].[PA_ConsultarEquivalencia]
@Codigo varchar(50) 
As 
begin

	Select 
				E.TU_Codigo								   CodigoSIAGPJ,				E.TN_CodSistema    			 Descripcion,
				E.TN_CodCatalogo							   Sistema,						E.TC_ValorExterno				 Catalogo,		
				E.TC_ValorSIAGPJ							   CodigoExterno
	From		Configuracion.Equivalencia E WITH(NOLOCK)
	Where E.TC_ValorExterno = @Codigo

End 

GO
