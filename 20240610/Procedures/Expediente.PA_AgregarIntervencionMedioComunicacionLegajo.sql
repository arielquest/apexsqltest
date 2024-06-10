SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Isaac Dobles Mata>
-- Fecha de creación:	<14/06/2019>
-- Descripción :		<Permite agregar un Medio de Comunicacion a un interviniente dentro de un legajo
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarIntervencionMedioComunicacionLegajo] 
	@CodigoMedioComunicacion	uniqueidentifier,		
	@CodigoLegajo				uniqueidentifier, 
	@PrioridadLegajo			smallint
AS
BEGIN
	INSERT INTO Expediente.IntervencionMedioComunicacionLegajo
	(
		TU_CodMedioComunicacion,
		TU_CodLegajo,
		TN_PrioridadLegajo
	)
	VALUES
	(
		@CodigoMedioComunicacion, 
		@CodigoLegajo, 
		@PrioridadLegajo
	)
END
GO
