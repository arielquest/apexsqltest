SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Jorge A. Harris R.>
-- Create date:					<05-06-2020>
-- Description:					<Traducción de la Variable del PJEditor Nombre representante para LibreOffice>
--								Tipos de intervencion:
--								50	REPRESENTANTE LEGAL / 51	REPRESENTANTE QUERELLANTE
--								Verificar si esto se pasa por párametro o se queda quemado en el SP.
-- ====================================================================================================================================================================================
-- Modificación:				<18/01/2022> <Aida Elena Siles R> <Se agrega lógica para legajos. Adicionalmente se agrega consulta de representantes SIAGPJ.>
-- Modificación:				<20/03/2024> <Ronny Ramírez R.> <PBI 377530: Se optimiza filtrado de representantes por nombre de interviniente representado.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_NombreRepresentante]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4), 
	@Parte1					AS VARCHAR(MAX),
	@Parte2					AS VARCHAR(MAX),
	@Parte3					AS VARCHAR(MAX),
	@Parte4					AS VARCHAR(MAX),
	@Parte5					AS VARCHAR(MAX)
AS
BEGIN
	DECLARE 	@L_NumeroExpediente		AS CHAR(14)		= @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
				@L_Contexto				AS VARCHAR(4)	= @Contexto, 
				@L_Parte1				AS VARCHAR(MAX) = @Parte1,
				@L_Parte2				AS VARCHAR(MAX) = @Parte2,
				@L_Parte3				AS VARCHAR(MAX) = @Parte3,
				@L_Parte4				AS VARCHAR(MAX) = @Parte4,
				@L_Parte5				AS VARCHAR(MAX) = @Parte5
	
	DECLARE		@L_Partes				TABLE (nombre VARCHAR(MAX));
	DECLARE		@L_Nombres				TABLE (	Nombre				VARCHAR(100),
												ApellidoUno			VARCHAR(50),
												ApellidoDos			VARCHAR(50));
	DECLARE		@L_Representantes		TABLE (	Nombre				VARCHAR(100),
												ApellidoUno			VARCHAR(50),
												ApellidoDos			VARCHAR(50));
				
	INSERT INTO @L_Partes
	SELECT	RTRIM(LTRIM(Value))
	FROM	STRING_SPLIT(@L_Parte1, ',')

	INSERT INTO @L_Partes
	SELECT	RTRIM(LTRIM(Value))
	FROM	STRING_SPLIT(@L_Parte2, ',')

	INSERT INTO @L_Partes
	SELECT	RTRIM(LTRIM(Value))
	FROM	STRING_SPLIT(@L_Parte3, ',')

	INSERT INTO @L_Partes
	SELECT	RTRIM(LTRIM(Value))
	FROM	STRING_SPLIT(@L_Parte4, ',')

	INSERT INTO @L_Partes
	SELECT	RTRIM(LTRIM(Value))
	FROM	STRING_SPLIT(@L_Parte5, ',')

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		INSERT 		INTO @L_Nombres
		SELECT		D.TC_Nombre						AS Nombre,
					D.TC_PrimerApellido				AS ApellidoUno,
					D.TC_SegundoApellido			AS ApellidoDos
		FROM		Expediente.Interviniente		A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion			B WITH(NOLOCK)
		ON			A.TU_CodInterviniente			= B.TU_CodInterviniente
		INNER JOIN	Catalogo.TipoIntervencion		C WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion		= C.TN_CodTipoIntervencion   
		INNER JOIN	Persona.PersonaFisica			D WITH(NOLOCK) 
		ON			D.TU_CodPersona					= B.TU_CodPersona
		LEFT JOIN	Expediente.ExpedienteDetalle	E WITH(NOLOCK) 
		ON			B.TC_NumeroExpediente			= E.TC_NumeroExpediente  
		WHERE		C.TN_CodTipoIntervencion		IN (50,51)   
		AND			E.TC_NumeroExpediente			= @L_NumeroExpediente
		AND			E.TC_CodContexto				= @L_Contexto
		AND			B.TU_CodInterviniente			NOT IN (SELECT	TU_CodInterviniente 
															FROM	Expediente.LegajoIntervencion WITH(NOLOCK)
															WHERE	TU_CodInterviniente = B.TU_CodInterviniente)
		UNION ALL
		SELECT		F.TC_Nombre						AS Nombre,
					''								AS ApellidoUno,
					''								AS ApellidoDos 
		FROM		Expediente.Interviniente		A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion			B WITH(NOLOCK)
		ON			A.TU_CodInterviniente			= B.TU_CodInterviniente
		INNER JOIN  Catalogo.TipoIntervencion		C WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion		= C.TN_CodTipoIntervencion 
		INNER JOIN	Persona.Persona					D WITH(NOLOCK) 
		ON			B.TU_CodPersona					= D.TU_CodPersona 
		LEFT JOIN	Expediente.ExpedienteDetalle	E WITH(NOLOCK) 
		ON			B.TC_NumeroExpediente			= E.TC_NumeroExpediente 
		INNER JOIN	Persona.PersonaJuridica			F WITH(NOLOCK) 
		ON			D.TU_CodPersona					= F.TU_CodPersona
		WHERE		C.TN_CodTipoIntervencion		IN (50,51)
		AND			E.TC_NumeroExpediente			= @L_NumeroExpediente
		AND			E.TC_CodContexto				= @L_Contexto
		AND			B.TU_CodInterviniente			NOT IN (SELECT	TU_CodInterviniente 
															FROM	Expediente.LegajoIntervencion WITH(NOLOCK)
															WHERE	TU_CodInterviniente = B.TU_CodInterviniente)

		--Lógica en caso que el representante se haya agregado con el tipo participación Representante en SIAGPJ.
		If (SELECT COUNT(Nombre) FROM @L_Nombres) < 1
		BEGIN
		INSERT 		INTO @L_Representantes
		SELECT		PF.TC_Nombre						AS Nombre,
					PF.TC_PrimerApellido				AS ApellidoUno,
					PF.TC_SegundoApellido				AS ApellidoDos
		FROM		Expediente.Intervencion				A WITH(NOLOCK)		
		INNER JOIN  Expediente.Representacion			B WITH(NOLOCK)
		ON			B.TU_CodIntervinienteRepresentante	= A.TU_CodInterviniente
		AND			A.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			A.TC_TipoParticipacion				= 'R'
		INNER JOIN	Persona.PersonaFisica				PF WITH(NOLOCK)
		ON			PF.TU_CodPersona					= A.TU_CodPersona		
		LEFT JOIN	Expediente.ExpedienteDetalle	E WITH(NOLOCK) 
		ON			E.TC_NumeroExpediente			= A.TC_NumeroExpediente
		WHERE		E.TC_CodContexto				= @L_Contexto		
		AND			NOT EXISTS	( -- Que no esté dentro de un legajo
									SELECT	TU_CodInterviniente 
									FROM	Expediente.LegajoIntervencion WITH(NOLOCK)
									WHERE	TU_CodInterviniente = B.TU_CodInterviniente
								)
		AND			EXISTS	(	
								SELECT		C.TU_CodInterviniente 		
								FROM		Expediente.Intervencion	C WITH(NOLOCK)
								INNER JOIN	Persona.PersonaFisica	D WITH(NOLOCK)
								ON			D.TU_CodPersona								= C.TU_CodPersona
								WHERE		C.TC_NumeroExpediente						= @L_NumeroExpediente
								AND			C.TU_CodInterviniente						= B.TU_CodInterviniente  -- Código de interviniente a quien representa
								AND			EXISTS	(				-- se busca que exista por nombre el interviniente a quien representa en la tabla de @L_Partes
														SELECT	nombre 
														FROM	@L_Partes 
														WHERE	nombre = CONCAT(D.TC_Nombre, ' ', D.TC_PrimerApellido, ' ', D.TC_SegundoApellido) 
														OR		nombre = CONCAT(D.TC_PrimerApellido, ' ', D.TC_SegundoApellido, ' ', D.TC_Nombre)
													)
							)
		END--FIN Lógica en caso que el representante se haya agregado con el tipo participación Representante en SIAGPJ.

	END
	ELSE
	BEGIN
		INSERT 		INTO @L_Nombres
		SELECT		D.TC_Nombre						AS Nombre,
					D.TC_PrimerApellido				AS ApellidoUno,
					D.TC_SegundoApellido			AS ApellidoDos
		FROM		Expediente.Interviniente		A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion			B WITH(NOLOCK)
		ON			A.TU_CodInterviniente			= B.TU_CodInterviniente
		INNER JOIN  Expediente.LegajoIntervencion	LI WITH(NOLOCK)
		ON			LI.TU_CodInterviniente			= B.TU_CodInterviniente
		INNER JOIN	Catalogo.TipoIntervencion		C WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion		= C.TN_CodTipoIntervencion   
		INNER JOIN	Persona.PersonaFisica			D WITH(NOLOCK) 
		ON			D.TU_CodPersona					= B.TU_CodPersona
		LEFT JOIN	Expediente.LegajoDetalle		E WITH(NOLOCK) 
		ON			E.TU_CodLegajo					= LI.TU_CodLegajo
		WHERE		C.TN_CodTipoIntervencion		IN (50,51)   
		AND			E.TU_CodLegajo					= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			E.TC_CodContexto				= @L_Contexto
		UNION ALL
		SELECT		F.TC_Nombre						AS Nombre,
					''								AS ApellidoUno,
					''								AS ApellidoDos 
		FROM		Expediente.Interviniente		A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion			B WITH(NOLOCK)
		ON			A.TU_CodInterviniente			= B.TU_CodInterviniente
		INNER JOIN  Expediente.LegajoIntervencion	LI WITH(NOLOCK)
		ON			LI.TU_CodInterviniente			= B.TU_CodInterviniente
		INNER JOIN  Catalogo.TipoIntervencion		C WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion		= C.TN_CodTipoIntervencion 
		INNER JOIN	Persona.Persona					D WITH(NOLOCK) 
		ON			B.TU_CodPersona					= D.TU_CodPersona 
		LEFT JOIN	Expediente.LegajoDetalle		E WITH(NOLOCK) 
		ON			E.TU_CodLegajo					= LI.TU_CodLegajo
		INNER JOIN	Persona.PersonaJuridica			F WITH(NOLOCK) 
		ON			D.TU_CodPersona					= F.TU_CodPersona
		WHERE		C.TN_CodTipoIntervencion		IN (50,51)
		AND			E.TU_CodLegajo					= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			E.TC_CodContexto				= @L_Contexto

		--Lógica en caso que el representante se haya agregado con el tipo participación Representante en SIAGPJ.
		If (SELECT COUNT(Nombre) FROM @L_Nombres) < 1
		BEGIN
		INSERT 		INTO @L_Representantes
		SELECT		PF.TC_Nombre					AS Nombre,
					PF.TC_PrimerApellido			AS ApellidoUno,
					PF.TC_SegundoApellido			AS ApellidoDos
		FROM		Expediente.Intervencion			A WITH(NOLOCK)			
		INNER JOIN  Expediente.LegajoIntervencion	B WITH(NOLOCK)
		ON			A.TU_CodInterviniente			= B.TU_CodInterviniente
		AND			A.TC_TipoParticipacion			= 'R'
		INNER JOIN  Expediente.Representacion		C WITH(NOLOCK)
		ON			C.TU_CodIntervinienteRepresentante = B.TU_CodInterviniente
		INNER JOIN	Persona.PersonaFisica			PF WITH(NOLOCK)
		ON			PF.TU_CodPersona				= A.TU_CodPersona
		LEFT JOIN	Expediente.LegajoDetalle		H WITH(NOLOCK) 
		ON			H.TU_CodLegajo					= B.TU_CodLegajo
		WHERE		H.TU_CodLegajo					= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			H.TC_CodContexto				= @L_Contexto		
		AND			EXISTS	(	
								SELECT			D.TU_CodInterviniente 		
								FROM			Expediente.Intervencion						D WITH(NOLOCK)
								INNER JOIN		Expediente.LegajoIntervencion				E WITH(NOLOCK)
								ON				E.TU_CodInterviniente						= D.TU_CodInterviniente
								INNER JOIN		Persona.PersonaFisica						F WITH(NOLOCK)
								ON				F.TU_CodPersona								= D.TU_CodPersona
								WHERE			D.TU_CodInterviniente						= C.TU_CodInterviniente  -- Código de interviniente a quien representa
								AND			EXISTS	(				-- se busca que exista por nombre el interviniente a quien representa en la tabla de @L_Partes
														SELECT	nombre 
														FROM	@L_Partes 
														WHERE	nombre = CONCAT(F.TC_Nombre, ' ', F.TC_PrimerApellido, ' ', F.TC_SegundoApellido) 
														OR		nombre = CONCAT(F.TC_PrimerApellido, ' ', F.TC_SegundoApellido, ' ', F.TC_Nombre)
													)
							)
		END--FIN Lógica en caso que el representante se haya agregado con el tipo participación Representante en SIAGPJ.
	END
	
	If (SELECT COUNT(nombre) FROM @L_Partes) > 1
		DELETE
		FROM	@L_Nombres
		WHERE	CONCAT(Nombre, ' ', ApellidoUno, ' ', ApellidoDos) NOT IN	(
																			SELECT	Nombre
																			FROM	@L_Partes
																			)
		AND		CONCAT(ApellidoUno, ' ', ApellidoDos, ' ', Nombre) NOT IN	(
																			SELECT	Nombre
																			FROM	@L_Partes
																			)

	IF (SELECT COUNT(nombre) FROM @L_Representantes) > 0
	BEGIN
	INSERT INTO @L_Nombres
	SELECT Nombre, ApellidoUno, ApellidoDos FROM @L_Representantes
	END

	SELECT	CONCAT(Nombre, ' ', ApellidoUno, ' ', ApellidoDos) 
	FROM	@L_Nombres
END
GO
