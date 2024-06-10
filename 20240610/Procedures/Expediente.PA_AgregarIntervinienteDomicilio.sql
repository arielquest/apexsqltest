SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Sigifredo Leitón Luna>
-- Fecha Creación:	<29/10/2015>
-- Descripcion:		<Asociar un domicilio de una persona a un interviniente.>
-- =============================================
CREATE PROCEDURE [Expediente].[PA_AgregarIntervinienteDomicilio] 
	@CodigoDomicilio		uniqueidentifier, 
	@CodigoInterviniente	uniqueidentifier
AS
BEGIN
	INSERT INTO Expediente.IntervinienteDomicilio
	(
		TU_CodDomicilio,	TU_CodInterviniente
	) 
	VALUES
	(
		@CodigoDomicilio,	@CodigoInterviniente
	)
END
GO
