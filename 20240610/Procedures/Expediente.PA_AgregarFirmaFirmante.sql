SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V.>
-- Fecha Creación: <13/10/2017>
-- Descripcion:	   <Guarda la información de la aplicación de la firma de un firmante>
-- =================================================================================================================================================
-- Modificación:	<Jonathan Aguilar Navarro> <31/08/2018> <Se agregar los parametros @EstadoDocTerminado,@EstadoFirmaTerminada@EsUltimoFirmante>
--					para saber si es el ultimo firmante y actualizar los estado del LegajoArchivo y AsignaciónFirmado 
-- Modificación:	<Jonathan Aguilar Navarro> <27/09/2018> <Se cambia el esquema de las tablas por Archivo, además se cambia la tabla por Archivo.Archivo>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarFirmaFirmante]
	@CodAsignacionFirmado uniqueidentifier,
	@CodPuestoTrabajo VARCHAR(14),
	@FechaAplicado datetime2,
	@CodFirmadoPor uniqueidentifier,
	@CodArchivOriginal uniqueidentifier,
	@EstadoDocTerminado tinyint,
	@EstadoFirmaTerminada char(1),
	@EsUltimoFirmante bit
AS

BEGIN
DECLARE @MaxOrden INT,
	    @Orden INT

UPDATE Archivo.AsignacionFirmante
   SET	TF_FechaAplicado = @FechaAplicado,
		TU_FirmadoPor = @CodFirmadoPor
 WHERE  Archivo.AsignacionFirmante.TU_CodAsignacionFirmado = @CodAsignacionFirmado 
		AND Archivo.AsignacionFirmante.TC_CodPuestoTrabajo= @CodPuestoTrabajo


--Se verifica: si es el ultimo firmante se debe cambiar el documento RTF por el PDF y se actualiza el estado a TERMINADO.
IF (@EsUltimoFirmante = 1)
BEGIN
	UPDATE Archivo.Archivo
	SET    TN_CodEstado = @EstadoDocTerminado
	WHERE  TU_CodArchivo = @CodArchivOriginal
	
	UPDATE [Archivo].AsignacionFirmado
	SET 	[TC_Estado] =@EstadoFirmaTerminada   
	WHERE 
			@CodAsignacionFirmado = TU_CodAsignacionFirmado AND 
			TU_CodArchivo = @CodArchivOriginal
END

END

GO
