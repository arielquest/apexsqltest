SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<15/01/2019>
-- Descripción :			<Permite mover archivos entre expedientes> 
-- =================================================================================================================================================
-- Modificación				<Jonathan Aguilar Navarro> <22/08/2019> <Se elimina el insert y delete en LegajoArchivo, ya que para
--							archivos de expediente no aplica.> 
-- Modificación:			<Jonathan Aguilar Navarro> <27/08/2019> <Se valida si el documento existe para insertalo o no>
-- Modificación:			<Aida Elena Siles R> <06/10/2020> <Se agrega parámetro de consecutivo historial procesal>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_MoverArchivoExpediente]
	@CodArchivo						UNIQUEIDENTIFIER,
	@NumeroExpediente				VARCHAR(14),
	@GrupoTrabajo					SMALLINT,
	@Notifica						BIT,
	@Eliminado						BIT,
	@ConsecutivoHistorialProcesal	INT = NULL
AS
BEGIN
	--Variables  
	 DECLARE 
	 @L_CodArchivo					 UNIQUEIDENTIFIER		= @CodArchivo,    
	 @L_NumeroExpediente			 VARCHAR(14)			= @NumeroExpediente,
	 @L_GrupoTrabajo				 SMALLINT				= @GrupoTrabajo,
	 @L_Notifica					 BIT					= @Notifica,
	 @L_Eliminado					 BIT					= @Eliminado,
	 @L_ConsecutivoHistorialProcesal INT					= @ConsecutivoHistorialProcesal,
	 @L_NumeroExpedienteAcumula		 VARCHAR(14)
	--LÓGICA
	BEGIN
		SET @L_NumeroExpedienteAcumula =(SELECT TC_NumeroExpediente 
										 FROM Historico.ExpedienteAcumulacion 
										 WHERE TC_NumeroExpedienteAcumula = @L_NumeroExpediente 
										 AND TF_InicioAcumulacion = (SELECT MAX(TF_InicioAcumulacion) 
																	 FROM Historico.ExpedienteAcumulacion 
																	 WHERE TC_NumeroExpedienteAcumula = @L_NumeroExpediente 
																	 AND TF_FinAcumulacion IS NULL))

		IF NOT EXISTS (SELECT TC_NumeroExpediente 
					   FROM Expediente.ArchivoExpediente 
					   WHERE TU_CodArchivo = @L_CodArchivo
					   AND TC_NumeroExpediente = @L_NumeroExpedienteAcumula)
		BEGIN
			INSERT INTO Expediente.ArchivoExpediente WITH(ROWLOCK)
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
				@L_CodArchivo,
				@L_NumeroExpedienteAcumula,
				@L_GrupoTrabajo,
				@L_Notifica,
				@L_Eliminado,
				@L_ConsecutivoHistorialProcesal
			)	
		END

	UPDATE  Expediente.ArchivoExpediente WITH(ROWLOCK)
	SET		TB_Eliminado = 1
	WHERE	TU_CodArchivo			=	@L_CodArchivo	
	AND		TC_NumeroExpediente		= 	@L_NumeroExpediente

	END
END
GO
