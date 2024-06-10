SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Juan Ramirez V.>
-- Fecha de creación:		<10/07/2018>
-- Descripción :			<Permite Consultar las representaciones
-- =================================================================================================================================================
-- Modificación:			<18/02/2022><Karol Jim‚nez S nchez><Cuando se trata de consulta de expediente, se excluyen representaciones de legajos del mismo>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarRepresentacionesAsociadas]
	@TipoParticipacion		char(1),
	@NumeroExpediente		varchar(14) = null,
	@CodigoInterviniente	uniqueidentifier = null,	
	@CodigoPersona			uniqueidentifier = null,
	@CodigoLegajo			uniqueidentifier = null
As
Begin
	DECLARE	@L_TipoParticipacion		char(1)				= @TipoParticipacion,
			@L_NumeroExpediente			varchar(14)			= @NumeroExpediente,
			@L_CodigoInterviniente		uniqueidentifier	= @CodigoInterviniente,
			@L_CodigoPersona			uniqueidentifier	= @CodigoPersona,
			@L_CodigoLegajo				uniqueidentifier	= @CodigoLegajo;

	IF (@L_CodigoLegajo IS NULL)
		Select			X.TB_Principal					As Principal,					X.TB_NotificaRepresentante		As NotificaRepresentante,
						x.TF_Inicio_Vigencia			As FechaActivacion, 			X.TF_Fin_Vigencia				As FechaDesactivacion,		      																
						'Split'							As	Split,
						X.TU_CodInterviniente			As CodInterviniente,		X.TU_CodIntervinienteRepresentante	As CodIntervinienteRepresentante,		
						A.TF_ComisionDelito				As	FechaComisionDelito,		X.TN_CodTipoRepresentacion		As  CodTipoRepresentacion,				
						P.TC_Descripcion				As  TipoRepresentacionDescripcion,
						A.TC_Caracteristicas			As	Caracteristicas,			A.TC_Alias						As	Alias, 
						A.TB_Droga						As	Droga,						A.TB_Rebeldia					As  Rebeldia,											
						Y.TU_CodPersona					As	CodigoPersona,				Y.TC_TipoParticipacion			As  TipoParticipacion,				
						A.TN_CodTipoIntervencion		As	CodigoTipoIntervencion,		B.TC_Descripcion				As	TipoIntervencionDescrip,								
						A.TC_CodPais					As	CodigoPais,     			E.TC_Descripcion				As	PaisDescrip,				
						A.TN_CodProfesion				As	CodigoProfesion,			F.TC_Descripcion				As	ProfesionDescrip,			
						A.TN_CodEscolaridad				As	CodigoEscolaridad,			G.TC_Descripcion				As	EscolaridadDescrip,			
						A.TN_CodSituacionLaboral		As	CodigoSituacionLaboral,		I.TC_Descripcion				As	SituacionLaboralDescrip,
						'SplitPersonaFisica'			As	SplitPersonaFisica,
						Y.TU_CodPersona					As	CodigoPersona,
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
						Y.TU_CodPersona					As	CodigoPersona,
						J.TC_Identificacion				As	Identificacion,				L.TC_Nombre						As	Nombre,
						L.TC_NombreComercial			As	NombreComercial,
						'SplitTipoIdentificacion'		As	SplitTipoIdentificacion,
						J.TN_CodTipoIdentificacion		As	Codigo,						M.TC_Descripcion				As	Descripcion,
						M.TC_Formato					As	Formato,					M.TB_Nacional					As	Nacional,
						'SplitEtnia'					As	SplitEtnia,
						K.TN_CodEtnia					As	Codigo,						N.TC_Descripcion				As	Descripcion,
						'SplitTipoEntidadJuridica'		As	SplitTipoEntidadJuridica,
						L.TN_CodTipoEntidad				As	Codigo,						O.TC_Descripcion				As	Descripcion	
		From 			Expediente.Representacion		As 	X WITH(NoLock)	
		Left Join		Expediente.Intervencion 		As  Y With(NoLock)
		On				Y.TU_CodInterviniente			=	X.TU_CodIntervinienteRepresentante
		Left Join		Expediente.Interviniente		As	A With(NoLock)
		On 				A.TU_CodInterviniente			=	Y.TU_CodInterviniente
		Left Join		Catalogo.TipoIntervencion		As	B With(NoLock) 
		On				B.TN_CodTipoIntervencion		=	A.TN_CodTipoIntervencion	
		Left Join		Catalogo.Pais					As	E With(NoLock) 
		On				A.TC_CodPais					=	E.TC_CodPais
		Left Join		Catalogo.Profesion				As	F With(NoLock) 
		On				A.TN_CodProfesion				=	F.TN_CodProfesion
		Left Join		Catalogo.Escolaridad			As	G With(NoLock) 
		On				A.TN_CodEscolaridad				=	G.TN_CodEscolaridad	
		Left Join		Catalogo.SituacionLaboral		As	I With(NoLock) 
		On				A.TN_CodSituacionLaboral		=	I.TN_CodSituacionLaboral
		Inner Join		Persona.Persona					As	J With(NoLock)
		On				J.TU_CodPersona					=	Y.TU_CodPersona
		Left Join		Persona.PersonaFisica			As	K With(NoLock)
		On				K.TU_CodPersona					=	Y.TU_CodPersona
		Left Join		Catalogo.EstadoCivil			As	C With(NoLock) 
		On				K.TN_CodEstadoCivil				=	C.TN_CodEstadoCivil
		Left Join		Catalogo.Sexo					As	H With(NoLock) 
		On				K.TC_CodSexo					=	H.TC_CodSexo
		Left Join		Persona.PersonaJuridica			As	L With(NoLock)
		On				L.TU_CodPersona					=	Y.TU_CodPersona
		Left Join		Catalogo.TipoIdentificacion		As	M With(NoLock)
		On				M.TN_CodTipoIdentificacion		=	J.TN_CodTipoIdentificacion
		Left Join		Catalogo.Etnia					As	N With(NoLock)
		On				N.TN_CodEtnia					=	K.TN_CodEtnia
		Left Join		Catalogo.TipoEntidadJuridica	As	O With(NoLock)
		On				O.TN_CodTipoEntidad				=	L.TN_CodTipoEntidad
		Left Join		Catalogo.TipoRepresentacion		As	P With(NoLock)
		On				P.TN_CodTipoRepresentacion		=	X.TN_CodTipoRepresentacion	
		Where			(X.TU_CodInterviniente			=	ISNULL(@L_CodigoInterviniente, X.TU_CodInterviniente))--Interviniente representado.
		AND				Y.TC_TipoParticipacion		    =   @L_TipoParticipacion
		And				(Y.TC_NumeroExpediente			=	ISNULL(@L_NumeroExpediente, Y.TC_NumeroExpediente))
	
		And				(
						 (Y.TU_CodPersona				=	Case	When @L_CodigoPersona is not null And @L_CodigoInterviniente is null
																	Then @L_CodigoPersona
																	Else Y.TU_CodPersona
															End)
							And
						 (IsNull(A.TF_Actualizacion,'')			=	Case	When @L_CodigoPersona is not null And @L_CodigoInterviniente is null
																	Then (Select MAX(T.TF_Actualizacion) From Expediente.Intervencion T Where T.TU_CodPersona = @L_CodigoPersona) 
																	Else IsNull(A.TF_Actualizacion,'')
															End)
						)
		And				((@L_CodigoInterviniente is not null) Or (@L_NumeroExpediente is not null) Or (@L_CodigoPersona is not null))
		And				Y.TU_CodInterviniente			NOT IN (SELECT		TU_CodInterviniente 
																FROM		Expediente.Legajo				L WITH(NOLOCK)
																INNER JOIN	Expediente.LegajoIntervencion	LI WITH(NOLOCK)
																ON			LI.TU_CodLegajo					= L.TU_CodLegajo
																WHERE		L.TC_NumeroExpediente			= @L_NumeroExpediente);
	ELSE
		Select			X.TB_Principal					As Principal,					X.TB_NotificaRepresentante		As NotificaRepresentante,
						x.TF_Inicio_Vigencia			As FechaActivacion, 			X.TF_Fin_Vigencia				As FechaDesactivacion,		      																
						'Split'							As	Split,
						X.TU_CodInterviniente			As CodInterviniente,		X.TU_CodIntervinienteRepresentante	As CodIntervinienteRepresentante,		
						A.TF_ComisionDelito				As	FechaComisionDelito,		X.TN_CodTipoRepresentacion		As  CodTipoRepresentacion,				
						P.TC_Descripcion				As  TipoRepresentacionDescripcion,
						A.TC_Caracteristicas			As	Caracteristicas,			A.TC_Alias						As	Alias, 
						A.TB_Droga						As	Droga,						A.TB_Rebeldia					As  Rebeldia,											
						Y.TU_CodPersona					As	CodigoPersona,				Y.TC_TipoParticipacion			As  TipoParticipacion,				
						A.TN_CodTipoIntervencion		As	CodigoTipoIntervencion,		B.TC_Descripcion				As	TipoIntervencionDescrip,								
						A.TC_CodPais					As	CodigoPais,     			E.TC_Descripcion				As	PaisDescrip,				
						A.TN_CodProfesion				As	CodigoProfesion,			F.TC_Descripcion				As	ProfesionDescrip,			
						A.TN_CodEscolaridad				As	CodigoEscolaridad,			G.TC_Descripcion				As	EscolaridadDescrip,			
						A.TN_CodSituacionLaboral		As	CodigoSituacionLaboral,		I.TC_Descripcion				As	SituacionLaboralDescrip,
						'SplitPersonaFisica'			As	SplitPersonaFisica,
						Y.TU_CodPersona					As	CodigoPersona,
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
						Y.TU_CodPersona					As	CodigoPersona,
						J.TC_Identificacion				As	Identificacion,				L.TC_Nombre						As	Nombre,
						L.TC_NombreComercial			As	NombreComercial,
						'SplitTipoIdentificacion'		As	SplitTipoIdentificacion,
						J.TN_CodTipoIdentificacion		As	Codigo,						M.TC_Descripcion				As	Descripcion,
						M.TC_Formato					As	Formato,					M.TB_Nacional					As	Nacional,
						'SplitEtnia'					As	SplitEtnia,
						K.TN_CodEtnia					As	Codigo,						N.TC_Descripcion				As	Descripcion,
						'SplitTipoEntidadJuridica'		As	SplitTipoEntidadJuridica,
						L.TN_CodTipoEntidad				As	Codigo,						O.TC_Descripcion				As	Descripcion	
		From 			Expediente.Representacion		As 	X WITH(NoLock)	
		Left Join		Expediente.Intervencion 		As  Y With(NoLock)
		On				Y.TU_CodInterviniente			=	X.TU_CodIntervinienteRepresentante
		Inner Join		Expediente.LegajoIntervencion	AS	LI WITH(NOLOCK)
		ON				LI.TU_CodInterviniente			=	Y.TU_CodInterviniente
		Left Join		Expediente.Interviniente		As	A With(NoLock)
		On 				A.TU_CodInterviniente			=	Y.TU_CodInterviniente
		Left Join		Catalogo.TipoIntervencion		As	B With(NoLock) 
		On				B.TN_CodTipoIntervencion		=	A.TN_CodTipoIntervencion	
		Left Join		Catalogo.Pais					As	E With(NoLock) 
		On				A.TC_CodPais					=	E.TC_CodPais
		Left Join		Catalogo.Profesion				As	F With(NoLock) 
		On				A.TN_CodProfesion				=	F.TN_CodProfesion
		Left Join		Catalogo.Escolaridad			As	G With(NoLock) 
		On				A.TN_CodEscolaridad				=	G.TN_CodEscolaridad	
		Left Join		Catalogo.SituacionLaboral		As	I With(NoLock) 
		On				A.TN_CodSituacionLaboral		=	I.TN_CodSituacionLaboral
		Inner Join		Persona.Persona					As	J With(NoLock)
		On				J.TU_CodPersona					=	Y.TU_CodPersona
		Left Join		Persona.PersonaFisica			As	K With(NoLock)
		On				K.TU_CodPersona					=	Y.TU_CodPersona
		Left Join		Catalogo.EstadoCivil			As	C With(NoLock) 
		On				K.TN_CodEstadoCivil				=	C.TN_CodEstadoCivil
		Left Join		Catalogo.Sexo					As	H With(NoLock) 
		On				K.TC_CodSexo					=	H.TC_CodSexo
		Left Join		Persona.PersonaJuridica			As	L With(NoLock)
		On				L.TU_CodPersona					=	Y.TU_CodPersona
		Left Join		Catalogo.TipoIdentificacion		As	M With(NoLock)
		On				M.TN_CodTipoIdentificacion		=	J.TN_CodTipoIdentificacion
		Left Join		Catalogo.Etnia					As	N With(NoLock)
		On				N.TN_CodEtnia					=	K.TN_CodEtnia
		Left Join		Catalogo.TipoEntidadJuridica	As	O With(NoLock)
		On				O.TN_CodTipoEntidad				=	L.TN_CodTipoEntidad
		Left Join		Catalogo.TipoRepresentacion		As	P With(NoLock)
		On				P.TN_CodTipoRepresentacion		=	X.TN_CodTipoRepresentacion	
		Where			(X.TU_CodInterviniente			=	ISNULL(@L_CodigoInterviniente, X.TU_CodInterviniente))--Interviniente representado.
		AND				Y.TC_TipoParticipacion		    =   @L_TipoParticipacion
		And				(Y.TC_NumeroExpediente			=	ISNULL(@L_NumeroExpediente, Y.TC_NumeroExpediente))
	
		And				(
						 (Y.TU_CodPersona				=	Case	When @L_CodigoPersona is not null And @L_CodigoInterviniente is null
																	Then @L_CodigoPersona
																	Else Y.TU_CodPersona
															End)
							And
						 (IsNull(A.TF_Actualizacion,'')			=	Case	When @L_CodigoPersona is not null And @L_CodigoInterviniente is null
																	Then (Select MAX(T.TF_Actualizacion) From Expediente.Intervencion T Where T.TU_CodPersona = @L_CodigoPersona) 
																	Else IsNull(A.TF_Actualizacion,'')
															End)
						)
		And				((@L_CodigoInterviniente is not null) Or (@L_NumeroExpediente is not null) Or (@L_CodigoPersona is not null))
		And				LI.TU_CodLegajo					=	@L_CodigoLegajo ;

End
GO
