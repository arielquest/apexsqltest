SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.2>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<11/02/2019>
-- Descripción :			<Permite consultar los datos básicos de cálculos de interés> 
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<14/05/2019>
-- Modificación				<Eliminados campos de indexación>
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<27/06/2019>
-- Modificación				<Agregado nuevo campo TN_MontoLiquidado>
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<08/07/2019>
-- Modificación				<Agregado campo TU_IDArchivoFSActual, para que se muestre al consultar el doc del formato jurídico>
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<12/07/2019>
-- Modificación				<Corregido nombre campo Codigo a CodigoResolucion, para que traiga el id correcto de la resolucion y agregado TU_CodArchivo>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarCalculoInteres]
	@Codigo				uniqueidentifier	=	Null,
	@CodigoDeuda		uniqueidentifier	=	Null,
	@NumeroExpediente	char(14)
As
Begin
		Select		A.TU_CodigoCalculoInteres			As	Codigo,			
					A.TF_FechaInicio					As	FechaInicio,
					A.TF_FechaFinal						As	FechaFinal,
					A.TF_FechaResolucion				As	FechaResolucion,		
					A.TF_FechaCalculo					As	FechaCalculo,			
					A.TC_UsuarioRed						As	UsuarioRed,
					A.TB_EnFirme						As	EnFirme,
					A.TB_CalculoLiquidado				As	CalculoLiquidado,
					A.TB_CostasPersonales				As	CostasPersonales,
					A.TN_MontoCostasPersonales			As	MontoCostasPersonales,
					A.TN_SaldoCostasPersonales			As	SaldoCostasPersonales,
					A.TN_MontoCostasProcesales			As	MontoCostasProcesales,
					A.TN_SaldoCostasProcesales			As	SaldoCostasProcesales,
					A.TC_DescripcionCostasProcesales	As	DescripcionCostasProcesales,
					A.TN_MontoLiquidado					AS	MontoLiquidado,
					A.TN_SaldoMontoLiquidado			As	SaldoMontoLiquidado,
					A.TN_MontoCambio					As	MontoCambio,
					A.TF_FechaTipoCambio				As	FechaTipoCambio,
					A.TN_MontoTotal						As	MontoTotal,
					'Split'								As	SplitFormatoJuridico,			
					A.TC_CodFormatoJuridico				As	Codigo,	
					C.TC_Descripcion					As	Descripcion,
					C.TU_IDArchivoFSActual				As	ArchivoFSActual,
					'Split'								As	SplitResolucion,			
					A.TU_CodResolucion					As	CodigoResolucion,
					E.TU_CodArchivo						AS	Codigo,
					'Split'								As	SplitDeuda,			
					A.TU_CodigoDeuda					As	Codigo,
					D.TC_Descripcion					As	Descripcion,
					'Split'								As	SplitContexto,			
					A.TC_CodContexto					As	Codigo,
					B.TC_Descripcion					As	Descripcion,					
					'Split'								As	SplitDatos,			
					A.TC_TipoInteres					As	TipoInteres,
					A.TC_EstadoCalculo					As	EstadoCalculo,		
					A.TC_TipoCambioUsado				As	TipoCambioUsado						
	From			Expediente.CalculoInteres			As	A	With(Nolock) 	
	Inner Join		Catalogo.Contexto					As	B	With(Nolock) 	
	On				B.TC_CodContexto					=	A.TC_CodContexto	
	Inner Join		Catalogo.FormatoJuridico			As	C	With(Nolock) 
	On				C.TC_CodFormatoJuridico				=	A.TC_CodFormatoJuridico
	Inner Join		Expediente.Deuda					As	D	With(Nolock)
	On				D.TU_CodigoDeuda					=	A.TU_CodigoDeuda
	Left Outer Join Expediente.Resolucion				AS	E	With(Nolock)
	ON				E.TU_CodResolucion					=	A.TU_CodResolucion
	Where			A.TU_CodigoCalculoInteres			=	Coalesce(@Codigo, A.TU_CodigoCalculoInteres)
	And				D.TC_NumeroExpediente				=	@NumeroExpediente		
	And				A.TU_CodigoDeuda					=	Coalesce(@CodigoDeuda, A.TU_CodigoDeuda)
 End
GO
