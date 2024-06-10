SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<23/11/2018>
-- Descripción :			<Permite consultar las historico de acumulaciones de un expediente> 
-- Modificación				<Jonathan Aguilar Navarro> <05/08/2019> <Se modifica para eliminar la relacion del ExpedienteEstado>
--							<Se eliminan campos de la consulta que ya no pertenecen a la tabla ExpedienteDetalle>
--							<Se agrega el join con la tabla ExpedienteMovimientoCirculante para saber el estado del Expediente> 
-- =================================================================================================================================================
-- Modificación				<Jonathan Aguilar Navarro> <23/08/2019> <Se agregar la materia, la oficina y el tipo de oficina a la consulta> 
-- Modificación				<Jose Gabriel Cordero Soto> <05/11/2019> <Se agrega la prioridad en la consulta> 
-- Modificación				<Roger Lara> <25/01/2021> <Se agrega cambia campo join con el historico de movimiento del expediente,> 
--							<para que sea el id unico del historico de movimientos>

CREATE PROCEDURE [Historico].[PA_ConsultarHistoricoAcumulacion]
	@NumeroExpedienteAcumula			varchar(14) 
As
BEGIN  
		select	A.TU_CodAcumulacion					As	CodigoAcumulacion,				
				A.TF_InicioAcumulacion				As	FechaInicioAcumulacion,
				A.TF_Actualizacion					As	FechaActualizacion,
				A.TF_FinAcumulacion					As	FechaFinAcumulacion,
				'SplitEstado'						As	SplitEstado,
				C.TN_CodEstado						As	Codigo,
				C.TC_Descripcion					AS	Descripcion,
				'SplitContexto'						As	SplitContexto,
				D.TC_CodContexto					As	Codigo,
				D.TC_Descripcion					As	Descripcion,
				'SplitContextoDetalle'				As	SplitContextoDetalle,
				K.TC_CodContexto					As	Codigo,
				D.TC_Descripcion					As	Descripcion,
				'SplitPuestoTrabajo'				As  SplitPuestoTrabajo,
				D.TC_CodContexto					As	Codigo,
				D.TC_Descripcion					As	Descripcion,
				'SplitPuestoTrabajo'				As  SplitPuestoTrabajo,
				P.TU_CodPuestoFuncionario			As  Codigo,
				'SplitFuncionario'					As	SplitFuncionario,
				E.TC_UsuarioRed						As	UsuarioRed,
				E.TC_Nombre							As	Nombre,
				E.TC_PrimerApellido					As	PrimerApellido,
				E.TC_SegundoApellido				As	SegundoApellido,
				E.TC_CodPlaza						As	Plaza,
				'Split'								As	Split,
				J.TU_CodArchivo						As	Codigo,
				J.TC_Descripcion					As	Descripcion,
				F.TF_Inicio							As	FechaEntrada,
				F.TC_Descripcion					As	DescripcionExpediente,
				CP.TN_CodPrioridad					As  CodigoPrioridad,
				CP.TC_Descripcion					As  DescripcionPrioridad,
				A.TC_NumeroExpediente				As	NumeroExpediente	,
				A.TC_NumeroExpedienteAcumula		As	NumeroExpedienteAcumula,
				G.TC_CodMateria						As  CodigoMateria,
				G.TC_Descripcion					As  DescripcionMateria,
				H.TC_CodOficina						As  CodigoOficina,
				H.TC_Nombre							As  DescripcionOficina,
				I.TN_CodTipoOficina					As  TipoOficina,
				I.TC_Descripcion					As	DescripcionTipoOficina,
				C.TC_Circulante						As	Circulante,
				L.TC_Codmateria						As	CodigoDetalleMateria,
				L.TC_Descripcion					As	DescripcionDetalleMateria,
				F.TF_Inicio							As  FechaInicioDetalle,
				M.TN_CodClase						As  ClaseDetalle,
				M.TC_Descripcion					As  ClaseDetalleDescripcion,
				N.TN_CodProceso						As  ProcesoDetalle,
				N.TC_Descripcion					As	DecripcionProcesoDetalle,
				NN.TC_CodOficina					As	OficinaDetalle,
				NN.TC_Nombre						AS	OficinaDetalleDescripcion,
			   'SplitMovimiento'					As	SplitMovimiento,
			   B.TN_CodExpedienteMovimientoCirculante AS  CodigoMovimiento,
			   B.TF_Fecha							AS  FechaMovimiento,
			   B.TC_CodContexto						As  ContextoMovimiento,
			   B.TN_CodEstado						As  CodigoEstado,
			   C.TC_Descripcion						As  DescripcionEstado,
			   B.TC_Movimiento						As Movimiento,
			   B.TC_Descripcion						As DescripcionMovimiento
				
		from	Historico.ExpedienteAcumulacion		As	A
		inner	join	Historico.ExpedienteMovimientoCirculante	As	B With(NoLock)
		on		B.TN_CodExpedienteMovimientoCirculante				=	A.TN_CodExpedienteMovimientoCirculante
		inner	join Expediente.ExpedienteDetalle	As	K with (Nolock)		
		on		K.TC_NumeroExpediente				=	A.TC_NumeroExpediente
		and		K.TC_CodContexto					=	A.TC_CodContexto
		inner	join	Catalogo.Estado				AS	C With(Nolock)
		on		C.TN_CodEstado						=	B.TN_CodEstado
		inner	join	Catalogo.Contexto			As	D With(Nolock)
		on		D.TC_CodContexto					=	A.TC_CodContexto
		inner join Catalogo.Materia					As	L With(Nolock)
		on		L.TC_CodMateria						=	D.TC_CodMateria
		inner join Catalogo.PuestoTrabajoFuncionario AS P With(Nolock)
		on		P.TU_CodPuestoFuncionario			=	A.TU_CodPuestoTrabajoFuncionario		
		inner	join	Catalogo.Funcionario		As	E With(Nolock)
		On		E.TC_UsuarioRed						=	P.TC_UsuarioRed
		inner join	Expediente.Expediente			As	F With(NoLock)
		on		F.TC_NumeroExpediente				=	A.TC_NumeroExpediente
		left join	Archivo.Archivo					As	J With (NoLock)
		on		J.TU_CodArchivo						=	A.TU_CodArchivo	
		inner join	Catalogo.Materia				As	G With(Nolock)
		on		G.TC_CodMateria						=	D.TC_CodMateria	
		inner join	Catalogo.Oficina				As	H With(Nolock)	
		on		H.TC_CodOficina						=	D.TC_CodOficina				 	 
		inner join	Catalogo.TipoOficina			As	I With(Nolock)	
		on		I.TN_CodTipoOficina					=	H.TN_CodTipoOficina
		inner join Catalogo.Clase					As	M With (NoLock)
		on		M.TN_CodClase						=	K.TN_CodClase	
		inner join Catalogo.Proceso					As	N With (NoLock)
		on		N.TN_CodProceso						=	K.TN_CodProceso
		inner 	join Catalogo.Oficina				As	NN With(Nolock)
		on		NN.TC_CodOficina					=	D.TC_CodOficina
		left 	join Catalogo.Prioridad				As	CP With(Nolock)
		on		CP.TN_CodPrioridad					=	F.TN_CodPrioridad
		
		where	TC_NumeroExpedienteAcumula			=	@NumeroExpedienteAcumula
		and		A.TF_FinAcumulacion					is null			

		order by A.TF_InicioAcumulacion desc
END
GO
