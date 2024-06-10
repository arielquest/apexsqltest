SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<27/02/2020>
-- Descripción :			<Permite consultar las resoluciones pendientes de enviar para consultas.>
-- =================================================================================================================================================
-- Modificación:			<Isaac Dobles Mata> <21/05/2021> <Limita a 1000 cantidad de registros, se ordena por fecha de modificación.>
-- =================================================================================================================================================
CREATE PROCEDURE [Consulta].[PA_ConsultarResolucionesEnviar]
AS
BEGIN
	
			SELECT TOP 1000
			[TU_CodArchivo], 
			[TC_Estado]

			FROM [Consulta].[ArchivoConsulta]
			WHERE	[TC_Estado]						= 'P'
			ORDER BY [TF_FechaModificacion] ASC

END
GO
