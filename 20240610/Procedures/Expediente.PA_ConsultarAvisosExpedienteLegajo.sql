SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis ALonso Leiva Tames>
-- Fecha de creación:		<21/12/2020>
-- Descripción :			<Consultar Avisos Expediente y Legajos> 
-- =================================================================================================================================================
-- Modificación:			<08/02/2021><Luis Alonso Leiva Tames><Se cambia variable de configuración para que acepte valores multiples para indigena>
-- Modificación:			<28/02/2021><Luis Alonso Leiva Tames><Se cambia variable de configuración para que acepte valores multiples para indigena para legajos>
-- Modificación:			<06/05/2021><Luis Alonso Leiva Tames><Se el filtro para el adulto mayor, menor de edad para los legajos>
-- Modificación:			<31/05/2021><Karol Jiménez Sánchez><Se ajusta para incluir representantes en validaciones, dado que estos no tienen registro en Interviniente,
--							Además, se incluye a solicitud de equipo de implantaciones y con VB de jefatura:
--							-Para alerta de persona indígena se calcule además de las etnias, con las vulnerabilidades y con el perfil de la victima.
--							-Para alerta de persona con discapacidad se calcule además de las discapacidades, con las vulnerabilidades>
-- Modificación:			<03/06/2021><Daniel Ruiz Hernández><Se agrega lista de expedientes y legajos para realizar la consulta de una lista y no solo 1 expediente>
-- Modificación:			<13/08/2021> <Aida Elena Siles R> <Se agrega aviso de pase a fallo.>
-- Modificación:			<13/10/2023> <Karol Jiménez S.> <PBI 348045 - Se agrega aviso de embargos físicos.>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarAvisosExpedienteLegajo]
	@Numero				CHAR(14), 
	@CodigoLegajo		UNIQUEIDENTIFIER,
	@ListaExpedientes	VARCHAR(MAX)		= NULL,
	@ListaLegajos		VARCHAR(MAX)		= NULL,
	@CodContexto		VARCHAR(4)			= NULL
