SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Stefany Quesada>
-- Fecha de creación:		<15/05/2016>
-- Descripción:				<Permite modificar una solicitud a [Expediente].[SolicitudDefensor].>
-- Modificación:            <24/06/2017>
-- Descripción:				<se elimina el parametro @fechacreacion ya que no es editable
-- Modificación:			<Jonathan Aguilar Navarro> <21/10/2020> <se cambia el parámetro Responsable por CodigoPuestoTrabajo, ademas se agregar la FechaIniciovigencia> 
-- ===========================================================================================
CREATE Procedure [Expediente].[PA_ModificarSolicitudDefensor]
	 @CodigoSolicitudDefensor     Uniqueidentifier,		
	 @EstadoSolicitud             Varchar(1),
	 @TipoSolicitud               Varchar(1),
	 @CodPuestoTrabajo			  Varchar(14),
	 @UsuarioRedSolicita          Varchar(30),
	 @Observaciones               Varchar(255),
	 @LugarDiligencia             Varchar(100),
	 @CodigoEvento                Uniqueidentifier,
	 @CodigoArchivo               Uniqueidentifier,
	 @FechaEnvio                  Datetime2(7),
	 @FechaActualizacion          Datetime2(7),
	 @OficinaSolicita			  Varchar(4),
	 @OficinaDefensa			  Varchar(4),
	 @FechaInicioVigencia		  datetime2(7)
As
Begin

	Declare @L_CodigoSolicitudDefensor   Uniqueidentifier	= @CodigoSolicitudDefensor   
	Declare @L_EstadoSolicitud           Varchar(1)			= @EstadoSolicitud           
	Declare @L_TipoSolicitud             Varchar(1)			= @TipoSolicitud             
	Declare @L_CodPuestoTrabajo			 Varchar(14)		= @CodPuestoTrabajo			
	Declare @L_UsuarioRedSolicita        Varchar(30)		= @UsuarioRedSolicita        
	Declare @L_Observaciones             Varchar(255)		= @Observaciones             
	Declare @L_LugarDiligencia           Varchar(100)		= @LugarDiligencia           
	Declare @L_CodigoEvento              Uniqueidentifier	= @CodigoEvento              
	Declare @L_CodigoArchivo             Uniqueidentifier	= @CodigoArchivo             
	Declare @L_FechaEnvio                Datetime2(7)		= @FechaEnvio                
	Declare @L_FechaActualizacion        Datetime2(7)		= @FechaActualizacion        
	Declare @L_OficinaSolicita			 Varchar(4)			= @OficinaSolicita			
	Declare @L_OficinaDefensa			 Varchar(4)			= @OficinaDefensa			
	Declare @L_FechaInicioVigencia		 datetime2(7)		= @FechaInicioVigencia		

	update  [Expediente].[SolicitudDefensor]
	set	
	
		TC_EstadoSolicitudDefensor  =    @EstadoSolicitud, 
		TC_TipoSolicitudDefensor    =    @TipoSolicitud, 
		TC_CodPuestoTrabajo			=    @CodPuestoTrabajo, 
		TU_UsuarioRedSolicita       =    @UsuarioRedSolicita, 
		TC_Observaciones            =    @Observaciones, 
		TC_LugarDiligencia          =    @LugarDiligencia, 
		TU_Evento                   =    @CodigoEvento, 
		TU_CodArchivo               =    @CodigoArchivo,  
		TF_FechaEnvio               =    @FechaEnvio,
        TF_Actualizacion            =    @FechaActualizacion,
		TC_CodOficinaSolicita		=	 @OficinaSolicita,
		TC_CodOficinaDefensa		=	 @OficinaDefensa ,
		TF_Inicio_Vigencia			=	@L_FechaInicioVigencia
	  
	where
	TU_CodSolicitudDefensor         =    @CodigoSolicitudDefensor 

End

GO
