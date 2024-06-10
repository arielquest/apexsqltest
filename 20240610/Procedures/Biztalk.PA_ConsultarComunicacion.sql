SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Manuel Alejandro Villalta Ruiz>
-- Fecha de creación:		<11/09/2017>
-- Descripción:				<Obtiene una única comunicación según su código.> 
-- Modificación:            <Tatiana Flores><21/08/2018> Se utiliza la tabla Contexto en lugar de la tabla Oficina
-- Modificación:			<Cristian Cerdas><25/09/2020> Se modifica ya que tenia en la tabla comunicación.comunicacion el campo código legajo
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultarComunicacion]
(
	@CodigoComunicacion uniqueidentifier
)
AS
BEGIN

		SELECT 
		C.TU_CodComunicacion				AS Codigo,					C.TC_ConsecutivoComunicacion AS ConsecutivoComunicacion,
		L.TC_NumeroExpediente				AS Nue,						L.TU_CodLegajo				 AS CodigoLegajo, 
		MC.TC_TipoMedio						AS CodigoTipoMedio,			MC.TC_Descripcion			 AS TipoMedio,
		C.TC_Valor							AS Valor,					C.TC_Rotulado				 AS Rotulado,
		C.TB_TienePrioridad					AS TienePrioridad,			C.TN_PrioridadMedio			 AS PrioridadMedio,
		C.TB_RequiereCopias					AS RequiereCopias,			C.TC_Estado					 AS Estado,		
		C.TC_Observaciones					AS Observaciones,			C.TF_FechaResolucion		 AS FechaResolucion,		
		CO.TC_CodOficina					AS CodigoOficina,			OE.TC_Nombre				 AS NombreOficina,				
		CO.TC_Email							AS EmailOficina,			COCJ.TC_CodOficina			 AS CodigoOCJ,					
		OC.TC_Nombre						AS NombreOCJ,				COCJ.TC_Email			     AS EmailOCJ,
		CA.TN_CodAsunto  					As CodigoClaseAsunto,		CA.TC_Descripcion			 As ClaseAsunto,					
		IIF(I.TU_CodInterviniente is not null, I.TU_CodInterviniente,	R.TU_CodIntervinienteRepresentante)		 AS CodigoDestinatario,		
		IIF(I.TU_CodInterviniente is not null, P.TC_Identificacion,PR.TC_Identificacion)			 As IdentificacionDestinatario,	
		IIF(I.TU_CodInterviniente is not null, Biztalk.FN_ObtenerNombreCompletoPersona(
																						 P.TC_CodTipoPersona,
																						 PF.TC_Nombre,
																						 PF.TC_PrimerApellido, 
																						 PF.TC_SegundoApellido, 
																						 PJ.TC_Nombre
																						),											
												Biztalk.FN_ObtenerNombreCompletoPersona(
																						 PR.TC_CodTipoPersona,
																						 PFR.TC_Nombre,
																						 PFR.TC_PrimerApellido, 
																						 PFR.TC_SegundoApellido, 
																						 null
																						))			 As NombreDestinatario,
		IIF(I.TU_CodInterviniente is not null,'I','R')						 As TipoDestinatario,
		IIF(I.TU_CodInterviniente is not null,TI.TC_Descripcion,TR.TC_Descripcion)					As TipoIntervencion,
		C.TF_FechaRegistro					As	FechaRegistro,			PT.TC_UsuarioRed			As	UsuarioRegistra,
		TA.TC_Descripcion					As	TipAsunto,				MA.TC_CodMateria			As	CodigoMateria,
		MA.TC_Descripcion					As	Materia,				LI.TC_NumeroResolucion		As	NumeroVoto
		
	FROM		  [Comunicacion].[Comunicacion]				  C	WITH(NOLOCK)
	JOIN          [Expediente].[Legajo]						  L WITH(NOLOCK) 
	ON			  C.TC_NumeroExpediente  					  = L.TU_CodLegajo

	JOIN		  [Expediente].[LegajoDetalle]				 ELG WITH(NOLOCK)
	ON			  L.TU_CodLegajo							  = ELG.TU_CodLegajo

	JOIN          [Catalogo].[Asunto]						TA WITH(NOLOCK) 
	ON			  TA.TN_CodAsunto						  = ELG.TN_CodAsunto

	JOIN          [Expediente].[Expediente]					  E WITH(NOLOCK) 
	ON			  E.TC_NumeroExpediente						  = L.TC_NumeroExpediente 

	JOIN		  [Catalogo].[Contexto]						  CO WITH(NOLOCK)
	ON			  CO.TC_CodContexto							  = C.TC_CodContexto

	JOIN		  [Catalogo].[Oficina]						  OE WITH(NOLOCK)
	ON			  OE.TC_CodOficina							  = CO.TC_CodOficina

	JOIN		  [Catalogo].[Contexto]					      COCJ WITH(NOLOCK) 
	ON			  COCJ.TC_CodContexto						  = C.TC_CodContextoOCJ

	JOIN		  [Catalogo].[Oficina]					      OC WITH(NOLOCK) 
	ON			  OC.TC_CodOficina							  = COCJ.TC_CodOficina
	
	JOIN		  [Catalogo].[TipoMedioComunicacion]		  MC WITH(NOLOCK)
	ON			  MC.TN_CodMedio							  = C.TC_CodMedio

	JOIN		  [Catalogo].[ClaseAsunto]					  CA WITH(NOLOCK) 
	ON			  CA.TN_CodClaseAsunto						  = ELG.TN_CodClaseAsunto
	
	JOIN		  [Catalogo].[PuestoTrabajoFuncionario]		  PT WITH(NOLOCK) 
	ON			  PT.TU_CodPuestoFuncionario				  = C.TU_CodPuestoFuncionarioRegistro

	JOIN		  [Catalogo].[Materia]							MA WITH(NOLOCK) 
	ON			  MA.TC_CodMateria							  = C.TC_CodContexto

	JOIN		  [Comunicacion].[ArchivoComunicacion]			AC WITH(NOLOCK) 
	ON			  AC.TU_CodComunicacion						  =	C.TU_CodComunicacion
	And			  AC.TB_EsPrincipal							  =	1

	LEFT JOIN    Expediente.Resolucion						EXR WITH(NOLOCK)
	ON			AC.TU_CodArchivo							= EXR.TU_CodArchivo

	LEFT JOIN	  [Expediente].[LibroSentencia]                LI WITH(NOLOCK)
	ON            LI.TU_CodResolucion						=	EXR.TU_CodResolucion

	LEFT JOIN	  [Expediente].[Interviniente]                I WITH(NOLOCK)
	ON            I.TU_CodInterviniente                       = C.TU_CodInterviniente

	LEFT JOIN	  [Expediente].[Representacion]                R WITH(NOLOCK)
	ON            R.TU_CodIntervinienteRepresentante         =C.TU_CodInterviniente
	
	LEFT JOIN	  Persona.Persona							  As P WITH (Nolock) 
	On			  I.TU_CodInterviniente 					  =	P.TU_CodPersona

	LEFT JOIN	  Persona.PersonaFisica						  As PF WITH (Nolock) 
	On			  PF.TU_CodPersona							  =	P.TU_CodPersona

	LEFT JOIN	  Persona.PersonaJuridica					  As PJ WITH (Nolock) 
	On			  PJ.TU_CodPersona							  =	P.TU_CodPersona

	LEFT JOIN	  Persona.Persona							  As PR WITH (Nolock) 
	On			  R.TU_CodIntervinienteRepresentante 	  =	PR.TU_CodPersona

	LEFT JOIN	  Persona.PersonaFisica						  As PFR WITH (Nolock) 
	On			  PFR.TU_CodPersona							  =	PR.TU_CodPersona


	LEFT JOIN	  Catalogo.TipoIntervencion                   TI WITH(NOLOCK)
	ON            TI.TN_CodTipoIntervencion                   = I.TN_CodTipoIntervencion

	LEFT JOIN	  Catalogo.TipoRepresentacion                   TR WITH(NOLOCK)
	ON            TR.TN_CodTipoRepresentacion                   = R.TN_CodTipoRepresentacion

	WHERE c.TU_CodComunicacion = @CodigoComunicacion


END
GO
