SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<13/11/2019>
-- Descripción :			<Realiza una consulta de todos los expedientes de la base de datos de SIAGPJ para ser utilizada por los componentes Aspire y ElasticSearch> 
-- =============================================================================================================================================================================
-- Modificación:			<04/02/2020> <Isaac Dobles Mata> <Se agrega más datos al procedimiento para realizar consulta avanzada de expedientes>
-- Modificación:			<02/06/2021> <Isaac Dobles Mata> <Se corrige problema de tipo en Estado y se optimiza consulta>
-- Modificación:			<14/07/2021> <Isaac Dobles Mata> <Se agrega NEWID para identificar cada registro únicamente>
-- Modificación:			<08/03/2022> <Aarón Ríos Retana> < HU 225841 - Se crea una tabla temporal y se añade otra consulta para habilitar la carga de datos de los legajos>
-- Modificación:			<02/12/2022> <Ronny Ramírez R.> <PBI 291674 - Se realiza ajuste para evitar error por caracteres especiales en resultados XML>
-- =============================================================================================================================================================================
CREATE    PROCEDURE [Consulta].[PA_CargaDatosExpedienteAspire]
AS

	BEGIN
	
	--Declaramos la tabla temporal donde se cargaran los expedientes y los legajos 
	Declare @ExpedienteLegajos AS TABLE
	(
		identificador					VARCHAR(50)				NULL,
		numeroexpediente				VARCHAR (14)			NOT NULL,
		descripcion						VARCHAR	(255)			NULL,
		documentosfisicos				BIT						NULL,
		fechainicio						DATETIME2				NULL,
		fechaentrada					DATETIME2				NULL,		 
		codcontexto						VARCHAR (4)				NULL,
		descripcioncontexto				VARCHAR	(255)			NULL,
		codcontextoprocedencia			VARCHAR (4)				NULL,
		codprioridad					SMALLINT				NULL,
		descripcionprioridad			VARCHAR	(150)			NULL,
		codclase						INTEGER					NULL,
		descripcionclase				VARCHAR (200)			NULL,
		codproceso						SMALLINT				NULL,
		descripcionproceso				VARCHAR (100)			NULL,
		codcategoriadelito				INTEGER					NULL,
		coddelito						INTEGER					NULL,
		descripciondelito				VARCHAR	(255)			NULL,
		codestado						INTEGER					NULL,
		descripcionestado				VARCHAR	(150)			NULL,
		intervenciones					NVARCHAR(MAX)			NULL,
		codmateria						VARCHAR (5)				NULL,
		descripcionmateria				VARCHAR (50)			NULL,
		codigolegajo					UNIQUEIDENTIFIER		NULL,
		codigoasunto					INT						NULL,
		descripcionasunto				VARCHAR(200)			NULL,
		codclaseasunto					INT						NULL,
		descripcionclaseasunto			VARCHAR(100)			NULL,
		codcontextodetalle				VARCHAR(4)				NULL
	);

	--Cargamos los expedientes y legajos en la tabla temporal
	INSERT INTO @ExpedienteLegajos 
	--Consulta de expedientes 
		SELECT			
					(E.TC_NumeroExpediente + '-' +
					ED.TC_CodContexto)					AS			identificador,
					E.TC_NumeroExpediente				AS			numeroexpediente,	
					E.TC_Descripcion					AS			descripcion,
					ED.TB_DocumentosFisicos				AS			documentosfisicos,
					E.TF_Inicio							AS			fechainicio,			
					ED.TF_Entrada						AS			fechaentrada,		 
					E.TC_CodContexto					AS			codcontexto,
					C.TC_Descripcion					AS			descripcioncontexto,
					ED.TC_CodContextoProcedencia		AS			codcontextoprocedencia,
					P.TN_CodPrioridad					AS			codprioridad,
					P.TC_Descripcion					AS			descripcionprioridad,
					M.TN_CodClase						AS			codclase,
					M.TC_Descripcion					AS			descripcionclase,
					N.TN_CodProceso						AS			codproceso,
					N.TC_Descripcion					AS			descripcionproceso,
					CD.TN_CodCategoriaDelito			AS			codcategoriadelito,
					T.TN_CodDelito						AS			coddelito,
					T.TC_Descripcion					AS			descripciondelito,
					U.TN_CodEstado						AS			codestado,
					U.TC_Descripcion					AS			descripcionestado,
					NULL								AS			intervenciones,
					CONDET.TC_CodMateria				AS			codmateria,
					MA.TC_Descripcion					AS			descripcionmateria,
					NULL								AS			CodigoLegajo,
					NULL								AS			CodigoAsunto,
					NULL								AS			DescripcionAsunto,
					NULL								AS			CodClaseAsunto,
					NULL								AS			DescripcionClaseAsunto,
					ED.TC_CodContexto					AS			codcontextodetalle
	FROM			Expediente.Expediente						AS  E	WITH	(NOLOCK)
	INNER JOIN		Expediente.ExpedienteDetalle				AS	ED	WITH	(NOLOCK)	
	ON			    E.TC_NumeroExpediente						=	ED.TC_NumeroExpediente
	INNER JOIN		Catalogo.Contexto							AS  C	WITH	(NOLOCK)
	ON				C.TC_CodContexto							=	E.TC_CodContexto
	INNER JOIN		Catalogo.Contexto							AS  CONDET	WITH	(NOLOCK)
	ON				CONDET.TC_CodContexto						=	ED.TC_CodContexto
	INNER JOIN		Catalogo.Materia							AS  MA	WITH	(NOLOCK)
	ON				CONDET.TC_CodMateria						=	MA.TC_CodMateria
	Left Outer JOIN	Catalogo.Prioridad							AS  P	WITH	(NOLOCK)
	ON				E.TN_CodPrioridad							=	P.TN_CodPrioridad
	INNER JOIN		Catalogo.Clase								AS	M	WITH	(NOLOCK)
	ON				M.TN_CodClase								=	ED.TN_CodClase
	INNER JOIN		Catalogo.Proceso							AS	N	WITH	(NOLOCK)
	ON				N.TN_CodProceso								=	ED.TN_CodProceso
	Left JOIN		Catalogo.Delito								AS	T	WITH	(NOLOCK)
	ON				T.TN_CodDelito								=	E.TN_CodDelito
	Left JOIN		Catalogo.CategoriaDelito					AS	CD	WITH	(NOLOCK)
	ON				CD.TN_CodCategoriaDelito					=	T.TN_CodCategoriaDelito
	INNER JOIN		Historico.ExpedienteMovimientoCirculante	AS	EMC WITH (NOLOCK)
	ON				EMC.TC_NumeroExpediente						=	ED.TC_NumeroExpediente
	INNER JOIN		Catalogo.Estado								AS	U WITH (NOLOCK)
	ON				U.TN_CodEstado								=	EMC.TN_CodEstado
	AND				EMC.TN_CodExpedienteMovimientoCirculante	=	(SELECT TOP 1 TN_CodExpedienteMovimientoCirculante 
																	FROM Historico.ExpedienteMovimientoCirculante WITH (NOLOCK)
																	WHERE TC_NumeroExpediente = ED.TC_NumeroExpediente
																	AND	  TC_CodContexto =	ED.TC_CodContexto
																	ORDER BY TN_CodExpedienteMovimientoCirculante desc)
