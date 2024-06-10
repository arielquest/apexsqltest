SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<18/09/2019>
-- Descripción :			<Permite consultar los registros de la tabla Expediente.ExpedienteSolicitudAcceso> 
-- ==========================================================================================================================================================================
-- Modificación				<19/09/2019><Isaac Dobles Mata><Se modifica para consultar las solicitudes de acceso del expediente sin importar el legajo>
-- Modificación				<27/09/2019><Ronny Ramírez Rojas><Se modifica para traer la información básica de la oficina asociada al contexto para usarlo como agrupación>
-- Modificación:			<21/09/2020><Aida Elena Siles R><Se modifica para obtener la descripción de la oficina que revisa correctamente.>
-- ==========================================================================================================================================================================

CREATE  PROCEDURE [Expediente].[PA_ConsultarExpedienteSolicitudAcceso] 
     @Codigo								uniqueidentifier	= null,
     @CodLegajo								uniqueidentifier	= null,
	 @Descripcion							varchar(225)		= null,
	 @CodContextoSolicitud					varchar(4)			= null,
	 @CodPuestoTabajoFuncionarioSolicitud	uniqueidentifier	= null,
	 @FechaSolicitud						datetime2			= null,
	 @EstadoSolicitudAccesoExpediente		char(1)				= null,
	 @CodContextoRevision					varchar(4)			= null,
	 @CodPuestoFuncionarioRevision			uniqueidentifier	= null,
	 @FechaRevision							datetime2			= null,
	 @MotivoRechazo							varchar(225)		= null,
	 @NumeroExpediente						char(14)			= null
