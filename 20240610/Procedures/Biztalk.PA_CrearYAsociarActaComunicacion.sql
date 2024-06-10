SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--====================================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Olger Gamboa>
-- Fecha de creación:		<02/06/2021>
-- Descripción:				<Asocia el codigo del documento del acta con la comunicación judicial. este sp es usado por el negocio para generar la devolución con biztalk server> 
-- ===================================================================================================================================================================================================
-- Modificación				<20/09/2021> <Isaac Dobles Mata> <Se elimina manejo de transacciones>
-- ===================================================================================================================================================================================================

CREATE PROCEDURE [Biztalk].[PA_CrearYAsociarActaComunicacion]
(
	@CodArchivoFS   			uniqueidentifier,
	@CodComunicacion			uniqueidentifier,	
	@Descripcion			    varchar(255),
	@CodOficinaOCJ  			varchar(4),
	@CodFormatoArchivo			smallint, 
	@UsuarioCrea				varchar(30),	
	@CodGrupoTrabajo			smallint,
	@CodEstado					tinyint
)
AS
BEGIN

	DECLARE @L_NumeroExpediente char(14)
	DECLARE	@L_ConsecutivoHistorialProcesal int
	DECLARE	@L_FormatoJuridicoActaNotificacion int
	DECLARE @L_CodLegajo					UNIQUEIDENTIFIER =NULL;

		--Se Obtiene el numero de expediente de la comunicación
			SELECT  @L_NumeroExpediente			=			TC_NumeroExpediente,
					@L_CodLegajo				=			TU_CodLegajo
			FROM	Comunicacion.Comunicacion WITH(NOLOCK)
			WHERE	TU_CodComunicacion			=			@CodComunicacion
		
		--Generamos el consecutivo para el documento de historial procesal
			EXEC	@L_ConsecutivoHistorialProcesal = [Expediente].[PA_GenerarConsecutivoHistorialProcesal]
			@NumeroExpediente = @L_NumeroExpediente,
			@CodigoLegajo = @L_CodLegajo
		--Se busca el formato jurídico con que se deben registrar las actas C_FORMATO_ACTA_NOTIFICACION
			SELECT TOP 1 @L_FormatoJuridicoActaNotificacion= TC_Valor 
			FROM Configuracion.ConfiguracionValor
			WHERE TC_CodConfiguracion='C_FORMATO_ACTA_NOTIFICACION'
		-- se inicia operación
			INSERT INTO Archivo.Archivo
			(
				TU_CodArchivo,			TC_Descripcion,				TC_CodContextoCrea,
				TN_CodFormatoArchivo,	TC_UsuarioCrea,				TF_FechaCrea,
				TN_CodEstado,			TC_CodFormatoJuridico
			)
			VALUES
			(
				@CodArchivoFS,			@Descripcion,				@CodOficinaOCJ,
				@CodFormatoArchivo,		@UsuarioCrea,				GetDate(),
				@CodEstado,				@L_FormatoJuridicoActaNotificacion
				
			)
			
			INSERT INTO Expediente.ArchivoExpediente
			(
				TU_CodArchivo,			TC_NumeroExpediente,		TN_CodGrupoTrabajo,
				TB_Notifica,			TB_Eliminado,				TN_Consecutivo
			)
			VALUES
			(
				@CodArchivoFS,			@L_NumeroExpediente,		@CodGrupoTrabajo,
				0,						0,							@L_ConsecutivoHistorialProcesal
			)
			--En caso de que el legajo venga es porque es una notificación de un legajo por lo que se le 
			--registra el documento al legajo
			IF @L_CodLegajo IS NOT NULL
			BEGIN
				Insert Into Expediente.LegajoArchivo 
				(
					TU_CodArchivo,    	     TU_CodLegajo, TC_NumeroExpediente   										
				)
				VALUES
				(
					@CodArchivoFS,    		@L_CodLegajo,	@L_NumeroExpediente  										      			    										
				)	
			END
			Insert Into	Comunicacion.ArchivoComunicacion
			(
				TU_CodArchivoComunicacion,	TU_CodComunicacion,			TB_EsActa,
				TF_FechaAsociacion,			TU_CodArchivo,				TB_EsPrincipal
			)
			Values
			(
				NEWID(),					@CodComunicacion,			1,
				GetDate(),					@CodArchivoFS,				0	
			)
END
GO
