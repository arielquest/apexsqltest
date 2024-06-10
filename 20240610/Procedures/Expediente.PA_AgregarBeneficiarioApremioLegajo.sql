SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Daniel Ruiz Hernández>
-- Fecha de creación:		<30/08/2021>
-- Descripción :			<Permite asociar un beneficiario al legajo de apremio>
-- =================================================================================================================================================


CREATE PROCEDURE [Expediente].[PA_AgregarBeneficiarioApremioLegajo]
	@CodApremio					uniqueidentifier,
	@CodLegajo					uniqueidentifier,
	@CodInterviniente			uniqueidentifier
AS 
BEGIN

	DECLARE	
	@L_TU_CodApremio			uniqueidentifier		= @CodApremio,
	@L_TU_CodLegajo				uniqueidentifier		= @CodLegajo,
	@L_TU_CodInterviniente		uniqueidentifier		= @CodInterviniente

	INSERT INTO Expediente.ApremioLegajoBeneficiarios
	(
			TU_CodApremio
			,TU_CodLegajo
            ,TU_CodInterviniente
	)
    VALUES
	(
			@L_TU_CodApremio
            ,@L_TU_CodLegajo
            ,@L_TU_CodInterviniente
	)
END
GO
