SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================================================================================================
-- Autor:			<Richard Zúñiga Segura>  
-- Fecha Creación:	<01/06/2021>  
-- Descripcion:		<Consulta todos los valores de los datos adicionales>  
-- =============================================================================================================================================================================
-- Modificado por:	<11-06-2021><Richard Zúñiga Segura> <Se modifica el nombre de IDATR y COLDAT ya que estaban incorrectos>	
-- Modificado por:	<30-06-2021><Karol Jiménez S./Jonathan Aguilar Navarro> <Se ajustan varios datos adicionales>	
-- Modificado por:	<24/08/2021><Jonathan Aguilar Navarro> <Se ajusta a varchar(255) el valor del campo DESCHEC>	
-- Modificación:	<03/03/2023> <Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos Delito y Provincia)>
-- Modificado por:	<18/05/2023><Ronny Ramírez R.> <Trunca a 255 el valor de CODHECHO y CODLUGAR que es lo máximo que soporta el campo valor de la tabla DCARMASD PBI:315052>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarDatosAdicionalesSiagpj]
	@CodHistoricoItineracion	UNIQUEIDENTIFIER
AS
BEGIN
	Declare	@L_TC_NumeroExpediente		CHAR(14),
			@L_TU_CodLegajo				UNIQUEIDENTIFIER	= NULL,
			@COLDAT						VARCHAR(2),
			@L_TC_CodContextoOrigen		VARCHAR(4)			= NULL,
			@L_Carpeta					VARCHAR(14),
			@L_CodHistoricoItineracion	UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
			@L_CantRegBase				INT;

	DECLARE @ValoresConfiguracioneEtniasIndigenas AS TABLE (TC_Valor  VARCHAR(255) NOT NULL);
	DECLARE @ValoresConfiguracionesVulnerabilidadesIndigenas AS TABLE (TC_Valor  VARCHAR(255) NOT NULL);

	-- Se obtiene el # de expediente asociado al código de histórico de itineración
    SELECT  @L_TC_NumeroExpediente	= TC_NumeroExpediente,
			@L_TU_CodLegajo			= TU_CodLegajo,
			@L_TC_CodContextoOrigen = TC_CodContextoOrigen,
			@L_Carpeta				= CARPETA
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodHistoricoItineracion);

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

	--Definición de tabla DCARMASD
	DECLARE @DCARMASD AS TABLE(
			[CARPETA] 			[varchar](14) 		NULL,
			[CODMASD]			[varchar](9) 		NOT NULL,
			[COLDAT] 			[varchar](2) 		NULL,
			[IDATR] 			[int] 				NULL,
			[VALOR] 			[varchar](255) 		NULL)

	--Definición de tabla DCARMASD
	DECLARE @CONTEXTO AS TABLE(
			[CODDEJ]			[varchar](4) 		NOT NULL,
			[CODJURIS] 			[varchar](2) 		NOT NULL,
			[CODTIDEJ]			[varchar](2) 		NULL)

	--Definición de tabla DBASE
	DECLARE @BASE AS TABLE
	(
			[MontoRemate]	INT
	)

	--LLENAR TABLA @CONTEXTO
	INSERT INTO @CONTEXTO
				([CODDEJ],
				[CODJURIS],	
				[CODTIDEJ])
	SELECT		B.TC_CodContexto				CODDEJ,
				B.TC_CodMateria					CODJURIS,
				B.CODTIDEJ						CODTIDEJ
	FROM		Historico.Itineracion			A	WITH (NOLOCK)
	INNER JOIN	Catalogo.Contexto				B	WITH (NOLOCK)
	ON			A.TC_CodContextoDestino			=	B.TC_CodContexto
	WHERE		A.TC_NumeroExpediente			=	@L_TC_NumeroExpediente
	AND			A.TU_CodHistoricoItineracion	=	@L_CodHistoricoItineracion

	--LLENAR TABLA @BASE
	--INSERT INTO @BASE
	--			([MontoRemate])
	--SELECT		B.TN_MontoRemate
	--FROM		Agenda.Evento A
	--INNER JOIN	Agenda.FechaEvento		B
	--ON			A.TU_CodEvento			=	B.TU_CodEvento
	--INNER JOIN	Expediente.Expediente	C
	--ON			A.TC_NumeroExpediente	=	C.TC_NumeroExpediente
	--INNER JOIN	Catalogo.TipoEvento		D
	--ON			A.TN_CodTipoEvento		=	D.TN_CodTipoEvento
	--WHERE		D.TB_EsRemate			=	1
	--AND			A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente
	--ORDER BY B.TF_FechaInicio

	--SET @L_CantRegBase = (SELECT COUNT(*) FROM @BASE)

	-- ADULTOMA
	INSERT INTO @DCARMASD
			([CARPETA], 			
			[CODMASD],			
			[COLDAT],			
			[IDATR],	
			[VALOR])	
	SELECT	@L_Carpeta,
			'ADULTOMA',
			'',
			0,
			CASE 
				WHEN E.CANTIDAD > 0 THEN 'S'
				ELSE 'N'
			END	
	FROM	Expediente.Expediente			A WITH (NOLOCK)
	OUTER APPLY
	(
		SELECT		COUNT(*) CANTIDAD 
		FROM		Expediente.Intervencion			B	WITH (NOLOCK)
		LEFT JOIN	Expediente.LegajoIntervencion	C	WITH (NOLOCK)
		ON			C.TU_CodInterviniente			=	B.TU_CodInterviniente
		INNER JOIN	Persona.PersonaFisica			D	WITH (NOLOCK)
		ON			B.TU_CodPersona					=	D.TU_CodPersona
		WHERE		DATEDIFF(year,D.TF_FechaNacimiento,getdate()) >= 65
		AND			B.TC_NumeroExpediente			= A.TC_NumeroExpediente
		AND			(@L_TU_CodLegajo				IS NULL
					OR C.TU_CodLegajo				= @L_TU_CodLegajo)
	) E
	WHERE 		A.TC_NumeroExpediente			= @L_TC_NumeroExpediente

	
	----BASE 1
	--IF @L_CantRegBase=1 
	--BEGIN
	--	INSERT INTO @DCARMASD
	--			([CARPETA], 			
	--			[CODMASD],			
	--			[CODALT],			
	--			[IDALT],	
	--			[VALOR])	
	--	SELECT	@L_Carpeta,
	--			'BASE 1',
	--			'',
	--			0,
	--			CONVERT(VARCHAR,A.MontoRemate)
	--	FROM	@BASE A
	--END

	----BASE 2
	--IF @L_CantRegBase=2 
	--BEGIN
	--	INSERT INTO @DCARMASD
	--			([CARPETA], 			
	--			[CODMASD],			
	--			[CODALT],			
	--			[IDALT],	
	--			[VALOR])	
	--	SELECT	TOP 1 
	--			@L_Carpeta,
	--			'BASE 2',
	--			'',
	--			0,
	--			CONVERT(VARCHAR,A.MontoRemate)
	--	FROM	@BASE A
	--END

	----BASE 3
	--IF @L_CantRegBase=3 
	--BEGIN
	--	INSERT INTO @DCARMASD
	--			([CARPETA], 			
	--			[CODMASD],			
	--			[CODALT],			
	--			[IDALT],	
	--			[VALOR])	
	--	SELECT	TOP 1 
	--			@L_Carpeta,
	--			'BASE 3',
	--			'',
	--			0,
	--			CONVERT(VARCHAR,A.MontoRemate)
	--	FROM	@BASE A
	--END

	--CANTH
	INSERT INTO @DCARMASD
				([CARPETA], 			
				[CODMASD],			
				[COLDAT],			
				[IDATR],	
				[VALOR])	
	SELECT		@L_Carpeta,
				'CANTH',
				'',
				0,
				CONVERT(VARCHAR, C.CODCANTON)
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	INNER JOIN  Catalogo.Canton			C	WITH (NOLOCK)
	ON          C.TN_CodCanton			=	A.TN_CodCanton
	AND         C.TN_CodProvincia		=	A.TN_CodProvincia
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	--INSERT INTO @DCARMASD
	--			([CARPETA], 			
	--			[CODMASD],			
	--			[COLDAT],			
	--			[IDATR],	
	--			[VALOR])	
	--SELECT		@L_Carpeta,
	--			'CAPITAL',
	--			'',
	--			0,
	--			CONVERT(VARCHAR, A.TN_MontoDeuda)
	--FROM		Expediente.Deuda		A	WITH (NOLOCK)/*validarlo luego, qu‚ pasa si hay varias deudas*/
	--WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	--CODDELEST
	UNION
	SELECT		@L_Carpeta,
				'CODDELEST',
				'',
				0,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Delito', A.TN_CodDelito,0,0)--CODDEL
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	--CODHECHO
	UNION
	SELECT		@L_Carpeta,
				'CODHECHO',
				'',
				0,
				LEFT(CONCAT(E.TC_Descripcion,',',D.TC_Descripcion,',',C.TC_Descripcion,',',B.TC_Descripcion,',',A.TC_Señas), 255) -- Trunca a 255
	FROM		Expediente.Expediente	A WITH (NOLOCK)
	INNER JOIN	Catalogo.Barrio			B WITH (NOLOCK)
	ON			B.TN_CodBarrio			= A.TN_CodBarrio
	AND			B.TN_CodDistrito		= A.TN_CodDistrito
	AND			B.TN_CodCanton			= A.TN_CodCanton
	AND			B.TN_CodProvincia		= A.TN_CodProvincia
	INNER JOIN	Catalogo.Distrito		C WITH (NOLOCK)
	ON			C.TN_CodDistrito		= A.TN_CodDistrito
	AND			C.TN_CodCanton			= A.TN_CodCanton
	AND			C.TN_CodProvincia		= A.TN_CodProvincia
	INNER JOIN	Catalogo.Canton			D WITH (NOLOCK)
	ON			D.TN_CodCanton			= A.TN_CodCanton
	AND			D.TN_CodProvincia		= A.TN_CodProvincia
	INNER JOIN	Catalogo.Provincia		E WITH (NOLOCK)
	ON			E.TN_CodProvincia		= A.TN_CodProvincia
	WHERE		A.TC_NumeroExpediente	= @L_TC_NumeroExpediente
	AND			A.TN_CodProvincia		IS NOT NULL
	AND			A.TN_CodCanton			IS NOT NULL
	AND			A.TN_CodDistrito		IS NOT NULL
	AND			A.TN_CodBarrio			IS NOT NULL
	AND			A.TC_Señas				IS NOT NULL

	--CODLUGAR
	UNION
	SELECT		@L_Carpeta,
				'CODLUGAR',
				'',
				0,
				LEFT(CONCAT(E.TC_Descripcion,',',D.TC_Descripcion,',',C.TC_Descripcion,',',B.TC_Descripcion,',',A.TC_Señas),255) -- Trunca a 255
	FROM		Expediente.Expediente	A WITH (NOLOCK)
	INNER JOIN	Catalogo.Barrio			B WITH (NOLOCK)
	ON			B.TN_CodBarrio			= A.TN_CodBarrio
	AND			B.TN_CodDistrito		= A.TN_CodDistrito
	AND			B.TN_CodCanton			= A.TN_CodCanton
	AND			B.TN_CodProvincia		= A.TN_CodProvincia
	INNER JOIN	Catalogo.Distrito		C WITH (NOLOCK)
	ON			C.TN_CodDistrito		= A.TN_CodDistrito
	AND			C.TN_CodCanton			= A.TN_CodCanton
	AND			C.TN_CodProvincia		= A.TN_CodProvincia
	INNER JOIN	Catalogo.Canton			D WITH (NOLOCK)
	ON			D.TN_CodCanton			= A.TN_CodCanton
	AND			D.TN_CodProvincia		= A.TN_CodProvincia
	INNER JOIN	Catalogo.Provincia		E WITH (NOLOCK)
	ON			E.TN_CodProvincia		= A.TN_CodProvincia
	WHERE		A.TC_NumeroExpediente	= @L_TC_NumeroExpediente
	AND			A.TN_CodProvincia		IS NOT NULL
	AND			A.TN_CodCanton			IS NOT NULL
	AND			A.TN_CodDistrito		IS NOT NULL
	AND			A.TN_CodBarrio			IS NOT NULL
	AND			A.TC_Señas				IS NOT NULL

	--ESCRITOS
	UNION
	SELECT		@L_Carpeta,
				'ESCRITOS',
				'',
				0,
				CASE
					WHEN B.CantidadEscritos > 0 THEN 'S'
					ELSE 'N'
				END
	FROM		Expediente.Expediente	X WITH (NOLOCK)
	OUTER APPLY(	
				SELECT		COUNT (*) CantidadEscritos 
				FROM		Expediente.EscritoExpediente	A WITH (NOLOCK)
				LEFT JOIN	Expediente.EscritoLegajo		B WITH (NOLOCK)
				ON			B.TU_CodEscrito					= A.TU_CodEscrito	
				WHERE		TC_NumeroExpediente				= X.TC_NumeroExpediente
				AND			(@L_TU_CodLegajo				IS NULL 
							OR B.TU_CodLegajo				= @L_TU_CodLegajo)
				AND			A.TC_EstadoEscrito				= 'P' --PENDIENTE
	) B
	WHERE		X.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	--FECHECHO
	UNION
	SELECT		@L_Carpeta,
				'FECHECHO',
				'',
				0,
				CONVERT(VARCHAR,A.TF_Hechos)
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	--FEHECHO
	UNION
	SELECT		@L_Carpeta,
				'FEHECHO',
				'',
				0,
				CONVERT(VARCHAR,A.TF_Hechos)
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	--HORAFECHA
	UNION
	SELECT		@L_Carpeta,
				'HORAFECHA',
				'',
				0,
				CONVERT(VARCHAR,MAX(B.TF_FechaResolucion))
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	INNER JOIN	Expediente.Resolucion	B	WITH (NOLOCK)
	ON			A.TC_NumeroExpediente	=	B.TC_NumeroExpediente
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	----HORFECR1
	--UNION
	--SELECT		@L_Carpeta,
	--			'HORFECR1',
	--			'',
	--			0,
	--			CONVERT(VARCHAR,C.MontoRemate)
	--FROM		Expediente.Expediente	A
	--INNER JOIN	Expediente.Resolucion	B
	--ON	A.TC_NumeroExpediente			=	B.TC_NumeroExpediente
	--OUTER APPLY(
	--	SELECT	MontoRemate 
	--	FROM	@BASE		
	--	WHERE	(SELECT ROW_NUMBER() OVER (ORDER BY MontoRemate DESC) as Row FROM @BASE)=3
	--	)C
	--WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	----HORFECR2
	--UNION
	--SELECT		@L_Carpeta,
	--			'HORFECR2',
	--			'',
	--			0,
	--			CONVERT(VARCHAR,C.MontoRemate)
	--FROM		Expediente.Expediente	A
	--INNER JOIN	Expediente.Resolucion	B
	--ON	A.TC_NumeroExpediente			=	B.TC_NumeroExpediente
	--OUTER APPLY(
	--	SELECT	MontoRemate 
	--	FROM	@BASE		
	--	WHERE	(SELECT ROW_NUMBER() OVER (ORDER BY MontoRemate DESC) as Row FROM @BASE)=2
	--	)C
	--WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	----HORFECR3
	--UNION
	--SELECT		@L_Carpeta,
	--			'HORFECR3',
	--			'',
	--			0,
	--			CONVERT(VARCHAR,C.MontoRemate)
	--FROM		Expediente.Expediente	A
	--INNER JOIN	Expediente.Resolucion	B
	--ON	A.TC_NumeroExpediente			=	B.TC_NumeroExpediente
	--OUTER APPLY(
	--	SELECT	MontoRemate 
	--	FROM	@BASE		
	--	WHERE	(SELECT ROW_NUMBER() OVER (ORDER BY MontoRemate DESC) as Row FROM @BASE)=1
	--	)C
	--WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	--AGUINAL
	UNION
	SELECT		@L_Carpeta,
				'AGUINAL',
				'',
				0,
				CONVERT(VARCHAR,A.TN_MontoAguinaldo)
	FROM		Expediente.Expediente	A	WITH (NOLOCK)
	WHERE		A.TC_NumeroExpediente	=	@L_TC_NumeroExpediente

	--DESCHEC
	UNION
	SELECT		@L_Carpeta,
				'DESCHEC',
				'',
				0,
				CONVERT(VARCHAR(255),A.TC_DescripcionHechos)
	FROM		Expediente.Expediente	A WITH (NOLOCK)
	WHERE		A.TC_NumeroExpediente	= @L_TC_NumeroExpediente

	--INDIGENA
	UNION
	SELECT		@L_Carpeta,
				'INDIGENA',
				'',
				0,
				CASE 
					WHEN E.CANTIDAD > 0 THEN 'S'
					ELSE 'N'
				END	
	FROM		Expediente.Expediente			X	WITH (NOLOCK)
	OUTER APPLY
	(			SELECT	COUNT(A.TU_CodInterviniente) CANTIDAD
				FROM	(
						SELECT		A.TU_CodInterviniente
						FROM		Expediente.Intervencion			A WITH (NOLOCK)
						LEFT JOIN	Expediente.LegajoIntervencion	L WITH (NOLOCK) 
						on			L.TU_CodInterviniente			= A.TU_CodInterviniente		
						INNER JOIN	Persona.PersonaFisica			F WITH (NOLOCK) 
						on			F.TU_CodPersona					= A.TU_CodPersona	
						WHERE		A.TF_Inicio_Vigencia			<=  GETDATE() 
						AND			A.TC_NumeroExpediente			=	X.TC_NumeroExpediente
						AND			(A.TF_Fin_Vigencia				IS NULL 
										OR A.TF_Fin_Vigencia		>= GETDATE()) 
						AND			F.TN_CodEtnia					in  (	SELECT	TC_Valor 
																			FROM	@ValoresConfiguracioneEtniasIndigenas) 
						AND			(@L_TU_CodLegajo				IS NULL
									OR L.TU_CodLegajo				=	@L_TU_CodLegajo)
						UNION
						SELECT		A.TU_CodInterviniente
						FROM		Expediente.Intervencion						A WITH (NOLOCK)
						LEFT JOIN	Expediente.LegajoIntervencion				L WITH (NOLOCK) 
						on			L.TU_CodInterviniente						= A.TU_CodInterviniente		
						INNER JOIN	Expediente.IntervinienteVulnerabilidad		P WITH (NOLOCK) 
						on			P.TU_CodInterviniente						= A.TU_CodInterviniente 
						WHERE		A.TF_Inicio_Vigencia						<=  GETDATE() 
						AND			A.TC_NumeroExpediente						=  X.TC_NumeroExpediente
						AND			(A.TF_Fin_Vigencia							IS NULL 
										OR A.TF_Fin_Vigencia					>= GETDATE()) 
						AND			P.TN_CodVulnerabilidad						in  (	SELECT	TC_Valor 
																						FROM	@ValoresConfiguracionesVulnerabilidadesIndigenas) 
						AND			(@L_TU_CodLegajo							IS NULL
									OR L.TU_CodLegajo							=	@L_TU_CodLegajo)
					) A
	) E
	WHERE 		X.TC_NumeroExpediente			= @L_TC_NumeroExpediente

	--PROVH
	UNION
	SELECT		@L_Carpeta,
				'PROVH',
				'',
				0,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Provincia', A.TN_CodProvincia,0,0)--CODPROV
	FROM		Expediente.Expediente	A WITH (NOLOCK)
	WHERE		A.TC_NumeroExpediente	= @L_TC_NumeroExpediente

	--SALESCO
	UNION
	SELECT		@L_Carpeta,
				'SALESCO',
				'',
				0,
				CONVERT(VARCHAR,A.TN_MontoSalarioEscolar)
	FROM		Expediente.Expediente	A WITH (NOLOCK)
	WHERE		A.TC_NumeroExpediente	= @L_TC_NumeroExpediente

	--TESTPIE
	UNION
	SELECT		@L_Carpeta,
				'TESTPIE',
				'',
				0,
				CASE
					WHEN B.TC_TestimonioPiezas IS NULL THEN 'N'
					ELSE 'S'
				END
	FROM		Expediente.Expediente			A	WITH (NOLOCK)
	INNER JOIN	Expediente.ExpedienteDetalle	B	WITH (NOLOCK)
	ON			A.TC_NumeroExpediente			=	B.TC_NumeroExpediente
	AND			B.TC_CodContexto				=	A.TC_CodContexto
	WHERE		A.TC_NumeroExpediente			=	@L_TC_NumeroExpediente

	
	-- Tablas a devolver
	SELECT * FROM @CONTEXTO;
	
	SELECT * FROM @DCARMASD WHERE VALOR IS NOT NULL AND VALOR <> '';
END
GO