As  
Begin
	If @NumeroExpediente IS NOT NULL
	Begin
		Select	Distinct	  
				
			ESA.TU_CodSolicitudAccesoExpediente		As	Codigo,		
			ESA.TC_Descripcion						As	Descripcion,
			ESA.TF_Solicitud						As	FechaSolicitud,
			ESA.TF_Revision							As	FechaRevision,
			ESA.TC_MotivoRechazo					As	MotivoRechazo,
			'SplitLegajo'							As	SplitLegajo,
			ESA.TU_CodLegajo						As	Codigo,		
			'SplitContextoSolicitud'				As	SplitContextoSolicitud,
			CO.TC_CodContexto						As	Codigo,					
			CO.TC_Descripcion						As	Descripcion,				
			'SplitFuncionarioSolicitud'				As	SplitFuncionarioSolicitud,
			G.TC_UsuarioRed							As	UsuarioRed,
			G.TC_Nombre								As	Nombre,
			G.TC_PrimerApellido						As	PrimerApellido,
			G.TC_SegundoApellido					As	SegundoApellido,	
			'SplitDinamico'							As	SplitDinamico,		
			L.TC_NumeroExpediente					As	NumeroExpediente,		
			F.TU_CodPuestoFuncionario				As	CodigoPuestoFuncionarioSolicitud,
			FR.TU_CodPuestoFuncionario				As	CodigoPuestoFuncionarioRevision,
			ESA.TC_EstadoSolicitudAccesoExpediente	As	EstadoSolicitudAccesoExpediente,
			OS.TC_CodOficina						As	CodigoOficinaSolicitud,
			OS.TC_Nombre							As	DescripcionOficinaSolicitud,			
			OFR.TC_CodOficina						As	CodigoOficinaRevision,
			OFR.TC_Nombre							As	DescripcionOficinaRevision,
			'SplitContextoRevision'					As	SplitContextoRevision,
			COR.TC_CodContexto						As	Codigo,					
			COR.TC_Descripcion						As	Descripcion,			
			'SplitFuncionarioRevision'				As	SplitFuncionarioRevision,
			GR.TC_UsuarioRed						As	UsuarioRed,
			GR.TC_Nombre							As	Nombre,
			GR.TC_PrimerApellido					As	PrimerApellido,
			GR.TC_SegundoApellido					As	SegundoApellido

		From		Expediente.ExpedienteSolicitudAcceso			As	ESA 							WITH (NOLOCK)		
		Inner Join	Expediente.Legajo								As	L								WITH (NOLOCK)
		On			L.TU_CodLegajo									=	ESA.TU_CodLegajo
		Inner Join	Catalogo.Contexto								As	CO								WITH (NOLOCK)
		On			CO.TC_CodContexto								=	ESA.TC_CodContextoSolicitud
		Inner Join	Catalogo.Oficina								As	OS								WITH (NOLOCK)
		On			OS.TC_CodOficina								=	CO.TC_CodOficina
		Inner Join	Catalogo.PuestoTrabajoFuncionario				As	F								WITH (NOLOCK)
		On			F.TU_CodPuestoFuncionario						=	ESA.TU_CodPuestoFuncionarioSolicitud
		Inner Join	Catalogo.Funcionario							As	G								WITH (NOLOCK)
		On			F.TC_UsuarioRed									=	G.TC_UsuarioRed
		Left Join	Catalogo.Contexto								As	COR								WITH (NOLOCK)
		On			COR.TC_CodContexto								=	ESA.TC_CodContextoRevision
		Left Join	Catalogo.Oficina								As	OFR								WITH (NOLOCK)
		On			OFR.TC_CodOficina								=	COR.TC_CodOficina
		Left Join	Catalogo.PuestoTrabajoFuncionario				As	FR								WITH (NOLOCK)
		On			FR.TU_CodPuestoFuncionario						=	ESA.TU_CodPuestoFuncionarioRevision
		Left Join	Catalogo.Funcionario							As	GR								WITH (NOLOCK)
		On			FR.TC_UsuarioRed								=	GR.TC_UsuarioRed	
	
		Where       ESA.TU_CodSolicitudAccesoExpediente				=	Coalesce(@Codigo, ESA.TU_CodSolicitudAccesoExpediente) 				
		AND			ESA.TU_CodLegajo								=	Coalesce(@CodLegajo, ESA.TU_CodLegajo)
		AND			ESA.TC_Descripcion								=	Coalesce(@Descripcion, ESA.TC_Descripcion)
		AND			ESA.TC_CodContextoSolicitud						=	Coalesce(@CodContextoSolicitud, ESA.TC_CodContextoSolicitud)
		AND			ESA.TU_CodPuestoFuncionarioSolicitud			=	Coalesce(@CodPuestoTabajoFuncionarioSolicitud, ESA.TU_CodPuestoFuncionarioSolicitud)
		AND			ESA.TF_Solicitud								=	Coalesce(@FechaSolicitud, ESA.TF_Solicitud)
		AND			ESA.TC_EstadoSolicitudAccesoExpediente			=	Coalesce(@EstadoSolicitudAccesoExpediente, ESA.TC_EstadoSolicitudAccesoExpediente)
		AND       ( 
					ESA.TC_CodContextoRevision						=	Coalesce(@CodContextoRevision, ESA.TC_CodContextoRevision)
					OR  ESA.TC_CodContextoRevision					is null			
				   )
		AND       ( 
					ESA.TU_CodPuestoFuncionarioRevision				=	Coalesce(@CodPuestoFuncionarioRevision, ESA.TU_CodPuestoFuncionarioRevision)
					OR  ESA.TU_CodPuestoFuncionarioRevision			is null			
				   )
		AND       ( 
					ESA.TF_Revision									=	Coalesce(@FechaRevision, ESA.TF_Revision)
					OR  ESA.TF_Revision								is null			
				   )
		AND       ( 
					ESA.TC_MotivoRechazo							=	Coalesce(@MotivoRechazo, ESA.TC_MotivoRechazo)
					OR  ESA.TC_MotivoRechazo						is null			
				   )
		AND			L.TC_NumeroExpediente							=	@NumeroExpediente

		ORDER BY	FechaSolicitud	ASC
	End
	Else
		Begin
			Select	Distinct	  
				
				ESA.TU_CodSolicitudAccesoExpediente		As	Codigo,		
				ESA.TC_Descripcion						As	Descripcion,
				ESA.TF_Solicitud						As	FechaSolicitud,
				ESA.TF_Revision							As	FechaRevision,
				ESA.TC_MotivoRechazo					As	MotivoRechazo,
				'SplitLegajo'							As	SplitLegajo,
				ESA.TU_CodLegajo						As	Codigo,		
				'SplitContextoSolicitud'				As	SplitContextoSolicitud,
				CO.TC_CodContexto						As	Codigo,					
				CO.TC_Descripcion						As	Descripcion,				
				'SplitFuncionarioSolicitud'				As	SplitFuncionarioSolicitud,
				G.TC_UsuarioRed							As	UsuarioRed,
				G.TC_Nombre								As	Nombre,
				G.TC_PrimerApellido						As	PrimerApellido,
				G.TC_SegundoApellido					As	SegundoApellido,	
				'SplitDinamico'							As	SplitDinamico,		
				L.TC_NumeroExpediente					As	NumeroExpediente,		
				F.TU_CodPuestoFuncionario				As	CodigoPuestoFuncionarioSolicitud,
				FR.TU_CodPuestoFuncionario				As	CodigoPuestoFuncionarioRevision,
				ESA.TC_EstadoSolicitudAccesoExpediente	As	EstadoSolicitudAccesoExpediente,
				OS.TC_CodOficina						As	CodigoOficinaSolicitud,
				OS.TC_Nombre							As	DescripcionOficinaSolicitud,
				OFR.TC_CodOficina						As	CodigoOficinaRevision,
				OFR.TC_Nombre							As	DescripcionOficinaRevision,
				'SplitContextoRevision'					As	SplitContextoRevision,
				COR.TC_CodContexto						As	Codigo,					
				COR.TC_Descripcion						As	Descripcion,			
				'SplitFuncionarioRevision'				As	SplitFuncionarioRevision,
				GR.TC_UsuarioRed						As	UsuarioRed,
				GR.TC_Nombre							As	Nombre,
				GR.TC_PrimerApellido					As	PrimerApellido,
				GR.TC_SegundoApellido					As	SegundoApellido

			From		Expediente.ExpedienteSolicitudAcceso			As	ESA 							WITH (NOLOCK)		
			Inner Join	Expediente.Legajo								As	L								WITH (NOLOCK)
			On			L.TU_CodLegajo									=	ESA.TU_CodLegajo
			Inner Join	Catalogo.Contexto								As	CO								WITH (NOLOCK)
			On			CO.TC_CodContexto								=	ESA.TC_CodContextoSolicitud
			Inner Join	Catalogo.Oficina								As	OS								WITH (NOLOCK)
			On			OS.TC_CodOficina								=	CO.TC_CodOficina
			Inner Join	Catalogo.PuestoTrabajoFuncionario				As	F								WITH (NOLOCK)
			On			F.TU_CodPuestoFuncionario						=	ESA.TU_CodPuestoFuncionarioSolicitud
			Inner Join	Catalogo.Funcionario							As	G								WITH (NOLOCK)
			On			F.TC_UsuarioRed									=	G.TC_UsuarioRed
			Left Join	Catalogo.Contexto								As	COR								WITH (NOLOCK)
			On			COR.TC_CodContexto								=	ESA.TC_CodContextoRevision
			Left Join	Catalogo.Oficina								As	OFR								WITH (NOLOCK)
			On			OFR.TC_CodOficina								=	COR.TC_CodOficina
			Left Join	Catalogo.PuestoTrabajoFuncionario				As	FR								WITH (NOLOCK)
			On			FR.TU_CodPuestoFuncionario						=	ESA.TU_CodPuestoFuncionarioRevision
			Left Join	Catalogo.Funcionario							As	GR								WITH (NOLOCK)
			On			FR.TC_UsuarioRed								=	GR.TC_UsuarioRed	
	
			Where       ESA.TU_CodSolicitudAccesoExpediente				=	Coalesce(@Codigo, ESA.TU_CodSolicitudAccesoExpediente) 				
			AND			ESA.TU_CodLegajo								=	Coalesce(@CodLegajo, ESA.TU_CodLegajo)
			AND			ESA.TC_Descripcion								=	Coalesce(@Descripcion, ESA.TC_Descripcion)
			AND			ESA.TC_CodContextoSolicitud						=	Coalesce(@CodContextoSolicitud, ESA.TC_CodContextoSolicitud)
			AND			ESA.TU_CodPuestoFuncionarioSolicitud			=	Coalesce(@CodPuestoTabajoFuncionarioSolicitud, ESA.TU_CodPuestoFuncionarioSolicitud)
			AND			ESA.TF_Solicitud								=	Coalesce(@FechaSolicitud, ESA.TF_Solicitud)
			AND			ESA.TC_EstadoSolicitudAccesoExpediente			=	Coalesce(@EstadoSolicitudAccesoExpediente, ESA.TC_EstadoSolicitudAccesoExpediente)
			AND       ( 
						ESA.TC_CodContextoRevision						=	Coalesce(@CodContextoRevision, ESA.TC_CodContextoRevision)
						OR  ESA.TC_CodContextoRevision					is null			
					   )
			AND       ( 
						ESA.TU_CodPuestoFuncionarioRevision				=	Coalesce(@CodPuestoFuncionarioRevision, ESA.TU_CodPuestoFuncionarioRevision)
						OR  ESA.TU_CodPuestoFuncionarioRevision			is null			
					   )
			AND       ( 
						ESA.TF_Revision									=	Coalesce(@FechaRevision, ESA.TF_Revision)
						OR  ESA.TF_Revision								is null			
					   )
			AND       ( 
						ESA.TC_MotivoRechazo							=	Coalesce(@MotivoRechazo, ESA.TC_MotivoRechazo)
						OR  ESA.TC_MotivoRechazo						is null			
					   )

			ORDER BY	FechaSolicitud	ASC
		End
End
GO
