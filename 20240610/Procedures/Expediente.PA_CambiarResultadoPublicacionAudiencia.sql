SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Andrew Allen Dawson>
-- Fecha de creación:	<05/02/2020>
-- Descripción:			<Permite cambiar es estado de publicación de una audiencia.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_CambiarResultadoPublicacionAudiencia]
   @CodAudiencia bigint,
   @NombreArchivo varchar(255),
   @EstadoPublicacion smallint
AS 
UPDATE [Expediente].[Audiencia]
   SET [TN_EstadoPublicacion] = @EstadoPublicacion
      ,[TC_NombreArchivo] = @NombreArchivo
 WHERE [TN_CodAudiencia] = @CodAudiencia
GO
