SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<27/12/2018>
-- Descripción :			<Permite consultar los datos básicos de cálculos de indexación> 
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<21/05/2019>
-- Modificación				<Eliminar y agregar campos de indexación>
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<12/07/2019>
-- Modificación				<Agregado campo de CodigoDeuda y su Descripcion, opcional, por si se está generando asociado a la Deuda>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarCalculoIndexacion]
	@Codigo				uniqueidentifier	=	Null,
	@CodigoDeuda		uniqueidentifier	=	Null,
	@NumeroExpediente	char(14)
As
Begin
	Select			A.TU_CodigoCalculoIndexacion		As	Codigo,
					A.TC_Descripcion					As	Descripcion,
					A.TF_FechaCalculo					As	FechaCalculo,			
					A.TC_UsuarioRed						As	UsuarioRed,
					A.TN_MontoIndexacion				As	MontoIndexacion,
					'Split'								As	SplitExpediente,			
					A.TC_NumeroExpediente				As	Numero,
					'Split'								As	SplitContexto,			
					B.TC_CodContexto					As	Codigo,
					B.TC_Descripcion					As	Descripcion,
					'Split'								As	SplitDatos,			
					A.TC_TipoMonto						As	TipoMonto,
					A.TN_TipoPago						As	TipoPago,
					A.TN_MontoTotalIndexado				AS	MontoTotalIndexado,
					A.TC_Indicador						AS	Indicador,
					'Split'								As	SplitMoneda,			
					A.TN_CodMoneda						As	Codigo,
					M.TC_Descripcion					As	Descripcion,
					'Split'								As	SplitDeuda,
					A.TU_CodigoDeuda					As	Codigo,
					D.TC_Descripcion					As	Descripcion
	From			Expediente.CalculoIndexacion		As	A	With(Nolock) 	
	Inner Join		Catalogo.Contexto					As	B	With(Nolock) 	
	On				B.TC_CodContexto					=	A.TC_CodContexto	
	Inner Join		Catalogo.Moneda						As	M	With(Nolock) 	
	On				M.TN_CodMoneda						=	A.TN_CodMoneda
	Left Outer Join	Expediente.Deuda					As	D	With(Nolock)
	On				D.TU_CodigoDeuda					=	A.TU_CodigoDeuda
	Where			A.TU_CodigoCalculoIndexacion		=	Coalesce(@Codigo, A.TU_CodigoCalculoIndexacion)
	And				(
					 (@CodigoDeuda						IS	NULL AND D.TU_CodigoDeuda IS NULL)
					 OR
					 (@CodigoDeuda						IS	NOT NULL AND D.TU_CodigoDeuda =	@CodigoDeuda)
					)
	And				A.TC_NumeroExpediente				=	@NumeroExpediente		 	
 End
GO
