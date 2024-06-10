SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jefry Hernández>
-- Fecha de creación:		<09/05/2017>
-- Descripción :			<Permite consultar los registros de la tabla  Expediente.SolicitudDefensor> 
-- ============================================================================================================================================================
-- Modificación:			<se agrega el with(lock) ademas se agraga [].>
-- Modificación:			<03/08/2017> <Ailyn López> <Se agregó una condición mas en el join de [LegajoArchivo]> 
-- Modificación:			<11/07/2017> <Diego Navarrete> <se agrega 2 condociones en el interviniente por si la solicitud no tiene un interviniente ligado,
--                          ademas se cambio de Ineer join a  left Join > 
-- Modificación:			<18/12/2017> <Ailyn López> <Se agregan dos campos nuevos.>
-- ============================================================================================================================================================
-- Modificación				<28/11/2019> <Ronny Ramírez Rojas> <Se realizan ajustes al script, para que coincida con las correcciones realizadas en el AD
--							con el cambio de legajo por expedienteDetalle >
-- Modificación:			<07/02/2020> <Aida E Siles> <Se obtiene el responsable asignado de la solicitud de defensor>
-- Modificación:			<21/02/2020> <Aida E Siles> <Se obtiene el responsable activo ya que se estaba duplicando los registros>
-- Modificación				<20/07/2020> <Ronny Ramírez Rojas> <Se realiza ajustes al script, por error detectado en subconsulta de puesto trabajo funcionario>
-- Modificación:			<22/10/2020> <Jonathan Aguilar Navarro> <Se modifica la consulta para indicar el fecha de inicio de vigencia para el ExpedienteAsignado>
-- ============================================================================================================================================================
 
CREATE PROCEDURE [Expediente].[PA_ConsultarSolicitudDefensor] 
     @CodSolicitudDefensor uniqueidentifier = null,
     @NumeroExpediente char(14) = null,
	 @CodInterviniente uniqueidentifier = null
