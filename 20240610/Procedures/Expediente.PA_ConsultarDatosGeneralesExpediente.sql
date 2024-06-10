SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez >
-- Fecha de creación:		<04/09/2015>
-- Descripción :			<Permite Consultar los datos generales de un expediente> 
-- =================================================================================================================================================
-- Modificación:			<01/03/2016> <Andrés Díaz> <Se agrega el campo nombre de la oficina.>
-- Modificado por:			<Donald Vargas Zúñiga>
-- Fecha:					<02/12/2016>
-- Descripción:				<Se corrige el nombre del campo TC_CodMoneda, TC_CodPrioridad, TN_CodPrioridad, TC_CodTipoViabilidad, TC_CodTipoAsunto y EsPrincipal a TN_CodMoneda, TN_CodPrioridad, TN_CodTipoCuantia, TN_CodTipoViabilidad, TC_CodTipoAsunto y TB_EsPrincipal de acuerdo al tipo de dato>
-- Modificación:			<Jonathan Aguilar Navarro> <26/04/2018> <Se cambios el campo TC_CodOficina por TC_CodContexto>
-- Modificación:			<Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- =================================================================================================================================================
-- Modificación				<Jonathan Aguilar Navarro> <16/01/2020> <Se modifica para eliminar liga con Legajo y agregarla con Expediente>

  
CREATE PROCEDURE [Expediente].[PA_ConsultarDatosGeneralesExpediente]
	@NumeroExpediente		varchar(14),
	@CodContexto	varchar(4)
		 
 As
 Begin
  
	Select			A.TC_Descripcion			As	Descripcion,	   A.TN_MontoCuantia		As	Cuantia,
				    B.TB_DocumentosFisicos  As DocumentosFisicos,		'Split'						As	Split,					A.TC_NumeroExpediente		As	NumeroExpediente,		 		 
					B.TC_CodContexto			As	CodigoContexto,			D.TC_Descripcion			As	ContextoNombre,			 D.TC_Descripcion	As 	ContextoDescrip,			 A.TN_CodPrioridad	As	CodigoPrioridad,		 
					E.TC_Descripcion	As	PrioridadDescrip,			A.TN_CodTipoCuantia			As	CodigoTipoCuantia,		F.TC_Descripcion			As	TipoCuantiaDescrip,		 A.TN_CodMoneda		As	CodigoMoneda,			 
					G.TC_Descripcion	As	MonedaDescrip,				A.TN_CodTipoViabilidad		As	CodigoTipoViabilidad,	H.TC_Descripcion			As  TipoViabilidadDescrip,	 B.TC_CodContextoProcedencia	As	CodigoContextoProcedencia,
					I.TC_Descripcion	As 	ContextoProcedenciaDescrip, I.TC_Descripcion			As	ContextoProcedenciaNombre
	From			Expediente.Expediente			As	A With(NoLock)
	Inner Join		Expediente.ExpedienteDetalle	As	B With(NoLock)
	On				A.TC_NumeroExpediente			=	B.TC_NumeroExpediente
	Inner Join		Catalogo.Contexto				As  D With(Nolock)
	On				D.TC_CodContexto				=	B.TC_CodContexto
	Left Outer Join	Catalogo.Prioridad				As  E With(Nolock)
	On				E.TN_CodPrioridad				=	A.TN_CodPrioridad
	Left Outer Join	Catalogo.TipoCuantia			As  F With(Nolock)
	On				F.TN_CodTipoCuantia				=	A.TN_CodTipoCuantia
	Left Outer Join	Catalogo.Moneda					As  G With(Nolock)
	On				G.TN_CodMoneda					=	A.TN_CodMoneda
	Left Outer Join	Catalogo.TipoViabilidad			As  H With(Nolock)
	On				H.TN_CodTipoViabilidad			=	A.TN_CodTipoViabilidad
	Left Join		Catalogo.Contexto				As  I With(Nolock)
	On				I.TC_CodContexto				=	B.TC_CodContextoProcedencia

	Where			A.TC_NumeroExpediente 			=	@NumeroExpediente 
    And             D.TC_CodContexto				=	@CodContexto
 End


GO
