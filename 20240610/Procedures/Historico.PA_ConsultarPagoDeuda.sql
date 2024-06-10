SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez>
-- Fecha de creación:		<05/06/2019>
-- Descripción :			<Permite consultar un listado de liquidaciones asociadas a una deuda>

CREATE PROCEDURE [Historico].[PA_ConsultarPagoDeuda]
	@CodigoDeuda		Uniqueidentifier
 As
 Begin

	SELECT		A.TU_CodigoPagoDeuda			AS Codigo,								
				A.TF_FechaDeposito				AS FechaDeposito,		
				A.TF_FechaPago					AS FechaPago,
				A.TN_MontoAbonoCapital			AS MontoAbonoCapital,	
				A.TN_MontoDeposito				AS MontoDeposito,	
				A.TN_MontoPagoCostasPersonales	AS MontoPagoCostasPersonales,	
				A.TN_MontoPagoCostasProcesales	AS MontoPagoCostasProcesales,
				A.TN_MontoPagoInteres			AS MontoPagoInteres,					
				A.TN_NumeroDeposito				AS NumeroDeposito,	
				A.TC_UsuarioRed					AS UsuarioRed,
				A.TF_FechaRegistroPago			AS FechaRegistroPago,
				'Split'							AS SplitMoneda,
				A.TN_CodMoneda					AS Codigo,
				B.TC_Descripcion				AS Descripcion,				
				'Split'							AS SplitDeuda,
				A.TU_CodigoDeuda				AS Codigo,
				C.TC_Descripcion				AS Descripcion
    FROM        Historico.PagoDeuda             As	A	With(Nolock) 	
	Inner Join	Catalogo.Moneda					AS	B	With(Nolock) 	
	On			B.TN_CodMoneda					=	A.TN_CodMoneda
	Inner Join	Expediente.Deuda				AS	C	With(Nolock) 	
	On			C.TU_CodigoDeuda				=	A.TU_CodigoDeuda
	WHERE       (A.TU_CodigoDeuda = @CodigoDeuda)
	ORDER BY TF_FechaRegistroPago DESC

 End
GO
