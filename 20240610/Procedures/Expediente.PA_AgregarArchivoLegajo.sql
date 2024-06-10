SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:		   <Isaac Dobles Mata>
-- Fecha Creación: <30/05/2019>
-- Descripcion:	   <Agregar un archivo a un legajo>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_AgregarArchivoLegajo] 
       @CodArchivo 						uniqueidentifier,
       @CodLegajo 						uniqueidentifier,
       @NumeroExpediente 				char(14)
AS

BEGIN
		INSERT INTO [Expediente].[LegajoArchivo]
           (
			   [TU_CodArchivo],
			   [TU_CodLegajo],
			   [TC_NumeroExpediente]
		   )
     VALUES
           (	
			   @CodArchivo,
			   @CodLegajo,
			   @NumeroExpediente
		   )
END
GO
