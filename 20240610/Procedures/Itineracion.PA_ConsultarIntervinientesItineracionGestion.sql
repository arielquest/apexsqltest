SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<16/12/2020>
-- Descripción :			<Permite consultar los intervinientes asociados a un registro de Itineración de Gestión con catálogos del SIAGPJ>
-- =====================================================================================================================================================================================================
-- Modificación:			<12/01/2021> <Ronny Ramírez R.> <Se agrega campo IDINT como CodigoIntervinienteGestion para mapear con entidad de SIAGPJ>
-- Modificación:			<18/01/2021> <Ronny Ramírez R.> <Se aplica conversión binaria a campo REBELDE que puede tomar valores vac­os, nulos, S y N en gestión>
-- Modificación:			<19/01/2021> <Ronny Ramírez R.> <Se agrega configuración por defecto para el TipoIntervencionDefecto en caso de no haber equivalencia de Gestión
--										  y se mapea el tipo de Entidad Jurídica contra tabla de equivalencias según el # de cédula Jurídica, al igual que Esteban lo hizo.>
-- Modificación:			<22/01/2021> <Jose Gabriel Cordero Soto> <Se agrega valores para entidad juridica (cargo representante y Nombre representante)>
-- Modificación:			<09/02/2021> <Karol Jiménez Sánchez> <Se modifica para agregar datos relacionados a las intervenciones de tipo representantes>
-- Modificación:			<01/03/2021> <Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<12/03/2021> <Jonathan Aguilar Navarro><Se agrega a la consulta el valor Lugar de trabajo del interviniente>
-- Modificación:			<16/03/2021> <Karol Jiménez S.><Se valida si tipo Intervención es Jurídica, deje el nombre nulo, para poder mapear correctamente en el AD>
-- Modificación:			<22/03/2021> <Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:			<25/03/2021> <Karol Jiménez S.> <Se ajusta consulta de intervinientes, para que no se dupliquen cuando existen como representantes>
-- Modificación:			<11/06/2021> <Ronny Ramírez R.> <Se agrega configuración U_ITI_CodTipoIdCarneAbogado para saber si cargar el valor de carn' de abogado con códigos originales de gestión>
-- Modificación:			<14/06/2021> <Ronny Ramírez R.> <Se agrega equivalencia vac­a para catálogo de SIAGPJ tipo de entidad 17 - Sucursales, pues en el RNP no tiene asignado código>
-- Modificación:			<14/06/2021> <Ronny Ramírez R.> <Se corrige a nombre exacto de campo Rebelde en lugar de REBELDE, pues no se interpretaba, además se agrega valor de campo Turista>
-- Modificación:			<16/07/2021> <Luis Alonso Leiva Tames> <Se modifica para que muestre valores por defecto para Escolaridad, Profesion, SituacionLaboral ya que no puede enviarse en null>
-- Modificación:			<16/07/2021> <Luis Alonso Leiva Tames> <Se cambia el tipo de variable por catalogo para Escolaridad, Profesion, SituacionLaboral ya que no puede enviarse en null>
-- Modificación:			<29/07/2021> <Ronny Ramírez R.> <Se agrega configuración C_ITI_EtniaIntervPorDefecto para asignar valor por defecto a Etnia en caso que no venga desde gestión>
-- Modificación:			<03/08/2021> <Ronny Ramírez R.> <Se aplica corrección para convertir todos los CTE's a tablas en memoria @ para optimizar el rendimiento>
-- Modificación:			<26/11/2021> <Luis Alonso Leiva Tames> <Se agrega valor por defecto en caso que el codigo de etnia se reciba en null y codigo de país>
-- Modificación:			<31/08/2022> <Ronny Ramírez R.> <Se aplica corrección para traer solo los tipos de intervención activos para los intervinientes (solo debería haber 1)>
-- Modificación:			<28/02/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos Etnia, TipoIntervencion, Profesion, Escolaridad,
--							SituacionLaboral, Parentesco, Sexo, EstadoCivil y TipoIdentificacion)>
-- =====================================================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarIntervinientesItineracionGestion]
	@CodItineracion Uniqueidentifier
AS 

