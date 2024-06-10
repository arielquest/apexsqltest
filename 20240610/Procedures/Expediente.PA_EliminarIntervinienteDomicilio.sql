SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Andrés Díaz Buján>
-- Fecha Creación:	<17/02/2015>
-- Descripcion:		<Desasocia el domicilio de una persona del interviniente.>
-- =============================================
CREATE PROCEDURE [Expediente].[PA_EliminarIntervinienteDomicilio]
	@CodigoDomicilio		uniqueidentifier, 
	@CodigoInterviniente	uniqueidentifier
AS
BEGIN
	DELETE	Expediente.IntervinienteDomicilio
	WHERE	TU_CodDomicilio			= @CodigoDomicilio
	AND		TU_CodInterviniente		= @CodigoInterviniente;
END;
GO
