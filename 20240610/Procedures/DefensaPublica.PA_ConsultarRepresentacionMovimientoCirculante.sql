SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<09/04/2019>
-- Descripción :			<Permite consultar el histórico de movimientos circulante de una representación> 
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_ConsultarRepresentacionMovimientoCirculante]
	@CodRepresentacion		uniqueidentifier,
	@CodContexto		    varchar(4)
As
Begin
	Select		A.TU_CodMovimiento									As	CodMovimiento,
				A.TF_Movimiento										As	FechaMovimiento,
				'Split'												As	Split,
				A.TC_Movimiento										As	Movimiento,
				B.TU_CodRepresentacion								As	CodigoRepresentacion,				
				C.TC_CodContexto									As	CodigoContexto,
				C.TC_Descripcion									As	ContextoDescrip,				
				E.TU_CodPuestoFuncionario							As	CodigoPuestoFuncionario,				
				D.TN_CodEstadoRepresentacion						As	CodigoEstadoRepresentacion,
				D.TC_Descripcion									As	EstadoRepresentacionDescrip,
				D.TC_Circulante										As	Circulante,
				D.TC_Pasivo											As	CirculantePasivo
	From		DefensaPublica.RepresentacionMovimientoCirculante	As	A With(NoLock)
	Inner Join	DefensaPublica.Representacion						As	B With(NoLock)
	On			A.TU_CodRepresentacion								=	B.TU_CodRepresentacion
	Inner Join	Catalogo.Contexto									As	C With(NoLock)
	On			A.TC_CodContexto									=	C.TC_CodContexto
	Inner Join	Catalogo.EstadoRepresentacion						As	D With(NoLock)
	On			A.TN_CodEstadoRepresentacion						=	D.TN_CodEstadoRepresentacion
	Inner Join	Catalogo.PuestoTrabajoFuncionario					As	E With(NoLock)
	On			A.TU_CodPuestoFuncionario							=	E.TU_CodPuestoFuncionario	
	Where		A.TU_CodRepresentacion								=	@CodRepresentacion
	And			A.TC_CodContexto									=	@CodContexto
	Order By	A.TF_Movimiento ASC	
End
GO
