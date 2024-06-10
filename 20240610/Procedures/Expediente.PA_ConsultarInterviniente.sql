SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<13/09/2015>
-- Descripción :			<Permite Consultar los intervinientes
-- =================================================================================================================================================
-- Actualizado :			<Johan Manuel Acosta Ibañez> <06/10/2015>
-- Modificado por:			<Gerardo Lopez> <16/11/2015> 	<Se elimina campo CodigoVulnerabilidad.> 
-- Modificado por:			<Henry Mendez> <23/11/2015> 	<Se elimina campo TC_CodSituacionLibertad y TF_SituacionLibertad.> 
-- Modificado por:			<Johan Acosta> <26/11/2015> 	<Se cambia el campo Observaciones por caracteristicas.> 
-- Modificado por:			<Alejandro Villalta> <03/12/2015><Se quita el campo TC_Discapacidad.> 
-- Modificado por:			<Johan Acosta> <17/03/2016> 	<Se modifico a left Outer Join las tablas relacionadas que permiten nulos.> 
-- Modificado por:			<Andrés Díaz> <16/06/2016> <Se agrega filtro por código de legajo.> 
-- Modificado por:			<Andrés Díaz> <28/06/2016> <Se agrega filtro por código de persona, obtiene unicamente el ÚLTIMO interviniente modificado por este código.>
-- Modificado por:			<Johan Acosta> <25/08/2016> <Se agrega seleccion del campo formato de tipo de identificación.>
-- Modificado por:			<Donald Vargas><02/12/2016> <Se corrige el nombre de los campos TC_CodTipoIntervencion, TC_CodEstadoCivil, TC_CodProfesion, TC_CodEscolaridad, TC_CodSituacionLaboral, TC_CodTipoIdentificacion, TC_CodEtnia y TC_CodTipoEntidad 
-- 							a TN_CodTipoIntervencion, TN_CodEstadoCivil, TN_CodProfesion, TN_CodEscolaridad, TN_CodSituacionLaboral, TN_CodTipoIdentificacion, TN_CodEtnia y TN_CodTipoEntidad de acuerdo al tipo de dato>
-- Modificado : 			<Johan Acosta> <05/12/2016> <Se cambio nombre de TC a TF>
-- Modificación:			<Andrés Díaz> <08/20/2018> <Se agrega el campo TB_Nacional as tipo de identificación.>
-- Modificación:			<Juan Ramirez> <22/06/2018> <Se modifica la consulta de intervinientes por el modulo de intervenciones>
-- Modificación:			<Jonathan Aguilar Navarro> <10/12/2018> <Se modifica la consulta de intervinientes para que tome en cuentra las fechas de fin de vigencia>
-- Modificación:			<Isaac Dobles> <14/01/2019> <Se modifica la consulta de intervinientes para que tome en cuentra el origen de los datos de interviniente>
-- Modificación:			<Jonathan Aguilar Navarro> <07/10/2019> <Se modifica la consulta se cambia el inner join de interviniente por un left join para que traiga la info del representante>
-- Modificación:			<Daniel Ruiz H.> <13/07/2020> <Se agrega dato intervercion del tipo de intervencion.>
-- Modificación:			<Jonathan Aguilar Navarro> <31/07/2020> <Se agrega el campo Turista>
-- Modificación:			<Jonathan Aguilar Navarro> <03/08/2020> <Se agrega las variables locales>
-- Modificación:			<Jonathan Aguilar Navarro> <11/03/2021> <Se agrega el campo TC_LugarTrabajo a la consulta>
-- Modificación:			<Ronny Ramírez R.> <10/05/2023> <Se agrega el campo CodigoIntervinienteGestion a la consulta>
-- Modificación				<Ronny Ramírez R.> <14/07/2023>  <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar  
--															problema de no uso de índices por el mal uso de COALESCE/ISNULL en el WHERE>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarInterviniente]
	@CodigoInterviniente	uniqueidentifier = null,
	@NumeroExpediente		varchar(14) = null,
	@CodigoPersona			uniqueidentifier = null
