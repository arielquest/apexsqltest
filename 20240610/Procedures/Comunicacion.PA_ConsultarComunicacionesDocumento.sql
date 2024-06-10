SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=======================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez>
-- Fecha de creación:		<22/08/2018>
-- Descripción:				<Obtiene las comunicaciones asociadas a un documento.> 
-- Modificación:			<29/10/2018> <Juan Ramírez> <Se modifica la consulta y se ajusta al módulo de intervenciones>
--========================================================================================================
  
 
CREATE PROCEDURE [Comunicacion].[PA_ConsultarComunicacionesDocumento]
	@CodArchivo uniqueidentifier  ,
    @NumeroExpediente char(14) 
AS
BEGIN

	 	 SELECT	     
			            C.TU_CodComunicacion			AS CodigoComunicacion,		          	
						'split'		                    AS split,
						CO.TC_CodContexto				AS Codigo,					CO.TC_Descripcion				AS Descripcion,			
						'split'			                AS split,
						I.TC_Alias						AS Alias,					I.TC_Caracteristicas			AS Caracteristicas,
						I.TU_CodInterviniente			AS CodigoInterviniente,		I.TF_ComisionDelito				AS FechaComisionDelito,						
						'split'						    As split,					PF.TU_CodPersona				As	CodigoPersona,
						PF.TC_Nombre					As Nombre,					PF.TC_PrimerApellido			As	PrimerApellido,
						PF.TC_SegundoApellido			As SegundoApellido,		    Persona.TC_Identificacion		As	Identificacion,	
						'split'						    As split,					PJ.TU_CodPersona				As	CodigoPersona,
						PJ.TC_Nombre					As	Nombre,					Persona.TC_Identificacion		As	Identificacion,
						PJ.TC_NombreComercial			As	NombreComercial,
						'split'				            AS split, 		            C.TC_Estado						AS Estado,
						C.TC_Resultado					AS Resultado,		    	C.TC_TipoComunicacion			AS TipoComunicacion,
						MC.TC_TipoMedio					AS TipoMedio
	
			FROM		  Comunicacion.Comunicacion					C	WITH(NOLOCK)	
			INNER JOIN    Expediente.Legajo							L	WITH(NOLOCK) 
			ON			  C.TC_NumeroExpediente							=	L.TC_NumeroExpediente 
			INNER JOIN    Expediente.LegajoArchivo                  LA   WITH(NOLOCK)
			ON            L.TU_CodLegajo                            = LA.TU_CodLegajo 
			INNER JOIN    Comunicacion .ArchivoComunicacion         A   WITH(NOLOCK)
			ON            C.TU_CodComunicacion                      = A.TU_CodComunicacion  AND
			              LA.TU_CodArchivo                           = A.TU_CodArchivo	 						 
			INNER JOIN	  Catalogo.Contexto			   			CO	WITH(NOLOCK) 
			ON			  CO.TC_CodContexto							= C.TC_CodContextoOCJ
			INNER JOIN	  Catalogo.TipoMedioComunicacion			MC	WITH(NOLOCK)
			ON			  MC.TN_CodMedio							=	C.TC_CodMedio
			INNER JOIN	  Comunicacion.ComunicacionIntervencion			CI WITH(NOLOCK)
			ON            CI.TU_CodComunicacion                       = C.TU_CodComunicacion
			INNER JOIN	  [Expediente].Intervencion						IT WITH(NOLOCK)
			ON            IT.TU_CodInterviniente                       = CI.TU_CodInterviniente
			LEFT JOIN	  Expediente.Interviniente					I	WITH(NOLOCK)
			ON            I.TU_CodInterviniente						=	CI.TU_CodInterviniente	
			LEFT JOIN	  Persona.Persona							As	Persona WITH (Nolock) 
			On			  IT.TU_CodPersona							=	Persona.TU_CodPersona
			LEFT JOIN	  Persona.PersonaFisica						As	PF WITH (Nolock) 
			On			  PF.TU_CodPersona							=	Persona.TU_CodPersona
			LEFT JOIN	  Persona.PersonaJuridica					As	PJ WITH (Nolock) 
			On			  PJ.TU_CodPersona							=	Persona.TU_CodPersona	

			WHERE		  LA.TU_CodArchivo 		=	@CodArchivo 
			      AND     LA.TC_NumeroExpediente       =	@NumeroExpediente 
				  AND     A.TB_EsPrincipal	    =  1
			ORDER BY      C.TF_FechaRegistro Desc

END
GO
