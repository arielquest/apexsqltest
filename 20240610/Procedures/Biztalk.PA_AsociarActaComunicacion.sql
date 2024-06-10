SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


--=======================================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<12/09/2017>
-- Descripción:				<Asocia el codigo del documento del acta con la comunicación judicial. El documento se encuentra almacenado en una base de datos SQL FileStream> 
-- Modificación				<Isaac Dobles Mata> <28/09/2018> <Se modifica para insertar en tablas Archivo.Archivo y Expediente.ArchivoExpediente>
-- Versión:					<1.2>
-- Modificación				<Olger Gamboa Castillo> <27/05/2021> Se modifica para que contemple el consecutivo de historial procesal y se obtenga correctamente el número de expediente
-- Modificación				<Olger Gamboa Castillo> <01/06/2021> Se modifica parámetro codlegajo ya que biztalk no envía el parámetro.
-- Modificación				<Olger Gamboa Castillo> <04/06/2021> Se agrega instrucción SET NOCOUNT ON;
-- Modificación				<Olger Gamboa Castillo> <06/06/2021> Se incorpora instrucciones de historial procesal para no llamar SP;
-- Modificación				<Esteban Cordero Benavides y Ronny Ramírez R.> <05/07/2021> Se aplican mejoras al SP para evitar errores de bloqueos, código repetido y problemas con transacciones externas
-- Modificación				<Isaac Dobles Mata.> <20/09/2021> Se elimina manejo de transacciones para que sea realizado por Biztalk;
-- Modificación:		    <Josué Quirós Batista> <13/09/2022> <Se modifica el select que obtiene el consecutivo del historial procesal de un expediente para obtener un único valor.>
-- =======================================================================================================================================================================================================

CREATE PROCEDURE [Biztalk].[PA_AsociarActaComunicacion]
(
	@CodArchivoFS   			UNIQUEIDENTIFIER,
	@CodComunicacion			UNIQUEIDENTIFIER,	
	@Descripcion			    VARCHAR(255),
	@CodOficinaOCJ  			VARCHAR(4),
	@CodFormatoArchivo			SMALLINT, 
	@UsuarioCrea				VARCHAR(30),	
	@CodGrupoTrabajo			SMALLINT,
	@CodEstado					TINYINT
)
AS
BEGIN
		SET NOCOUNT ON;
		DECLARE @L_NumeroExpediente					CHAR(14),
			@L_ConsecutivoHistorialProcesal		INT = 1,
			@L_FormatoJuridicoActaNotificacion	INT,
			@L_CodLegajo						UNIQUEIDENTIFIER =NULL,
			@L_CodConsecutivo					UNIQUEIDENTIFIER,
			@L_CodFormatoArchivo				INT	= @CodFormatoArchivo;

			--Se Obtiene el numero de expediente de la comunicación
			SELECT  @L_NumeroExpediente			= A.TC_NumeroExpediente,
					@L_CodLegajo				= A.TU_CodLegajo
			FROM	Comunicacion.Comunicacion	A WITH(NOLOCK)
			WHERE	A.TU_CodComunicacion		= @CodComunicacion;

			--Obtener consecutivo historial procesal
			SELECT	Top 1 @L_CodConsecutivo					 = A.TU_CodHistorialConsecutivo 
			FROM	Expediente.ConsecutivoHistorialProcesal  A WITH(NOLOCK)
			WHERE	A.TC_NumeroExpediente					= @L_NumeroExpediente 			
			AND     
			(
				(
					@L_CodLegajo						IS NOT NULL 
					AND
					A.TU_CodLegajo						= @L_CodLegajo
				)

				OR

				(
					@L_CodLegajo IS NULL 
					AND
					A.TU_CodLegajo						IS NULL
				)
			)
			Order by		TN_Consecutivo Desc,		TF_Actualizacion Desc
						
			--
			IF @L_CodConsecutivo IS NULL
			BEGIN
				INSERT INTO	Expediente.ConsecutivoHistorialProcesal WITH(ROWLOCK)
				(
					TU_CodHistorialConsecutivo,	TC_NumeroExpediente,	TU_CodLegajo
				)
				VALUES
				(
					NEWID(),					@L_NumeroExpediente,	@L_CodLegajo
				)
			END ELSE
			BEGIN
				UPDATE	Expediente.ConsecutivoHistorialProcesal WITH(ROWLOCK)
				SET		TN_Consecutivo							= TN_Consecutivo + 1, 
						@L_ConsecutivoHistorialProcesal			= TN_Consecutivo,
						TF_Actualizacion						= GETDATE()
				WHERE	TU_CodHistorialConsecutivo				= @L_CodConsecutivo
				--
				SELECT	@L_ConsecutivoHistorialProcesal			= TN_Consecutivo 
				FROM	Expediente.ConsecutivoHistorialProcesal WITH(NOLOCK)
				WHERE	TU_CodHistorialConsecutivo				= @L_CodConsecutivo
			END

			--Se busca el formato jurídico con que se deben registrar las actas C_FORMATO_ACTA_NOTIFICACION
			SELECT TOP 1	@L_FormatoJuridicoActaNotificacion	= TC_Valor 
			FROM			Configuracion.ConfiguracionValor	WITH(NOLOCK)
			WHERE			TC_CodConfiguracion					= 'C_FORMATO_ACTA_NOTIFICACION'

			--Se busca el formato de archivo con que se deben registrar las actas C_FORMATO_ACTA_NOTIFICACION
			SELECT TOP 1	@L_CodFormatoArchivo	= TC_Valor 
			FROM			Configuracion.ConfiguracionValor	WITH(NOLOCK)
			WHERE			TC_CodConfiguracion					= 'C_FORMATOARCHIVO_ACTA_NOTIFICACION'

			-- se inicia operación
			INSERT INTO Archivo.Archivo WITH(ROWLOCK)
			(
				TU_CodArchivo,			TC_Descripcion,						TC_CodContextoCrea,
				TN_CodFormatoArchivo,	TC_UsuarioCrea,						TF_FechaCrea,
				TN_CodEstado,			TC_CodFormatoJuridico
			)
			VALUES
			(
				@CodArchivoFS,			@Descripcion,						@CodOficinaOCJ,
				@L_CodFormatoArchivo,		@UsuarioCrea,						GETDATE(),
				@CodEstado,				@L_FormatoJuridicoActaNotificacion
				
			)
			--
			INSERT INTO Expediente.ArchivoExpediente WITH(ROWLOCK)
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
				INSERT INTO Expediente.LegajoArchivo  WITH(ROWLOCK)
				(
					TU_CodArchivo,    	     TU_CodLegajo, TC_NumeroExpediente   										
				)
				VALUES
				(
					@CodArchivoFS,    		@L_CodLegajo,	@L_NumeroExpediente  										      			    										
				)	
			END
			INSERT INTO Comunicacion.ArchivoComunicacion  WITH(ROWLOCK)
			(
				TU_CodArchivoComunicacion,	TU_CodComunicacion,			TB_EsActa,
				TF_FechaAsociacion,			TU_CodArchivo,				TB_EsPrincipal
			)
			VALUES
			(
				NEWID(),					@CodComunicacion,			1,
				GETDATE(),					@CodArchivoFS,				0	
			)
END
GO