AS
	DECLARE  @L_Numero						AS CHAR(14)			= @Numero,
			 @L_CodigoLegajo				AS UNIQUEIDENTIFIER = @CodigoLegajo,
			 @L_CodContexto					VARCHAR(4)			= @CodContexto,
			 @L_CodVulenrabilidad			AS INT,
			 @L_TN_CodEtnia					AS INT,
			 @L_ValorPersonaMayor			AS INT, 
	--- Variables que van a contener la leyenda de la fila 
			 @L_Indigena						AS VARCHAR(50)		= 'Persona Indígena',
			 @L_Discapacidad					AS VARCHAR(50)		= 'Persona con discapacidad',
			 @L_AdultaMayor						AS VARCHAR(50)		= 'Persona adulta mayor',
			 @L_MenorEdad						AS VARCHAR(50)		= 'Persona menor de edad',
			 @L_PaseFallo						AS VARCHAR(50)		= 'En proceso de pase a fallo',
			 @L_EmbargosFisicos					AS VARCHAR(50)		= ' con embargo(s) físico(s).',
	--- Variables Identificadores 
			 @L_IdentificadorIndigena			AS VARCHAR(20)		= 'PersonaIndigena',
			 @L_IdentificadorDiscapacidad		AS VARCHAR(20)		= 'PersonaDiscapacitada',
			 @L_IdentificadorAdultaMayor		AS VARCHAR(20)		= 'PersonaAdulta',
			 @L_IdentificadorMenorEdad			AS VARCHAR(20)		= 'PersonaMenor',
			 @L_IdentificadorPaseFallo			AS VARCHAR(20)		= 'PaseFallo',
			 @L_IdentificadorEmbargosFisicos	AS VARCHAR(20)		= 'EmbargosFisicos'
	
	DECLARE @ValoresConfiguracioneEtniasIndigenas					AS TABLE (TC_Valor  VARCHAR(255) NOT NULL);
	DECLARE @ValoresConfiguracionesVulnerabilidadesIndigenas		AS TABLE (TC_Valor  VARCHAR(255) NOT NULL);
	DECLARE @ValoresConfiguracionesVulnerabilidadesDiscapacidades	AS TABLE (TC_Valor  VARCHAR(255) NOT NULL);

	--- Obtenemos el valor de las etnias Persona Indigena
	INSERT INTO @ValoresConfiguracioneEtniasIndigenas
			(TC_Valor)
	SELECT	C.TC_Valor  
	FROM	Configuracion.ConfiguracionValor	C WITH (NOLOCK)
	WHERE	C.TC_CodConfiguracion				= 'C_PersonaIndigena' 
	AND		C.TF_FechaActivacion				<= GETDATE() 
	AND		(C.TF_FechaCaducidad				IS NULL 
				OR C.TF_FechaCaducidad			>= GETDATE())

	--- Obtenemos el valor de las vulnerabilidades Persona Indigena
	INSERT INTO @ValoresConfiguracionesVulnerabilidadesIndigenas
			(TC_Valor)
	SELECT	C.TC_Valor  
	FROM	Configuracion.ConfiguracionValor	C WITH (NOLOCK)
	WHERE	C.TC_CodConfiguracion				= 'C_VulnerabilidadesIndigenas' 
	AND		C.TF_FechaActivacion				<= GETDATE() 
	AND		(C.TF_FechaCaducidad				IS NULL 
				OR C.TF_FechaCaducidad			>= GETDATE())

	--- Obtenemos el valor de las vulnerabilidades Persona con discapacidad
	INSERT INTO @ValoresConfiguracionesVulnerabilidadesDiscapacidades
			(TC_Valor)
	SELECT	C.TC_Valor  
	FROM	Configuracion.ConfiguracionValor	C WITH (NOLOCK)
	WHERE	C.TC_CodConfiguracion				= 'C_VulnerabilidadesDiscapac' 
	AND		C.TF_FechaActivacion				<= GETDATE() 
	AND		(C.TF_FechaCaducidad				IS NULL 
				OR C.TF_FechaCaducidad			>= GETDATE())

	--- Obtenemos el valor para la Persona Adulta Mayor 
	SELECT	@L_ValorPersonaMayor				= C.TC_Valor  
	FROM	Configuracion.ConfiguracionValor	C WITH (NOLOCK)
	WHERE	C.TC_CodConfiguracion				= 'U_PersonaAdultaMayor' 
	AND		C.TF_FechaActivacion				<= GETDATE() 
	AND		(C.TF_FechaCaducidad				IS NULL 
			OR C.TF_FechaCaducidad				>= GETDATE())

	IF(@L_Numero IS NOT NULL) 
	BEGIN
		WITH AvisosNotificacion (Cantidad,Identificador,Descripcion, Expediente, Legajo) 
		AS
		(
			--- Persona Indigena
			SELECT		COUNT(S.TU_CodInterviniente)	AS Cantidad, 
						@L_IdentificadorIndigena		AS Identificador,
						@L_Indigena						AS Descripcion,
						NULL							AS Expediente,
						NULL							AS Legajo
			FROM (
					SELECT		A.TU_CodInterviniente
					FROM		Expediente.Intervencion		A WITH (NOLOCK)
					INNER JOIN	Persona.PersonaFisica		F WITH (NOLOCK) 
					ON			F.TU_CodPersona				= A.TU_CodPersona
					WHERE		A.TF_Inicio_Vigencia		<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia			IS NULL 
								OR A.TF_Fin_Vigencia		>= GETDATE()) 
					AND			F.TN_CodEtnia				IN (SELECT	TC_Valor 
																FROM	@ValoresConfiguracioneEtniasIndigenas) 
					AND			A.TC_NumeroExpediente		=	@L_Numero
					UNION	
					SELECT		A.TU_CodInterviniente
					FROM		Expediente.Intervencion					A WITH (NOLOCK)
					INNER JOIN	Expediente.IntervinienteVulnerabilidad	B WITH (NOLOCK)
					ON			B.TU_CodInterviniente					= A.TU_CodInterviniente
					WHERE		A.TF_Inicio_Vigencia					<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia						IS NULL 
								OR A.TF_Fin_Vigencia					>= GETDATE()) 
					AND			B.TN_CodVulnerabilidad					IN (SELECT	TC_Valor 
																			FROM	@ValoresConfiguracionesVulnerabilidadesIndigenas) 
					AND			A.TC_NumeroExpediente					=	@L_Numero
					UNION	
					SELECT		A.TU_CodInterviniente
					FROM		Expediente.Intervencion					A WITH (NOLOCK)
					INNER JOIN	Expediente.IntervinienteVictima			B WITH (NOLOCK)
					ON			B.TU_CodInterviniente					= A.TU_CodInterviniente
					WHERE		A.TF_Inicio_Vigencia					<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia						IS NULL 
								OR A.TF_Fin_Vigencia					>= GETDATE()) 
					AND			B.TB_EsIndigena							=	1
					AND			A.TC_NumeroExpediente					=	@L_Numero) S
			UNION ALL
			--- Persona con Discapacidad
			SELECT	COUNT(S.TU_CodInterviniente)			AS Cantidad, 
					@L_IdentificadorDiscapacidad			AS Identificador,
					@L_Discapacidad							AS Descripcion,
					NULL									AS Expediente,
					NULL									AS Legajo
			FROM	(
					SELECT		A.TU_CodInterviniente
					FROM		Expediente.Intervencion					A WITH (NOLOCK)
					INNER JOIN	Expediente.IntervinienteDiscapacidad	D WITH (NOLOCK) 
					ON			D.TU_CodInterviniente					= A.TU_CodInterviniente
					INNER JOIN	Persona.PersonaFisica					F WITH (NOLOCK) 
					ON			F.TU_CodPersona							= A.TU_CodPersona
					WHERE		A.TF_Inicio_Vigencia					<=  GETDATE()	
					AND			(A.TF_Fin_Vigencia						IS NULL	
									OR A.TF_Fin_Vigencia				>= GETDATE()) 
					AND			A.TC_NumeroExpediente					= @L_Numero
					UNION	
					SELECT		A.TU_CodInterviniente
					FROM		Expediente.Intervencion					A WITH (NOLOCK)
					INNER JOIN	Expediente.IntervinienteVulnerabilidad	B WITH (NOLOCK)
					ON			B.TU_CodInterviniente					= A.TU_CodInterviniente
					WHERE		A.TF_Inicio_Vigencia					<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia						IS NULL 
								OR A.TF_Fin_Vigencia					>= GETDATE()) 
					AND			B.TN_CodVulnerabilidad					IN (SELECT	TC_Valor 
																			FROM	@ValoresConfiguracionesVulnerabilidadesDiscapacidades) 
					AND			A.TC_NumeroExpediente					=	@L_Numero ) S
			--- Persona Adulta Mayor
			UNION ALL 
			SELECT 
						COUNT(1)						AS Cantidad,
						@L_IdentificadorAdultaMayor		AS Identificador,
						@L_AdultaMayor					AS Descripcion,
						NULL							AS Expediente,
						NULL							AS Legajo
			FROM		Expediente.Intervencion			A WITH (NOLOCK)
			INNER JOIN	Persona.PersonaFisica			F WITH (NOLOCK) 
			ON			F.TU_CodPersona					= A.TU_CodPersona
			WHERE		A.TF_Inicio_Vigencia			<=  GETDATE() 
			AND			(A.TF_Fin_Vigencia				IS NULL 
							OR A.TF_Fin_Vigencia		>= GETDATE()) 
			AND			(CAST(DATEDIFF(dd,F.TF_FechaNacimiento,GETDATE()) / 365.25 as int)) >= @L_ValorPersonaMayor 
			AND			A.TC_NumeroExpediente			= @L_Numero
			--- Persona menor de edad
			UNION ALL 
			SELECT		COUNT(1)					AS Cantidad, 
						@L_IdentificadorMenorEdad	AS Identificador,
						@L_MenorEdad				AS Descripcion,
						NULL						AS Expediente,
						NULL						AS Legajo
			FROM		Expediente.Intervencion		A WITH (NOLOCK)
			INNER JOIN	Persona.PersonaFisica		F WITH (NOLOCK) 
			ON			F.TU_CodPersona				= A.TU_CodPersona
			WHERE		A.TF_Inicio_Vigencia		<=  GETDATE() 
			AND			(A.TF_Fin_Vigencia			IS NULL 
							OR A.TF_Fin_Vigencia	>= GETDATE()) 
			AND			(CAST(DATEDIFF(dd,F.TF_FechaNacimiento,GETDATE()) / 365.25 as int)) < 18 
			AND			A.TC_NumeroExpediente		= @L_Numero
			--- En Pase a fallo
			UNION ALL 
			SELECT		COUNT(A.TU_CodPaseFallo)	AS Cantidad, 
						@L_IdentificadorPaseFallo	AS Identificador,
						@L_PaseFallo				AS Descripcion,
						NULL						AS Expediente,
						NULL						AS Legajo
			FROM		Historico.PaseFallo			A WITH (NOLOCK)
			WHERE		A.TU_CodPaseFallo			= ( SELECT TOP	1 B.TU_CodPaseFallo 
														FROM		Historico.PaseFallo B WITH(NOLOCK)
														WHERE		B.TC_NumeroExpediente	= @L_Numero
														AND			B.TU_CodLegajo			IS NULL
														AND			B.TC_CodContexto		= @L_CodContexto
														ORDER BY	B.TF_FechaAsignacion DESC)
			AND			A.TF_FechaDevolucion		IS NULL
			--- Embargos Físicos
			UNION ALL 
			SELECT		1									AS Cantidad, 
						@L_IdentificadorEmbargosFisicos		AS Identificador,
						'Expediente' + @L_EmbargosFisicos	AS Descripcion,
						NULL								AS Expediente,
						NULL								AS Legajo
			FROM		Expediente.Expediente				A WITH (NOLOCK)
			WHERE		A.TC_NumeroExpediente				= @L_Numero
			AND			A.TB_EmbargosFisicos				= 1
			)

			SELECT	Cantidad,	
					Identificador,	
					Descripcion,
					'SplitOtros'	AS SplitOtros,
					Expediente		AS NumeroExpediente,
					Legajo			AS CodigoLegajo
			FROM	AvisosNotificacion
	END
	ELSE IF (@L_CodigoLegajo IS NOT NULL) 
	BEGIN 
		WITH AvisosNotificacion (Cantidad,Identificador,Descripcion, Expediente, Legajo) 
		AS
		(
			--- Persona Indigena
			SELECT		COUNT(S.TU_CodInterviniente)	AS Cantidad, 
						@L_IdentificadorIndigena		AS Identificador,
						@L_Indigena						AS Descripcion,
						NULL							AS Expediente,
						NULL							AS Legajo
			FROM (
					SELECT		A.TU_CodInterviniente
					FROM		Expediente.Intervencion			A WITH (NOLOCK)
					INNER JOIN	Expediente.LegajoIntervencion	L WITH (NOLOCK) 
					ON			L.TU_CodInterviniente			= A.TU_CodInterviniente		
					INNER JOIN	Persona.PersonaFisica			F WITH (NOLOCK) 
					ON			F.TU_CodPersona					= A.TU_CodPersona	
					WHERE		A.TF_Inicio_Vigencia			<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia				IS NULL 
									OR A.TF_Fin_Vigencia		>= GETDATE()) 
					AND			F.TN_CodEtnia					IN  (	SELECT	TC_Valor 
																		FROM	@ValoresConfiguracioneEtniasIndigenas) 
					AND			L.TU_CodLegajo					=	@L_CodigoLegajo
					UNION
					SELECT		A.TU_CodInterviniente
					FROM		Expediente.Intervencion						A WITH (NOLOCK)
					INNER JOIN	Expediente.LegajoIntervencion				L WITH (NOLOCK) 
					ON			L.TU_CodInterviniente						= A.TU_CodInterviniente		
					INNER JOIN	Expediente.IntervinienteVulnerabilidad		P WITH (NOLOCK) 
					ON			P.TU_CodInterviniente						= L.TU_CodInterviniente 
					WHERE		A.TF_Inicio_Vigencia						<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia							IS NULL 
									OR A.TF_Fin_Vigencia					>= GETDATE()) 
					AND			P.TN_CodVulnerabilidad						IN  (	SELECT	TC_Valor 
																					FROM	@ValoresConfiguracionesVulnerabilidadesIndigenas) 
					AND			L.TU_CodLegajo								=	@L_CodigoLegajo 
					UNION
					SELECT		A.TU_CodInterviniente
					FROM		Expediente.Intervencion						A WITH (NOLOCK)
					INNER JOIN	Expediente.LegajoIntervencion				L WITH (NOLOCK) 
					ON			L.TU_CodInterviniente						= A.TU_CodInterviniente		
					INNER JOIN	Expediente.IntervinienteVictima				P WITH (NOLOCK) 
					ON			P.TU_CodInterviniente						= L.TU_CodInterviniente 
					WHERE		A.TF_Inicio_Vigencia						<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia							IS	NULL 
									OR A.TF_Fin_Vigencia					>=	GETDATE()) 
					AND			P.TB_EsPrivadoLibertad						=	1
					AND			L.TU_CodLegajo								=	@L_CodigoLegajo ) S
			UNION ALL
			--- Persona con Discapacidad
			SELECT	COUNT(S.TU_CodInterviniente)	AS Cantidad, 
					@L_IdentificadorDiscapacidad	AS Identificador,
					@L_Discapacidad					AS Descripcion,
					NULL							AS Expediente,
					NULL							AS Legajo
			FROM	(
					SELECT		A.TU_CodInterviniente
					FROM		Expediente.Intervencion					A WITH (NOLOCK)
					INNER JOIN	Expediente.LegajoIntervencion			L WITH (NOLOCK) 
					ON			A.TU_CodInterviniente					= L.TU_CodInterviniente
					INNER JOIN	Expediente.IntervinienteDiscapacidad	D WITH (NOLOCK) 
					ON			D.TU_CodInterviniente					= A.TU_CodInterviniente
					INNER JOIN	Persona.PersonaFisica					F WITH (NOLOCK)  
					ON			F.TU_CodPersona							= A.TU_CodPersona
					WHERE		A.TF_Inicio_Vigencia					<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia						IS NULL 
									OR A.TF_Fin_Vigencia				>= GETDATE()) 
					AND			L.TU_CodLegajo							=	@L_CodigoLegajo
					UNION
					SELECT		A.TU_CodInterviniente
					FROM		Expediente.Intervencion						A WITH (NOLOCK)
					INNER JOIN	Expediente.LegajoIntervencion				L WITH (NOLOCK) 
					on			L.TU_CodInterviniente						= A.TU_CodInterviniente		
					INNER JOIN	Expediente.IntervinienteVulnerabilidad		P WITH (NOLOCK) 
					on			P.TU_CodInterviniente						= L.TU_CodInterviniente 
					WHERE		A.TF_Inicio_Vigencia						<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia							IS NULL 
									OR A.TF_Fin_Vigencia					>= GETDATE()) 
					AND			P.TN_CodVulnerabilidad						IN  (	SELECT	TC_Valor 
																					FROM	@ValoresConfiguracionesVulnerabilidadesIndigenas) 
					AND			L.TU_CodLegajo								=	@L_CodigoLegajo ) S 
			--- Persona Adulta Mayor
			UNION ALL 
			SELECT		COUNT(1)					AS Cantidad, 
						@L_IdentificadorAdultaMayor	AS Identificador,
						@L_AdultaMayor				AS Descripcion,
						null						AS Expediente,
						null						AS Legajo
			FROM		Expediente.Intervencion			A WITH (NOLOCK) 
			INNER JOIN	Expediente.LegajoIntervencion	L WITH (NOLOCK) 
			ON			A.TU_CodInterviniente			= L.TU_CodInterviniente
			INNER JOIN	Persona.PersonaFisica			F WITH (NOLOCK)  
			ON			F.TU_CodPersona					= A.TU_CodPersona		
			WHERE		A.TF_Inicio_Vigencia			<=  GETDATE() 
			AND			(A.TF_Fin_Vigencia				IS NULL 
							OR A.TF_Fin_Vigencia		>= GETDATE()) 
			AND			(CAST(DATEDIFF(dd,F.TF_FechaNacimiento,GETDATE()) / 365.25 as int)) >= @L_ValorPersonaMayor
			AND			L.TU_CodLegajo = @L_CodigoLegajo
			--- Persona menor de edad
			UNION ALL 
			SELECT 
						COUNT(1)					AS Cantidad, 
						@L_IdentificadorMenorEdad	AS Identificador,
						@L_MenorEdad				AS Descripcion,
						null						AS Expediente,
						null						AS Legajo
			FROM		Expediente.Intervencion			A WITH (NOLOCK)
			INNER JOIN	Expediente.LegajoIntervencion	L WITH (NOLOCK) 
			ON			A.TU_CodInterviniente			= L.TU_CodInterviniente
			INNER JOIN	Persona.PersonaFisica			F WITH (NOLOCK)  
			ON			F.TU_CodPersona					= A.TU_CodPersona
			WHERE		A.TF_Inicio_Vigencia			<=  GETDATE() 
			AND			(A.TF_Fin_Vigencia				IS NULL 
						OR A.TF_Fin_Vigencia			>= GETDATE()) 
			AND			(CAST(DATEDIFF(dd,F.TF_FechaNacimiento,GETDATE()) / 365.25 as int)) < 18 
			AND			L.TU_CodLegajo					= @L_CodigoLegajo
			--- Pase fallo
			UNION ALL 
			SELECT		COUNT(A.TU_CodPaseFallo)	AS Cantidad, 
						@L_IdentificadorPaseFallo	AS Identificador,
						@L_PaseFallo				AS Descripcion,
						NULL						AS Expediente,
						NULL						AS Legajo
			FROM		Historico.PaseFallo			A WITH (NOLOCK)
			WHERE		A.TU_CodPaseFallo			= ( SELECT TOP	1 B.TU_CodPaseFallo 
														FROM		Historico.PaseFallo		B WITH(NOLOCK)
														WHERE		B.TU_CodLegajo			= @L_CodigoLegajo
														AND			B.TC_CodContexto		= @L_CodContexto
														ORDER BY	B.TF_FechaAsignacion DESC)
			AND			A.TF_FechaDevolucion		IS NULL
			--- Embargos Físicos
			UNION ALL 
			SELECT		1								AS Cantidad, 
						@L_IdentificadorEmbargosFisicos	AS Identificador,
						'Legajo' + @L_EmbargosFisicos	AS Descripcion,
						NULL							AS Expediente,
						NULL							AS Legajo
			FROM		Expediente.Legajo				A WITH (NOLOCK)
			WHERE		A.TU_CodLegajo					= @L_CodigoLegajo
			AND			A.TB_EmbargosFisicos			= 1
			)

			SELECT	Cantidad, 	
					Identificador,	
					Descripcion,
					'SplitOtros'	AS SplitOtros,
					Expediente		AS NumeroExpediente,
					Legajo			AS CodigoLegajo
			FROM 	AvisosNotificacion
	END
	ELSE IF (@ListaExpedientes IS NOT NULL OR @ListaLegajos IS NOT NULL)
	BEGIN
		WITH AvisosNotificacion (Cantidad,Identificador,Descripcion, Expediente, Legajo) 
		AS
		(
			--- Persona Indigena
			SELECT		COUNT(S.TU_CodInterviniente)	AS Cantidad, 
						@L_IdentificadorIndigena		AS Identificador,
						@L_Indigena						AS Descripcion,
						S.TC_NumeroExpediente			AS Expediente,
						null							AS Legajo
			FROM (
					SELECT		A.TU_CodInterviniente, A.TC_NumeroExpediente
					FROM		Expediente.Intervencion						A WITH (NOLOCK)
					INNER JOIN	Persona.PersonaFisica						F WITH (NOLOCK) 
					ON			F.TU_CodPersona								= A.TU_CodPersona
					INNER JOIN (SELECT value 
								FROM string_split(@ListaExpedientes,','))	L 
					ON			A.TC_NumeroExpediente						= L.value
					WHERE		A.TF_Inicio_Vigencia						<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia							IS NULL 
								OR A.TF_Fin_Vigencia						>= GETDATE()) 
					AND			F.TN_CodEtnia								in (SELECT	TC_Valor 
																				FROM	@ValoresConfiguracioneEtniasIndigenas) 
					UNION	
					SELECT		A.TU_CodInterviniente, A.TC_NumeroExpediente
					FROM		Expediente.Intervencion						A WITH (NOLOCK)
					INNER JOIN	Expediente.IntervinienteVulnerabilidad		B WITH (NOLOCK)
					ON			B.TU_CodInterviniente						= A.TU_CodInterviniente
					INNER JOIN (SELECT value 
								FROM string_split(@ListaExpedientes,','))	L 
					ON			A.TC_NumeroExpediente						= L.value
					WHERE		A.TF_Inicio_Vigencia						<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia							IS NULL 
								OR A.TF_Fin_Vigencia						>= GETDATE()) 
					AND			B.TN_CodVulnerabilidad						IN (SELECT	TC_Valor 
																				FROM	@ValoresConfiguracionesVulnerabilidadesIndigenas) 
					UNION	
					SELECT		A.TU_CodInterviniente, A.TC_NumeroExpediente
					FROM		Expediente.Intervencion						A WITH (NOLOCK)
					INNER JOIN	Expediente.IntervinienteVictima				B WITH (NOLOCK)
					ON			B.TU_CodInterviniente						= A.TU_CodInterviniente
					INNER JOIN (SELECT value 
								FROM string_split(@ListaExpedientes,','))	L 
					ON			A.TC_NumeroExpediente						= L.value
					WHERE		A.TF_Inicio_Vigencia						<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia							IS NULL 
								OR A.TF_Fin_Vigencia						>= GETDATE()) 
					AND			B.TB_EsIndigena								=	1) S
			GROUP BY	S.TC_NumeroExpediente

			UNION ALL
			--- Persona con Discapacidad
			SELECT	COUNT(S.TU_CodInterviniente)			AS Cantidad, 
					@L_IdentificadorDiscapacidad			AS Identificador,
					@L_Discapacidad							AS Descripcion,
					S.TC_NumeroExpediente					AS Expediente,
					null									AS Legajo
			FROM	(
					SELECT		A.TU_CodInterviniente, A.TC_NumeroExpediente
					FROM		Expediente.Intervencion						A WITH (NOLOCK)
					INNER JOIN	Expediente.IntervinienteDiscapacidad		D WITH (NOLOCK) 
					ON			D.TU_CodInterviniente						= A.TU_CodInterviniente
					INNER JOIN	Persona.PersonaFisica						F WITH (NOLOCK) 
					ON			F.TU_CodPersona								= A.TU_CodPersona
					INNER JOIN (SELECT value 
								FROM string_split(@ListaExpedientes,','))	L 
					ON			A.TC_NumeroExpediente						= L.value
					WHERE		A.TF_Inicio_Vigencia					<=  GETDATE()	
					AND			(A.TF_Fin_Vigencia						IS NULL	
									OR A.TF_Fin_Vigencia				>= GETDATE()) 

					UNION	
					SELECT		A.TU_CodInterviniente, A.TC_NumeroExpediente
					FROM		Expediente.Intervencion						A WITH (NOLOCK)
					INNER JOIN	Expediente.IntervinienteVulnerabilidad		B WITH (NOLOCK)
					ON			B.TU_CodInterviniente						= A.TU_CodInterviniente
					INNER JOIN (SELECT value 
								FROM string_split(@ListaExpedientes,','))	L 
					ON			A.TC_NumeroExpediente						= L.value
					WHERE		A.TF_Inicio_Vigencia						<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia							IS NULL 
								OR A.TF_Fin_Vigencia						>= GETDATE()) 
					AND			B.TN_CodVulnerabilidad						in (SELECT	TC_Valor 
																				FROM	@ValoresConfiguracionesVulnerabilidadesDiscapacidades)) S
			GROUP BY	S.TC_NumeroExpediente
			--- Persona Adulta Mayor
			UNION ALL 
			SELECT 
						COUNT(1)									AS Cantidad,
						@L_IdentificadorAdultaMayor					AS Identificador,
						@L_AdultaMayor								AS Descripcion,
						A.TC_NumeroExpediente						AS Expediente,
						null										AS Legajo
			FROM		Expediente.Intervencion						A WITH (NOLOCK)
			INNER JOIN	Persona.PersonaFisica						F WITH (NOLOCK) 
			on			F.TU_CodPersona								= A.TU_CodPersona
			INNER JOIN (SELECT value 
						FROM string_split(@ListaExpedientes,','))	L 
			ON			A.TC_NumeroExpediente						= L.value
			WHERE		A.TF_Inicio_Vigencia			<=  GETDATE() 
			AND			(A.TF_Fin_Vigencia				IS NULL 
							OR A.TF_Fin_Vigencia		>= GETDATE()) 
			AND			(CAST(DATEDIFF(dd,F.TF_FechaNacimiento,GETDATE()) / 365.25 as int)) >= @L_ValorPersonaMayor 
			GROUP BY	A.TC_NumeroExpediente
			--- Persona menor de edad
			UNION ALL 
			SELECT		COUNT(1)									AS Cantidad, 
						@L_IdentificadorMenorEdad					AS Identificador,
						@L_MenorEdad								AS Descripcion,
						A.TC_NumeroExpediente						AS Expediente,
						null										AS Legajo
			FROM		Expediente.Intervencion						A WITH (NOLOCK)
			INNER JOIN	Persona.PersonaFisica						F WITH (NOLOCK) 
			on			F.TU_CodPersona								= A.TU_CodPersona
			INNER JOIN (SELECT value 
						FROM string_split(@ListaExpedientes,','))	L 
			ON			A.TC_NumeroExpediente						= L.value
			WHERE		A.TF_Inicio_Vigencia						<=  GETDATE() 
			AND			(A.TF_Fin_Vigencia							IS NULL 
							OR A.TF_Fin_Vigencia					>= GETDATE()) 
			AND			(CAST(DATEDIFF(dd,F.TF_FechaNacimiento,GETDATE()) / 365.25 as int)) < 18
			GROUP BY	A.TC_NumeroExpediente
			--- Pase fallo
			UNION ALL 
			SELECT		COUNT(1)									AS Cantidad, 
						@L_IdentificadorPaseFallo					AS Identificador,
						@L_PaseFallo								AS Descripcion,
						A.TC_NumeroExpediente						AS Expediente,
						NULL										AS Legajo
			FROM		Historico.PaseFallo							A WITH (NOLOCK)
			INNER JOIN (SELECT value 
						FROM string_split(@ListaExpedientes,','))	B 
			ON			A.TC_NumeroExpediente						= B.value
			WHERE		A.TF_FechaDevolucion						IS NULL
			AND			A.TC_CodContexto							= @L_CodContexto
			GROUP BY	A.TC_NumeroExpediente			
			--LEGAJOS	
			UNION ALL 
			SELECT		COUNT(S.TU_CodInterviniente)	AS Cantidad, 
						@L_IdentificadorIndigena		AS Identificador,
						@L_Indigena						AS Descripcion,
						null							AS Expediente,
						S.TU_CodLegajo					AS Legajo
			FROM (
					SELECT		A.TU_CodInterviniente, L.TU_CodLegajo
					FROM		Expediente.Intervencion					A WITH (NOLOCK)
					INNER JOIN	Expediente.LegajoIntervencion			L WITH (NOLOCK) 
					on			L.TU_CodInterviniente					= A.TU_CodInterviniente		
					INNER JOIN	Persona.PersonaFisica					F WITH (NOLOCK) 
					on			F.TU_CodPersona							= A.TU_CodPersona	
					INNER JOIN (SELECT value 
								FROM string_split(@ListaLegajos,','))	G 
					ON			L.TU_CodLegajo							= G.value
					WHERE		A.TF_Inicio_Vigencia					<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia						IS NULL 
									OR A.TF_Fin_Vigencia				>= GETDATE()) 
					AND			F.TN_CodEtnia							IN  (	SELECT	TC_Valor 
																				FROM	@ValoresConfiguracioneEtniasIndigenas)

					UNION
					SELECT		A.TU_CodInterviniente, L.TU_CodLegajo
					FROM		Expediente.Intervencion						A WITH (NOLOCK)
					INNER JOIN	Expediente.LegajoIntervencion				L WITH (NOLOCK) 
					on			L.TU_CodInterviniente						= A.TU_CodInterviniente		
					INNER JOIN	Expediente.IntervinienteVulnerabilidad		P WITH (NOLOCK) 
					on			P.TU_CodInterviniente						= L.TU_CodInterviniente 
					INNER JOIN (SELECT value 
								FROM string_split(@ListaLegajos,','))		G 
					ON			L.TU_CodLegajo								= G.value
					WHERE		A.TF_Inicio_Vigencia						<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia							IS NULL 
									OR A.TF_Fin_Vigencia					>= GETDATE()) 
					AND			P.TN_CodVulnerabilidad						in  (	SELECT	TC_Valor 
																					FROM	@ValoresConfiguracionesVulnerabilidadesIndigenas)

					UNION
					SELECT		A.TU_CodInterviniente, L.TU_CodLegajo
					FROM		Expediente.Intervencion						A WITH (NOLOCK)
					INNER JOIN	Expediente.LegajoIntervencion				L WITH (NOLOCK) 
					on			L.TU_CodInterviniente						= A.TU_CodInterviniente		
					INNER JOIN	Expediente.IntervinienteVictima				P WITH (NOLOCK) 
					on			P.TU_CodInterviniente						= L.TU_CodInterviniente 
					INNER JOIN (SELECT value 
								FROM string_split(@ListaLegajos,','))		G 
					ON			L.TU_CodLegajo								= G.value
					WHERE		A.TF_Inicio_Vigencia						<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia							IS	NULL 
									OR A.TF_Fin_Vigencia					>=	GETDATE()) 
					AND			P.TB_EsPrivadoLibertad						=	1
					) S
			GROUP BY	S.TU_CodLegajo	
			UNION ALL
			--- Persona con Discapacidad
			SELECT	COUNT(S.TU_CodInterviniente)	AS Cantidad, 
					@L_IdentificadorDiscapacidad	AS Identificador,
					@L_Discapacidad					AS Descripcion,
					null							AS Expediente,
					S.TU_CodLegajo					AS Legajo
			FROM	(
					SELECT		A.TU_CodInterviniente, L.TU_CodLegajo
					FROM		Expediente.Intervencion					A WITH (NOLOCK)
					INNER JOIN	Expediente.LegajoIntervencion			L WITH (NOLOCK) 
					ON			A.TU_CodInterviniente					= L.TU_CodInterviniente
					INNER JOIN	Expediente.IntervinienteDiscapacidad	D WITH (NOLOCK) 
					ON			D.TU_CodInterviniente					= A.TU_CodInterviniente
					INNER JOIN	Persona.PersonaFisica					F WITH (NOLOCK)  
					ON			F.TU_CodPersona							= A.TU_CodPersona
					INNER JOIN (SELECT value 
								FROM string_split(@ListaLegajos,','))	G 
					ON			L.TU_CodLegajo							= G.value
					WHERE		A.TF_Inicio_Vigencia					<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia						IS NULL 
									OR A.TF_Fin_Vigencia				>= GETDATE()) 
					
					UNION
					SELECT		A.TU_CodInterviniente, L.TU_CodLegajo
					FROM		Expediente.Intervencion						A WITH (NOLOCK)
					INNER JOIN	Expediente.LegajoIntervencion				L WITH (NOLOCK) 
					on			L.TU_CodInterviniente						= A.TU_CodInterviniente		
					INNER JOIN	Expediente.IntervinienteVulnerabilidad		P WITH (NOLOCK) 
					on			P.TU_CodInterviniente						= L.TU_CodInterviniente
					INNER JOIN (SELECT value 
								FROM string_split(@ListaLegajos,','))		G 
					ON			L.TU_CodLegajo								= G.value
					WHERE		A.TF_Inicio_Vigencia						<=  GETDATE() 
					AND			(A.TF_Fin_Vigencia							IS NULL 
									OR A.TF_Fin_Vigencia					>= GETDATE()) 
					AND			P.TN_CodVulnerabilidad						in  (	SELECT	TC_Valor 
																					FROM	@ValoresConfiguracionesVulnerabilidadesIndigenas)
					) S 
			GROUP BY	S.TU_CodLegajo	
			--- Persona Adulta Mayor
			UNION ALL 
			SELECT		COUNT(1)					AS Cantidad, 
						@L_IdentificadorAdultaMayor	AS Identificador,
						@L_AdultaMayor				AS Descripcion,
						null						AS Expediente,
						L.TU_CodLegajo				AS Legajo
			FROM		Expediente.Intervencion					A WITH (NOLOCK) 
			INNER JOIN	Expediente.LegajoIntervencion			L WITH (NOLOCK) 
			ON			A.TU_CodInterviniente					= L.TU_CodInterviniente
			INNER JOIN	Persona.PersonaFisica					F WITH (NOLOCK)  
			ON			F.TU_CodPersona							= A.TU_CodPersona	
			INNER JOIN (SELECT value 
						FROM string_split(@ListaLegajos,','))	G 
			ON			L.TU_CodLegajo							= G.value
			WHERE		A.TF_Inicio_Vigencia					<=  GETDATE() 
			AND			(A.TF_Fin_Vigencia						IS NULL 
			OR			A.TF_Fin_Vigencia						>= GETDATE()) 
			AND			(CAST(DATEDIFF(dd,F.TF_FechaNacimiento,GETDATE()) / 365.25 as int)) >= @L_ValorPersonaMayor
			GROUP BY	L.TU_CodLegajo			
			--- Persona menor de edad			
			UNION ALL 
			SELECT 
						COUNT(1)					AS Cantidad, 
						@L_IdentificadorMenorEdad	AS Identificador,
						@L_MenorEdad				AS Descripcion,
						null						AS Expediente,
						L.TU_CodLegajo				AS Legajo
			FROM		Expediente.Intervencion					A WITH (NOLOCK)
			INNER JOIN	Expediente.LegajoIntervencion			L WITH (NOLOCK) 
			ON			A.TU_CodInterviniente					= L.TU_CodInterviniente
			INNER JOIN	Persona.PersonaFisica					F WITH (NOLOCK)  
			ON			F.TU_CodPersona							= A.TU_CodPersona
			INNER JOIN (SELECT value 
						FROM string_split(@ListaLegajos,','))	G 
			ON			L.TU_CodLegajo							= G.value
			WHERE		A.TF_Inicio_Vigencia					<=  GETDATE() 
			AND			(A.TF_Fin_Vigencia						IS NULL 
						OR A.TF_Fin_Vigencia					>= GETDATE()) 
			AND			(CAST(DATEDIFF(dd,F.TF_FechaNacimiento,GETDATE()) / 365.25 as int)) < 18 
			GROUP BY	L.TU_CodLegajo			
			--- Pase fallo			
			UNION ALL 
			SELECT 
						COUNT(1)					AS Cantidad, 
						@L_IdentificadorPaseFallo	AS Identificador,
						@L_PaseFallo				AS Descripcion,
						NULL						AS Expediente,
						A.TU_CodLegajo				AS Legajo
			FROM		Historico.PaseFallo						A WITH (NOLOCK)			
			INNER JOIN (SELECT value 
						FROM string_split(@ListaLegajos,','))	B 
			ON			A.TU_CodLegajo							= B.value
			WHERE		A.TF_FechaDevolucion					IS NULL
			AND			A.TC_CodContexto						= @L_CodContexto
			GROUP BY	A.TU_CodLegajo	
		)

		SELECT	Cantidad,	
				Identificador,	
				Descripcion,
				'SplitOtros'	AS SplitOtros,
				Expediente		AS NumeroExpediente,
				Legajo			AS CodigoLegajo
		FROM	AvisosNotificacion
	END
GO
