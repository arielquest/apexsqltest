SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO





-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<10/02/2021>
-- Descripción :			<Permite verificar si existe un registro en ArchivoConsulta para un documento en específico.>
-- =================================================================================================================================================
CREATE PROCEDURE [Consulta].[PA_ConsultarArchivoConsulta]
	@CodigoArchivo							UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE @L_TU_CodArchivo	UNIQUEIDENTIFIER	= @CodigoArchivo,
	@L_Resultado				INT					= 0

	SELECT  @L_Resultado = COUNT([TU_CodArchivo])
			FROM	[Consulta].[ArchivoConsulta]
			WHERE	[TU_CodArchivo]	= @L_TU_CodArchivo

	RETURN @L_Resultado
END
GO