BEGIN
	--Variables 
	DECLARE	@L_CodItineracion					VARCHAR(36)			= @CodItineracion,
			@L_XML								XML,
			@L_NumeroExpediente					VARCHAR(14),
			@L_ContextoDestino					VARCHAR(4),
			@L_CodTipoIntervencion				SMALLINT,
			@L_CodTipoEntidad					SMALLINT,
			@L_ValorDefectoTipoIntervencionRep	SMALLINT			= NULL,
			@L_ValorDefectoProfesion			VARCHAR(255)		= NULL,
			@L_ValorDefectoEscolaridad			VARCHAR(255)		= NULL,
			@L_ValorDefectoSituacionLaboral		VARCHAR(255)		= NULL,
			@L_ValorDefectoEtniaIntervencion	SMALLINT			= NULL;

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SET @L_XML = (
					SELECT	VALUE 
					FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS WITH(NOLOCK) 
					WHERE	ID = @L_CodItineracion
				);

	-- Se obtiene el contexto al que se está itinerando y el # de expediente
	SELECT	@L_ContextoDestino					= RECIPIENTADDRESS,
			@L_NumeroExpediente					= NUE
	FROM	ItineracionesSIAGPJ.dbo.MESSAGES	WITH(NOLOCK) 
	WHERE	ID									= @L_CodItineracion

	-- Se obtiene valor por defecto para el tipo de intervención del interviniente desde configuración
	SET	@L_CodTipoIntervencion				= CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_TipoIntervencionInter', @L_ContextoDestino))
	SET	@L_ValorDefectoTipoIntervencionRep	= CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_TipoIntervencionRep',@L_ContextoDestino))
	SET	@L_ValorDefectoProfesion			= Itineracion.FN_ConsultarValorDefectoConfiguracion('C_Profesion','');
	SET	@L_ValorDefectoEscolaridad			= Itineracion.FN_ConsultarValorDefectoConfiguracion('C_Escolaridad','');
	SET	@L_ValorDefectoSituacionLaboral		= Itineracion.FN_ConsultarValorDefectoConfiguracion('C_SituacionLaboral','');
	
	SELECT	@L_ValorDefectoEtniaIntervencion	= TN_CodEtnia 
	FROM	Catalogo.Etnia WITH(NOLOCK) 
	WHERE	TN_CodEtnia = CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_EtniaIntervPorDefecto',@L_ContextoDestino));


	-- Equivalencias por defecto para el tipo de entidad Jurídica, sacados por los números iniciales de la identificación de tipo jurídico,
	-- de acuerdo a tabla sacada del Registro Nacional de la Propiedad investigado por Esteban
	DECLARE @TipoEntidadJuridica AS TABLE 
	(
		CodTipoEntidad SMALLINT NOT NULL PRIMARY KEY IDENTITY(2,1),
		CodEquivalenciaRNP VARCHAR(5) NOT NULL
	)
 
	 INSERT INTO @TipoEntidadJuridica VALUES ('2-100'), -- 2
											 ('2-200'), -- 3
											 ('2-300'), -- 4
											 ('2-400'), -- 5
											 ('3-002'), -- 6
											 ('3-003'), -- 7
											 ('3-004'), -- 8
											 ('3-005'), -- 9
											 ('3-006'), -- 10
											 ('3-007'), -- 11
											 ('3-008'), -- 12
											 ('3-009'), -- 13
											 ('3-010'), -- 14
											 ('3-011'), -- 15
											 ('3-012'), -- 16
											 (''),	   -- 17
											 ('3-013'), -- 18
											 ('3-014'), -- 19
											 ('3-101'), -- 20
											 ('3-102'), -- 21
											 ('3-103'), -- 22
											 ('3-104'), -- 23
											 ('3-105'), -- 24
											 ('3-106'), -- 25
											 ('3-107'), -- 26
											 ('3-108'), -- 27
											 ('3-109'), -- 28
											 ('3-110'), -- 29
											 ('4-000'), -- 30
											 ('5-001');-- 31

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	 
	-- Representantes
	DECLARE @DINTREP TABLE (IDINT INT, FECINI DATETIME2(3), FECFIN VARCHAR(35)) 
	INSERT INTO @DINTREP		
	SELECT		X.Y.value('(IDINTREP)[1]', 'INT'),	
				TRY_CONVERT(DATETIME2(3),X.Y.value('(FECINI)[1]', 'VARCHAR(35)')),
				TRY_CONVERT(DATETIME2(3),X.Y.value('(FECFIN)[1]', 'VARCHAR(35)'))
	FROM		@L_XML.nodes('(/*/DINTREP)')	AS X(Y)				
	
	-- Persona Intervención
	DECLARE @DINT TABLE (IDINT INT, CODINT VARCHAR(3), CODLAB VARCHAR(3), ALIAS VARCHAR(255), CODRELAC VARCHAR(9), LUGTRAB VARCHAR(255), CODFIJU VARCHAR(1), IND_TURISTA BIT)
	INSERT INTO @DINT		
	SELECT	A.B.value('(IDINT)[1]', 'INT'),
				A.B.value('(CODINT)[1]', 'VARCHAR(3)'),
				A.B.value('(CODLAB)[1]', 'VARCHAR(3)'),
				A.B.value('(ALIAS)[1]', 'VARCHAR(255)'),	
				A.B.value('(CODRELAC)[1]', 'VARCHAR(9)'),
				A.B.value('(LUGTRAB)[1]', 'VARCHAR(255)'),	
				A.B.value('(CODFIJU)[1]', 'VARCHAR(1)'),
				A.B.value('(IND_TURISTA)[1]', 'BIT')
		FROM	@L_XML.nodes('(/*/DINT)') AS A(B)
	
	DECLARE @INTERVINIENTES TABLE (IDINT INT, CODINT VARCHAR(3), CODLAB VARCHAR(3), ALIAS VARCHAR(255), CODRELAC VARCHAR(9), TipoParticipacion VARCHAR(1), FECINI DATETIME2(3), FECFIN VARCHAR(35), LUGTRAB VARCHAR(255), CODFIJU VARCHAR(1), IND_TURISTA BIT)
	INSERT INTO @INTERVINIENTES			
	SELECT  IDINT,			CODINT,					CODLAB,					ALIAS, 
			CODRELAC,		'P' TipoParticipacion,	GETDATE()	FECINI,		NULL	FECFIN, 
			LUGTRAB,		CODFIJU,				IND_TURISTA
	FROM	@DINT		
	WHERE	IDINT NOT IN (SELECT IDINT FROM @DINTREP) --SE EXCLUYEN LOS REPRESENTANTES QUE YA ESTAN REGISTRADOS EN DINTREP, PORQUE SINO SE DUPLICAR™AN

	UNION 

	SELECT		R.IDINT,			I.CODINT,					I.CODLAB,					I.ALIAS, 
				NULL CODRELAC,		'R' TipoParticipacion,		R.FECINI,					R.FECFIN, 
				I.LUGTRAB,			'F',						NULL	IND_TURISTA
	FROM		@DINTREP	R
	LEFT JOIN	@DINT	I
	ON			I.IDINT				= R.IDINT
	

	-- Persona F­sica
	DECLARE @DINTPER TABLE (IDINT INT, CODPAIS VARCHAR(5), CODPROINT VARCHAR(4), CODESCO VARCHAR(2), OBSERV VARCHAR(255), REBELDE VARCHAR(1), CODSEX VARCHAR(1), CODESCIV VARCHAR(1), CODTIPIDE VARCHAR(1), NUMINT VARCHAR(21), NOMBRE VARCHAR(50), APE1 VARCHAR(50), APE2 VARCHAR(50), FECNAC VARCHAR(35), LUGNAC VARCHAR(50), FECDEF VARCHAR(35), LUGDEF VARCHAR(50), NOMMAD VARCHAR(60), NOMPAD VARCHAR(60), CODETN VARCHAR(2))
	INSERT INTO	@DINTPER
	SELECT	C.D.value('(IDINT)[1]', 'INT'),
			C.D.value('(CODPAIS)[1]', 'VARCHAR(5)'),
			C.D.value('(CODPROINT)[1]', 'VARCHAR(4)'),
			C.D.value('(CODESCO)[1]', 'VARCHAR(2)'),
			C.D.value('(OBSERV)[1]', 'VARCHAR(255)'),
			C.D.value('(Rebelde)[1]', 'VARCHAR(1)'),
			C.D.value('(CODSEX)[1]', 'VARCHAR(1)'),
			C.D.value('(CODESCIV)[1]', 'VARCHAR(1)'),
			C.D.value('(CODTIPIDE)[1]', 'VARCHAR(1)'),
			C.D.value('(NUMINT)[1]', 'VARCHAR(21)'),
			C.D.value('(NOMBRE)[1]', 'VARCHAR(50)'),
			C.D.value('(APE1)[1]', 'VARCHAR(50)'),
			C.D.value('(APE2)[1]', 'VARCHAR(50)'),
			TRY_CONVERT(DATETIME2(3),C.D.value('(FECNAC)[1]', 'VARCHAR(35)')),
			C.D.value('(LUGNAC)[1]', 'VARCHAR(50)'),
			TRY_CONVERT(DATETIME2(3),C.D.value('(FECDEF)[1]', 'VARCHAR(35)')),
			C.D.value('(LUGDEF)[1]', 'VARCHAR(50)'),
			C.D.value('(NOMMAD)[1]', 'VARCHAR(60)'),
			C.D.value('(NOMPAD)[1]', 'VARCHAR(60)'),
			C.D.value('(CODETN)[1]', 'VARCHAR(2)')
		FROM @L_XML.nodes('(/*/DINTPER)') AS C(D)
	

	-- Persona Jur­ídica
	DECLARE @DINTENT TABLE(IDINT INT, CODTIPIDE VARCHAR(1), NUMINT VARCHAR(21), NOMBRE VARCHAR(100), NOMCIAL VARCHAR(100), NOMRESP VARCHAR(100), CARRESP VARCHAR(100))

	INSERT	INTO @DINTENT
	SELECT	E.F.value('(IDINT)[1]', 'INT'),
			E.F.value('(CODTIPIDE)[1]', 'VARCHAR(1)'),
			E.F.value('(NUMINT)[1]', 'VARCHAR(21)'),
			E.F.value('(NOMBRE)[1]', 'VARCHAR(100)'),
			E.F.value('(NOMCIAL)[1]', 'VARCHAR(100)'),
			E.F.value('(NOMRESP)[1]', 'VARCHAR(100)'),
			E.F.value('(CARRESP)[1]', 'VARCHAR(100)')
	FROM @L_XML.nodes('(/*/DINTENT)') AS E(F)
	

	-- Catálogo de Tipo Intervención
	DECLARE @TipoIntervencionDefecto TABLE (Codigo SMALLINT, Descripcion VARCHAR(255), Intervencion CHAR(1))
	INSERT INTO @TipoIntervencionDefecto
	SELECT	TN_CodTipoIntervencion, TC_Descripcion, TC_Intervencion
	FROM	Catalogo.TipoIntervencion	WITH(NOLOCK)
	WHERE	TN_CodTipoIntervencion		=  @L_CodTipoIntervencion
	

	-- Se obtienen valores que aplican para identificar carnés de abogado entre los datos de EV/Gestión 
	DECLARE @ValoresCarneAbogado TABLE (Codigo VARCHAR(255))
	INSERT INTO 	@ValoresCarneAbogado	
	SELECT	TC_Valor
	FROM	Configuracion.ConfiguracionValor 
	WHERE	TC_CodConfiguracion					=	'U_ITI_CodTipoIdCarneAbogado'
	AND		TF_FechaActivacion					<=	GETDATE() 
	AND		(
					TF_FechaCaducidad			IS NULL 
				OR	TF_FechaCaducidad			>	GETDATE()
			)
	

	-- Consulta de registros de intervinientes con equivalencias de catálogos de SIAGPJ
	SELECT			A.FECINI									As	FechaActivacion,
					A.FECFIN									As	FechaDesactivacion,
					GETDATE()									As	FechaModificacion,					
					'Split'										As	Split,
					A.IDINT										As	CodigoIntervinienteGestion,
					@L_NumeroExpediente							As	NumeroExpediente,
					CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)		As	CodigoInterviniente,
					CASE WHEN A.TipoParticipacion = 'R' --Representante 
						THEN @L_ValorDefectoTipoIntervencionRep
						ELSE
							ISNULL(
								B.TN_CodTipoIntervencion,
								@L_CodTipoIntervencion
							)											
					END											As	CodigoTipoIntervencion,	
					CASE WHEN A.TipoParticipacion = 'R' --Representante
							THEN 'Representante'
						ELSE
							ISNULL(
							B.TC_Descripcion,
							(SELECT Descripcion FROM @TipoIntervencionDefecto)		
						)											
					END											As	TipoIntervencionDescrip,
					CASE WHEN E.TC_CodPais IS NULL THEN '040' ELSE E.TC_CodPais END	As	CodigoPais,     			
					CASE WHEN E.TC_Descripcion IS NULL THEN 'COSTA RICA' ELSE E.TC_Descripcion END	As	PaisDescrip,
					CASE WHEN F.TN_CodProfesion IS NULL 
						THEN @L_ValorDefectoProfesion 
					ELSE F.TN_CodProfesion END					As	CodigoProfesion,			
					F.TC_Descripcion							As	ProfesionDescrip,	
					CASE WHEN G.TN_CodEscolaridad IS NULL
						THEN @L_ValorDefectoEscolaridad
					ELSE G.TN_CodEscolaridad END				As	CodigoEscolaridad,			
					G.TC_Descripcion							As	EscolaridadDescrip,	
					cast('1753-1-1' as datetime)				As	FechaComisionDelito, -- La entidad no acepta null
					DP.OBSERV									As	Caracteristicas,
					CASE WHEN I.TN_CodSituacionLaboral IS NULL
						THEN @L_ValorDefectoSituacionLaboral 
					ELSE I.TN_CodSituacionLaboral END			As	CodigoSituacionLaboral,		
					I.TC_Descripcion							As	SituacionLaboralDescrip,
					A.ALIAS										As	Alias, 
					NULL										As	Droga,	
					CAST(
					 CASE
						WHEN UPPER(DP.REBELDE) = 'S' THEN 1						
						ELSE 0
					 END
					AS BIT)										As  Rebeldia,
					P.TC_CodParentesco							As  CodigoParentesco,			
					P.TC_Descripcion							As	DescripcionParentesco,
					A.TipoParticipacion							As  TipoParticipacion,				
					A.IND_TURISTA								As  Turista,
					CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)		As	CodigoPersona,				
					ISNULL(
						B.TC_Intervencion,
						(SELECT Intervencion FROM @TipoIntervencionDefecto)		
					)											As	Intervencion,
					'D'											As	Origen,
					H.TC_CodSexo								As	CodigoSexo,					
					H.TC_Descripcion							As	SexoDescrip,
					C.TN_CodEstadoCivil							As	CodigoEstadoCivil,			
					C.TC_Descripcion							As	EstadoCivilDescrip,	
					A.LUGTRAB									AS	LugarTrabajo,
					
					'SplitPersonaFisica'						As	SplitPersonaFisica,
					CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)		As	CodigoPersona,
					DP.NUMINT									As	Identificacion,	
					CASE WHEN A.CODFIJU IS NULL OR A.CODFIJU = 'J'
						THEN NULL
						ELSE ISNULL(DP.NOMBRE, 'IGNORADO')
					END											As	Nombre,
					ISNULL(DP.APE1, 'IGNORADO')					As	PrimerApellido,
					DP.APE2										As	SegundoApellido,
					DP.FECNAC									As	FechaNacimiento,			
					DP.LUGNAC									As	LugarNacimiento,
					DP.FECDEF									As	FechaDefuncion,				
					DP.LUGDEF									As	LugarDefuncion,
					DP.NOMMAD									As	NombreMadre,
					DP.NOMPAD									As	NombrePadre,
					CASE WHEN DP.CODTIPIDE IN (
												SELECT Codigo FROM @ValoresCarneAbogado
											  )
						THEN DP.NUMINT
						ELSE NULL
					END											As	Carne,
					NULL										As  Salario,
					0											As	EsIgnorado,	

					'SplitPersonaJuridica'						As	SplitPersonaJuridica,
					CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)		As	CodigoPersona,
					DI.NUMINT									As	Identificacion,
					DI.NOMBRE									As	Nombre,
					DI.NOMCIAL									As	NombreComercial,
					DI.NOMRESP									As	NombreRepresentante,
					DI.CARRESP									As  CargoRepresentante,
					
					'SplitTipoIdentificacion'					As	SplitTipoIdentificacion,
					M.TN_CodTipoIdentificacion					As	Codigo,						
					M.TC_Descripcion							As	Descripcion,
					M.TC_Formato								As	Formato,					
					M.TB_Nacional								As	Nacional,

					'SplitEtnia'								As	SplitEtnia,
					CASE WHEN N.TN_CodEtnia IS NULL THEN '6' ELSE N.TN_CodEtnia END	As	Codigo,						
					CASE WHEN N.TC_Descripcion IS NULL THEN 'Desconocida' ELSE N.TC_Descripcion END As	Descripcion,												

					'SplitTipoEntidadJuridica'					As	SplitTipoEntidadJuridica,
					O.TN_CodTipoEntidad							As	Codigo,		
					O.TC_Descripcion							As	Descripcion
	
	From			@INTERVINIENTES					A		-- Datos Persona
	LEFT JOIN		@DINTPER						DP		-- Datos Persona Fí­sica
	ON				DP.IDINT						=	A.IDINT
	LEFT JOIN		@DINTENT						DI		-- Datos Persona Jurídica
	ON				DI.IDINT						=	A.IDINT
	LEFT JOIN		Catalogo.TipoIntervencion		B	WITH(NOLOCK) 
	ON				B.TN_CodTipoIntervencion		=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'TipoIntervencion', A.CODINT,0,0))
	AND				(
						B.TF_Inicio_Vigencia			<	GETDATE()
						AND
						(
							B.TF_Fin_Vigencia				IS NULL 
							OR 
							B.TF_Fin_Vigencia			>=	GETDATE()
						)
					)													-- Toma solo tipos de intervención activos (solo debe haber 1)
	LEFT JOIN		Catalogo.Pais					E	WITH(NOLOCK) 
	On				E.TC_CodPais 					=	DP.CODPAIS
	LEFT JOIN		Catalogo.Profesion				F	WITH(NOLOCK)
	ON				F.TN_CodProfesion				=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Profesion', DP.CODPROINT,0,0))
	LEFT JOIN		Catalogo.Escolaridad			G	WITH(NOLOCK) 
	ON				G.TN_CodEscolaridad				=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Escolaridad', DP.CODESCO,0,0))
	LEFT JOIN		Catalogo.SituacionLaboral		I	WITH(NOLOCK) 
	ON				I.TN_CodSituacionLaboral		=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'SituacionLaboral', A.CODLAB,0,0))
	LEFT JOIN		Catalogo.Parentesco				P	WITH(NOLOCK) 
	ON				P.TC_CodParentesco				=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Parentesco', A.CODRELAC,0,0))
	LEFT JOIN		Catalogo.Sexo					H	WITH(NOLOCK) 
	ON				H.TC_CodSexo					=	CONVERT(CHAR(1), Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Sexo', DP.CODSEX,0,0))
	LEFT JOIN		Catalogo.EstadoCivil			C	WITH(NOLOCK) 
	ON				C.TN_CodEstadoCivil				=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'EstadoCivil', DP.CODESCIV,0,0))
	LEFT JOIN		Catalogo.TipoIdentificacion		M	WITH(NOLOCK)
	ON				M.TN_CodTipoIdentificacion 		=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'TipoIdentificacion', ISNULL(DP.CODTIPIDE, DI.CODTIPIDE),0,0))
	LEFT JOIN		Catalogo.Etnia					N	WITH(NOLOCK)
	ON				N.TN_CodEtnia 					=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Etnia', ISNULL(DP.CODETN, @L_ValorDefectoEtniaIntervencion),0,0))
	LEFT JOIN		Catalogo.TipoEntidadJuridica	O	WITH(NOLOCK)
	On				O.TN_CodTipoEntidad				=	ISNULL(
															(
																SELECT CodTipoEntidad
																FROM @TipoEntidadJuridica
																WHERE SUBSTRING(DI.NUMINT, 1, 1) + '-' + SUBSTRING(DI.NUMINT, 2, 3) = CodEquivalenciaRNP
															)
															,	1 -- Desconocido
														)
	ORDER BY		TipoParticipacion				DESC	
END
GO
