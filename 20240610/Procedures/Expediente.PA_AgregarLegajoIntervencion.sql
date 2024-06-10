SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<07/03/2019>
-- Descripcion:			<Agregar una intervencion a un legajo.>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarLegajoIntervencion] 
	@CodigoLegajo				uniqueidentifier,		
	@Interviniente				uniqueidentifier
AS
BEGIN
	INSERT INTO Expediente.LegajoIntervencion
	(
		TU_CodInterviniente,
		TU_CodLegajo
	)
	VALUES
	(
		@Interviniente,
		@CodigoLegajo
	)
END
GO
