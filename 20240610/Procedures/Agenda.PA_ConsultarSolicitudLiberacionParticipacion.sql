SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=============================================================================================================================================
-- Autor:		   <Diego Navarrete>
-- Fecha Creación: <11/09/2017>
-- Descripcion:	   <Consulta las solicitudes por código de evento y código de puesto de trabajo>
--=============================================================================================================================================
CREATE PROCEDURE  [Agenda].[PA_ConsultarSolicitudLiberacionParticipacion]  
	@CodigoPuestoTrabajo	varchar(14),
	@CodigoEvento			uniqueidentifier
As
Begin

	Select 
		SLP.TU_CodSolicitudLiberacion	As CodigoSolicitudLiberacion,
		SLP.TF_FechaSolicitud			As FechaSolicitud,
		SLP.TC_DescripcionSolicitud		As DescripcionSolicitud,
		SLP.TF_FechaInicioLiberacion	As FechaInicioLiberacion,
		SLP.TF_FechaFinLiberacion		As FechaFinLiberacion,
		SLP.TC_Observaciones			As Observaciones,
		SLP.TB_Aprobada					As Aprobada,
		'SplitFuncionario'				As SplitFuncionario,
		F.Nombre						As Nombre,
		F.PrimerApellido				As Apellido,
		F.SegundoApellido				As SegundoApellido,
		F.UsuarioRed					As UsuarioRed,
		'SplitOficina'					As SplitOficina,
		O.TC_CodOficina					As Codigo,	
		O.TC_Nombre						As Descripcion,
		O.TF_Inicio_Vigencia			As FechaActivacion, 
		O.TF_Fin_Vigencia				As FechaDesactivacion,
		O.TC_DescripcionAbreviada		As DescripcionAbreviada,
		'SplitParticipanteEvento'		As SplitParticipanteEvento,
		PE.TU_CodParticipacion			As Codigo
	 
	FROM		Agenda.ParticipanteEvento					AS PE  
	INNER JOIN	Agenda.SolicitudLiberacionParticipacion		As SLP
	ON			SLP.TU_CodParticipacion			=			pe.TU_CodParticipacion
	INNER JOIN	Catalogo.PuestoTrabajo						As PT
	ON			PT.TC_CodPuestoTrabajo			=			PE.TC_CodPuestoTrabajo	
	INNER JOIN	Catalogo.Oficina							As O
	ON			PT.TC_CodOficina				=			O.TC_CodOficina		
	OUTER APPLY	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(PE.TC_CodPuestoTrabajo) F

	WHERE		TU_CodEvento					=			@CodigoEvento
	AND			PT.TC_CodPuestoTrabajo			=			Coalesce(@CodigoPuestoTrabajo, PT.TC_CodPuestoTrabajo)

End





GO
