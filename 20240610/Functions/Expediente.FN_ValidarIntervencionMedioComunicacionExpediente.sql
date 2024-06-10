SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Karol Jiménez Sánchez>
-- Fecha de creación:		<19/05/2021>
-- Descripción :			<Valida si los datos se pueden insertar/modificar en Expediente.IntervencionMedioComunicacion solo para los medios de 
--							comunicación de expediente, retorna 1 cuando es válido.> 
-- =================================================================================================================================================
CREATE FUNCTION [Expediente].[FN_ValidarIntervencionMedioComunicacionExpediente]
(
	@CodMedioComunicacion		UNIQUEIDENTIFIER,
	@CodInterviniente			UNIQUEIDENTIFIER,
	@PrioridadExpediente		SMALLINT,
	@PerteneceExpediente		BIT
)
RETURNS TINYINT
AS
BEGIN
	Declare	@MedioComunicacionValido	As TINYINT = 0;

	IF (@PerteneceExpediente = 1)
	BEGIN
		SET @MedioComunicacionValido = IIF((SELECT	COUNT(M.TU_CodMedioComunicacion)
											FROM	Expediente.IntervencionMedioComunicacion	M WITH(NOLOCK)
											WHERE	M.TB_PerteneceExpediente					= @PerteneceExpediente
											AND		M.TU_CodInterviniente						= @CodInterviniente
											AND		M.TN_PrioridadExpediente					= @PrioridadExpediente
											AND		M.TU_CodMedioComunicacion					<> @CodMedioComunicacion
											) > 0, 0, 1)
	END
	ELSE
		SET @MedioComunicacionValido = 1;

	Return @MedioComunicacionValido;
END

GO
