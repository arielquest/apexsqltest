SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Gerardo Lopez R>
-- Fecha Creación:	<16/11/2015>
-- Descripcion:		<Asociar vulnerabilidad de una persona a un interviniente.>
-- Modificado:		<Alejandro Villalta, 10-12-2015, Cambiar tipo de dato del codigo de vulnerabilidad.>
-- =============================================
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarIntervinienteVulnerabilidad]   
	@CodInterviniente	uniqueidentifier,
    @CodVulnerabilidad		smallint
AS
BEGIN
	INSERT INTO Expediente.IntervinienteVulnerabilidad
	(
		TU_CodInterviniente, TN_CodVulnerabilidad
	) 
	VALUES
	(
			@CodInterviniente, @CodVulnerabilidad
	)
END
GO
