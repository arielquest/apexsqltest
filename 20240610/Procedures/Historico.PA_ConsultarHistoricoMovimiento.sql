SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<08/11/2018>
-- Descripción :			<Permite consultar el histórico de movimientos de un expediente> 
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_ConsultarHistoricoMovimiento]
	@CodArchivo				uniqueidentifier
AS  
BEGIN 
 
	SELECT
	A.[TF_Movimiento]						AS	Fecha,
	A.[TC_JustificacionTraslado]			AS	JustificacionTraslado,	
	'Split'									AS	Split,
	A.[TC_Movimiento]						AS	MovimientoArchivoSinExpediente,
	'Split'									AS	Split,
	A.[TC_CodContexto]						AS  Codigo,
	B.[TC_Descripcion]						AS	Descripcion,
	'Split'									AS	Split,
	D.[TC_CodOficina]						AS  Codigo,
	D.[TC_Nombre]							AS  Descripcion,
	'Split'									AS	Split,
	A.[TC_UsuarioRed]						AS	UsuarioRed,
	C.[TC_Nombre]							AS	Nombre,
	C.[TC_PrimerApellido]					AS	PrimerApellido,
	C.[TC_SegundoApellido]					AS	SegundoApellido

	FROM [Historico].[ArchivoSinExpedienteMovimiento]	A WITH(NOLOCK)
	INNER JOIN	[Catalogo].[Contexto]					B WITH(NOLOCK)
	ON	A.TC_CodContexto								= B.TC_CodContexto

	INNER JOIN [Catalogo].[Funcionario]					C WITH(NOLOCK)
	ON	A.TC_UsuarioRed									= C.TC_UsuarioRed

	INNER JOIN	[Catalogo].[Oficina]					D WITH(NOLOCK)
	ON	B.TC_CodOficina									= D.TC_CodOficina

	WHERE	A.TU_CodArchivo								= @CodArchivo
	ORDER BY [TF_Movimiento] DESC
	
END
GO
