SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<06/02/2020>
-- Descripción :			<Realiza una consulta de todas las intervenciones de la base de datos de SIAGPJ para ser utilizada por los componentes Aspire y ElasticSearch> 
-- =========================================================================================================================================================================
-- Modificado por:			<Kirvin Bennett Mathurin> <11/03/2021> <Se incluyen datos de carga del expediente para Gestión en Línea (FechaEntrada, Estado, Materia, Clase, Fase, ConsultaPrivadaCiudadano)> 
-- Modificado por:			<Kirvin Bennett Mathurin> <09/04/2021> <Se modifica quita el Outer apply y se cambia por un Left join para obtener la Fase y el Estado> 
-- Modificado por:			<Kirvin Bennett Mathurin> <13/04/2021> <Se modifica quita el Estado> 
-- Modificado por:			<Isaac Dobles Mata> <03/02/2022> <Se optimiza consulta para mostrar únicamente los intervinientes que pertenecen a un expediente y NO a un legajo> 
-- =========================================================================================================================================================================
--CREATE PROCEDURE [Consulta].[PA_CargaDatosIntervencionesAspire] - AAA
CREATE PROCEDURE [Consulta].[PA_CargaDatosIntervencionesAspire]
AS
	BEGIN
	
	CREATE TABLE #Intervenciones
	(
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
		fechaentrada					datetime2(7),
		descripcionexpediente			varchar(255),
		codclase						int,
		descripcionclase				varchar(200),
		codmateria						varchar(5),
		descripcionmateria				varchar(50),
		codfase							smallint,
		descripcionfase					varchar(255),
		consultaprivadaciudadano		bit
	)


	INSERT INTO #Intervenciones
	(
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
		fechaentrada,
		descripcionexpediente,
		codclase,
		descripcionclase,
		codmateria,
		descripcionmateria,
		codfase,
		descripcionfase,
		consultaprivadaciudadano
	)

	SELECT			I.TU_CodInterviniente,
					I.TC_TipoParticipacion,
					I.TC_NumeroExpediente,
					E.TC_CodContexto,
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
					ED.TF_Entrada,
					E.TC_Descripcion,
					ED.TN_CodClase,
					CL.TC_Descripcion,
					C.TC_CodMateria,
					CM.TC_Descripcion,
					ED.TN_CodFase,
					CF.TC_Descripcion,
					C.TB_ConsultaPrivadaCiudadano		

	FROM			Expediente.Intervencion			As	I		With	(NoLock)
	Left Join		Expediente.Interviniente		As	INTE	With	(NoLock)
	On				I.TU_CodInterviniente			=	INTE.TU_CodInterviniente
	Left Join		Catalogo.TipoIntervencion		As	TI		With	(NoLock)
	On				INTE.TN_CodTipoIntervencion		=	TI.TN_CodTipoIntervencion
	Inner Join		Expediente.Expediente			As	E		With	(NoLock)
	On				I.TC_NumeroExpediente			=	E.TC_NumeroExpediente
	Inner Join		Expediente.ExpedienteDetalle	As	ED		With	(NoLock)
	On				E.TC_NumeroExpediente			=	ED.TC_NumeroExpediente
	And				E.TC_CodContexto				=	ED.TC_CodContexto
	Inner Join		Catalogo.Contexto				As	C		With	(NoLock)
	On				E.TC_CodContexto				=	C.TC_CodContexto
	Left Join		Catalogo.Delito					As	D		With	(NoLock)
	On				E.TN_CodDelito					=	D.TN_CodDelito
	Inner Join		Persona.Persona					As	P		With	(NoLock)
	On				I.TU_CodPersona					=	P.TU_CodPersona
	Left Join		Persona.PersonaFisica			As	PF		With	(NoLock)
	On				P.TU_CodPersona					=	PF.TU_CodPersona
	Left Join		Catalogo.Sexo					As	S		With	(NoLock)
	On				PF.TC_CodSexo					=	S.TC_CodSexo
	Left Join		Persona.PersonaJuridica			As	PJ		With	(NoLock)
	On				P.TU_CodPersona					=	PJ.TU_CodPersona
	Left Join		Catalogo.TipoEntidadJuridica	As	TEJ		With	(NoLock)
	On				PJ.TN_CodTipoEntidad			=	TEJ.TN_CodTipoEntidad
	Inner Join		Catalogo.Clase					As	CL		With	(NoLock)
	On				ED.TN_CodClase					=	CL.TN_CodClase
	Inner Join		Catalogo.Materia				As	CM		With	(NoLock)
	On				C.TC_CodMateria					=	CM.TC_CodMateria
	Left Join		Catalogo.Fase					As	CF		With	(NoLock)
	On				CF.TN_CodFase					=	ED.TN_CodFase
	Where			Not Exists
					(Select 
					TU_CodInterviniente
					From 
					Expediente.LegajoIntervencion
					Where TU_CodInterviniente = I.TU_CodInterviniente)
	SELECT

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
			fechaentrada,
			descripcionexpediente,
			codclase,
			descripcionclase,
			codmateria,
			descripcionmateria,
			codfase,
			descripcionfase,
			consultaprivadaciudadano

	FROM	#Intervenciones
	
	END
GO
