SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Jonathan Aguilar Navarro>
-- Fecha Creación: <31/08/2018>
-- Descripcion:	   <Permite consultar si el firmante es el ultimo que debe de firmar>
-- =================================================================================================================================================
-- Modificación	   <Jonathan Aguilar Navarro> <27/09/2018> <Se cambia el esquema de la tablas por Archivo.> 
CREATE PROCEDURE [Expediente].[PA_ConsultarUltimoFirmante]
	@CodAsignacionFirmado uniqueidentifier,
	@CodPuestoTrabajo VARCHAR(14)
AS

BEGIN
DECLARE @MaxOrden INT

SELECT @MaxOrden = (SELECT MAX(TN_Orden) 
				   FROM Archivo.AsignacionFirmante AS A 
				   WHERE A.TU_CodAsignacionFirmado =@CodAsignacionFirmado)

SELECT			TU_CodAsignacionFirmado As Codigo,
				TN_Orden				AS Orden,
				'Split'					AS Split,
				TC_CodPuestoTrabajo		AS Codigo
				FROM Archivo.AsignacionFirmante AS B 
				WHERE B.TU_CodAsignacionFirmado =@CodAsignacionFirmado
				AND B.TC_CodPuestoTrabajo= @CodPuestoTrabajo 
				and TN_Orden = @MaxOrden
END
GO
