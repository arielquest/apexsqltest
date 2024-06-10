SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Juan Ramirez V.>
-- Fecha de creación:		<30/10/2018>
-- Descripción :			<Permite Consultar las intervenciones asociadas a una comunicación
-- =================================================================================================================================================
-- Modificación:			<15/10/2021><Luis Alonso Leiva Tames><Se modifica la relación con las tablas Expediente.Interviniente y  Catalogo.TipoIntervencion>
-- =================================================================================================================================================

CREATE PROCEDURE [Comunicacion].[PA_ConsultarIntervencionesAsociadas]
	@CodigoComunicacion 	uniqueidentifier,
	@CodigoInterviniente	uniqueidentifier = null
As
Begin
		Select 		CI.TB_Principal					As  EsPrincipal,
					Z.TF_Inicio_Vigencia			As  FechaActivacion,		  
					Z.TF_Fin_Vigencia				As  FechaDesactivacion, 
					Z.TF_Actualizacion				As  FechaModificacion,						      																
					'SplitInterviniente'			As	SplitInterviniente,
					A.TU_CodInterviniente			As	CodigoInterviniente,		A.TF_ComisionDelito				As	FechaComisionDelito, 
					A.TC_Caracteristicas			As	Caracteristicas,			A.TC_Alias						As	Alias, 
					A.TB_Droga						As	Droga,						A.TB_Rebeldia					As  Rebeldia,
					Z.TU_CodPersona					As	CodigoPersona,				
					A.TC_CodPais					As	CodigoPais,     			E.TC_Descripcion				As	PaisDescrip,				
					A.TN_CodProfesion				As	CodigoProfesion,			F.TC_Descripcion				As	ProfesionDescrip,			
					A.TN_CodEscolaridad				As	CodigoEscolaridad,			G.TC_Descripcion				As	EscolaridadDescrip,			
					A.TN_CodSituacionLaboral		As	CodigoSituacionLaboral,		I.TC_Descripcion				As	SituacionLaboralDescrip,
					'SplitTipoIntervencion'			As	SplitTipoIntervencion,
					A.TN_CodTipoIntervencion		As	Codigo,						B.TC_Descripcion				As	Descripcion,
					'SplitPersonaFisica'			As	SplitPersonaFisica,
					Z.TU_CodPersona					As	CodigoPersona,
					J.TC_Identificacion				As	Identificacion,				K.TC_Nombre						As	Nombre,
					K.TC_PrimerApellido				As	PrimerApellido,				K.TC_SegundoApellido			As	SegundoApellido,
					K.TF_FechaNacimiento			As	FechaNacimiento,			K.TC_LugarNacimiento			As	LugarNacimiento,
					K.TF_FechaDefuncion				As	FechaDefuncion,				K.TC_LugarDefuncion				As	LugarDefuncion,
					K.TC_NombreMadre				As	NombreMadre,				K.TC_NombrePadre				As	NombrePadre,
					K.TC_Carne						As	Carne,					
					K.TB_EsIgnorado					As	EsIgnorado,					
					H.TC_CodSexo					As	CodigoSexo,					H.TC_Descripcion				As	SexoDescrip,
					C.TN_CodEstadoCivil				As	CodigoEstadoCivil,			C.TC_Descripcion				As	EstadoCivilDescrip,						
					'SplitPersonaJuridica'			As	SplitPersonaJuridica,
					Z.TU_CodPersona					As	CodigoPersona,
					J.TC_Identificacion				As	Identificacion,				L.TC_Nombre						As	Nombre,
					L.TC_NombreComercial			As	NombreComercial,
					'SplitOtros'					As	SplitOtros,
					Z.TC_TipoParticipacion			As  CodigoTipoParticipacion,	
					J.TN_CodTipoIdentificacion		As	Codigo,						M.TC_Descripcion				As	Descripcion,
					M.TC_Formato					As	Formato,					M.TB_Nacional					As	Nacional,					
					L.TN_CodTipoEntidad				As	CodigoEntidad,				O.TC_Descripcion				As	DescripcionEntidad,	
					B.TC_Intervencion 				As Intervencion					
	FROM		  	Comunicacion.ComunicacionIntervencion	As	CI	WITH(NOLOCK)
	INNER JOIN		Expediente.Intervencion 		As  Z With(NoLock)	
	On 				CI.TU_CodInterviniente			=	Z.TU_CodInterviniente
	LEFT JOIN		Expediente.Interviniente		As	A With(NoLock)
	On 				A.TU_CodInterviniente			=	Z.TU_CodInterviniente	
	LEFT JOIN		Catalogo.TipoIntervencion		As	B With(NoLock) 
	On				B.TN_CodTipoIntervencion		=	A.TN_CodTipoIntervencion	
	LEFT JOIN		Catalogo.Pais					As	E With(NoLock) 
	On				A.TC_CodPais					=	E.TC_CodPais
	LEFT JOIN		Catalogo.Profesion				As	F With(NoLock) 
	On				A.TN_CodProfesion				=	F.TN_CodProfesion
	LEFT JOIN		Catalogo.Escolaridad			As	G With(NoLock) 
	On				A.TN_CodEscolaridad				=	G.TN_CodEscolaridad	
	LEFT JOIN		Catalogo.SituacionLaboral		As	I With(NoLock) 
	On				A.TN_CodSituacionLaboral		=	I.TN_CodSituacionLaboral
	INNER JOIN		Persona.Persona					As	J With(NoLock)
	On				J.TU_CodPersona					=	Z.TU_CodPersona
	LEFT JOIN		Persona.PersonaFisica			As	K With(NoLock)
	On				K.TU_CodPersona					=	Z.TU_CodPersona
	LEFT JOIN		Catalogo.EstadoCivil			As	C With(NoLock) 
	On				K.TN_CodEstadoCivil				=	C.TN_CodEstadoCivil
	LEFT JOIN		Catalogo.Sexo					As	H With(NoLock) 
	On				K.TC_CodSexo					=	H.TC_CodSexo
	LEFT JOIN		Persona.PersonaJuridica			As	L With(NoLock)
	On				L.TU_CodPersona					=	Z.TU_CodPersona
	LEFT JOIN		Catalogo.TipoIdentificacion		As	M With(NoLock)
	On				M.TN_CodTipoIdentificacion		=	J.TN_CodTipoIdentificacion	
	LEFT JOIN		Catalogo.TipoEntidadJuridica	As	O With(NoLock)
	On				O.TN_CodTipoEntidad				=	L.TN_CodTipoEntidad		
	WHERE			CI.TU_CodComunicacion 			= @CodigoComunicacion 
	AND				(CI.TU_CodInterviniente			=	ISNULL(@CodigoInterviniente, CI.TU_CodInterviniente))
End
GO
