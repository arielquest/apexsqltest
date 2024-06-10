SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Karol Jiménez Sánchez>
-- Fecha de creación:		<19/05/2021>
-- Descripción :			<Valida si los datos se pueden insertar/modificar en Expediente.IntervencionMedioComunicacionLegajo solo para los medios de 
--							comunicación de legajos, retorna 1 cuando es válido.> 
-- =================================================================================================================================================
CREATE FUNCTION [Expediente].[FN_ValidarIntervencionMedioComunicacionLegajos]
(
	@CodMedioComunicacion		UNIQUEIDENTIFIER,
	@CodLegajo					UNIQUEIDENTIFIER,
	@PrioridadLegajo			SMALLINT
)
RETURNS BIT
AS
BEGIN
	Declare	@MedioComunicacionValido	As BIT = 0;

	DECLARE @TU_CodMedioComunicacion	UNIQUEIDENTIFIER	= @CodMedioComunicacion,
			@TU_CodLegajo				UNIQUEIDENTIFIER	= @CodLegajo,
			@TN_PrioridadLegajo			SMALLINT			= @PrioridadLegajo,
			@TU_CodInterviniente		UNIQUEIDENTIFIER; 
	
	SELECT	@TU_CodInterviniente						=	M.TU_CodInterviniente
	FROM	Expediente.IntervencionMedioComunicacion	M	WITH(NOLOCK)
	WHERE 	M.TU_CodMedioComunicacion					=	@TU_CodMedioComunicacion;

	SET @MedioComunicacionValido = CASE WHEN EXISTS (	 SELECT		ML.TU_CodMedioComunicacion	
														 FROM		Expediente.IntervencionMedioComunicacionLegajo	ML	WITH(NOLOCK)
														 INNER JOIN	Expediente.IntervencionMedioComunicacion		M	WITH(NOLOCK)
														 ON			M.TU_CodMedioComunicacion						=	ML.TU_CodMedioComunicacion
														 WHERE		M.TB_PerteneceExpediente						=	0
														 AND		M.TU_CodInterviniente							=	@TU_CodInterviniente
														 AND		ML.TN_PrioridadLegajo							=	@TN_PrioridadLegajo
														 AND		ML.TU_CodLegajo									=	@TU_CodLegajo
														 AND		ML.TU_CodMedioComunicacion						<>	@TU_CodMedioComunicacion
													) 
										THEN 0
									ELSE 1 END;
	Return @MedioComunicacionValido;
END

GO
