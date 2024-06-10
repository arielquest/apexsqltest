SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Kirvin Bennett Mathurin>
-- Fecha de creación:		<12/03/2021>
-- Descripción :			<Realiza una consulta de todas las intervenciones asociadas a los legajos de la base de datos de SIAGPJ para ser utilizada por los componentes Aspire y ElasticSearch>
-- =========================================================================================================================================================================
-- Modificación:			<09/04/2021> <Kirvin Bennett Mathurin> <Se modifica quita el Outer apply y se cambia por un Left join para obtener la Fase y el Estado> 		
-- Modificación:			<13/04/2021> <Kirvin Bennett Mathurin> <Se modifica quita el Estado>
-- Modificación:			<14/02/2022> <Isaac Dobles Mata> <Se modifica consulta para agregar NEWID como llave>
-- Modificación:			<14/02/2022> <Michael Arroyo> <Se modifica consulta para mostrar descripción de Codigo Clase Asunto>
-- Modificación:			<06/10/2022> <Michael Arroyo> <Se modifica para evitar duplicados de intervenciones expedientes de acuerdo con el historico legajo fase>
-- Modificación:			<28/10/2022> <Michael Arroyo> <Se elimina NEWID y se implementa llave compuesta para evitar duplicidad de legajos en contenedor de Aspire>
-- =========================================================================================================================================================================
CREATE     PROCEDURE [Consulta].[PA_CargaDatosIntervencionesLegajosAspire]
AS
	BEGIN
	
	CREATE TABLE #Intervenciones
	(
		codllave						nvarchar(100),
		codinterviniente				uniqueidentifier,
		tipoparticipacion				char(1),
		numeroexpediente				char(14),
		codcontexto						varchar(4),
		descripcioncontexto				varchar(255),
		coddelito						int,
		descripciondelito				varchar(255),
		codtipopersona					char(1),
		identificacion					varchar(21),
		codtipoentidadjuridica			smallint,
		desctipoentidadjuridica			varchar(255),
		codtipointervencion				smallint,
		desctipointervencion			varchar(255),
		codsexo							char(1),
		desccodsexo						varchar(50),
		fechanacimiento					datetime2(7),
		caracteristicas					varchar(255),
		rebeldia						bit,
		nombre							varchar(max),
		codigolegajo					uniqueidentifier,
		fechaentrada					datetime2(7),
		descripcionlegajo				varchar(255),
		codasunto						int,
		descripcionasunto				varchar(200),
		codclaseasunto					int,
		descripcionclaseasunto			varchar(100),
		codmateria						varchar(5),
		descripcionmateria				varchar(50),
		codfase							smallint,
		descripcionfase					varchar(255),
		consultaprivadaciudadano		bit
	)


	INSERT INTO #Intervenciones
	(
		codllave,
		codinterviniente,
		tipoparticipacion,
		numeroexpediente,
		codcontexto,
		descripcioncontexto,
		coddelito,
		descripciondelito,
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
		codigolegajo,
		fechaentrada,
		descripcionlegajo,
		codasunto,
		descripcionasunto,
		codclaseasunto,
		descripcionclaseasunto,
		codmateria,
		descripcionmateria,
		codfase,
		descripcionfase,
		consultaprivadaciudadano
	)

	SELECT			CONCAT(I.TU_CodInterviniente,'|',L.TU_CodLegajo),
					I.TU_CodInterviniente,
					I.TC_TipoParticipacion,
					L.TC_NumeroExpediente,
					L.TC_CodContexto,
					C.TC_Descripcion,
					E.TN_CodDelito,
					D.TC_Descripcion,
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
					Case  When P.TC_CodTipoPersona = 'F'
						Then 
							PF.TC_Nombre + ' ' + PF.TC_PrimerApellido + ' ' + PF.TC_SegundoApellido
                        Else 
							PJ.TC_Nombre
                    End,
					L.TU_CodLegajo,
					LD.TF_Entrada,
					L.TC_Descripcion,
					LD.TN_CodAsunto,
					CA.TC_Descripcion,
					LD.TN_CodClaseAsunto,
					CL.TC_Descripcion,
					C.TC_CodMateria,
					CM.TC_Descripcion,
					HF.TN_CodFase,
					CF.TC_Descripcion,
					C.TB_ConsultaPrivadaCiudadano

	FROM			Expediente.LegajoIntervencion	As	LI		With	(NoLock)
	Inner Join		Expediente.Legajo				As	L		With	(NoLock)
	On				L.TU_CodLegajo					=	LI.TU_CodLegajo
	Inner Join		Expediente.LegajoDetalle		As	LD		With	(NoLock)
	On				L.TU_CodLegajo					=	LD.TU_CodLegajo
	And				L.TC_CodContexto				=	LD.TC_CodContexto
	Inner Join		Expediente.Intervencion			As	I		With	(NoLock)
	On				I.TU_CodInterviniente			=	LI.TU_CodInterviniente
	Inner Join		Persona.Persona					As	P		With	(NoLock)
	On				I.TU_CodPersona					=	P.TU_CodPersona
	Inner Join		Catalogo.Contexto				As	C		With	(NoLock)
	On				L.TC_CodContexto				=	C.TC_CodContexto
	Inner Join		Expediente.Expediente			As	E		With	(NoLock)
	On				E.TC_NumeroExpediente			=	L.TC_NumeroExpediente
	And				E.TC_CodContexto				=	L.TC_CodContexto
	Left Join		Expediente.Interviniente		As	INTE	With	(NoLock)
	On				I.TU_CodInterviniente			=	INTE.TU_CodInterviniente
	And				LI.TU_CodInterviniente			=	INTE.TU_CodInterviniente
	Left Join		Catalogo.TipoIntervencion		As	TI		With	(NoLock)
	On				INTE.TN_CodTipoIntervencion		=	TI.TN_CodTipoIntervencion
	Left Join		Catalogo.Delito					As	D		With	(NoLock)
	On				E.TN_CodDelito					=	D.TN_CodDelito
	Left Join		Persona.PersonaFisica			As	PF		With	(NoLock)
	On				P.TU_CodPersona					=	PF.TU_CodPersona
	Left Join		Catalogo.Sexo					As	S		With	(NoLock)
	On				PF.TC_CodSexo					=	S.TC_CodSexo
	Left Join		Persona.PersonaJuridica			As	PJ		With	(NoLock)
	On				P.TU_CodPersona					=	PJ.TU_CodPersona
	Left Join		Catalogo.TipoEntidadJuridica	As	TEJ		With	(NoLock)
	On				PJ.TN_CodTipoEntidad			=	TEJ.TN_CodTipoEntidad
	Left Join		Catalogo.Asunto					As	CA		With	(NoLock)
	On				LD.TN_CodAsunto					=	CA.TN_CodAsunto
	Left Join		Catalogo.ClaseAsunto			As	CL		With	(NoLock)
	On				LD.TN_CodClaseAsunto			=	CL.TN_CodClaseAsunto
	Left Join		Catalogo.Materia				As	CM		With	(NoLock)
	On				C.TC_CodMateria					=	CM.TC_CodMateria
	Left Join		Historico.LegajoFase			As	HF		WITH	(NOLOCK)
	On				HF.TU_CodLegajo					=	L.TU_CodLegajo
	And				HF.TC_CodContexto				=	L.TC_CodContexto
	And				HF.TU_CodLegajoFase				=	(SELECT	TOP 1 (HLF.TU_CodLegajoFase)
														FROM Historico.LegajoFase HLF WITH(NOLOCK)
														WHERE	HLF.TU_CodLegajo = L.TU_CodLegajo
														AND		HLF.TC_CodContexto =	L.TC_CodContexto
														ORDER BY HLF.TF_Fase DESC)
	Left Join	Catalogo.Fase						As	CF		WITH	(NOLOCK)
	On			CF.TN_CodFase						=	HF.TN_CodFase
	SELECT
			codllave,
			codinterviniente,
			tipoparticipacion,
			numeroexpediente,
			codcontexto,
			descripcioncontexto,
			coddelito,
			descripciondelito,
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
			codigolegajo,
			fechaentrada,
			descripcionlegajo,
			codasunto,
			descripcionasunto,
			codclaseasunto,
			descripcionclaseasunto,
			codmateria,
			descripcionmateria,
			codfase,
			descripcionfase,
			consultaprivadaciudadano

	FROM	#Intervenciones
	
	END
GO
