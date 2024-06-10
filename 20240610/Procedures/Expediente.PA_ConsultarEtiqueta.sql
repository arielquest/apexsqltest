SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Andrew Allen Dawson>
-- Fecha de creación:	<18/03/2020>
-- Descripción:			<Permite consultar etiquetas relacionadas de una audiencia.>
-- ==================================================================================================================================================================================
-- Modificación:		<Aida Elena Sile Rojas> <15/10/2020> <Se agregan los campos tiempo archivo y nombre archivo a la consulta.>
-- ==================================================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ConsultarEtiqueta]
	@CodAudiencia BIGINT
AS
BEGIN
	DECLARE @L_TN_CodAudiencia	BIGINT	= @CodAudiencia

	SELECT	TU_CodEtiqueta					Codigo,	
			TN_TiempoMilisegundos			TiempoMilisegundos,	
			TC_Etiqueta						Descripcion,	
			TB_TipoEtiqueta					TipoEtiqueta,
			TC_TiempoArchivo				TiempoArchivo,
			TC_NombreArchivo				NombreArchivo
	FROM	Expediente.EtiquetaAudiencia	WITH(NOLOCK)
	WHERE	TN_CodAudiencia					= @L_TN_CodAudiencia
END
GO
