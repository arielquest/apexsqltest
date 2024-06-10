SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V>
-- Fecha Creación: <13/09/2017>
-- Descripcion:	   Agregar el detalle de los firmantes en la asignación de la firma de documentos en el expediente
-- =================================================================================================================================================
-- Modificación		<Jonathan Aguilar Navarro> <17/07/2018> <Se agregan los campos TB_Nota,TB_Salva y JustificacionSalvaVotoNota>

CREATE PROCEDURE [Expediente].[PA_AgregarExpedienteAsignacionFirmante] 
	   @CodAsignacionFirmado		uniqueidentifier,
       @CodPuestoTrabajo			varchar(14),
       @Orden						tinyint,
	   @FirmadoPor					uniqueidentifier,
	   @Salva						bit,
	   @Nota						bit,
	   @JustificacionSalvaVotoNota varchar (max)
AS

BEGIN
	INSERT INTO [Expediente].[AsignacionFirmante]
				([TU_CodAsignacionFirmado]
				,[TC_CodPuestoTrabajo]
				,[TN_Orden]
				,[TU_FirmadoPor]
				,[TB_Salva]
				,[TB_Nota]
				,[TC_JustificacionSalvaVotoNota])
     VALUES
			(	
				@CodAsignacionFirmado,
				@CodPuestoTrabajo,
				@Orden,
				@FirmadoPor,
				@Salva,
				@Nota,
				@JustificacionSalvaVotoNota)
	END
GO
