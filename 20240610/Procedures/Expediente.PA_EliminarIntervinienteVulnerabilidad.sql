SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Roger Lara Hernandez>
-- Fecha Creación:	<03/12/2015>
-- Descripcion:		<Eliminar vulnerabilidad de un interviniente.>
-- =============================================
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarIntervinienteVulnerabilidad]   
	@CodInterviniente	uniqueidentifier,
    @CodVulnerabilidad		varchar(3)
AS
BEGIN
	
	Delete
	From Expediente.IntervinienteVulnerabilidad
	where TU_CodInterviniente=@CodInterviniente
	and	  TN_CodVulnerabilidad=@CodVulnerabilidad
END
GO
