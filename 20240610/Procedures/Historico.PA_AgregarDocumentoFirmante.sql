SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Autor:		   <Jonahtan Aguilar Navarro>
-- Fecha Creación: <07/09/208>
-- Descripcion:	   <Agregar los datos al Historico.DocumentoFirmante>
-- =================================================================================================================================================
-- Modificación:	<Jonathan Aguilar Navaro> <28/09/2018> <Se actualiza el nombre dle campo TU_FirmadoPor> 

CREATE PROCEDURE [Historico].[PA_AgregarDocumentoFirmante] 
	   @CodArchivo					uniqueidentifier,
	   @FirmadoPor					uniqueidentifier,
	   @Orden						tinyint,
	   @FechaAplicado				datetime2,
	   @CodAsignacionFirmado		uniqueidentifier,
	   @Salva						bit,
	   @Nota						bit,
	   @JustificacionSalvaVotoNota varchar (max)
AS

BEGIN
	INSERT INTO [Historico].[DocumentoFirmante]
				([TU_CodArchivo],
				[TU_FirmadoPor],
				[TN_Orden],
				[TF_FechaAplicado],
				[TU_CodAsignacionFirmado],
				[TB_Salva],
				[TB_Nota],
				[TC_JustificacionSalvaVotoNota])
     VALUES
			(
				@CodArchivo,
				@FirmadoPor,
				@Orden,
				@FechaAplicado,
				@CodAsignacionFirmado,
				@Salva,
				@Nota,
				@JustificacionSalvaVotoNota	
			)
	END
GO
