SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V.>
-- Fecha Creaci�n: <31/10/2017>
-- Descripcion:	   <Corrige un documento en una asignaci�n de firma>
-- =================================================================================================================================================
-- Modificación	   <Jonathan Aguilar Navarro> <17/09/2018> <Se crea el esquema Archivo y se renombre respectivamente en los sp y tablas> 

CREATE PROCEDURE [Archivo].[PA_CorregirLegajoArchivoAsignado]
	@CodAsignacionFirmado uniqueidentifier,
	@CodCorregidoPor uniqueidentifier,
	@EstadoCorregir VARCHAR(2)
	
WITH RECOMPILE
AS
BEGIN

UPDATE	Archivo.AsignacionFirmado
   SET	TC_Estado = @EstadoCorregir,
		TU_CorregidoPor = @CodCorregidoPor
 WHERE  TU_CodAsignacionFirmado = @CodAsignacionFirmado

END

GO
