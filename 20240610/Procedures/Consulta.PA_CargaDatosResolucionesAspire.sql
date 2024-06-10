SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =========================================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<06/02/2020>
-- Descripción :			<Realiza una consulta de todas las resoluciones de la base de datos de SIAGPJ para ser utilizada por los componentes Aspire y ElasticSearch> 
-- =========================================================================================================================================================================
-- Modificación:			<05/04/2022> <Aarón Ríos Retana> < Bug 214859 - Se crea un identificador personalizado, ya que se detecta errores de duplicación de registros en aspire y elastic search>
-- =========================================================================================================================================================================
CREATE PROCEDURE [Consulta].[PA_CargaDatosResolucionesAspire]
AS
	BEGIN
	
	CREATE TABLE #Resoluciones
	(
		identificador					VARCHAR(100),
		codresolucion					uniqueidentifier,
		idarchivo						uniqueidentifier,
		numeroexpediente				char(14),
		codcontexto						varchar(4),
		descripcioncontexto				varchar(255),
		codredactor						uniqueidentifier,
		nombreredactor					varchar(max),
		puestotrabajoredactor			varchar(14),
		codestadoresolucion				tinyint,
		codtiporesolucion				smallint,
		desctiporesolucion				varchar(100),
		codresultadoresolucion			smallint,
		descresultadoresolucion			varchar(150),
		fecharesolucion					datetime2(7),
		numeroresolucion				char(14),
		fechacreacion					datetime2(7),
		portanto						varchar(max)
	)

	INSERT INTO #Resoluciones
	(
		identificador,
		codresolucion,
		idarchivo,
		numeroexpediente,
		codcontexto,
		descripcioncontexto,
		codredactor,
		nombreredactor,
		puestotrabajoredactor,
		codestadoresolucion,
		codtiporesolucion,
		desctiporesolucion,
		codresultadoresolucion,
		descresultadoresolucion,
		fecharesolucion,
		numeroresolucion,
		fechacreacion,
		portanto
	)

	SELECT			
					(CAST(R.TU_CodResolucion AS VARCHAR(36))) + '-' + (CAST(LS.TU_CodLibroSentencia AS VARCHAR(36))),
					R.TU_CodResolucion,
					R.TU_CodArchivo,
					E.TC_NumeroExpediente,
					E.TC_CodContexto,
					C.TC_Descripcion,
					R.TU_RedactorResponsable,			
					F.TC_Nombre + ' ' + F.TC_PrimerApellido + ' ' + F.TC_SegundoApellido,
					PTF.TC_CodPuestoTrabajo,
					A.TN_CodEstado,
					R.TN_CodTipoResolucion,
					TR.TC_Descripcion,
					R.TN_CodResultadoResolucion,
					RR.TC_Descripcion,
					R.TF_FechaResolucion,
					LS.TC_NumeroResolucion,
					R.TF_FechaCreacion,
					R.TC_PorTanto
	FROM			Expediente.Resolucion						As	R	With	(NoLock)
	Inner Join		Archivo.Archivo								As	A	With	(NoLock)
	On				R.TU_CodArchivo								=	A.TU_CodArchivo
	Inner Join		Expediente.Expediente						As  E	With	(NoLock)
	On				R.TC_NumeroExpediente						=	E.TC_NumeroExpediente
	Inner Join		Catalogo.Contexto							As  C	With	(NoLock)
	On				C.TC_CodContexto							=	E.TC_CodContexto
	Inner Join		Catalogo.TipoResolucion						As	TR	With	(NoLock)
	On				R.TN_CodTipoResolucion						=	TR.TN_CodTipoResolucion
	Inner Join		Catalogo.ResultadoResolucion				As	RR	With	(NoLock)
	On				R.TN_CodResultadoResolucion					=	RR.TN_CodResultadoResolucion
	Inner Join		Expediente.LibroSentencia					As	LS	With	(NoLock)
	On				R.TU_CodResolucion							=	LS.TU_CodResolucion
	Inner Join		Catalogo.PuestoTrabajoFuncionario			As	PTF	With	(NoLock)
	On				R.TU_RedactorResponsable					=	PTF.TU_CodPuestoFuncionario
	Inner Join		Catalogo.Funcionario						As	F	With	(NoLock)
	On				PTF.TC_UsuarioRed							=	F.TC_UsuarioRed
	Where			A.TN_CodEstado								=	'4'

	SELECT
			identificador,
			codresolucion,
			idarchivo,
			numeroexpediente,
			codcontexto,
			descripcioncontexto,
			codredactor,
			nombreredactor,
			puestotrabajoredactor,
			codestadoresolucion,
			codtiporesolucion,
			desctiporesolucion,
			codresultadoresolucion,
			descresultadoresolucion,
			fecharesolucion,
			numeroresolucion,
			fechacreacion,
			portanto
	FROM #Resoluciones
	
	END
GO
