SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<13/11/2018>
-- Descripción :			<Permite consultar las solicitudes de desacumulacion por puesto de trabajo>
-- =================================================================================================================================================
-- Modificación :			<18/12/2020> <Daniel Ruiz Hernández> <Se agrega la consulta de la fase para asignar al expediente.> 
-- =================================================================================================================================================
CREATE Procedure [Historico].[PA_ConsultarSolicituDesacumulacion]
	@CodPuestoTrabajo	varchar (14),
	@NumeroExpediente	varchar(14),
	@Estado				char(1)
As 
begin
if @Estado is null
begin
	select	A.TU_CodSolicitud					as Codigo,
		A.TC_UsuarioRed						as UsuarioRed,
		A.TF_FechaSolicitud					as FechaSolicitud,
		A.TF_Actualizacion					as FechaActualizacion,
		A.TC_Observaciones					as Observaciones,
		'SplitPuestoTrabajo'				as SplitPuestoTrabajo,
		C.TC_CodPuestoTrabajo				as Codigo,
		C.TC_Descripcion					as Descripcion, 
		'SplitFuncionario'					aS SplitFuncionario,
		D.UsuarioRed						as	UsuarioRed,
		D.Nombre							as	Nombre,
		D.PrimerApellido					as	PrimerApellido,
		D.SegundoApellido					as	SegundoApellido,
		D.CodigoPlaza						as	CodigoPlaza,
		D.FechaActivacion					as	FechaActivacion,
		D.FechaDesactivacion				as	FechaDesactivacion,
		'SplitAsignadorPor'					as SplitAsignadorPor,
		E.TC_CodPuestoTrabajo				as Codigo,
		E.TC_Descripcion					as Descripcion,
		'SplitFuncionarioAsignadorPor'		as SplitFuncionarioAsignadorPor,
		D.UsuarioRed						as	UsuarioRed,
		D.Nombre							as	Nombre,
		D.PrimerApellido					as	PrimerApellido,
		D.SegundoApellido					as	SegundoApellido,
		D.CodigoPlaza						as	CodigoPlaza,
		D.FechaActivacion					as	FechaActivacion,
		D.FechaDesactivacion				as	FechaDesactivacion,
		'Split'								as Split,		 
		A.TC_Estado							as Estado,		
		A.TC_NumeroExpediente				as NumeroExpediente,
		A.TC_TipoDesacumulacion				as TipoDesacumulacion,
		G.TN_CodFase						as CodigoFase,
		G.TC_Descripcion					as DescripcionFase
from	Historico.SolicitudDesacumulacion	as A With(Nolock)
		inner join Catalogo.PuestoTrabajo	as C With(Nolock)
		on	C.TC_CodPuestoTrabajo			=  A.TC_CodPuestoTrabajo
		Outer Apply			Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) As D
		inner join Catalogo.PuestoTrabajo	as E With(NoLock)
		on	E.TC_CodPuestoTrabajo			=  A.TC_AsignadoPor	
		Outer Apply			Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_AsignadoPor) As F 
		INNER JOIN Catalogo.Fase			AS G With(NoLock)
		on G.TN_CodFase						=  A.TN_CodFase 
where	A.TC_CodPuestoTrabajo				= Coalesce(@CodPuestoTrabajo,A.TC_CodPuestoTrabajo)
And		A.TC_NumeroExpediente				= coalesce(@NumeroExpediente,A.TC_NumeroExpediente) 
And		A.TC_Estado							not in ('A','Z')		
end
else
begin
select	A.TU_CodSolicitud					as Codigo,
		A.TC_UsuarioRed						as UsuarioRed,
		A.TF_FechaSolicitud					as FechaSolicitud,
		A.TF_Actualizacion					as FechaActualizacion,
		A.TC_Observaciones					as Observaciones,
		'SplitPuestoTrabajo'				as SplitPuestoTrabajo,
		C.TC_CodPuestoTrabajo				as Codigo,
		C.TC_Descripcion					as Descripcion, 
		'SplitFuncionario'					aS SplitFuncionario,
		D.UsuarioRed						as	UsuarioRed,
		D.Nombre							as	Nombre,
		D.PrimerApellido					as	PrimerApellido,
		D.SegundoApellido					as	SegundoApellido,
		D.CodigoPlaza						as	CodigoPlaza,
		D.FechaActivacion					as	FechaActivacion,
		D.FechaDesactivacion				as	FechaDesactivacion,
		'SplitAsignadorPor'					as SplitAsignadorPor,
		E.TC_CodPuestoTrabajo				as Codigo,
		E.TC_Descripcion					as Descripcion,
		'SplitFase'							as SplitFase,
		G.TN_CodFase						as CodigoFase,
		G.TC_Descripcion					as DescripcionFase,
		'SplitFuncionarioAsignadorPor'		as SplitFuncionarioAsignadorPor,
		D.UsuarioRed						as	UsuarioRed,
		D.Nombre							as	Nombre,
		D.PrimerApellido					as	PrimerApellido,
		D.SegundoApellido					as	SegundoApellido,
		D.CodigoPlaza						as	CodigoPlaza,
		D.FechaActivacion					as	FechaActivacion,
		D.FechaDesactivacion				as	FechaDesactivacion,
		'Split'								as Split,		 
		A.TC_Estado							as Estado,		
		A.TC_NumeroExpediente				as NumeroExpediente,
		A.TC_TipoDesacumulacion				as TipoDesacumulacion
from	Historico.SolicitudDesacumulacion	as A With(Nolock)
		inner join Catalogo.PuestoTrabajo	as C With(Nolock)
		on	C.TC_CodPuestoTrabajo			=  A.TC_CodPuestoTrabajo
		Outer Apply			Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) As D
		inner join Catalogo.PuestoTrabajo	as E With(NoLock)
		on	E.TC_CodPuestoTrabajo			=  A.TC_AsignadoPor	
		Outer Apply			Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_AsignadoPor) As F
		INNER JOIN Catalogo.Fase			AS G With(NoLock)
		on G.TN_CodFase						=  A.TN_CodFase 
where	A.TC_CodPuestoTrabajo				= Coalesce(@CodPuestoTrabajo,A.TC_CodPuestoTrabajo)
And		A.TC_NumeroExpediente				= coalesce(@NumeroExpediente,A.TC_NumeroExpediente) 
And		A.TC_Estado							= @Estado		
end
end
GO
