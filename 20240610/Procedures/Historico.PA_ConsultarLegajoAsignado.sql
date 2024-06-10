SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ========================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<24/05/2019>
-- ========================================================================================================================================================================================
-- Modificado por:			<20/08/2020> <Kirvin Bennett Mathurin> Se agrega el codigo y descripcion del tipo de puesto de trabajo en los valores de retorno
-- Modificación:			<18/11/2020> <Aida Elena Siles Rojas> <Se filtra la consulta para que muestre los asignados solo del contexto donde se encuentra el legajo
--						     - HU Recibir Legajo Itineración>
-- Modificación:			<13/03/2021> <Aida Elena Siles Rojas> <Se hace corrección para obtener correctamente el tipo de funcionario. El InnerJoin debe ser entre TipoPuestoTrabajo y TipoFuncionario>
-- Modificado por:			<12/05/2021> <Johan Acosta Ibañez> Se agrega el retono de la nueva columna que indica si se asigno por reparto>
-- Modificado por:			<18/10/2021> <Jose Gabriel Cordero Soto> <Se agrega campo ESRESPONSABLE en resultado de la consulta>
-- Modificado por:			<19/11/2021> <Xinia Soto V> Se agrega convert a filtro de fecha fin asignado>
-- ========================================================================================================================================================================================
CREATE PROCEDURE [Historico].[PA_ConsultarLegajoAsignado]
    @CodigoLegajo  	UNIQUEIDENTIFIER		=	NULL
AS
BEGIN	
-- VARIABLES
DECLARE @L_CodigoLegajo UNIQUEIDENTIFIER	= @CodigoLegajo

--LOGICA
	SELECT		A.TU_CodLegajo						AS	Codigo,
				A.TF_Inicio_Vigencia				AS  FechaInicioVigencia,
				A.TF_Fin_Vigencia					AS	FechaFinVigencia,
				A.TB_AsignadoPorReparto				AS	AsignadoPorReparto,
				A.TB_EsResponsable					AS  EsResponsable,
				'SplitContexto'						AS	SplitContexto,
				B.TC_CodContexto					AS	Codigo,
				B.TC_Descripcion					AS	Descripcion,
				'SplitPuesto'						AS	SplitPuesto,
				C.TC_CodPuestoTrabajo				AS	Codigo,
				C.TC_Descripcion					AS	Descripcion,
				'SplitTipoPuesto'					AS	SplitTipoPuesto,
				D.TN_CodTipoFuncionario				AS	Codigo,
				D.TC_Descripcion					AS	Descripcion,
				'SplitTipoPuestoTrabajo'			AS	SplitTipoPuestoTrabajo,
				G.TN_CodTipoPuestoTrabajo			AS	Codigo,
				G.TC_Descripcion					AS	Descripcion,
				'SplitFuncionario'					AS	SplitFuncionario,
				E.UsuarioRed						AS	UsuarioRed,
				E.Nombre							AS	Nombre,
				E.PrimerApellido					AS	PrimerApellido,
				E.SegundoApellido					AS	SegundoApellido,
				E.CodigoPlaza						AS	CodigoPlaza,
				E.FechaActivacion					AS	FechaActivacion,
				E.FechaDesactivacion				AS	FechaDesactivacion,
				F.TU_CodPuestoFuncionario			AS	CodPuestoFuncionario
	FROM		Historico.LegajoAsignado			AS	A WITH(NOLOCK)
	INNER JOIN	Expediente.Legajo					AS	L WITH(NOLOCK)
	ON			L.TU_CodLegajo						=	A.TU_CodLegajo
	AND			L.TC_CodContexto					=	A.TC_CodContexto
	INNER JOIN	Catalogo.Contexto					AS	B WITH(NOLOCK)
	ON			B.TC_CodContexto					=	A.TC_CodContexto
	INNER JOIN	Catalogo.PuestoTrabajo				AS	C WITH(NOLOCK)
	ON			C.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
	LEFT JOIN	Catalogo.TipoPuestoTrabajo			AS	G with (Nolock)
	ON			C.TN_CodTipoPuestoTrabajo			=	G.TN_CodTipoPuestoTrabajo
	INNER JOIN	Catalogo.TipoFuncionario			AS	D WITH(NOLOCK)
	ON			D.TN_CodTipoFuncionario				=	G.TN_CodTipoFuncionario
	INNER JOIN	Catalogo.PuestoTrabajoFuncionario	AS F WITH (NOLOCK)
	ON			F.TC_CodPuestoTrabajo				= C.TC_CodPuestoTrabajo	
	CROSS APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) E	
	WHERE		A.TU_CodLegajo						=	@L_CodigoLegajo
	AND			(	
					A.TF_Fin_Vigencia	IS NULL 
					OR 
					A.TF_Fin_Vigencia >= CONVERT(DATETIME2(7), GETDATE())
				)
	AND			F.TF_Inicio_Vigencia			<	GETDATE()
	AND			(
					F.TF_Fin_Vigencia	IS NULL
					OR
					F.TF_Fin_Vigencia	>= GETDATE()
				)	
END

GO
