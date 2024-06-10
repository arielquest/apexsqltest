SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Juan Ramirez V.>
-- Fecha de creación:		<10/07/2018>
-- Descripción :			<Permite Consultar las intervenciones no representadas
-- =================================================================================================================================================
-- Modificación:			<15/09/2020><Daniel Ruiz Hern ndez><Se agrega consulta de intervenciones del legajo.>
-- Modificación:			<18/02/2022><Karol Jim‚nez S nchez><Cuando se trata de consulta de expediente, se excluyen intervenciones de legajos del mismo>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervencionesNoRepresentadas]
	@TipoParticipacion		char(1),
	@NumeroExpediente		varchar(14) = null,
	@CodigoInterviniente	uniqueidentifier = null,
	@CodigoPersona			uniqueidentifier = null,
	@CodigoLegajo			uniqueidentifier = null
	
As
Begin
	Declare @L_TipoParticipacion		char(1)				= @TipoParticipacion,
			@L_NumeroExpediente			varchar(14)			= @NumeroExpediente,
			@L_CodigoInterviniente		uniqueidentifier	= @CodigoInterviniente,
			@L_CodigoPersona			uniqueidentifier	= @CodigoPersona,
			@L_CodigoLegajo				uniqueidentifier	= @CodigoLegajo;

	if (@L_CodigoLegajo is null) 
		Select 			Z.TF_Inicio_Vigencia			As FechaActivacion,		  
						Z.TF_Fin_Vigencia				As FechaDesactivacion, 
						Z.TF_Actualizacion				As FechaModificacion,		      																
						'Split'							As	Split,
						A.TU_CodInterviniente			As	CodigoInterviniente,		A.TF_ComisionDelito				As	FechaComisionDelito, 
						A.TC_Caracteristicas			As	Caracteristicas,			A.TC_Alias						As	Alias, 
						A.TB_Droga						As	Droga,						A.TB_Rebeldia					As  Rebeldia,
						Z.TU_CodPersona					As	CodigoPersona,				Z.TC_TipoParticipacion			As  TipoParticipacion,				
						A.TN_CodTipoIntervencion		As	CodigoTipoIntervencion,		B.TC_Descripcion				As	TipoIntervencionDescrip,								
						A.TC_CodPais					As	CodigoPais,     			E.TC_Descripcion				As	PaisDescrip,				
						A.TN_CodProfesion				As	CodigoProfesion,			F.TC_Descripcion				As	ProfesionDescrip,			
						A.TN_CodEscolaridad				As	CodigoEscolaridad,			G.TC_Descripcion				As	EscolaridadDescrip,			
						A.TN_CodSituacionLaboral		As	CodigoSituacionLaboral,		I.TC_Descripcion				As	SituacionLaboralDescrip,
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
						'SplitTipoIdentificacion'		As	SplitTipoIdentificacion,
						J.TN_CodTipoIdentificacion		As	Codigo,						M.TC_Descripcion				As	Descripcion,
						M.TC_Formato					As	Formato,					M.TB_Nacional					As	Nacional,
						'SplitEtnia'					As	SplitEtnia,
						K.TN_CodEtnia					As	Codigo,						N.TC_Descripcion				As	Descripcion,
						'SplitTipoEntidadJuridica'		As	SplitTipoEntidadJuridica,
						L.TN_CodTipoEntidad				As	Codigo,						O.TC_Descripcion				As	Descripcion				
		From			Expediente.Intervencion 		As  Z With(NoLock)	
		Inner Join		Expediente.Interviniente		As	A With(NoLock)
		On 				A.TU_CodInterviniente			=	Z.TU_CodInterviniente
		left outer Join	Expediente.Representacion		As 	X WITH(NoLock)
		On				X.TU_CodInterviniente			=	Z.TU_CodInterviniente
		Inner Join		Catalogo.TipoIntervencion		As	B With(NoLock) 
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
		On				J.TU_CodPersona					=	Z.TU_CodPersona
		Left Join		Persona.PersonaFisica			As	K With(NoLock)
		On				K.TU_CodPersona					=	Z.TU_CodPersona
		Left Join		Catalogo.EstadoCivil			As	C With(NoLock) 
		On				K.TN_CodEstadoCivil				=	C.TN_CodEstadoCivil
		Left Join		Catalogo.Sexo					As	H With(NoLock) 
		On				K.TC_CodSexo					=	H.TC_CodSexo
		Left Join		Persona.PersonaJuridica			As	L With(NoLock)
		On				L.TU_CodPersona					=	Z.TU_CodPersona
		Left Join		Catalogo.TipoIdentificacion		As	M With(NoLock)
		On				M.TN_CodTipoIdentificacion		=	J.TN_CodTipoIdentificacion
		Left Join		Catalogo.Etnia					As	N With(NoLock)
		On				N.TN_CodEtnia					=	K.TN_CodEtnia
		Left Join		Catalogo.TipoEntidadJuridica	As	O With(NoLock)
		On				O.TN_CodTipoEntidad				=	L.TN_CodTipoEntidad		
		Where			(Z.TU_CodInterviniente			=	ISNULL(@L_CodigoInterviniente, Z.TU_CodInterviniente))
		AND				Z.TC_TipoParticipacion		    =   @L_TipoParticipacion
		And				(Z.TC_NumeroExpediente			=	ISNULL(@L_NumeroExpediente, Z.TC_NumeroExpediente))
		And				(
						 (Z.TU_CodPersona				=	Case	When @L_CodigoPersona is not null And @L_CodigoInterviniente is null
																	Then @L_CodigoPersona
																	Else Z.TU_CodPersona
															End)
							And
						 (A.TF_Actualizacion			=	Case	When @L_CodigoPersona is not null And @L_CodigoInterviniente is null
																	Then (Select MAX(T.TF_Actualizacion) From Expediente.Intervencion T Where T.TU_CodPersona = @L_CodigoPersona) 
																	Else A.TF_Actualizacion
															End)
						)
		And				X.TU_CodInterviniente 			IS  NULL
		And				((@L_CodigoInterviniente is not null) Or (@L_NumeroExpediente is not null) Or (@L_CodigoPersona is not null))
		And				Z.TU_CodInterviniente			NOT IN (SELECT		TU_CodInterviniente 
																FROM		Expediente.Legajo				L WITH(NOLOCK)
																INNER JOIN	Expediente.LegajoIntervencion	LI WITH(NOLOCK)
																ON			LI.TU_CodLegajo					= L.TU_CodLegajo
																WHERE		L.TC_NumeroExpediente			= @L_NumeroExpediente);
	else
			Select 			Z.TF_Inicio_Vigencia			As FechaActivacion,		  
						Z.TF_Fin_Vigencia				As FechaDesactivacion, 
						Z.TF_Actualizacion				As FechaModificacion,		      																
						'Split'							As	Split,
						A.TU_CodInterviniente			As	CodigoInterviniente,		A.TF_ComisionDelito				As	FechaComisionDelito, 
						A.TC_Caracteristicas			As	Caracteristicas,			A.TC_Alias						As	Alias, 
						A.TB_Droga						As	Droga,						A.TB_Rebeldia					As  Rebeldia,
						Z.TU_CodPersona					As	CodigoPersona,				Z.TC_TipoParticipacion			As  TipoParticipacion,				
						A.TN_CodTipoIntervencion		As	CodigoTipoIntervencion,		B.TC_Descripcion				As	TipoIntervencionDescrip,								
						A.TC_CodPais					As	CodigoPais,     			E.TC_Descripcion				As	PaisDescrip,				
						A.TN_CodProfesion				As	CodigoProfesion,			F.TC_Descripcion				As	ProfesionDescrip,			
						A.TN_CodEscolaridad				As	CodigoEscolaridad,			G.TC_Descripcion				As	EscolaridadDescrip,			
						A.TN_CodSituacionLaboral		As	CodigoSituacionLaboral,		I.TC_Descripcion				As	SituacionLaboralDescrip,
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
						'SplitTipoIdentificacion'		As	SplitTipoIdentificacion,
						J.TN_CodTipoIdentificacion		As	Codigo,						M.TC_Descripcion				As	Descripcion,
						M.TC_Formato					As	Formato,					M.TB_Nacional					As	Nacional,
						'SplitEtnia'					As	SplitEtnia,
						K.TN_CodEtnia					As	Codigo,						N.TC_Descripcion				As	Descripcion,
						'SplitTipoEntidadJuridica'		As	SplitTipoEntidadJuridica,
						L.TN_CodTipoEntidad				As	Codigo,						O.TC_Descripcion				As	Descripcion				
		From			Expediente.Intervencion 		As  Z With(NoLock)	
		join			Expediente.LegajoIntervencion	As	Q With(NoLock)
		on				z.TU_CodInterviniente			=	Q.TU_CodInterviniente
		Inner Join		Expediente.Interviniente		As	A With(NoLock)
		On 				A.TU_CodInterviniente			=	Z.TU_CodInterviniente
		left outer Join	Expediente.Representacion		As 	X WITH(NoLock)
		On				X.TU_CodInterviniente			=	Z.TU_CodInterviniente
		Inner Join		Catalogo.TipoIntervencion		As	B With(NoLock) 
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
		On				J.TU_CodPersona					=	Z.TU_CodPersona
		Left Join		Persona.PersonaFisica			As	K With(NoLock)
		On				K.TU_CodPersona					=	Z.TU_CodPersona
		Left Join		Catalogo.EstadoCivil			As	C With(NoLock) 
		On				K.TN_CodEstadoCivil				=	C.TN_CodEstadoCivil
		Left Join		Catalogo.Sexo					As	H With(NoLock) 
		On				K.TC_CodSexo					=	H.TC_CodSexo
		Left Join		Persona.PersonaJuridica			As	L With(NoLock)
		On				L.TU_CodPersona					=	Z.TU_CodPersona
		Left Join		Catalogo.TipoIdentificacion		As	M With(NoLock)
		On				M.TN_CodTipoIdentificacion		=	J.TN_CodTipoIdentificacion
		Left Join		Catalogo.Etnia					As	N With(NoLock)
		On				N.TN_CodEtnia					=	K.TN_CodEtnia
		Left Join		Catalogo.TipoEntidadJuridica	As	O With(NoLock)
		On				O.TN_CodTipoEntidad				=	L.TN_CodTipoEntidad		
		Where			(Z.TU_CodInterviniente			=	ISNULL(@L_CodigoInterviniente, Z.TU_CodInterviniente))
		AND				Z.TC_TipoParticipacion		    =   @L_TipoParticipacion
		And				q.TU_CodLegajo					=	@L_CodigoLegajo
		And				(
						 (Z.TU_CodPersona				=	Case	When @L_CodigoPersona is not null And @L_CodigoInterviniente is null
																	Then @L_CodigoPersona
																	Else Z.TU_CodPersona
															End)
							And
						 (A.TF_Actualizacion			=	Case	When @L_CodigoPersona is not null And @L_CodigoInterviniente is null
																	Then (Select MAX(T.TF_Actualizacion) From Expediente.Intervencion T Where T.TU_CodPersona = @L_CodigoPersona) 
																	Else A.TF_Actualizacion
															End)
						)
		And				X.TU_CodInterviniente 			IS  NULL;
	

End
GO
