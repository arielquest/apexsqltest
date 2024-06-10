SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Juan Ramirez>
-- Fecha Creación:	<13/08/2018>
-- Descripcion:		<Desasocia una representación según el tipo de participación>
-- =============================================
CREATE PROCEDURE [Expediente].[PA_DesasociarRepresentacion] 
		@TipoParticipacionParte char(1), --Enumerador tipo participación Parte
		@TipoParticipacion 		char(1), --Tipo de intervención que desea desasociar -Parte o Representante
		@CodigoInterviniente	uniqueidentifier 
AS
BEGIN
	IF @TipoParticipacion = @TipoParticipacionParte
	BEGIN
		DELETE [Expediente].[Representacion] FROM [Expediente].[Representacion] WHERE TU_CodInterviniente = @CodigoInterviniente
	END
	ELSE
	BEGIN
		DELETE [Expediente].[Representacion] FROM [Expediente].[Representacion] WHERE TU_CodIntervinienteRepresentante = @CodigoInterviniente
	END
END


GO
