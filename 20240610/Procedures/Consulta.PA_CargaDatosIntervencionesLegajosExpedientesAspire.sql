SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aarón Ríos Retana>
-- Fecha de creación:		<21/03/2022>
-- Descripción :			<HU 225856 - Realiza una consulta de todas las intervenciones (legajos y expedientes) de la base de datos de SIAGPJ para ser utilizada por los componentes aspire y ElasticSearch> 
-- =========================================================================================================================================================================
-- Modificación:			<05/06/2023> <Luis Alonso Leiva Tames> <Se aumenta el tamaño del campo descripcionclase a varchar 200>

CREATE  PROCEDURE [Consulta].[PA_CargaDatosIntervencionesLegajosExpedientesAspire]
AS
	BEGIN
	-- se crea la tabla temporal 
	Declare @Intervenciones AS TABLE
	(
		identificador					VARCHAR(100)			NULL,
		codinterviniente				UNIQUEIDENTIFIER			,
		tipoparticipacion				CHAR(1)					NULL,
		numeroexpediente				CHAR(14)				NULL,
		codcontexto						VARCHAR(4)				NULL,
		descripcioncontexto				VARCHAR(255)			NULL,
		coddelito						NVARCHAR(MAX)			NULL,
		descripciondelito				NVARCHAR(MAX)			NULL,
		codtipopersona					CHAR(1)					NULL,
		identificacion					VARCHAR(21)				NULL,
		codtipoentidadjuridica			SMALLINT				NULL,
		desctipoentidadjuridica			VARCHAR(255)			NULL,
		codtipointervencion				SMALLINT				NULL,
		desctipointervencion			VARCHAR(255)			NULL,
		codsexo							CHAR(1)					NULL,
		desccodsexo						VARCHAR(50)				NULL,
		fechanacimiento					DATETIME2(7)			NULL,
		caracteristicas					VARCHAR(255)			NULL,
		rebeldia						BIT						NULL,
		nombre							VARCHAR(255)			NULL,
		apellido1						VARCHAR(50)				NULL,	
		apellido2						VARCHAR(50)				NULL,
		codigolegajo					UNIQUEIDENTIFIER		NULL,
		fechaentrada					DATETIME2(7)			NULL,
		codasunto						INT						NULL,
		descripcionasunto				VARCHAR(200)			NULL,
		codclase						INT						NULL,
		descripcionclase				VARCHAR(200)			NULL,
		codclaseasunto					INT						NULL,
		descripcionclaseasunto			VARCHAR(100)			NULL,
		codmateria						VARCHAR(5)				NULL,
		descripcionmateria				VARCHAR(50)				NULL,
		codfase							SMALLINT				NULL,
		descripcionfase					VARCHAR(255)			NULL,
		consultaprivadaciudadano		BIT						NULL,
		descripcion						VARCHAR	(255)			NULL,
		codcontextodetalle				VARCHAR(4)				NULL,
		sa_nombre						VARCHAR(255)			NULL,
		sa_apellido1					VARCHAR(50)				NULL,
		sa_apellido2					VARCHAR(50)				NULL
	);

	-- se cargan los datos de las intervenciones de expedientes
	INSERT INTO @Intervenciones
	(
		identificador,
		codinterviniente,
		tipoparticipacion,
		numeroexpediente,
		codcontexto,
		descripcioncontexto,
		codtipopersona,
		identificacion,
		codtipoentidadjuridica,
		desctipoentidadjuridica,
		codtipointervencion,
		desctipointervencion,
		codsexo,
		desccodsexo,
		fechanacimiento,
		caracteristicas,
		rebeldia,
		nombre,
		apellido1,
		apellido2,
		fechaentrada,
		descripcion,
		codclase,
		descripcionclase,
		codmateria,
		descripcionmateria,
		codfase,
		descripcionfase,
		consultaprivadaciudadano,
		codcontextodetalle,
		sa_nombre,
		sa_apellido1,
		sa_apellido2
	)
	SELECT			
					(CAST(I.TU_CodInterviniente AS VARCHAR(36))
					+ '-' +	ED.TC_CodContexto),
					I.TU_CodInterviniente,
					I.TC_TipoParticipacion,
					I.TC_NumeroExpediente,
					E.TC_CodContexto,
					C.TC_Descripcion,
					P.TC_CodTipoPersona,
					P.TC_Identificacion,
					PJ.TN_CodTipoEntidad,
					TEJ.TC_Descripcion,
					INTE.TN_CodTipoIntervencion,
					TI.TC_Descripcion,
					PF.TC_CodSexo,
					S.TC_Descripcion,
					PF.TF_FechaNacimiento,
					INTE.TC_Caracteristicas,
					INTE.TB_Rebeldia,
					IIF(P.TC_CodTipoPersona = 'F', PF.TC_Nombre, PJ.TC_Nombre),
					PF.TC_PrimerApellido,
					PF.TC_SegundoApellido,
					ED.TF_Entrada,
					E.TC_Descripcion,
					ED.TN_CodClase,
					CL.TC_Descripcion,
					C.TC_CodMateria,
					CM.TC_Descripcion,
					ED.TN_CodFase,
					CF.TC_Descripcion,
					C.TB_ConsultaPrivadaCiudadano,
					ED.TC_CodContexto,
					IIF(P.TC_CodTipoPersona = 'F', PF.TC_Nombre, PJ.TC_Nombre) COLLATE SQL_Latin1_General_Cp1251_CS_as,
					PF.TC_PrimerApellido COLLATE SQL_Latin1_General_Cp1251_CS_as,
					PF.TC_SegundoApellido COLLATE SQL_Latin1_General_Cp1251_CS_as
	FROM			Expediente.Intervencion			AS	I		WITH	(NOLOCK)
	Left Join		Expediente.Interviniente		AS	INTE	WITH	(NOLOCK)
	ON				I.TU_CodInterviniente			=	INTE.TU_CodInterviniente
	Left Join		Catalogo.TipoIntervencion		AS	TI		WITH	(NOLOCK)
	ON				INTE.TN_CodTipoIntervencion		=	TI.TN_CodTipoIntervencion
	Inner Join		Expediente.Expediente			AS	E		WITH	(NOLOCK)
	ON				I.TC_NumeroExpediente			=	E.TC_NumeroExpediente
	Inner Join		Expediente.ExpedienteDetalle	AS	ED		WITH	(NOLOCK)
	ON				E.TC_NumeroExpediente			=	ED.TC_NumeroExpediente
	Inner Join		Catalogo.Contexto				AS	C		WITH	(NOLOCK)
	ON				E.TC_CodContexto				=	C.TC_CodContexto
	Inner Join		Persona.Persona					AS	P		WITH	(NOLOCK)
	ON				I.TU_CodPersona					=	P.TU_CodPersona
	Left Join		Persona.PersonaFisica			AS	PF		WITH	(NOLOCK)
	ON				P.TU_CodPersona					=	PF.TU_CodPersona
	Left Join		Catalogo.Sexo					AS	S		WITH	(NOLOCK)
	ON				PF.TC_CodSexo					=	S.TC_CodSexo
	Left Join		Persona.PersonaJuridica			AS	PJ		WITH	(NOLOCK)
	ON				P.TU_CodPersona					=	PJ.TU_CodPersona
	Left Join		Catalogo.TipoEntidadJuridica	AS	TEJ		WITH	(NOLOCK)
	ON				PJ.TN_CodTipoEntidad			=	TEJ.TN_CodTipoEntidad
	Inner Join		Catalogo.Clase					AS	CL		WITH	(NOLOCK)
	ON				ED.TN_CodClase					=	CL.TN_CodClase
	Inner Join		Catalogo.Materia				AS	CM		WITH	(NOLOCK)
	ON				C.TC_CodMateria					=	CM.TC_CodMateria
	Left Join		Catalogo.Fase					AS	CF		WITH	(NOLOCK)
	ON				CF.TN_CodFase					=	ED.TN_CodFase
	WHERE			Not Exists
					(SELECT 
					TU_CodInterviniente
					FROM 
					Expediente.LegajoIntervencion
					WHERE TU_CodInterviniente = I.TU_CodInterviniente)
	and ED.TC_CodContexto	<> '0000'
	
	-- se cargan los datos de las intervenciones de legajos
	INSERT INTO @Intervenciones
	(
		identificador,
		descripcion,
		codinterviniente,
		tipoparticipacion,
		numeroexpediente,
		codcontexto,
		descripcioncontexto,
		codtipopersona,
		identificacion,
		codtipoentidadjuridica,
		desctipoentidadjuridica,
		codtipointervencion,
		desctipointervencion,
		codsexo,
		desccodsexo,
		fechanacimiento,
		caracteristicas,
		rebeldia,
		nombre ,
		apellido1,
		apellido2,
		codigolegajo,
		fechaentrada,
		codasunto,
		descripcionasunto,
		codclaseasunto,
		descripcionclaseasunto,
		codmateria,
		descripcionmateria,
		codfase,
		descripcionfase,
		consultaprivadaciudadano,
		codcontextodetalle,
		sa_nombre,
		sa_apellido1,
		sa_apellido2
	)
	SELECT			
					(CAST(I.TU_CodInterviniente AS VARCHAR(36))
					+ '-' +	LD.TC_CodContexto
					+ '-' + CAST(L.TU_CodLegajo AS VARCHAR(36))),
					L.TC_Descripcion,
					I.TU_CodInterviniente,
					I.TC_TipoParticipacion,
					L.TC_NumeroExpediente,
					L.TC_CodContexto,
					C.TC_Descripcion,
					P.TC_CodTipoPersona,
					P.TC_Identificacion,
					PJ.TN_CodTipoEntidad,
					TEJ.TC_Descripcion,
					INTE.TN_CodTipoIntervencion,
					TI.TC_Descripcion,
					PF.TC_CodSexo,
					S.TC_Descripcion,
					PF.TF_FechaNacimiento,
					INTE.TC_Caracteristicas,
					INTE.TB_Rebeldia,
					IIF(P.TC_CodTipoPersona = 'F', PF.TC_Nombre, PJ.TC_Nombre),
					PF.TC_PrimerApellido,
					PF.TC_SegundoApellido,
					L.TU_CodLegajo,
					LD.TF_Entrada,					
					LD.TN_Codasunto,
					CA.TC_Descripcion,
					LD.TN_CodClaseasunto,
					CL.TC_Descripcion,
					C.TC_CodMateria,
					CM.TC_Descripcion,
					HF.TN_CodFase,
					CF.TC_Descripcion,
					C.TB_ConsultaPrivadaCiudadano,
					LD.TC_CodContexto,
					IIF(P.TC_CodTipoPersona = 'F', PF.TC_Nombre, PJ.TC_Nombre) COLLATE SQL_Latin1_General_Cp1251_CS_as,
					PF.TC_PrimerApellido COLLATE SQL_Latin1_General_Cp1251_CS_as,
					PF.TC_SegundoApellido COLLATE SQL_Latin1_General_Cp1251_CS_as	
	FROM			Expediente.LegajoIntervencion	AS	LI		WITH	(NOLOCK)
	Inner Join		Expediente.Legajo				AS	L		WITH	(NOLOCK)
	ON				L.TU_CodLegajo					=	LI.TU_CodLegajo
	Inner Join		Expediente.LegajoDetalle		AS	LD		WITH	(NOLOCK)
	ON				L.TU_CodLegajo					=	LD.TU_CodLegajo
	Inner Join		Expediente.Intervencion			AS	I		WITH	(NOLOCK)
	ON				I.TU_CodInterviniente			=	LI.TU_CodInterviniente
	Inner Join		Persona.Persona					AS	P		WITH	(NOLOCK)
	ON				I.TU_CodPersona					=	P.TU_CodPersona
	Inner Join		Catalogo.Contexto				AS	C		WITH	(NOLOCK)
	ON				L.TC_CodContexto				=	C.TC_CodContexto
	Inner Join		Expediente.Expediente			AS	E		WITH	(NOLOCK)
	ON				E.TC_NumeroExpediente			=	L.TC_NumeroExpediente
	Left Join		Expediente.Interviniente		AS	INTE	WITH	(NOLOCK)
	ON				I.TU_CodInterviniente			=	INTE.TU_CodInterviniente
	And				LI.TU_CodInterviniente			=	INTE.TU_CodInterviniente
	Left Join		Catalogo.TipoIntervencion		AS	TI		WITH	(NOLOCK)
	ON				INTE.TN_CodTipoIntervencion		=	TI.TN_CodTipoIntervencion
	Left Join		Persona.PersonaFisica			AS	PF		WITH	(NOLOCK)
	ON				P.TU_CodPersona					=	PF.TU_CodPersona
	Left Join		Catalogo.Sexo					AS	S		WITH	(NOLOCK)
	ON				PF.TC_CodSexo					=	S.TC_CodSexo
	Left Join		Persona.PersonaJuridica			AS	PJ		WITH	(NOLOCK)
	ON				P.TU_CodPersona					=	PJ.TU_CodPersona
	Left Join		Catalogo.TipoEntidadJuridica	AS	TEJ		WITH	(NOLOCK)
	ON				PJ.TN_CodTipoEntidad			=	TEJ.TN_CodTipoEntidad
	Left Join		Catalogo.asunto					AS	CA		WITH	(NOLOCK)
	ON				LD.TN_Codasunto					=	CA.TN_Codasunto
	Left Join		Catalogo.Claseasunto			AS	CL		WITH	(NOLOCK)
	ON				LD.TN_CodClaseasunto			=	CL.TN_CodClaseasunto
	Left Join		Catalogo.Materia				AS	CM		WITH	(NOLOCK)
	ON				C.TC_CodMateria					=	CM.TC_CodMateria
	Left Join		Historico.LegajoFase			AS	HF		WITH	(NOLOCK)
	ON				HF.TU_CodLegajo					=	L.TU_CodLegajo
	And				HF.TC_CodContexto				=	L.TC_CodContexto
	And				HF.TU_CodLegajoFase				=	(SELECT	TOP 1 (HLF.TU_CodLegajoFase)
														FROM Historico.LegajoFase HLF WITH(NOLOCK)
														WHERE	HLF.TU_CodLegajo = L.TU_CodLegajo
														AND		HLF.TC_CodContexto = L.TC_CodContexto
														ORDER BY HLF.TF_Fase DESC ) 
	Left Join	Catalogo.Fase						AS	CF		WITH	(NOLOCK)
	ON			CF.TN_CodFase						=	HF.TN_CodFase
	
	--Cargamos los delitos de las intervenciones de los legajos y expedientes
	UPDATE	INTER
	SET		INTER.coddelito 		= (SELECT    STUFF((
										select N' , '+  RTRIM(DEL.TN_CodDelito) 
										FROM			Expediente.Intervencion			AS	I		WITH	(NOLOCK)
										JOIN			Expediente.Interviniente		AS	INTE	WITH	(NOLOCK)
										ON				I.TU_CodInterviniente			=	INTE.TU_CodInterviniente
										JOIN			Expediente.IntervinienteDelito	AS	ID		WITH	(NOLOCK)
										ON				ID.TU_CodInterviniente			=	INTE.TU_CodInterviniente
										JOIN			Catalogo.Delito					AS	DEL		WITH	(NOLOCK)
										ON				DEL.TN_CodDelito				=	ID.TN_CodDelito
										where INTER.codinterviniente = I.TU_CodInterviniente
												FOR XML PATH(''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N'')),
			INTER.descripciondelito	=	(SELECT    STUFF((
										select N' , '+  RTRIM(DEL.TC_Descripcion) 
										FROM			Expediente.Intervencion			AS	I		WITH	(NOLOCK)
										JOIN			Expediente.Interviniente		AS	INTE	WITH	(NOLOCK)
										ON				I.TU_CodInterviniente			=	INTE.TU_CodInterviniente
										JOIN			Expediente.IntervinienteDelito	AS	ID		WITH	(NOLOCK)
										ON				ID.TU_CodInterviniente			=	INTE.TU_CodInterviniente
										JOIN			Catalogo.Delito					AS	DEL		WITH	(NOLOCK)
										ON				DEL.TN_CodDelito				=	ID.TN_CodDelito
										where INTER.codinterviniente = I.TU_CodInterviniente
												FOR XML PATH(''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N''))
	FROM	@Intervenciones		AS	INTER
	
	--Retornamos los expedientes y legajos 
	SELECT * FROM @Intervenciones 
	END 
GO
