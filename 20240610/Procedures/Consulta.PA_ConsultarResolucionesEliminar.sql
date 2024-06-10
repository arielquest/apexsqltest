SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<10/03/2020>
-- Descripción :			<Permite consultar las resoluciones pendientes de eliminar para consultas.>
-- =================================================================================================================================================
-- Modificación:			<Isaac Dobles Mata> <21/05/2021> <Limita a 1000 cantidad de registros, se ordena por fecha de modificación.>
-- =================================================================================================================================================

CREATE PROCEDURE [Consulta].[PA_ConsultarResolucionesEliminar]
AS
BEGIN
	
			SELECT 
			[TU_CodArchivo], 
			[TC_Estado],
			[TC_RutaArchivo]

			FROM [Consulta].[ArchivoConsulta]
			WHERE	[TC_Estado]						= 'F'
			ORDER BY [TF_FechaModificacion] ASC

END
GO
