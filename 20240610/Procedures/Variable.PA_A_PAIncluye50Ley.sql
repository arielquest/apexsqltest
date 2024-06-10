SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<25-08-2020>
-- Description:					<Traducción de la Variable del PJEditor A_PAIncluye50Ley para LibreOffice>
-- ====================================================================================================================================================================================
-- Modidicación:				<18/01/2022> <Aida Elena Siles R> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_PAIncluye50Ley]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4) 
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)     = @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
@L_Contexto             AS VARCHAR(4)   = @Contexto;

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT	CASE
					WHEN C.TC_CodMateria IN ('PA', 'CI','FA', 'LA', 'AG', 'CA') THEN ' ' 
					ELSE '(Incluye 50 por ciento de Ley)'
				END AS Retorno
		FROM		Expediente.ExpedienteDetalle	A WITH(NOLOCK)
		INNER JOIN	Catalogo.Proceso				B WITH(NOLOCK)
		ON			A.TN_CodProceso					= B.TN_CodProceso
		INNER JOIN	Catalogo.Contexto				C WITH(NOLOCK)
		ON			A.TC_CodContexto				= C.TC_CodContexto
		WHERE		A.TC_NumeroExpediente			= @L_NumeroExpediente
		AND			A.TC_CodContexto				= @L_Contexto
	END
	ELSE
	BEGIN
		SELECT	CASE
					WHEN C.TC_CodMateria IN ('PA', 'CI','FA', 'LA', 'AG', 'CA') THEN ' ' 
					ELSE '(Incluye 50 por ciento de Ley)'
				END AS Retorno
		FROM		Expediente.LegajoDetalle		A WITH(NOLOCK)
		INNER JOIN	Catalogo.Proceso				B WITH(NOLOCK)
		ON			A.TN_CodProceso					= B.TN_CodProceso
		INNER JOIN	Catalogo.Contexto				C WITH(NOLOCK)
		ON			A.TC_CodContexto				= C.TC_CodContexto
		WHERE		A.TU_CodLegajo					= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			A.TC_CodContexto				= @L_Contexto
	END
END
GO
