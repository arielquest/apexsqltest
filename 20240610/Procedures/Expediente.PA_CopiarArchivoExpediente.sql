SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<15/01/2019>
-- Descripción :			<Permite copiar archivos entre expedientes> 
-- =================================================================================================================================================
-- Modificación:			<Jonathan Aguilar Navarro> <22/08/2019> <Se elimina el insert y delete en LegajoArchivo, ya que para
--							archivos de expediente no aplica.> 
-- Modificación:            <Aida Elena Siles R> <06/10/2020> <Se agrega parámetro de consecutivo historial procesal>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_CopiarArchivoExpediente]
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
END
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
	
END
GO
