SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez R.>
-- Fecha de creación:		<25/09/2019>
-- Descripción :			<Permite Consultar las solicitudes de acceso al expediente que recibe el despacho>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarBuzonSolicitudAccesoExpediente]   
 	@NumeroPagina				int,
	@CantidadRegistros			int,
	@CodContextoRevision		varchar(4),
	@CodContextoSolicitud		varchar(4)		= NULL,
	@CodOficinaSolicitud		varchar(4)		= NULL,
	@EstadoSolicitud	    	char(1)			= NULL,
	@FechaSolicitud				date			= NULL	
As
begin
 
DECLARE @Solicitudes AS TABLE
  (
   CodigoSolicitud              UniqueIdentifier,
   FechaSolicitud				datetime2,
   DescripcionSolicitud			varchar(225),
   TotalRegistros               int,
   NumeroExpediente				char(14),
   EstadoSolicitud				char(1),
   NombreFuncionarioSolicita	varchar(100),
   NombreOficinaSolicita		varchar(225),
   NombreContextoSolicita		varchar(225)
  )   
 
  if( @NumeroPagina is null) set @NumeroPagina=1;

   INSERT INTO @Solicitudes(
   CodigoSolicitud,   
   FechaSolicitud,
   DescripcionSolicitud,
   NumeroExpediente,
   EstadoSolicitud,
   NombreFuncionarioSolicita,
   NombreOficinaSolicita,
   NombreContextoSolicita
  ) 
	SELECT	Distinct	  				
		ESA.TU_CodSolicitudAccesoExpediente			As	CodigoSolicitud,
		ESA.TF_Solicitud							As	FechaSolicitud,
		ESA.TC_Descripcion							As	Descripcion,
		L.TC_NumeroExpediente						As	NumeroExpediente,
		ESA.TC_EstadoSolicitudAccesoExpediente		As	EstadoSolicitudAccesoExpediente,
		RTRIM(G.TC_Nombre + ' ' 
			+ G.TC_PrimerApellido + ' ' 
			+ Coalesce(G.TC_SegundoApellido,''))	As 	NombreFuncionarioSolicita,
		OS.TC_Nombre								As	NombreOficinaSolicita,
		CO.TC_Descripcion							As	NombreContextoSolicita
	FROM 
			Expediente.ExpedienteSolicitudAcceso						As	ESA 							WITH (NOLOCK)		
			Inner Join	Expediente.Legajo								As	L								WITH (NOLOCK)
			On			L.TU_CodLegajo									=	ESA.TU_CodLegajo
			Inner Join	Expediente.Expediente							As	E								WITH (NOLOCK)
			On			E.TC_NumeroExpediente							=	L.TC_NumeroExpediente
			Inner Join	Catalogo.Contexto								As	CO								WITH (NOLOCK)
			On			CO.TC_CodContexto								=	ESA.TC_CodContextoSolicitud
			Inner Join	Catalogo.Oficina								As	OS								WITH (NOLOCK)
			On			OS.TC_CodOficina								=	CO.TC_CodOficina
			Inner Join	Catalogo.PuestoTrabajoFuncionario				As	F								WITH (NOLOCK)
			On			F.TU_CodPuestoFuncionario						= ESA.TU_CodPuestoFuncionarioSolicitud
			Inner Join	Catalogo.Funcionario							As	G								WITH (NOLOCK)
			On			F.TC_UsuarioRed									=	G.TC_UsuarioRed			
	
			Where		E.TC_CodContexto								=	@CodContextoRevision
			AND			ESA.TC_CodContextoSolicitud						=	Coalesce(@CodContextoSolicitud, ESA.TC_CodContextoSolicitud)			
			AND			(
							@FechaSolicitud	 	 						Is	null 
							OR convert(date,ESA.TF_Solicitud,3)   		=	@FechaSolicitud
						) 
			AND			ESA.TC_EstadoSolicitudAccesoExpediente			=	Coalesce(@EstadoSolicitud, ESA.TC_EstadoSolicitudAccesoExpediente)
			AND       ( 
							ESA.TC_CodContextoRevision					=	Coalesce(@CodContextoRevision, ESA.TC_CodContextoRevision)
							OR  ESA.TC_CodContextoRevision				Is 	null			
					   )
			ORDER BY	FechaSolicitud	ASC
	
--Obtener cantidad registros de la consulta
 DECLARE @TotalRegistros AS INT = @@rowcount;  
 
 
--Resultado de consulta
SELECT		    
			CodigoSolicitud						As	CodigoSolicitud,
			FechaSolicitud						As	FechaSolicitud,
			DescripcionSolicitud				As	DescripcionSolicitud,			
			NombreFuncionarioSolicita			As	NombreFuncionarioSolicita,
			NombreOficinaSolicita				As	NombreOficinaSolicita,
			NombreContextoSolicita				As	NombreContextoSolicita,
			@TotalRegistros	 					As 	TotalRegistros,
			NumeroExpediente					As 	NumeroExpediente,
			'SplitDinamico'						As	SplitDinamico,	
			EstadoSolicitud						As 	EstadoSolicitud

FROM		@Solicitudes
ORDER BY	FechaSolicitud 						Asc

OFFSET		(@NumeroPagina - 1) * @CantidadRegistros ROWS 
FETCH NEXT	@CantidadRegistros ROWS ONLY
 
 
end
GO
