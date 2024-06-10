SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<14-07-2020>
-- Description:					<Traducción de la Variable del PJEditor C_Contravencion para LibreOffice>
-- NOTA:						<14/07/2020> <El parametro @TiposIntervencion debe recibir los valores separados por comas.>
--														  <Por ejemplo: '1,14,15,11,17,18,19,20'>
-- ====================================================================================================================================================================================
-- Modificación:				<Aida Elena Siles R> <21/01/2022> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_C_Contravencion]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4),
	@TiposIntervencion		AS VARCHAR(MAX)
AS
BEGIN
	DECLARE		@L_NumeroExpediente		AS CHAR(14)		= @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
@L_Contexto				AS VARCHAR(4)	= @Contexto,
				@L_TiposIntervencion	VARCHAR(MAX)	= @TiposIntervencion
	DECLARE		@L_Tipos				TABLE (Tipo INT);

INSERT INTO @L_Tipos
	SELECT	CONVERT(INT,RTRIM(LTRIM(Value)))
	FROM	STRING_SPLIT(@L_TiposIntervencion, ',')

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT		G.TC_Descripcion					AS Delito
		FROM		Expediente.Interviniente			A WITH(NOLOCK)
		INNER JOIN	Expediente.IntervinienteDelito		F WITH(NOLOCK)
		ON			F.TU_CodInterviniente				= A.TU_CodInterviniente
		INNER JOIN	Catalogo.Delito						G WITH(NOLOCK)
		ON			F.TN_CodDelito						= G.TN_CodDelito
		INNER JOIN	Expediente.Intervencion				B WITH(NOLOCK)
		ON			A.TU_CodInterviniente				= B.TU_CodInterviniente
		INNER JOIN	Catalogo.TipoIntervencion			C WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion			= C.TN_CodTipoIntervencion
		LEFT JOIN	Expediente.ExpedienteDetalle		E WITH(NOLOCK) 
		ON			B.TC_NumeroExpediente				= E.TC_NumeroExpediente  
		WHERE		C.TN_CodTipoIntervencion			IN (
															SELECT	Tipo
															FROM	@L_Tipos
															)  
		AND			E.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			E.TC_CodContexto					= @L_Contexto
		AND			B.TU_CodInterviniente				NOT IN ( SELECT TU_CodInterviniente 
																 FROM	Expediente.LegajoIntervencion WITH(NOLOCK)
																 WHERE	TU_CodInterviniente = B.TU_CodInterviniente)
		UNION ALL
		SELECT		B.TC_Descripcion					AS Delito
		FROM		Expediente.Expediente				A WITH(NOLOCK)
		INNER JOIN	Catalogo.Delito						B WITH(NOLOCK)
		ON			A.TN_CodDelito						= B.TN_CodDelito
		LEFT JOIN	Expediente.ExpedienteDetalle		C WITH(NOLOCK) 
		ON			A.TC_NumeroExpediente				= C.TC_NumeroExpediente  
		WHERE		C.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			C.TC_CodContexto					= @L_Contexto
	END
	ELSE
	BEGIN
		SELECT		G.TC_Descripcion					AS Delito
		FROM		Expediente.Interviniente			A WITH(NOLOCK)
		INNER JOIN	Expediente.IntervinienteDelito		F WITH(NOLOCK)
		ON			F.TU_CodInterviniente				= A.TU_CodInterviniente
		INNER JOIN	Catalogo.Delito						G WITH(NOLOCK)
		ON			F.TN_CodDelito						= G.TN_CodDelito
		INNER JOIN	Expediente.Intervencion				B WITH(NOLOCK)
		ON			A.TU_CodInterviniente				= B.TU_CodInterviniente
		INNER JOIN  Expediente.LegajoIntervencion		LI WITH(NOLOCK)
		ON			LI.TU_CodInterviniente				= B.TU_CodInterviniente
		INNER JOIN	Catalogo.TipoIntervencion			C WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion			= C.TN_CodTipoIntervencion
		LEFT JOIN	Expediente.LegajoDetalle			E WITH(NOLOCK) 
		ON			E.TU_CodLegajo						= LI.TU_CodLegajo
		WHERE		C.TN_CodTipoIntervencion			IN (
															SELECT	Tipo
															FROM	@L_Tipos
															)  
		AND			E.TU_CodLegajo						= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			E.TC_CodContexto					= @L_Contexto
		--No se agrega el UNION ALL, Porque se toma el delito de Expediente.Expediente, en este caso, para legajo no aplica.
	END

	
END
GO
