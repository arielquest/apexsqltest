SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<21/02/2020>
-- Descripción :			<Actualiza el estado de un documento utilizado para publicarse en el módulo de consultas> 
-- =========================================================================================================================================================================
-- Modificación:			<Isaac Dobles Mata> <21/05/2021> <Se agrega actualización de fecha de modificación.>
-- =========================================================================================================================================================================
CREATE PROCEDURE [Consulta].[PA_ActualizarEstadoDocumentoTerminado]
	@CodEstado		char(1),
	@CodArchivo		uniqueidentifier,
	@Ruta			varchar(255) = null
AS
	BEGIN
	
	UPDATE	[Consulta].[ArchivoConsulta] 
	SET		
	TC_Estado								=	@CodEstado,
	TC_RutaArchivo							=	@Ruta,
	TF_FechaModificacion					=	GETDATE()
	WHERE	TU_CodArchivo					=	@CodArchivo

	END
GO
