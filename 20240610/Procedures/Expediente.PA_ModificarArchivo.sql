SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Donald Vargas>
-- Fecha de creación:		<26/04/2016>
-- Descripción :			<Permite Modificar un LegajoArchivo> 
-- =================================================================================================================================================
-- Modificación:    <Donald Vargas> <05/05/2016> <Se agrega los campos de grupo de trabajo y estado>
-- Modificación:	<Johan Acosta> <05/12/2016> <Se cambio nombre de TC a TN>
-- Modificación:	<Tatiana Flores> <03/10/2017> <Se cambia para que no actualice los campos @CodLegajo, @CodOficinaCrea, @CodFormatoArchivo si vienen nulos>
-- Modificación:	<Jonathan Aguilar Navarro> <30/04/2018> <Se cambio el campo TC_CodOficinaCrea por TC_CodContextoCrea>
-- Modificación:	<Isaac Dobles> <14/09/2018> <Se cambia nombre de SP por PA_ModificarArchivo y se actualiza para ajustarse a los cambios de análisis archivos sin expediente>
-- Modificación:	<Jonathan Aguilar Navarro> <28/09/2018> <Se actualizar el esquema de la tabla Archivo.Archivo, ademas se corrige el nombre del parametro CodGupoTrabajo por CodGrupoTrabajo> 
-- Modificación:	<Isaac Dobles Mata> <15/04/2020> <Se agrega TN_Consecutivo>
-- Modificación:	<Isaac Dobles> <29/05/2020> <Se agregan variables locales>
-- Modificación:	<Andrew Allen Dawson> <22/08/2020> <Se Agrega la funcion COALESCE sobre los campos a ser actualizados>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarArchivo]
	@CodArchivo						uniqueidentifier,
	@Descripcion					varchar(255) = null,
	@CodContextoCrea				varchar(4)	=	null,
	@CodFormatoArchivo				int			=	null, 
	@UsuarioCrea					varchar(30) = null,
	@FechaCrea						datetime2(7) = null,
	@CodEstado						tinyint = null,
	@NumeroExpediente				char(14) = null,
	@CodGrupoTrabajo				smallint = null,
	@Notifica						bit = null, 
	@Eliminado						bit = null,
	@ConsecutivoHistorialProcesal	int = null
AS  
BEGIN  

	DECLARE 
	@L_TU_CodArchivo					uniqueidentifier		= @CodArchivo,    
	@L_TC_Descripcion					varchar(255)            = @Descripcion,
	@L_TC_CodContextoCrea				varchar(4)				= @CodContextoCrea, 
	@L_TN_CodFormatoArchivo				int						= @CodFormatoArchivo,    
	@L_TC_UsuarioCrea					varchar(30)				= @UsuarioCrea,    
	@L_TF_FechaCrea						datetime2(7)			= @FechaCrea,
	@L_TN_CodEstado						tinyint					= @CodEstado,
	@L_TC_NumeroExpediente				char(14)				= @NumeroExpediente,
	@L_TN_CodGrupoTrabajo				smallint				= @CodGrupoTrabajo,
	@L_TB_Notifica						bit						= @Notifica,
	@L_TB_Eliminado						bit						= @Eliminado,
	@L_TN_Consecutivo					int						= @ConsecutivoHistorialProcesal

	Update	Archivo.Archivo
	Set		@CodArchivo							=	@L_TU_CodArchivo,		
			TC_Descripcion						=	COALESCE(@L_TC_Descripcion, TC_Descripcion),
			TC_CodContextoCrea					=	COALESCE( @L_TC_CodContextoCrea,TC_CodContextoCrea),
			TN_CodFormatoArchivo				=	COALESCE(@L_TN_CodFormatoArchivo,TN_CodFormatoArchivo),
			TC_UsuarioCrea						=	COALESCE(@L_TC_UsuarioCrea, TC_UsuarioCrea),
			TF_FechaCrea						=	COALESCE(@L_TF_FechaCrea, TF_FechaCrea),
			TN_CodEstado						=	COALESCE(@L_TN_CodEstado, TN_CodEstado),
			TF_Actualizacion					=	Getdate()
						
	Where	TU_CodArchivo						=	@L_TU_CodArchivo
	
	UPDATE	Expediente.ArchivoExpediente
	SET		TC_NumeroExpediente					= 	COALESCE(@L_TC_NumeroExpediente, TC_NumeroExpediente),	
			TN_CodGrupoTrabajo 					= 	COALESCE(@L_TN_CodGrupoTrabajo, TN_CodGrupoTrabajo),
			TB_Notifica							=	COALESCE(@L_TB_Notifica, TB_Notifica),
			TB_Eliminado						=	COALESCE(@L_TB_Eliminado, TB_Eliminado),
			TN_Consecutivo						=	COALESCE(@L_TN_Consecutivo, TN_Consecutivo)
	WHERE	TU_CodArchivo						=	@L_TU_CodArchivo

End

GO
