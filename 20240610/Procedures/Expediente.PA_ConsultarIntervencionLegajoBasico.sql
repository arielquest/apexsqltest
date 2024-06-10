SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<20/05/2019>
-- Descripción :			<Permite Consultar las intervenciones de un Legajo>
-- =================================================================================================================================================
-- Modificacion				<28-10-2019> <Isaac Dobles Mata> <Se modifica consulta para incluir las representaciones>
-- Modificacion				<08-05-2020> <Isaac Dobles Mata> <Se modifica consulta para incluir el formato del tipo de identificación>
-- Modificacion				<29-06-2020> <Daniel Ruiz Hern ndez> <Se modifica la consulta para seleccionar el CodInterviniente de partes y representantes>
-- Modificación:			<17/02/2021> <Karol Jim‚nez S.> <Se agrega consulta de IDINT (CodigoIntervinienteGestion)>
-- Modificación:			<14/04/2021> <Aida Elena Siles R> <Se agrega a la consulta el Nombre comercial para las personas jur¡dicas>
-- Modificación:			<28/10/2021> <Aida Elena Siles R> <Se agrega a la consulta el tipo de entidad para las personas jur¡dicas>
-- Modificación:			<24/04/2023> <Karol Jiménez S.> <Se obtiene la etnia, país, escolaridad, profesión y situación laboral, necesarios cuando 
--							se están recibiendo itineraciones de Gestión, para tener la información actual en SIAGPJ completa del interviniente>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ConsultarIntervencionLegajoBasico]
  @CodigoLegajo uniqueidentifier

