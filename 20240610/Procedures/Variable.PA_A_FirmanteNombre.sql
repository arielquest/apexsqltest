SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<10-09-2020>
-- Description:					<Traducción de la Variable del PJEditor para el nombre del firmante de la resolucion para LibreOffice>
-- ====================================================================================================================================================================================
-- Modificación:				<17/01/2022> <Aida Elena Siles R> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_FirmanteNombre]
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
		SELECT		CONCAT(E.TC_Nombre, ' ', E.TC_PrimerApellido, ' ', E.TC_SegundoApellido)
		FROM		Expediente.Resolucion				A WITH(NOLOCK)
		INNER JOIN	Expediente.ExpedienteDetalle		F WITH(NOLOCK) 
		ON			A.TC_NumeroExpediente				= F.TC_NumeroExpediente 
		INNER JOIN	Archivo.AsignacionFirmado			B WITH(NOLOCK)
		ON			A.TU_CodArchivo						= B.TU_CodArchivo
		INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
		ON			B.TU_CodAsignacionFirmado			= C.TU_CodAsignacionFirmado
		INNER JOIN	Catalogo.PuestoTrabajoFuncionario	D WITH(NOLOCK)
		ON			C.TU_FirmadoPor						= D.TU_CodPuestoFuncionario
		INNER JOIN	Catalogo.Funcionario				E WITH(NOLOCK)
		ON			D.TC_UsuarioRed						= E.TC_UsuarioRed
		WHERE		A.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			A.TC_CodContexto					= @L_Contexto
		AND			A.TF_FechaResolucion				= (
															SELECT	MAX(H.TF_FechaResolucion)
															FROM	Expediente.Resolucion	H WITH(NOLOCK)
															WHERE	A.TC_NumeroExpediente	= H.TC_NumeroExpediente
															AND		A.TC_CodContexto		= H.TC_CodContexto
															AND		H.TU_CodArchivo			NOT IN (SELECT	TU_CodArchivo 
																									FROM	Expediente.LegajoArchivo WITH(NOLOCK)
																									WHERE	TU_CodArchivo = A.TU_CodArchivo)
														   )
	END
	ELSE
	BEGIN
		SELECT		CONCAT(G.TC_Nombre, ' ', G.TC_PrimerApellido, ' ', G.TC_SegundoApellido)
		FROM		Expediente.Resolucion				A WITH(NOLOCK)
		INNER JOIN	Expediente.LegajoArchivo			B WITH(NOLOCK)
		ON			A.TU_CodArchivo						= B.TU_CodArchivo
		INNER JOIN	Expediente.LegajoDetalle			C WITH(NOLOCK) 
		ON			C.TU_CodLegajo						= B.TU_CodLegajo
		INNER JOIN	Archivo.AsignacionFirmado			D WITH(NOLOCK)
		ON			D.TU_CodArchivo						= B.TU_CodArchivo
		INNER JOIN	Archivo.AsignacionFirmante			E WITH(NOLOCK)
		ON			E.TU_CodAsignacionFirmado			= D.TU_CodAsignacionFirmado
		INNER JOIN	Catalogo.PuestoTrabajoFuncionario	F WITH(NOLOCK)
		ON			F.TU_CodPuestoFuncionario			= E.TU_FirmadoPor
		INNER JOIN	Catalogo.Funcionario				G WITH(NOLOCK)
		ON			G.TC_UsuarioRed						= F.TC_UsuarioRed
		WHERE		C.TU_CodLegajo						= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			A.TC_CodContexto					= @L_Contexto
		AND			A.TF_FechaResolucion				= (
															SELECT		MAX(TF_FechaResolucion)
															FROM		Expediente.Resolucion	H WITH(NOLOCK)
															INNER JOIN	Expediente.LegajoArchivo I WITH(NOLOCK)
															ON			H.TU_CodArchivo			= I.TU_CodArchivo
															WHERE		I.TU_CodLegajo			= C.TU_CodLegajo
															AND			A.TC_CodContexto		= H.TC_CodContexto
															)
	END
END
GO
