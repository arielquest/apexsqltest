SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Jonathan Aguilar Navarro>
-- Fecha Creación: <10/09/2018>
-- Descripcion:	   <Consulta la lista de Firmantes en la tabla histórico DocumentoFirmantes>

CREATE PROCEDURE [Expediente].[PA_ConsultarDocumentoFirmantes]
	@Codigo uniqueidentifier

WITH RECOMPILE
AS
BEGIN
	SELECT 
		A.TN_Orden							AS Orden,
		A.TF_FechaAplicado					AS FechaAplicado,
		A.TB_Nota							AS IndicaSiEsNotas,
		A.TB_Salva							AS IndicaSiEsVoto,
		A.TC_JustificacionSalvaVotoNota		AS ObservacionNotaVoto,
		'Split'								AS Split,		
		A.TU_CodAsignacionFirmado			AS Codigo,	
		'Split'								AS Split,	
		D.TC_CodPuestoTrabajo				As Codigo,
		D.TC_Descripcion					AS Descrípcion,
		'Split'								AS Split,		 
		A.TU_FirmadoPor						AS CodigoFirmadoPor,
		E.UsuarioRed						As UsuarioRed,
		E.Nombre							As Nombre,
		E.PrimerApellido					As PrimerApellido,
		E.SegundoApellido					As SegundoApellido,
		E.CodigoPlaza						As CodigoPlaza,
		E.FechaActivacion					As FechaActivacion,
		E.FechaDesactivacion				As FechaDesactivacion
	FROM Historico.DocumentoFirmante		A		
		INNER JOIN  Archivo.AsignacionFirmado B WITH(NOLOCK) 
		ON	A.TU_CodAsignacionFirmado		= B.TU_CodAsignacionFirmado
		Inner Join	Catalogo.PuestoTrabajoFuncionario	C With(Nolock)
		ON			A.TU_FirmadoPor			= C.TU_CodPuestoFuncionario	
		Inner Join Catalogo.PuestoTrabajo	D With(nolock)
		ON			C.TC_CodPuestoTrabajo	= D.TC_CodPuestoTrabajo	
		CROSS APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(D.TC_CodPuestoTrabajo) E		
	 WHERE 
		A.TU_CodAsignacionFirmado			= ISNULL(@Codigo, A.TU_CodAsignacionFirmado)
	 ORDER BY TN_Orden			
END


GO
