SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<01-07-2021>
-- Description:					<Muestra la fecha y hora de un documento generado a partir de un machote>
-- Parametros:					@FormatosOrigen: Indicar los codigos de formatos juridicos ('1,2,3,4') para los que se desea buscar las fechas. Dejar en blanco para buscar todos.
--								@Orden: 1: Muestra la fecha del primer documento generado a partir de los formatos juridicos indicados.
--										2: Muestra la fecha del ultimo documento generado a partir de los formatos juridicos indicados.
-- ====================================================================================================================================================================================
-- Modificación:				<17/01/2022> <Aida Elena Siles R> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_FechaHoraDocumento]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4),
	@FormatosOrigen			AS VARCHAR(MAX),
	@Orden					AS SMALLINT
AS
BEGIN
	DECLARE		@L_NumeroExpediente		AS CHAR(14)		=	@NumeroExpediente
	DECLARE		@L_CodLegajo			VARCHAR(40)		=	@CodLegajo
	DECLARE		@L_Contexto				AS VARCHAR(4)	=	@Contexto
	DECLARE		@L_FormatosOrigen		VARCHAR(MAX)	=	@FormatosOrigen
	DECLARE		@L_Orden				AS SMALLINT		=	@Orden
DECLARE		@L_Formatos				TABLE (Formato VARCHAR(8));

	IF LEN(@L_FormatosOrigen) = 0
		INSERT INTO 
		@L_Formatos
		SELECT		TC_CodFormatoJuridico
		FROM		Catalogo.FormatoJuridico WITH(NOLOCK)
	ELSE
		INSERT INTO @L_Formatos
SELECT	CONVERT(INT,RTRIM(LTRIM(Value)))
		FROM	STRING_SPLIT(@L_FormatosOrigen, ',')

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		IF (@L_Orden = 1)
		BEGIN
			SELECT		CONVERT(CHAR(12), B.TF_FechaCrea, 103) + CONVERT(CHAR(12),B.TF_FechaCrea, 108) FechaDocumento
			FROM		Expediente.ArchivoExpediente		A WITH(NOLOCK)  
			INNER JOIN	Expediente.ExpedienteDetalle		F WITH(NOLOCK) 
			ON			A.TC_NumeroExpediente				= F.TC_NumeroExpediente 
			AND			A.TB_Eliminado						= 0
			INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
			ON			A.TU_CodArchivo						= B.TU_CodArchivo
			AND			B.TC_CodFormatoJuridico				IN (
																SELECT	Formato
																FROM	@L_Formatos
																)
			WHERE		F.TC_NumeroExpediente				= @L_NumeroExpediente
			AND			F.TC_CodContexto					= @L_Contexto
			ORDER BY	B.TF_FechaCrea ASC
		END
		ELSE
		BEGIN
			SELECT		CONVERT(CHAR(12), B.TF_FechaCrea, 103) + CONVERT(CHAR(12),B.TF_FechaCrea, 108) FechaDocumento
			FROM		Expediente.ArchivoExpediente		A WITH(NOLOCK)  
			INNER JOIN	Expediente.ExpedienteDetalle		F WITH(NOLOCK) 
			ON			A.TC_NumeroExpediente				= F.TC_NumeroExpediente 
			AND			A.TB_Eliminado						= 0
			INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
			ON			A.TU_CodArchivo						= B.TU_CodArchivo
			AND			B.TC_CodFormatoJuridico				IN (
																SELECT	Formato
																FROM	@L_Formatos
																)
			WHERE		F.TC_NumeroExpediente				= @L_NumeroExpediente
			AND			F.TC_CodContexto					= @L_Contexto
			ORDER BY	B.TF_FechaCrea DESC
		END
	END
	ELSE
	BEGIN
		IF (@L_Orden = 1)
		BEGIN
			SELECT		CONVERT(CHAR(12), D.TF_FechaCrea, 103) + CONVERT(CHAR(12),D.TF_FechaCrea, 108) FechaDocumento
			FROM		Expediente.ArchivoExpediente		A WITH(NOLOCK)
			INNER JOIN	Expediente.LegajoArchivo			B WITH(NOLOCK)
			ON			B.TU_CodArchivo						= A.TU_CodArchivo
			INNER JOIN	Expediente.LegajoDetalle			C WITH(NOLOCK) 
			ON			C.TU_CodLegajo						= B.TU_CodLegajo 
			AND			A.TB_Eliminado						= 0
			INNER JOIN	Archivo.Archivo						D WITH(NOLOCK)
			ON			D.TU_CodArchivo						= B.TU_CodArchivo
			AND			D.TC_CodFormatoJuridico				IN (
																SELECT	Formato
																FROM	@L_Formatos
																)
			WHERE		C.TU_CodLegajo						= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
			AND			C.TC_CodContexto					= @L_Contexto
			ORDER BY	D.TF_FechaCrea ASC
		END
		ELSE
		BEGIN
			SELECT		CONVERT(CHAR(12), D.TF_FechaCrea, 103) + CONVERT(CHAR(12),D.TF_FechaCrea, 108) FechaDocumento
			FROM		Expediente.ArchivoExpediente		A WITH(NOLOCK)  
			INNER JOIN	Expediente.LegajoArchivo			B WITH(NOLOCK)
			ON			B.TU_CodArchivo						= A.TU_CodArchivo
			INNER JOIN	Expediente.LegajoDetalle			C WITH(NOLOCK) 
			ON			C.TU_CodLegajo						= B.TU_CodLegajo 
			AND			A.TB_Eliminado						= 0
			INNER JOIN	Archivo.Archivo						D WITH(NOLOCK)
			ON			D.TU_CodArchivo						= B.TU_CodArchivo
			AND			D.TC_CodFormatoJuridico				IN (
																SELECT	Formato
																FROM	@L_Formatos
																)
			WHERE		C.TU_CodLegajo						= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
			AND			C.TC_CodContexto					= @L_Contexto
			ORDER BY	D.TF_FechaCrea DESC
		END
	END
	
END
GO
