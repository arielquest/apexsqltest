SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<23/10/2018>
-- Descripción :			<Permite actualizar el número de expediente en la tabla ArchivoExpeidiente> 
-- =================================================================================================================================================
-- Modificacion:			<Jonathan Aguilar Navarro> <07/08/2019> <Se elimina la insercion en la tabla LegajoArchivo, se elimina parametro Legajo>
-- Modificacion:			<Isaac Dobles Mata> <07/10/2020> <Se agrega el consecutivo del historial procesal, se agrega variables locales y se quita TRAN>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ActualizarArchivoExpedienteNumeroExpediente]
	@CodArchivo				uniqueidentifier,
	@NumeroExpediente		varchar(15),
	@GrupoTrabajo			smallint,
	@Notifica				bit,
	@Eliminado				bit,
	@Consecutivo			int = null
AS  
BEGIN  
	DECLARE	@L_TU_CodArchivo			uniqueidentifier		= @CodArchivo,
			@L_TC_NumeroExpediente		varchar(15)				= @NumeroExpediente,
			@L_TN_CodGrupoTrabajo		smallint				= @GrupoTrabajo,
			@L_TB_Notifica				bit						= @Notifica,
			@L_TB_Eliminado				bit						= @Eliminado,
			@L_TN_Consecutivo			int						= @Consecutivo
			
	INSERT INTO Expediente.ArchivoExpediente
	(
			TU_CodArchivo,
			TC_NumeroExpediente,
			TN_CodGrupoTrabajo,
			TB_Notifica,
			TB_Eliminado, 
			TN_Consecutivo
	)
	VALUES
	(
			@L_TU_CodArchivo,							
			@L_TC_NumeroExpediente,		
			@L_TN_CodGrupoTrabajo,			
			@L_TB_Notifica,				
			@L_TB_Eliminado,
			@L_TN_Consecutivo
	)	
END
GO