As
Begin
 
	SELECT			Z.TF_Inicio_Vigencia			As	FechaActivacion,		  
					Z.TF_Fin_Vigencia				As	FechaDesactivacion, 
					Z.TF_Actualizacion				As	FechaModificacion,
							      																
					'SplitTI'						As  SplitTI,
					Z.IDINT							AS  CodigoIntervinienteGestion,
					LI.TU_CodInterviniente			As	CodigoInterviniente,		  
					A.TF_ComisionDelito				As	FechaComisionDelito, 
					A.TC_Caracteristicas			As	Caracteristicas,		      
					A.TC_Alias						As	Alias, 
					A.TB_Droga						As	Droga, (Select count(*) From Expediente.MedidaPena  As E	WITH(Nolock)
																			   Where E.TU_CodInterviniente = A.TU_CodInterviniente) As TieneMedidaPena,
					A.TB_Rebeldia					As	Rebeldia,
									
					'SplitTIn'						As  SplitTIn,						
					A.TN_CodTipoIntervencion		As	Codigo,
					B.TC_Descripcion				As	Descripcion,
									 
					'SplitPF'						As  SplitPF,
					C.TU_CodPersona					As	CodigoPersona,
					C.TC_Nombre						As	Nombre,
					C.TC_PrimerApellido				As	PrimerApellido,
					C.TC_SegundoApellido			As	SegundoApellido,
					C.TC_LugarNacimiento			As  LugarNacimiento,
					C.TF_FechaNacimiento			As  FechaNacimiento,			 
					P.TC_Identificacion				As	Identificacion,
					C.TB_EsIgnorado					As	EsIgnorado,	
					C.TF_FechaDefuncion				As	FechaDefuncion,	
					C.TC_LugarDefuncion				As	LugarDefuncion,	
					C.TC_NombreMadre				As	NombreMadre,		
					C.TC_NombrePadre				As	NombrePadre,
					C.TC_Carne						As	Carne,
					C.TN_Salario					As  Salario,
									
					'SplitPJ'						As  SplitPJ,
					D.TU_CodPersona					As	CodigoPersona,
					D.TC_Nombre						As	Nombre,
					P.TC_Identificacion				As	Identificacion,
					D.TC_NombreComercial			As  NombreComercial,
						
					'SplitIdent'					As  SplitIdent,						
					T.TN_CodTipoIdentificacion		As	Codigo,
					T.TC_Descripcion				As	Descripcion,
					T.TC_Formato					As	Formato,

					'SplitOtros'					As  SplitOtros,
					B.TC_Intervencion 				As	Intervencion,
					Z.TC_TipoParticipacion			As  TipoParticipacion,
					K.TC_CodSexo					As	CodigoSexo,					
					K.TC_Descripcion				As	SexoDescrip,
					J.TN_CodEstadoCivil				As	CodigoEstadoCivil,			
					J.TC_Descripcion				As	EstadoCivilDescrip,	
					A.TU_CodParentesco				As	CodigoParentesco,			
					L.TC_Descripcion				As	DescripcionParentesco,
					E.TN_CodEtnia					As  CodigoEtnia,    
					E.TC_Descripcion				As  DescripcionEtnia,
					D.TN_CodTipoEntidad				AS	CodigoTipoEntidadJuridica,
					M.TC_Descripcion				As  DescripcionTipoEntidadJuridica,				
					N.TC_CodPais					As  CodigoPais,
					N.TC_Descripcion				As	DescripcionPais,
    				R.TC_Descripcion			    As  DescripcionEscolaridad,
					R.TN_CodEscolaridad				As  CodigoEscolaridad,
					S.TC_Descripcion			    As  DescripcionProfesion,
					S.TN_CodProfesion				As  CodigoProfesion,
					I.TC_Descripcion			    As  DescripcionSitLaboral,
					I.TN_CodSituacionLaboral		As  CodigoSitLaboral,
					D.TC_NombreRepresentante		AS	Representante,
					P.TC_Origen						AS  OrigenPersona
	From			Expediente.Intervencion			As	Z WITH (NoLock)
	Left Join		Expediente.Interviniente		As	A WITH (NoLock)
	On				A.TU_CodInterviniente			= Z.TU_CodInterviniente	
	Left Join		Catalogo.TipoIntervencion		As	B WITH (NoLock) 
	On				B.TN_CodTipoIntervencion		=	A.TN_CodTipoIntervencion
	Inner Join		Expediente.LegajoIntervencion	As	LI WITH (NoLock)
	On				LI.TU_CodInterviniente			=	Z.TU_CodInterviniente
	And				LI.TU_CodLegajo					=	@CodigoLegajo
	Inner Join		Persona.Persona					As	P WITH (NoLock) 
	On				Z.TU_CodPersona					=	P.TU_CodPersona
	left outer join	Persona.PersonaFisica			As	C WITH (NoLock) 
	On				C.TU_CodPersona					=	P.TU_CodPersona
	Left Join		Catalogo.EstadoCivil			As	J With(NoLock) 
	On				C.TN_CodEstadoCivil				=	J.TN_CodEstadoCivil	
	Left Join		Catalogo.Sexo					As	K With(NoLock) 
	On				C.TC_CodSexo					=	K.TC_CodSexo
	Left outer Join	Catalogo.Parentesco				As	L With(NoLock) 
	On				A.TU_CodParentesco				=	L.TC_CodParentesco
	left outer join	Persona.PersonaJuridica			As	D WITH (NoLock) 
	On				D.TU_CodPersona					=	P.TU_CodPersona
	left outer join	Catalogo.TipoIdentificacion		As	T WITH (NoLock) 
	On				P.TN_CodTipoIdentificacion		=	T.TN_CodTipoIdentificacion
	left outer join	Catalogo.TipoEntidadJuridica	AS	M WITH (Nolock) 
	On				M.TN_CodTipoEntidad		        =	D.TN_CodTipoEntidad
	Left Join       Catalogo.Etnia                  As  E With(Nolock)  
    On              E.TN_CodEtnia					=   C.TN_CodEtnia
	Left Join       Catalogo.Pais					As	N With(NoLock)   
	On              N.TC_CodPais					=	A.TC_CodPais  
	Left Join		Catalogo.Profesion				As  S With(NoLock)   
	On				S.TN_CodProfesion				=   A.TN_CodProfesion  
	Left Join		Catalogo.Escolaridad			As  R With(NoLock)   
	On				R.TN_CodEscolaridad				=   A.TN_CodEscolaridad   
	Left Join		Catalogo.SituacionLaboral		As	I With(NoLock)   
	On				I.TN_CodSituacionLaboral		=	A.TN_CodSituacionLaboral  
	WHERE			(Z.TF_Fin_Vigencia				>=  getdate() or Z.TF_Fin_Vigencia	is null)

End
GO
