SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<23/01/2019>
-- Descripción :			<Permite consultar los datos de cálculo de horas extra> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarCalculoHorasExtra]
	@NumeroExpediente		char(14),
	@Codigo					uniqueidentifier	=	Null,
	@CodigoInterviniente	uniqueidentifier	=	Null	
As
Begin
		Select		A.TU_CodigoCalculoHorasExtra		As	Codigo,
					A.TC_Descripcion					As	Descripcion,
					A.TF_FechaCalculo					As	FechaCalculo,	
					A.TF_FechaInicio					As	FechaInicio,
					A.TF_FechaFinal						As	FechaFinal,
					A.TC_UsuarioRed						As	UsuarioRed,
					A.TN_CantidadDiasFeriados			As	CantidadDiasFeriados,
					A.TN_CantidadDiasIncapacidad		As	CantidadDiasIncapacidad,
					A.TN_CantidadDiasNoLaborado			As	CantidadDiasNoLaborado,
					A.TN_CantidadDiasVacaciones			As	CantidadDiasVacaciones,
					A.TN_CantidadHorasExtra				As	CantidadHorasExtra,
					A.TN_CantidadHorasLaboradas			As	CantidadHorasLaboradas,
					A.TN_FormaPago						As	FormaPago,
					A.TN_MontoSalarioMensual			As	MontoSalarioMensual,
					A.TN_MontoTotalHorasExtra			As	MontoTotalHorasExtra,
					A.TN_MontoUnitarioHoraExtra			As	MontoUnitarioHoraExtra,
					A.TB_CalculoHorasExtraEliminado		As	CalculoHorasExtraEliminado,
					'Split'								As	SplitExpediente,			
					A.TC_NumeroExpediente				As	Numero,
					'Split'								As	SplitMoneda,			
					A.TN_CodMoneda						As	Codigo,
					B.TC_Descripcion					As	Descripcion,
					'Split'								As	SplitContexto,			
					A.TC_CodContexto					As	Codigo,
					C.TC_Descripcion					As	Descripcion,
					'Split'								As	SplitInterviniente,			
					A.TU_CodInterviniente				As	CodigoInterviniente,
					'Split'								As	SplitPersonaFisica,
					E.TU_CodPersona						As	CodigoPersona,
					E.TC_Nombre							As	Nombre,
					E.TC_PrimerApellido					As	PrimerApellido,				
					E.TC_SegundoApellido				As	SegundoApellido,
					'Split'								As	SplitPersonaJuridica,
					F.TU_CodPersona						As	CodigoPersona,
					F.TC_Nombre							As	Nombre,
					F.TC_NombreComercial				As	NombreComercial
		From		Expediente.CalculoHorasExtra		As	A	With(Nolock) 	
		Inner Join	Catalogo.Moneda						As	B	With(Nolock) 	
		On			B.TN_CodMoneda						=	A.TN_CodMoneda	
		Inner Join	Catalogo.Contexto					As	C	With(Nolock) 	
		On			C.TC_CodContexto					=	A.TC_CodContexto	
		Inner Join	Expediente.Intervencion				As	D	With(Nolock)
		On			D.TU_CodInterviniente				=	A.TU_CodInterviniente
		Left  Join	Persona.PersonaFisica				As	E	With(Nolock)
		On			E.TU_CodPersona						=	D.TU_CodPersona
		Left  Join	Persona.PersonaJuridica				As	F	With(Nolock)
		On			F.TU_CodPersona						=	D.TU_CodPersona												
		Where		A.TU_CodigoCalculoHorasExtra		=	Coalesce(@Codigo, A.TU_CodigoCalculoHorasExtra)
		And			A.TU_CodInterviniente				=	Coalesce(@CodigoInterviniente, A.TU_CodInterviniente)
		And			A.TC_NumeroExpediente				=	@NumeroExpediente	
		And			A.TB_CalculoHorasExtraEliminado		=	0
 End
GO
