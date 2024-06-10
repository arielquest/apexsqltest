SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<22/08/2019>
-- Descripción :			<Permite consultar los movimientos en el circulante de un expediente.
-- =========================================================================================================

CREATE PROCEDURE [Historico].[PA_ConsultarExpedienteMovimientoCirculante]

	@NumeroExpediente				char(14),
	@CodContexto					varchar(4),
	@Movimiento						char(1)

AS

BEGIN
	
	SELECT 
	A.TF_Fecha												AS	Fecha,
	A.TC_Descripcion										AS  Descripcion,
	A.TN_CodExpedienteMovimientoCirculante                  AS  Codigo,
	'Split'													AS  Split,
	B.TC_NumeroExpediente									AS	Numero,
	'Split'													AS  Split,		
	A.TC_CodContexto										AS	Codigo,
	C.TC_Descripcion										AS  Descripcion,
	'Split'													AS  Split,
	E.TN_CodEstado											AS  Codigo,
	E.TC_Descripcion										AS	Descripcion,
	'Split'													AS	Split,
	AR.TU_CodArchivo										AS	Codigo,
	AR.TC_Descripcion										AS	Descripcion,
	'Split'													AS	Split,
	F.TC_CodPuestoTrabajo									AS	Codigo,
	G.TC_Descripcion										AS	Descripcion,
	'Split'													AS	Split,
	G.TN_CodTipoFuncionario									AS	Codigo,
	G.TC_Descripcion										AS	Descripcion,
	H.UsuarioRed											AS	UsuarioRed,
	H.Nombre												AS	Nombre,
	H.PrimerApellido										AS	PrimerApellido,
	H.SegundoApellido										AS	SegundoApellido,
	H.CodigoPlaza											AS	CodigoPlaza,
	H.FechaActivacion										AS	FechaActivacion,
	H.FechaDesactivacion									AS	FechaDesactivacion,	
	A.TC_Movimiento											AS	Movimiento

	FROM [Historico].[ExpedienteMovimientoCirculante]		AS A WITH(NOLOCK)
	
	INNER JOIN Expediente.Expediente						AS B WITH(NOLOCK)
	On A.TC_NumeroExpediente								= B.TC_NumeroExpediente
	
	INNER JOIN Catalogo.Contexto							AS C WITH(NOLOCK)
	On A.TC_CodContexto										= C.TC_CodContexto
	
	LEFT JOIN Archivo.Archivo								AS AR WITH(NOLOCK)
	On A.TU_CodArchivo										= AR.TU_CodArchivo
	
	INNER JOIN Catalogo.Estado								AS E WITH(NOLOCK)
	On A.TN_CodEstado										= E.TN_CodEstado

	INNER JOIN Catalogo.PuestoTrabajoFuncionario			AS F WITH(NOLOCK)
	On A.TU_CodPuestoFuncionario							= F.TU_CodPuestoFuncionario

	INNER JOIN Catalogo.PuestoTrabajo						AS G WITH(NOLOCK)
	On	F.TC_CodPuestoTrabajo								= G.TC_CodPuestoTrabajo

	Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(F.TC_CodPuestoTrabajo) As H

	WHERE	A.TC_NumeroExpediente							= @NumeroExpediente
	AND		A.TC_CodContexto								= COALESCE(@CodContexto,A.TC_CodContexto)
	AND		A.TC_Movimiento									= COALESCE(@Movimiento,A.TC_Movimiento)
	ORDER BY A.TF_Fecha	DESC
	
END
	 
GO