As
Begin

	Declare @L_CodigoInterviniente		uniqueidentifier		= @CodigoInterviniente
	Declare	@L_NumeroExpediente			varchar(14)				= @NumeroExpediente
	Declare @L_CodigoPersona			uniqueidentifier		= @CodigoPersona
	
 
	Select			Z.TF_Inicio_Vigencia			As FechaActivacion,		  
					Z.TF_Fin_Vigencia				As FechaDesactivacion, 
					Z.TF_Actualizacion				As FechaModificacion,					
					'Split'							As	Split,		      																				
					A.TU_CodInterviniente			As	CodigoInterviniente,		A.TF_ComisionDelito				As	FechaComisionDelito, 
					A.TC_Caracteristicas			As	Caracteristicas,			A.TC_Alias						As	Alias, 
					A.TB_Droga						As	Droga,						A.TB_Rebeldia					As  Rebeldia,
					A.TB_Turista					AS  Turista,
					A.TC_LugarTrabajo				AS  LugarTrabajo,
					Z.TU_CodPersona					As	CodigoPersona,				Z.TC_TipoParticipacion			As  TipoParticipacion,				
					A.TN_CodTipoIntervencion		As	CodigoTipoIntervencion,		B.TC_Descripcion				As	TipoIntervencionDescrip,
					B.TC_Intervencion				as	Intervencion, 
					A.TC_CodPais					As	CodigoPais,     			E.TC_Descripcion				As	PaisDescrip,				
					A.TN_CodProfesion				As	CodigoProfesion,			F.TC_Descripcion				As	ProfesionDescrip,			
					A.TN_CodEscolaridad				As	CodigoEscolaridad,			G.TC_Descripcion				As	EscolaridadDescrip,			
					A.TN_CodSituacionLaboral		As	CodigoSituacionLaboral,		I.TC_Descripcion				As	SituacionLaboralDescrip,
					J.TC_Origen						As	Origen,
					A.TU_CodParentesco				As  CodigoParentesco,			P.TC_Descripcion				As	DescripcionParentesco,
					H.TC_CodSexo					As	CodigoSexo,					H.TC_Descripcion				As	SexoDescrip,
					C.TN_CodEstadoCivil				As	CodigoEstadoCivil,			C.TC_Descripcion				As	EstadoCivilDescrip,	
					Z.IDINT							AS	CodigoIntervinienteGestion,
					'SplitPersonaFisica'			As	SplitPersonaFisica,
					Z.TU_CodPersona					As	CodigoPersona,
					J.TC_Identificacion				As	Identificacion,				K.TC_Nombre						As	Nombre,
					K.TC_PrimerApellido				As	PrimerApellido,				K.TC_SegundoApellido			As	SegundoApellido,
					K.TF_FechaNacimiento			As	FechaNacimiento,			K.TC_LugarNacimiento			As	LugarNacimiento,
					K.TF_FechaDefuncion				As	FechaDefuncion,				K.TC_LugarDefuncion				As	LugarDefuncion,
					K.TC_NombreMadre				As	NombreMadre,				K.TC_NombrePadre				As	NombrePadre,
					K.TC_Carne						As	Carne,						K.TN_Salario					As  Salario,				
					K.TB_EsIgnorado					As	EsIgnorado,																			
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
	left Join		Expediente.Interviniente		As	A With(NoLock)
	On 				A.TU_CodInterviniente			=	Z.TU_CodInterviniente	
	left Join		Catalogo.TipoIntervencion		As	B With(NoLock) 
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
	On				K.TU_CodPersona					=	J.TU_CodPersona
	Left Join		Catalogo.EstadoCivil			As	C With(NoLock) 
	On				K.TN_CodEstadoCivil				=	C.TN_CodEstadoCivil
	Left Join		Catalogo.Sexo					As	H With(NoLock) 
	On				K.TC_CodSexo					=	H.TC_CodSexo
	Left Join		Catalogo.Parentesco				As	P With(NoLock) 
	On				A.TU_CodParentesco				=	P.TC_CodParentesco
	Left Join		Persona.PersonaJuridica			As	L With(NoLock)
	On				L.TU_CodPersona					=	J.TU_CodPersona
	Left Join		Catalogo.TipoIdentificacion		As	M With(NoLock)
	On				M.TN_CodTipoIdentificacion		=	J.TN_CodTipoIdentificacion
	Left Join		Catalogo.Etnia					As	N With(NoLock)
	On				N.TN_CodEtnia					=	K.TN_CodEtnia
	Left Join		Catalogo.TipoEntidadJuridica	As	O With(NoLock)
	On				O.TN_CodTipoEntidad				=	L.TN_CodTipoEntidad		
	
	Where			(Z.TU_CodInterviniente			=	ISNULL(@L_CodigoInterviniente, Z.TU_CodInterviniente))			
	And				(Z.TC_NumeroExpediente			=	ISNULL(@L_NumeroExpediente, Z.TC_NumeroExpediente))
	And				(
					 (Z.TU_CodPersona				=	Case	When @L_CodigoPersona is not null And @L_CodigoInterviniente is null
																Then @L_CodigoPersona
																Else Z.TU_CodPersona
														End)
						And
					 (Z.TF_Actualizacion			=	Case	When @L_CodigoPersona is not null And @L_CodigoInterviniente is null
																Then (Select MAX(T.TF_Actualizacion) From Expediente.Intervencion T Where T.TU_CodPersona = @L_CodigoPersona) 
																Else Z.TF_Actualizacion
														End)
					)
	And				((@L_CodigoInterviniente is not null) Or (@L_NumeroExpediente is not null) Or (@L_CodigoPersona is not null))
	And			(Z.TF_Fin_Vigencia					>=  getdate() or Z.TF_Fin_Vigencia	is null)
	OPTION(RECOMPILE);

End
GO
