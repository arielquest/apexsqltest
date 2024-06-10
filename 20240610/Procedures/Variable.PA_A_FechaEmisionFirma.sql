SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<10-09-2020>
-- Description:					<Traducción de la Variable del PJEditor para la fecha de emision de firma para LibreOffice>
-- ====================================================================================================================================================================================
-- Modificación:				<17/01/2022> <Aida Elena Siles R> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_FechaEmisionFirma]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4) 
AS
BEGIN

DECLARE 	@L_NumeroExpediente		AS CHAR(14)		= @NumeroExpediente,
			@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
			@L_Contexto				AS VARCHAR(4)	= @Contexto

	
	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT		CONVERT(VARCHAR(20), C.TF_FechaAplicado, 103) + CONVERT(VARCHAR(20),C.TF_FechaAplicado, 108)
		FROM		Expediente.Resolucion				A WITH(NOLOCK)
		INNER JOIN	Expediente.ExpedienteDetalle		F WITH(NOLOCK)
		ON			A.TC_NumeroExpediente				= F.TC_NumeroExpediente 
		INNER JOIN	Archivo.AsignacionFirmado			B WITH(NOLOCK)
		ON			A.TU_CodArchivo						= B.TU_CodArchivo
		INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
		ON			B.TU_CodAsignacionFirmado			= C.TU_CodAsignacionFirmado
		WHERE		A.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			A.TC_CodContexto					= @L_Contexto
		AND			A.TF_FechaResolucion				= (
															SELECT	MAX(TF_FechaResolucion)
															FROM	Expediente.Resolucion	WITH(NOLOCK)
															WHERE	A.TC_NumeroExpediente	= TC_NumeroExpediente
															AND		A.TC_CodContexto		= TC_CodContexto
														   )
	END
	ELSE
	BEGIN
		SELECT		CONVERT(VARCHAR(20), C.TF_FechaAplicado, 103) + CONVERT(VARCHAR(20),C.TF_FechaAplicado, 108)
		FROM		Expediente.Resolucion				A WITH(NOLOCK)
		INNER JOIN	Expediente.Legajo					F WITH(NOLOCK)
		ON			A.TC_NumeroExpediente				= F.TC_NumeroExpediente
		INNER JOIN  Expediente.LegajoDetalle			D WITH(NOLOCK)
		ON			D.TU_CodLegajo						= F.TU_CodLegajo
		INNER JOIN	Archivo.AsignacionFirmado			B WITH(NOLOCK)
		ON			A.TU_CodArchivo						= B.TU_CodArchivo
		INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
		ON			B.TU_CodAsignacionFirmado			= C.TU_CodAsignacionFirmado
		WHERE		A.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			A.TC_CodContexto					= @L_Contexto
		AND			D.TU_CodLegajo						= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			A.TF_FechaResolucion				= (
															SELECT		MAX(E.TF_FechaResolucion)
															FROM		Expediente.Resolucion		E WITH(NOLOCK)
															INNER JOIN	Expediente.Legajo			G	WITH(NOLOCK)
															ON			E.TC_NumeroExpediente		= G.TC_NumeroExpediente
															WHERE		A.TC_NumeroExpediente		= E.TC_NumeroExpediente
															AND			A.TC_CodContexto			= E.TC_CodContexto
															AND			D.TU_CodLegajo				= G.TU_CodLegajo															
														   )
	END
END
GO
