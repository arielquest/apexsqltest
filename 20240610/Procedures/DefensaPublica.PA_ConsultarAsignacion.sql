SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<10/09/2019>
-- Descripción :			<Permite consultar las asignaciones de defensor de una representación>
-- =================================================================================================================================================
-- Modificación:			<23-03-2020> <Aida E Siles> <Se agrega variable local.>
-- Modificación:			<05-03-2021> <Aida E Siles> <Se agrega tabla Catalogo.TipoPuestoTrabajo para obtener correctamente el tipo funcionario>
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_ConsultarAsignacion]
	@CodRepresentacion		UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE		@L_TU_CodRepresentacion				UNIQUEIDENTIFIER		= @CodRepresentacion

	--Lógica
	SELECT		D.TF_Actualizacion					AS	FechaActualizacion,
				'Split'								AS	Split,				
				D.TU_CodAsignacion					AS	CodigoAsignacion,
				D.TF_Inicio_Vigencia				AS	FechaActivacion,
				D.TF_Fin_Vigencia					AS	FechaDesactivacion,				
				A.TU_CodRepresentacion				AS	CodigoRepresentacion,
				A.TU_CodPersona						AS	CodigoPersona,
				A.TC_NRD							AS	NRD,
				B.TC_CodContexto					AS	CodigoContexto,
				C.TC_Descripcion					AS	ContextoDescrip,
				J.TN_CodTipoFuncionario				AS	CodigoTipoFuncionario,
				J.TC_Descripcion					AS	TipoFuncionarioDescrip,
				I.TN_CodTipoPuestoTrabajo			AS	CodigoTipoPuestoTrabajo,
				I.TC_Descripcion					AS  TipoPuestoTrabajoDescrip,
				'Split'								AS	Split,				
				F.TU_CodPuestoFuncionario			AS	Codigo,
				'Split'								AS	Split,
				E.TC_CodPuestoTrabajo				AS	Codigo,
				E.TC_Descripcion					AS	Descripcion,	
				'Split'								AS	Split,
				G.TC_UsuarioRed						AS	UsuarioRed,
				G.TC_Nombre							AS	Nombre,
				G.TC_PrimerApellido					AS	PrimerApellido,
				G.TC_SegundoApellido				AS	SegundoApellido,				
				'Split'								AS	Split,
				H.TN_CodMotivoFinalizacion			AS	Codigo,
				H.TC_Descripcion					AS	Descripcion
	From		DefensaPublica.Representacion		AS	A WITH(NOLOCK)
	INNER JOIN	DefensaPublica.Carpeta				AS	B WITH(NOLOCK)
	ON			A.TC_NRD							=	B.TC_NRD
	INNER JOIN	Catalogo.Contexto					AS	C WITH(NOLOCK)
	ON			B.TC_CodContexto					=	C.TC_CodContexto
	INNER JOIN	DefensaPublica.Asignacion			AS	D WITH(NOLOCK)
	ON			A.TU_CodRepresentacion				=	D.TU_CodRepresentacion
	INNER JOIN	Catalogo.PuestoTrabajo				AS	E WITH(NOLOCK)
	ON			D.TC_CodPuestoTrabajo				=	E.TC_CodPuestoTrabajo
	INNER JOIN	Catalogo.PuestoTrabajoFuncionario	AS	F  WITH(NOLOCK)
	ON			E.TC_CodPuestoTrabajo				=	F.TC_CodPuestoTrabajo
	INNER JOIN	Catalogo.Funcionario				AS	G WITH(NOLOCK)
	ON			F.TC_UsuarioRed						=	G.TC_UsuarioRed
	LEFT JOIN	Catalogo.MotivoFinalizacion			AS	H WITH(NOLOCK)
	ON			D.TN_CodMotivoFinalizacion			=	H.TN_CodMotivoFinalizacion
	INNER JOIN	Catalogo.TipoPuestoTrabajo			AS	I WITH(NOLOCK)
	ON			I.TN_CodTipoPuestoTrabajo			=	E.TN_CodTipoPuestoTrabajo
	INNER JOIN	Catalogo.TipoFuncionario			AS	J WITH(NOLOCK)
	ON			J.TN_CodTipoFuncionario				=	I.TN_CodTipoFuncionario		
	WHERE		A.TU_CodRepresentacion				=	@L_TU_CodRepresentacion
END
GO