As  
Begin
  
	Select	Distinct	  
				
		SD.[TU_CodSolicitudDefensor]	As Codigo,			
		SD.[TC_Observaciones]			As Observaciones,	SD.[TC_LugarDiligencia]		As LugarDiligencia,
		SD.[TU_Evento]					As CodEvento,		SD.[TF_FechaCreacion]		As FechaCreacion,
		SD.[TF_FechaEnvio]				As FechaEnvio,		SD.[TF_Actualizacion]		As Actualizacion,
		'SplitExpedienteDetalle'		AS SplitExpedienteDetalle,
		SD.[TC_NumeroExpediente]		As Numero,
		'SplitFuncionario'				AS SplitFuncionario,
		F.[TC_UsuarioRed]				As UsuarioRed,      
		'SplitArchivo'					AS SplitArchivo,
		SD.[TU_CodArchivo]				As Codigo,			
		'SplitEstadoSolicitud'			AS SplitEstadoSolicitud, 
		SD.[TC_EstadoSolicitudDefensor] As EstadoSolicitud, 
		'SplitTipoSolicitud'			AS SplitTipoSolicitud,
		SD.[TC_TipoSolicitudDefensor]   As TipoSolicitud,	
		'SplitOficinaSolicita'			AS SplitOficinaSolicita,
		OFS.[TC_CodOficina]				AS Codigo,			
		OFS.[TC_Nombre]					AS Descripcion,         
		'SplitOficinaDefensa'			As SplitOficinaDefensa,
		OFD.[TC_CodOficina]				AS Codigo,			
		OFD.[TC_Nombre]					AS Descripcion,
		'Split'							AS Split,
		PF.TU_CodPuestoFuncionario		AS CodPuestoFuncionario,
		PT.TC_CodPuestoTrabajo			AS CodigoPuestoTrabajo,
		FF.TC_Nombre					AS NombreAsignado,
		FF.TC_PrimerApellido			AS Apellido1Asignado,
		FF.TC_SegundoApellido			AS Apellido2Asignado,
		EA.TF_Inicio_Vigencia			AS InicioVigencia

	From		[Expediente].[SolicitudDefensor]				As	SD 								WITH (NOLOCK)		
	Inner Join	[Catalogo].[Oficina]							As	OFS								WITH (NOLOCK)
	On			OFS.[TC_CodOficina]								=	SD.TC_CodOficinaSolicita
	Inner Join	[Catalogo].[Oficina]							As	OFD								WITH (NOLOCK)
	On			OFD.[TC_CodOficina]								=	SD.TC_CodOficinaDefensa
	Inner Join  [Catalogo].[Funcionario]						As	F								WITH (NOLOCK)
	On			F.[TC_UsuarioRed]								=	SD.TU_UsuarioRedSolicita     
    left Join	[Expediente].[SolicitudDefensorInterviniente]	As  SDI								WITH (NOLOCK)
	On			SDI.[TU_CodSolicitudDefensor]					=	SD.TU_CodSolicitudDefensor  
	left  join  [Expediente].[Interviniente]					As  I								WITH (NOLOCK)
	On          SDI.[TU_CodInterviniente]						=	I.TU_CodInterviniente
	INNER JOIN	[Catalogo].[PuestoTrabajoFuncionario]			AS	PF								WITH (NOLOCK)	
	ON			SD.TC_CodPuestoTrabajo							=	PF.TC_CodPuestoTrabajo	
	AND			PF.TU_CodPuestoFuncionario						=	(SELECT TOP 1 H.TU_CodPuestoFuncionario 
																	FROM Catalogo.PuestoTrabajoFuncionario H WITH (NOLOCK)	
																	WHERE H.TC_CodPuestoTrabajo = SD.TC_CodPuestoTrabajo 
																	AND	(H.TF_Fin_Vigencia IS NULL OR H.TF_Fin_Vigencia > GETDATE()))	
	INNER JOIN	[Catalogo].[PuestoTrabajo]						AS	PT								WITH (NOLOCK)	
	ON			PF.TC_CodPuestoTrabajo							=	PT.TC_CodPuestoTrabajo
	INNER JOIN	[Catalogo].[Funcionario]						AS	FF								WITH (NOLOCK)
	ON			PF.TC_UsuarioRed								=	FF.TC_UsuarioRed	
	INNER JOIN    Historico.ExpedienteAsignado					EA WITH(NOLOCK)
	ON            EA.TC_NumeroExpediente						= SD.TC_NumeroExpediente
	AND           EA.TF_Inicio_Vigencia							<= GETDATE()
	AND            (
                EA.TF_Fin_Vigencia								IS NULL
   OR
                EA.TF_Fin_Vigencia								<= GETDATE()
            )
	AND            EA.TC_CodPuestoTrabajo					= SD.TC_CodPuestoTrabajo

	INNER JOIN    Catalogo.PuestoTrabajoFuncionario    C WITH(NOLOCK)
	ON            C.TC_CodPuestoTrabajo                = EA.TC_CodPuestoTrabajo
	AND            EA.TF_Inicio_Vigencia                <= GETDATE()
	AND            (
					EA.TF_Fin_Vigencia                IS NULL
				OR
					EA.TF_Fin_Vigencia                <= GETDATE()
				)
	INNER JOIN    Catalogo.Funcionario                D WITH(NOLOCK)
	ON            D.TC_UsuarioRed                        = C.TC_UsuarioRed

	WHERE   (
				SD.[TU_CodSolicitudDefensor]					= Coalesce(@CodSolicitudDefensor,SD.TU_CodSolicitudDefensor) 
				OR SD.[TU_CodSolicitudDefensor]					IS null
			)
	AND		SD.[TC_NumeroExpediente]							= COALESCE(@NumeroExpediente,SD.TC_NumeroExpediente)
	AND     ( 
				SDI.[TU_CodInterviniente]						= Coalesce(@CodInterviniente,SDI.TU_CodInterviniente)
				OR  SDI.[TU_CodInterviniente]						IS null
				AND @CodInterviniente								IS null
			)	
End


GO
