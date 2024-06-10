SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Daniel Ruiz Hernández>
-- Fecha de creación:		<08/01/2021>
-- Descripción :			<Permite consultar las historico de fases y estados del legajo> 
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_ConsultarHistoricoLegajoFaseEstado]
@CodLegajo		uniqueidentifier
AS  
BEGIN 
	SELECT		A.TU_CodLegajo								AS CodigoLegajo, 
				'Split'					                    AS  Split,	
				A.TN_CodFase								AS CodigoFase, 
				B.TC_Descripcion							AS DescripcionFase, 
				E.TN_CodEstado								AS CodigoEstado, 
				F.TC_Descripcion							AS DescripcionEstado, 
				A.TC_CodContexto							AS CodigoContexto, 
				C.TC_Descripcion							AS DescripcionContexto,
				E.TF_Fecha									AS FechaEstado,
				G.TC_UsuarioRed								AS UsuarioEstado,
				A.TF_Actualizacion							AS FechaFase,
				A.TC_UsuarioRed								AS UsuarioFase,
				A.TC_CodContexto							 AS CodigoContexto, 
				C.TC_Descripcion							 AS DescripcionContexto,
				CO.TC_CodOficina							 AS CodigoOficina,
				CO.TC_Nombre								 AS NombreOficina,
				H.TC_Nombre									 AS NombreFase,
				H.TC_PrimerApellido							 AS PrimerApellidoFase,
				H.TC_SegundoApellido						 AS SegundoApellidoFase,
				I.TC_Nombre									 AS NombreEstado,
				I.TC_PrimerApellido						     AS PrimerApellidoEstado,
				I.TC_SegundoApellido						 AS SegundoApellidoEstado
	FROM		Historico.LegajoFase						AS A With(NoLock)
	INNER JOIN	Catalogo.Fase								AS B With(NoLock)  
	ON			B.TN_CodFase								= A.TN_CodFase 
	INNER JOIN	Catalogo.Contexto							AS C With(NoLock) 
	ON			C.TC_CodContexto							= A.TC_CodContexto
	INNER JOIN	Catalogo.Oficina						 	  AS CO With(NoLock) 
	ON			CO.TC_CodOficina						 	= C.TC_CodOficina
	INNER JOIN	Historico.LegajoMovimientoCirculanteFase	AS D With(NoLock) 
	ON			D.TU_CodLegajoFase							= A.TU_CodLegajoFase 
	AND			D.TU_CodLegajo								= A.TU_CodLegajo 
	INNER JOIN	Historico.LegajoMovimientoCirculante		AS E With(NoLock) 
	ON			E.TN_CodLegajoMovimientoCirculante			= D.TN_CodLegajoMovimientoCirculante 
	AND			E.TU_CodLegajo								= A.TU_CodLegajo
	AND			E.TC_CodContexto							= A.TC_CodContexto 
	INNER JOIN	Catalogo.Estado								AS F With(NoLock) 
	ON			F.TN_CodEstado								= E.TN_CodEstado
	INNER JOIN	Catalogo.PuestoTrabajoFuncionario			AS G With(NoLock) 
	ON			E.TU_CodPuestoFuncionario					= G.TU_CodPuestoFuncionario 
	INNER JOIN  Catalogo.Funcionario						 AS H With(NoLock)
	ON			H.TC_UsuarioRed								= A.TC_UsuarioRed
	INNER JOIN  Catalogo.Funcionario						 AS I With(NoLock)
	ON			I.TC_UsuarioRed								= G.TC_UsuarioRed
	WHERE		A.TU_CodLegajo								= @CodLegajo
	ORDER BY	D.TF_Fecha									ASC
	
END

GO
