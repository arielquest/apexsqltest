SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:		   <Isaac Dobles Mata>
-- Fecha Creación: <20/04/2020>
-- Descripcion:	   <Asociar una intervención a un documento>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_AgregarIntervencionArchivo] 
       @CodArchivo 						uniqueidentifier,
       @CodIntervencion 				uniqueidentifier
AS

BEGIN
		DECLARE
		@L_TU_CodArchivo						uniqueidentifier = @CodArchivo,
		@L_TU_CodInterviniente					uniqueidentifier = @CodIntervencion

		INSERT INTO [Expediente].[IntervencionArchivo] 
           (
			   [TU_CodArchivo],
			   [TU_CodInterviniente]
		   )
		VALUES
           (	
			   @L_TU_CodArchivo,
			   @L_TU_CodInterviniente
		   )
END
GO
