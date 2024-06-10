SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================================================
-- Autor:			<Gerardo Lopez>
-- Fecha Creación:	<28/10/2015>
-- Descripcion:		<Validar que existe un numero de expediente en una oficina>
-- ==========================================================================================================================================================
-- Modificado:		<Johan Acosta Ibañez>					 <Consulta si existe el expediente independientemente en que oficina se encuentre>
-- Modificación		<Jonathan Aguilar Navarro>	<12/03/2019> <Se modifica el sp para devolver en objeto de tipo ExpedienteMovimientoCirculante>
-- Modificación		<Isaac Dobles Mata>			<30/04/2019> <Se modifica el sp para devolver los datos ordenados por la fecha más reciente en el circulante>
-- Modificación		<Karol Jiménez S.>			<23/03/2021> <Se modifica el sp para devolver la fecha del movimiento circulante>
-- Modificación		<Ronny Ramírez R.>			<23/09/2021> <Se corrige para que devuelva el contexto correspondiente de cada Movimiento Circulante>
-- ==========================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ExisteExpediente] 
	@NumeroExpediente varchar(14)
AS
BEGIN
    SELECT		A.TC_NumeroExpediente				As	NumeroExpediente,
				A.TF_Inicio							AS	FechaInicio,
				B.TU_CodArchivo						As	Archivo,
				B.TC_Descripcion					As	Descripcion,
				B.TF_Fecha							As	Fecha, 
				'Split'								As	Split,
				B.TC_CodContexto					AS	CodigoContexto,
				C.TC_Descripcion					AS	DescripcionContexto,
				D.TN_CodEstado						As	CodigoEstado,
				D.TC_Descripcion					As	DescripcionEstado,
				B.TC_Movimiento						As	Movimiento,
				E.TU_CodPuestoFuncionario			AS  CodigoPuesto,
				F.TC_Nombre							AS	NombreFuncionario,
				F.TC_PrimerApellido					AS	PrimerApellidoFuncionario,
				F.TC_SegundoApellido				As	SegundoApellidoFuncionario
    FROM		Expediente.Expediente				As	A With(NoLock)
	Inner Join	Historico.ExpedienteMovimientoCirculante B With (NoLock)
	on			B.TC_NumeroExpediente				=	A.TC_NumeroExpediente
	inner join	Catalogo.Contexto					AS  C With (NoLock)
	On			C.TC_CodContexto					=	B.TC_CodContexto	
	Inner join	Catalogo.Estado						As	D With (NoLock)
	on			D.TN_CodEstado						=	B.TN_CodEstado
	Inner join	Catalogo.PuestoTrabajoFuncionario	As	E with(Nolock)	
	on			E.TU_CodPuestoFuncionario			=	B.TU_CodPuestoFuncionario
	Inner join	Catalogo.Funcionario				As	F with (NoLock)
	on			F.TC_UsuarioRed						=	E.TC_UsuarioRed

	WHERE		A.TC_NumeroExpediente				=	@NumeroExpediente
	
	ORDER BY	B.TF_Fecha						DESC 
	 
END
GO
