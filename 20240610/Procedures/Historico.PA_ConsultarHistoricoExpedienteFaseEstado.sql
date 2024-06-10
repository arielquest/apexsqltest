SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara Hernández>
-- Fecha de creación:		<11/01/2021>
-- Descripción :			<Permite consultar las historico de fases y estados de un expediente> 
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_ConsultarHistoricoExpedienteFaseEstado]
@NumeroExpediente		VARCHAR(14)
AS  
BEGIN 
   --Variables
	DECLARE	@L_NumeroExpediente		VARCHAR(14)		         = @NumeroExpediente
    --Lógica

	SELECT	  
			  	D.TF_Fecha								 	 AS Fecha,	
				'Split'					                     AS  Split,	
			    A.TU_CodExpedienteFase						 AS CodigoGFase,
		        A.TN_CodFase								 AS CodigoFase, 
				B.TC_Descripcion							 AS DescripcionFase, 
				A.TF_Fase								     AS FechaFase,
				A.TC_UsuarioRed								 AS UsuarioFase,
				E.TN_CodExpedienteMovimientoCirculante       AS CodigoBEstado,
				E.TN_CodEstado								 AS CodigoEstado, 
				E.TF_Fecha									 AS FechaEstado,
				F.TC_Descripcion							 AS DescripcionEstado, 
			    G.TC_UsuarioRed								 AS UsuarioEstado,
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
	FROM		Historico.ExpedienteFase					 AS A With(NoLock)
	INNER JOIN	Catalogo.Fase							 	 AS B With(NoLock)  
	ON			B.TN_CodFase							 	= A.TN_CodFase 
	INNER JOIN	Catalogo.Contexto							 AS C With(NoLock) 
	ON			C.TC_CodContexto						 	= A.TC_CodContexto
	INNER JOIN	Catalogo.Oficina						 	  AS CO With(NoLock) 
	ON			CO.TC_CodOficina						 	= C.TC_CodOficina
	INNER JOIN	Historico.ExpedienteMovimientoCirculanteFase AS D With(NoLock) 
	ON			D.TU_CodExpedienteFase						= A.TU_CodExpedienteFase 
	INNER JOIN	Historico.ExpedienteMovimientoCirculante	 AS E With(NoLock) 
	ON			E.TN_CodExpedienteMovimientoCirculante		= D.TN_CodExpedienteMovimientoCirculante 
	AND			E.TC_CodContexto							= A.TC_CodContexto 
	INNER JOIN	Catalogo.Estado								 AS F With(NoLock) 
	ON			F.TN_CodEstado								= E.TN_CodEstado
	INNER JOIN	Catalogo.PuestoTrabajoFuncionario			 AS G With(NoLock) 
	ON		    G.TU_CodPuestoFuncionario				    = E.TU_CodPuestoFuncionario
	INNER JOIN  Catalogo.Funcionario						 AS H With(NoLock)
	ON			H.TC_UsuarioRed								= A.TC_UsuarioRed
	INNER JOIN  Catalogo.Funcionario						 AS I With(NoLock)
	ON			I.TC_UsuarioRed								= G.TC_UsuarioRed
	WHERE		D.TC_NumeroExpediente						= @L_NumeroExpediente 
	ORDER BY	D.TF_Fecha									 DESC
	
END
GO
