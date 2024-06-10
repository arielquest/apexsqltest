SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<15/11/2018>
-- Descripción :			<Permite consultar las intervenciones de una soliciutud de desacumulacion> 
-- =================================================================================================================================================
-- Modificación				<Jonathan Aguilar Navarro> <11/10/2019> <Se modifica la consulta para que muestre datos de los representantes>
-- Modificación				<Aida Elena Siles R> <09/10/2020> <Ajuste formato y variable local.>
-- Modificación				<Jorge Isaac Dobles Mata> <06/05/2021> <Se modifica para que se obtenga el ID de intervencion para las representaciones.>
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_ConsultarIntervencionesSolicitudDesacumulacion]
@CodSolicitud		UNIQUEIDENTIFIER
AS
BEGIN
--Variables  
	 DECLARE 
	 @L_CodSolicitud	UNIQUEIDENTIFIER	= @CodSolicitud
--LÓGICA
	SELECT			Z.TF_Inicio_Vigencia			AS FechaActivacion,		  
					Z.TF_Fin_Vigencia				AS FechaDesactivacion, 
					Z.TF_Actualizacion				AS FechaModificacion,
					R.TU_CodSolicitud				AS CodigoSolicitud,
					'Split'							AS Split,																									
					Z.TU_CodInterviniente			AS	CodigoInterviniente,		A.TF_ComisionDelito				AS	FechaComisionDelito, 
					A.TC_Caracteristicas			AS	Caracteristicas,			A.TC_Alias						AS	Alias, 
					A.TB_Droga						AS	Droga,						A.TB_Rebeldia					AS  Rebeldia,				
					Z.TU_CodPersona					AS	CodigoPersona,				Z.TC_TipoParticipacion			AS  TipoParticipacion,				
					A.TN_CodTipoIntervencion		AS	CodigoTipoIntervencion,		B.TC_Descripcion				AS	TipoIntervencionDescrip,								
					A.TC_CodPais					AS	CodigoPais,     			E.TC_Descripcion				AS	PaisDescrip,				
					A.TN_CodProfesion				AS	CodigoProfesion,			F.TC_Descripcion				AS	ProfesionDescrip,			
					A.TN_CodEscolaridad				AS	CodigoEscolaridad,			G.TC_Descripcion				AS	EscolaridadDescrip,			
					A.TN_CodSituacionLaboral		AS	CodigoSituacionLaboral,		I.TC_Descripcion				AS	SituacionLaboralDescrip,
					R.TC_ModoSeleccion				AS	Modo,						Z.TC_NumeroExpediente			AS	NumeroExpediente,	
					'SplitPersonaFisica'			AS	SplitPersonaFisica,
					Z.TU_CodPersona					AS	CodigoPersona,
					J.TC_Identificacion				AS	Identificacion,				K.TC_Nombre						AS	Nombre,
					K.TC_PrimerApellido				AS	PrimerApellido,				K.TC_SegundoApellido			AS	SegundoApellido,
					K.TF_FechaNacimiento			AS	FechaNacimiento,			K.TC_LugarNacimiento			AS	LugarNacimiento,
					K.TF_FechaDefuncion				AS	FechaDefuncion,				K.TC_LugarDefuncion				AS	LugarDefuncion,
					K.TC_NombreMadre				AS	NombreMadre,				K.TC_NombrePadre				AS	NombrePadre,
					K.TC_Carne						AS	Carne,					
					K.TB_EsIgnorado					AS	EsIgnorado,					
					H.TC_CodSexo					AS	CodigoSexo,					H.TC_Descripcion				AS	SexoDescrip,
					C.TN_CodEstadoCivil				AS	CodigoEstadoCivil,			C.TC_Descripcion				AS	EstadoCivilDescrip,						
					'SplitPersonaJuridica'			AS	SplitPersonaJuridica,
					Z.TU_CodPersona					AS	CodigoPersona,
					J.TC_Identificacion				AS	Identificacion,				L.TC_Nombre						AS	Nombre,
					L.TC_NombreComercial			AS	NombreComercial,
					'SplitTipoIdentificacion'		AS	SplitTipoIdentificacion,
					J.TN_CodTipoIdentificacion		AS	Codigo,						M.TC_Descripcion				AS	Descripcion,
					M.TC_Formato					AS	Formato,					M.TB_Nacional					AS	Nacional,
					'SplitEtnia'					AS	SplitEtnia,
					K.TN_CodEtnia					AS	Codigo,						N.TC_Descripcion				AS	Descripcion,
					'SplitTipoEntidadJuridica'		AS	SplitTipoEntidadJuridica,
					L.TN_CodTipoEntidad				AS	Codigo,						O.TC_Descripcion				AS	Descripcion				
	FROM			Historico.IntervinienteSolicitudDesacumulacion AS R
	INNER JOIN		Expediente.Intervencion 		AS  Z With(NoLock)	
	ON				Z.TU_CodInterviniente			=   R.TU_CodInterviniente
	LEFT JOIN		Expediente.Interviniente		AS	A With(NoLock)
	ON 				A.TU_CodInterviniente			=	Z.TU_CodInterviniente	
	LEFT JOIN		Catalogo.TipoIntervencion		AS	B With(NoLock) 
	ON				B.TN_CodTipoIntervencion		=	A.TN_CodTipoIntervencion	
	LEFT JOIN		Catalogo.Pais					AS	E With(NoLock) 
	ON				A.TC_CodPais					=	E.TC_CodPais
	LEFT JOIN		Catalogo.Profesion				AS	F With(NoLock) 
	ON				A.TN_CodProfesion				=	F.TN_CodProfesion
	LEFT JOIN		Catalogo.Escolaridad			AS	G With(NoLock) 
	ON				A.TN_CodEscolaridad				=	G.TN_CodEscolaridad	
	LEFT JOIN		Catalogo.SituacionLaboral		AS	I With(NoLock) 
	ON				A.TN_CodSituacionLaboral		=	I.TN_CodSituacionLaboral
	INNER JOIN		Persona.Persona					AS	J With(NoLock)
	ON				J.TU_CodPersona					=	Z.TU_CodPersona
	LEFT JOIN		Persona.PersonaFisica			AS	K With(NoLock)
	ON				K.TU_CodPersona					=	J.TU_CodPersona
	LEFT JOIN		Catalogo.EstadoCivil			AS	C With(NoLock) 
	ON				K.TN_CodEstadoCivil				=	C.TN_CodEstadoCivil
	LEFT JOIN		Catalogo.Sexo					AS	H With(NoLock) 
	ON				K.TC_CodSexo					=	H.TC_CodSexo
	LEFT JOIN		Persona.PersonaJuridica			AS	L With(NoLock)
	ON				L.TU_CodPersona					=	J.TU_CodPersona
	LEFT JOIN		Catalogo.TipoIdentificacion		AS	M With(NoLock)
	ON				M.TN_CodTipoIdentificacion		=	J.TN_CodTipoIdentificacion
	LEFT JOIN		Catalogo.Etnia					AS	N With(NoLock)
	ON				N.TN_CodEtnia					=	K.TN_CodEtnia
	LEFT JOIN		Catalogo.TipoEntidadJuridica	AS	O With(NoLock)
	ON				O.TN_CodTipoEntidad				=	L.TN_CodTipoEntidad		
	WHERE			(R.TU_CodSolicitud				=	ISNULL(@L_CodSolicitud, R.TU_CodSolicitud))

END
GO
