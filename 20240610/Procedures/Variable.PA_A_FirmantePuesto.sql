SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<10-09-2020>
-- Description:					<Traducción de la Variable del PJEditor para firmante de la resolucion para LibreOffice>
-- ====================================================================================================================================================================================
-- Modificación:				<Aida Elena Siles R> <17/01/2022> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_FirmantePuesto]
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
		SELECT		E.TC_Descripcion
		FROM		Expediente.Resolucion				A WITH(NOLOCK)  
		INNER JOIN	Expediente.ExpedienteDetalle		F WITH(NOLOCK)
		ON			A.TC_NumeroExpediente				= F.TC_NumeroExpediente 
		INNER JOIN	Archivo.AsignacionFirmado			B WITH(NOLOCK)
		ON			A.TU_CodArchivo						= B.TU_CodArchivo
		INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
		ON			B.TU_CodAsignacionFirmado			= C.TU_CodAsignacionFirmado
		INNER JOIN	Catalogo.PuestoTrabajo				D WITH(NOLOCK)
		ON			C.TC_CodPuestoTrabajo				= D.TC_CodPuestoTrabajo
		INNER JOIN	Catalogo.TipoPuestoTrabajo			E WITH(NOLOCK)
		ON			D.TN_CodTipoPuestoTrabajo			= E.TN_CodTipoPuestoTrabajo
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
		SELECT		G.TC_Descripcion
		FROM		Expediente.Resolucion				A WITH(NOLOCK)  
		INNER JOIN	Expediente.LegajoArchivo			B WITH(NOLOCK)
		ON			A.TU_CodArchivo						= B.TU_CodArchivo
		INNER JOIN	Expediente.LegajoDetalle			C WITH(NOLOCK)
		ON			C.TU_CodLegajo						= B.TU_CodLegajo
		INNER JOIN	Archivo.AsignacionFirmado			D WITH(NOLOCK)
		ON			D.TU_CodArchivo						= B.TU_CodArchivo
		INNER JOIN	Archivo.AsignacionFirmante			E WITH(NOLOCK)
		ON			E.TU_CodAsignacionFirmado			= D.TU_CodAsignacionFirmado
		INNER JOIN	Catalogo.PuestoTrabajo				F WITH(NOLOCK)
		ON			F.TC_CodPuestoTrabajo				= E.TC_CodPuestoTrabajo
		INNER JOIN	Catalogo.TipoPuestoTrabajo			G WITH(NOLOCK)
		ON			G.TN_CodTipoPuestoTrabajo			= F.TN_CodTipoPuestoTrabajo
		WHERE		B.TU_CodLegajo						= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			A.TC_CodContexto					= @L_Contexto
		AND			A.TF_FechaResolucion				= (
															SELECT		MAX(TF_FechaResolucion)
															FROM		Expediente.Resolucion		H WITH(NOLOCK)
															INNER JOIN	Expediente.LegajoArchivo	I WITH(NOLOCK)
															ON			I.TU_CodArchivo				= H.TU_CodArchivo
															WHERE		I.TU_CodLegajo				= B.TU_CodLegajo
															AND			A.TC_CodContexto			= H.TC_CodContexto															
															)
	END
END
GO