where ED.TC_CodContexto	<> '0000'

	UNION
	--Consulta de legajos
	SELECT
					(cast(LE.TU_CodLegajo AS VARCHAR(36))	
					+ '-' +	LED.TC_CodContexto)			AS			identificador,
					LE.TC_NumeroExpediente				AS			numeroexpediente,	
					LE.TC_Descripcion					AS			descripcion,
					DF.TB_DocumentosFisicos				AS			documentosfisicos,
					LE.TF_Inicio						AS			fechainicio,			
					LED.TF_Entrada						AS			fechaentrada,		 
					LED.TC_CodContexto					AS			codcontexto,
					CON.TC_Descripcion					AS			descripcioncontexto,
					LED.TC_CodContextoProcedencia		AS			codcontextoprocedencia,
					LE.TN_CodPrioridad					AS			codprioridad,
					PRI.TC_Descripcion					AS			descripcionprioridad,
					NULL								AS			codclase,
					NULL								AS			descripcionclase,
					LED.TN_CodProceso					AS			codproceso,
					PRO.TC_Descripcion					AS			descripcionproceso,
					NULL								AS			codcategoriadelito,
					NULL								AS			coddelito,
					NULL								AS			descripciondelito,
					ES.TN_CodEstado						AS			codestado,
					ES.TC_Descripcion					AS			descripcionestado,
					NULL								AS			intervenciones,
					CONDET.TC_CodMateria				AS			codmateria,
					MA.TC_Descripcion					AS			descripcionmateria,
					LE.TU_CodLegajo						AS			CodigoLegajo,
					ASU.TN_CodAsunto					AS			CodigoAsunto,
					ASU.TC_Descripcion					AS			DescripcionAsunto,
					CLA.TN_CodClaseAsunto				AS			CodClaseAsunto,
					CLA.TC_Descripcion					AS			DescripcionClaseAsunto,
					LED.TC_CodContexto					AS			codcontextodetalle
	FROM			Expediente.Expediente						AS	E		WITH	(NOLOCK)
	Left JOIN		Expediente.Legajo							AS	LE		WITH	(NOLOCK)
	ON				E.TC_NumeroExpediente						=	LE.TC_NumeroExpediente 
	INNER JOIN		Expediente.LegajoDetalle					AS  LED		WITH	(NOLOCK)
	ON				LE.TU_CodLegajo								=	LED.TU_CodLegajo
	INNER JOIN		Catalogo.Contexto							AS  CON		WITH	(NOLOCK)
	ON				CON.TC_CodContexto							=	LE.TC_CodContexto
	INNER JOIN		Catalogo.Contexto							AS  CONDET	WITH	(NOLOCK)
	ON				CONDET.TC_CodContexto						=	LED.TC_CodContexto
	INNER JOIN		Catalogo.Materia							AS  MA		WITH	(NOLOCK)
	ON				CONDET.TC_CodMateria						=	MA.TC_CodMateria
	Left Outer JOIN	Catalogo.Prioridad							AS  PRI		WITH	(NOLOCK)
	ON				LE.TN_CodPrioridad							=	PRI.TN_CodPrioridad
	INNER JOIN		Catalogo.Asunto								AS	ASU		WITH	(NOLOCK)
	ON				LED.TN_CodAsunto							=	ASU.TN_CodAsunto	
	INNER JOIN		Catalogo.ClaseAsunto						AS	CLA		WITH	(NOLOCK)
	ON				CLA.TN_CodClaseAsunto						=	LED.TN_CodClaseAsunto
	Left JOIN		Catalogo.Proceso							AS	PRO		WITH	(NOLOCK)
	ON				PRO.TN_CodProceso							=	LED.TN_CodProceso
	INNER JOIN		Historico.LegajoMovimientoCirculante		AS	EMC		WITH	(NOLOCK)
	ON				EMC.TC_NumeroExpediente						=	LE.TC_NumeroExpediente
	INNER JOIN		Catalogo.Estado								AS	ES		WITH	(NOLOCK)
	ON				ES.TN_CodEstado								=	EMC.TN_CodEstado
	AND				EMC.TN_CodLegajoMovimientoCirculante		=	(SELECT TOP 1 TN_CodLegajoMovimientoCirculante 
																	FROM Historico.LegajoMovimientoCirculante WITH (NOLOCK)
																	WHERE TU_CodLegajo = LE.TU_CodLegajo
																	AND	  TC_CodContexto =	LED.TC_CodContexto
																	ORDER BY TN_CodLegajoMovimientoCirculante desc)
	OUTER APPLY (	SELECT		top 1 (ED.TB_DocumentosFisicos)
					FROM		Expediente.ExpedienteDetalle AS ED WITH (NOLOCK)
					WHERE		ED.TC_NumeroExpediente = LE.TC_NumeroExpediente
					ORDER BY	ED.TF_Entrada DESC) AS DF

	----Cargamos los intervinientes de los expedientes, en una sola línea concatenados por expediente y con # de separador
	UPDATE			LE
	SET				LE.intervenciones		=	(
													SELECT	STUFF
													(
														(
															SELECT
															N' #' +
															REPLACE
															(
																(
																	SELECT
																	RTRIM
																	(
																		COALESCE(K.TC_Nombre, L.TC_Nombre) 
																		+ ' ' + COALESCE(K.TC_PrimerApellido,'') 
																		+ ' ' + COALESCE(K.TC_SegundoApellido,'')
																	) 
																	+ '' FOR XML PATH('') -- Evita error por caracteres ilegales en XML, sin eliminarlos
																)
																,'#','' -- elimina el caracter # en caso de aparecer dentro del texto, pues es el que se utiliza como separador de intervinientes
															)
															FROM			Expediente.Intervencion			AS	A WITH(NOLOCK)
															INNER JOIN		Persona.Persona					AS	J WITH(NOLOCK)
															ON				J.TU_CodPersona					=	A.TU_CodPersona
															AND				A.TC_NumeroExpediente			=  LE.numeroexpediente
															LEFT JOIN		Persona.PersonaFisica			AS	K WITH(NOLOCK)
															ON				K.TU_CodPersona					=	J.TU_CodPersona
															LEFT JOIN		Persona.PersonaJuridica			AS	L WITH(NOLOCK)
															ON				L.TU_CodPersona					=	J.TU_CodPersona	
															FOR XML PATH(''), TYPE
														)
														.value(N'.[1]', N'nvarchar(max)'), 1, 2, N''
													)
												)			
	FROM			@ExpedienteLegajos		AS	LE
	WHERE			LE.codigolegajo is null
							
	------------Cargamos los intervinientes de los legajos, en una sola línea concatenados por expediente y con # de separador
	UPDATE			LE
	SET				LE.intervenciones		=	(
													SELECT	STUFF
													(
														(
															SELECT 
															N' #' +
															REPLACE
															(
																(
																	SELECT  																		
																	RTRIM
																	(
																		COALESCE(K.TC_Nombre, L.TC_Nombre) 
																		+ ' ' + COALESCE(K.TC_PrimerApellido,'') 
																		+ ' ' + COALESCE(K.TC_SegundoApellido,'')
																	)
																	 + '' FOR XML PATH('') -- Evita error por caracteres ilegales en XML, sin eliminarlos
																)
																,'#','' -- elimina el caracter # en caso de aparecer dentro del texto, pues es el que se utiliza como separador de intervinientes
															)
															FROM			Expediente.LegajoIntervencion	AS	B WITH(NOLOCK)
															INNER JOIN		Expediente.Intervencion			AS	A WITH(NOLOCK)
															ON				B.TU_CodInterviniente			=	A.TU_CodInterviniente
															INNER JOIN		Persona.Persona					AS	J WITH(NOLOCK)
															ON				J.TU_CodPersona					=	A.TU_CodPersona
															LEFT JOIN		Persona.PersonaFisica			AS	K WITH(NOLOCK)
															ON				K.TU_CodPersona					=	J.TU_CodPersona
															LEFT JOIN		Persona.PersonaJuridica			AS	L WITH(NOLOCK)
															ON				L.TU_CodPersona					=	J.TU_CodPersona
															WHERE			B.TU_CodLegajo					=	LE.codigolegajo
															FOR XML PATH(''), TYPE
														)
														.value(N'.[1]', N'nvarchar(max)'), 1, 2, N''
													)
												)
	FROM			@ExpedienteLegajos		AS	LE
	WHERE			LE.codigolegajo is not null
	
	--Retornamos los expedientes y legajos 
	SELECT * FROM @ExpedienteLegajos

	END
GO
