SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<28/02/2019>
-- Descripción :			<Permite consultar los datos básicos de una deuda> 
-- =================================================================================================================================================
-- Modificacion:			<04/07-2019> <Isaac Dobles Mata> <Se modifica para ajustarse a estructura nueva del desarrollo expediente>
-- Modificacion:			<18/07/2019><Ronny Ramírez Rojas><Agregado campo CostasPersonalesCapital>
-- Modificacion:			<11/03/2021><Jonathan Aguilar Navarro><Se agrega a la consulta el campo Monto sobre giro>
-- Modificacion:			<18/03/2021><Jonathan Aguilar Navarro><Se agrega a la consulta los campos correspondiente a sobregiros>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ConsultarDeuda]
	@Codigo				uniqueidentifier	=	Null,
	@NumeroExpediente	char(14)
As
BEGIN

DECLARE 
					@L_Codigo				uniqueidentifier	= @Codigo,
					@L_NumeroExpediente	char(14)				= @NumeroExpediente

Select				A.TU_CodigoDeuda						As	Codigo,					
					A.TC_Descripcion						As	Descripcion,
					A.TF_FechaCreacion						As	FechaCreacion,		
					A.TN_MontoDeuda							As	MontoDeuda,
					A.TN_MontoLPT							As	MontoLPT,
					A.TN_MontoObrero						As	MontoObrero,
					A.TN_MontoPatronal						As	MontoPatronal,
					A.TN_MontoTrabajadorInd					As	MontoTrabajadorIndependiente,
					A.TN_ImpuestoRenta						As	ImpuestoRenta,
					A.TN_ImpuestoVenta						As	ImpuestoVenta,
					A.TN_Timbres							As	Timbres,
					A.TN_Sanciones							As	Sanciones,
					A.TN_SaldoDeuda							As	SaldoDeuda,
					A.TN_InteresCorriente					As	InteresCorriente,
					A.TN_InteresMoratorio					As	InteresMoratorio,
					A.TB_CostasPersonalesCapital			As	CostasPersonalesCapital,
					A.TN_MontoSobreGiro						As  MontoSobreGiro,
					A.TN_InteresSobreGiro					AS	InteresSobreGiro,				 
					A.TF_FechaInicioSobreGiro				As 	FechaInicioSobreGiro,			
					A.TF_FechaFinalSobreGiro				As 	FechaFinalSobreGiro,			
					A.TN_MontoInteresSobreGiro				As 	MontoInteresSobreGiro,			
					A.TN_TasaInteresPosterior				As 	TasaInteresPosterior,			
					A.TF_FechaInteresPosterior				As 	FechaInteresPosterior,			
					A.TN_TasaInteresPosteriorSobreGiro		As 	TasaInteresPosteriorSobreGiro,
					A.TF_FechaInteresPosteriorSobreGiro		As 	FechaInteresPosteriorSobreGiro,
					'Split'									As	SplitMoneda,
					A.TN_CodMoneda							As	Codigo,
					B.TC_Descripcion						As	Descripcion,
					'Split'									As	SplitBanco,
					A.TC_CodigoBanco						As	Codigo,
					C.TC_Descripcion						As	Descripcion,
					'Split'									As	SplitExpediente,
					E.TC_NumeroExpediente					As	Numero,
					'Split'									As	SplitClase,
					CL.TN_CodClase							As	Codigo,
					CL.TC_Descripcion						As	Descripcion,
					CL.TF_Inicio_Vigencia					As	FechaActivacion,
					CL.TF_Fin_Vigencia						As	FechaDesactivacion,
					'Split'									As	SplitDecreto,
					A.TC_CodigoDecreto						As	Codigo,
					D.TC_Descripcion						As	Descripcion,
					'Split'									As	SplitOtrosDatos,
					A.TC_ProcesoEstado						As	ProcesoEstado,
					A.TC_TipoObligacion						As	TipoObligacion,
					A.TC_TipoTasaInteres					As	TipoTasaInteres,
					A.TC_Periodicidad						As	Periodicidad,
					A.TC_TipoInteres						As	TipoInteres
	From			Expediente.Deuda						As	A	With(Nolock)
	Inner Join		Expediente.ExpedienteDetalle 			As	E	With(Nolock)
	On				E.TC_NumeroExpediente					=	A.TC_NumeroExpediente
	Inner Join		Catalogo.Clase							As	CL	With(Nolock)
	On				CL.TN_CodClase							=	E.TN_CodClase
	Inner Join		Catalogo.Moneda							As	B	With(Nolock) 	
	On				B.TN_CodMoneda							=	A.TN_CodMoneda
	Left Outer Join	Catalogo.Banco							As	C	With(Nolock) 	
	On				C.TC_CodigoBanco						=	A.TC_CodigoBanco
	Left Outer Join Catalogo.Decreto						As	D	With(Nolock)
	On				D.TC_CodigoDecreto						=	A.TC_CodigoDecreto
	Where			A.TU_CodigoDeuda						=	Coalesce(@L_Codigo, A.TU_CodigoDeuda)
	And				A.TC_NumeroExpediente					=	@L_NumeroExpediente		
	Order by		A.TF_FechaCreacion						Asc
 End
GO
