SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<13/09/2015>
-- Descripción :			<Permite Consultar los intervinientes
-- =================================================================================================================================================
-- Modificación:			<26/04/2016> <Johan Acosta> Se modificó el cambo Observaciones por Caracteristicas.	
-- Modificación:			<Johan Acosta> Se modificó para que retorne la intervención del interviniente.
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre de los campos TC_CodTipoIntervencion y TC_CodTipoIdentificacion a TN_CodTipoIntervencion y TN_CodTipoIdentificacion de acuerdo al tipo de dato.>
-- Modificación:			<25/01/2018> <Jonathan Aguilar> <Se agrega a la consulta el campo TB_EsIgnorado>
-- Modificación:			<20/07/2018> <Juan Ram¡rez V> <Se modifica la estructura a Intervencion>
-- Modificación:			<28/10/2019> <Isaac Dobles Mata> <Se modifica consulta para que excluya aquellos intervinientes que pertenecen a un legajo>
-- Modificación:			<15/04/2020> <Aida E Siles> <Se agrega a la consulta el campo TC_Formato>
-- Modificación:			<19/06/2020> <Xinia Soto V.> <Se agregan a la consulta otros datos>
-- Modificación:			<24/07/2020> <Daniel Ruiz H.> <Se agrega representante>
-- Modificación:			<21/08/2020> <Daniel Ruiz H.> <Se modifica validacion de fechas de vigencia del representante>
-- Modificación:			<16/02/2021> <Karol Jim‚nez S.> <Se agrega consulta de IDINT (CodigoIntervinienteGestion)>
-- Modificación:			<31/03/2021> <Isaac Dobles Mata> <Se quita cl usula NOT IN por bug 182498>
-- Modificación:			<11/06/2021> <Karol Jim‚nez S.> <Se corrige consulta de campo Representante, dado que se debia consulta del representante 
--							de Personas Jur¡dicas, no en F¡sicas (estaba ocasionando producto cartesiano). Bug 193943. Se validó con Daniel Ruiz y Sigifredo>
--Modificación:				<14/06/2021> <Fabian Sequeira> <Se indica la clasula is not null ya que no debe permitir intervenciones en null >
--Modificación:				<23/06/2021> <Roger Lara> <Se cambia clausula is not null para ponerla en el left join >
--Modificación:				<02/09/2021> <Isaac Santiago M‚ndez Castillo> <Se agrega el origen de la persona en la consulta principal >
--Modificacion:				<05/11/2021> <Roger Lara><Se modifica consulta para que excluya aquellos intervinientes que pertenecen a un legajo>
-- =================================================================================================================================================
 
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervinienteBasico]
  @NumeroExpediente VARCHAR(14)
   AS
 BEGIN
 --Variables
	DECLARE			@L_NumeroExpediente				VARCHAR(14)				= @NumeroExpediente
	
	SELECT			Z.TF_Inicio_Vigencia			AS FechaActivacion,		  
					Z.TF_Fin_Vigencia				AS FechaDesactivacion, 
					Z.TF_Actualizacion				AS FechaModificacion,
					'SplitTI'						AS SplitTI,
					Z.IDINT							AS CodigoIntervinienteGestion,
					Z.TU_CodInterviniente			AS CodigoInterviniente,		  
					A.TF_ComisionDelito				AS FechaComisionDelito, 
					A.TC_Caracteristicas			AS Caracteristicas,		      
					A.TC_Alias						AS Alias, 
					A.TB_Droga						AS Droga, 
					(SELECT COUNT(*) FROM Expediente.MedidaPena  AS E	WITH(Nolock)
					WHERE E.TU_CodInterviniente = A.TU_CodInterviniente) AS TieneMedidaPena,
					A.TB_Rebeldia					AS Rebeldia,				
					'SplitTIn' AS SplitTIn,
					A.TN_CodTipoIntervencion		AS	Codigo,
					B.TC_Descripcion				AS	Descripcion,				 
					'SplitPF' AS SplitPF,
					C.TU_CodPersona					AS	CodigoPersona,
					C.TC_Nombre						AS	Nombre,
					C.TC_PrimerApellido				AS	PrimerApellido,
					C.TC_SegundoApellido			AS	SegundoApellido,
					C.TC_LugarNacimiento			AS  LugarNacimiento,
					C.TF_FechaNacimiento			AS  FechaNacimiento,			 
					P.TC_Identificacion				AS	Identificacion,
					C.TB_EsIgnorado					AS	EsIgnorado,	
					C.TF_FechaDefuncion				AS	FechaDefuncion,	
					C.TC_LugarDefuncion				AS	LugarDefuncion,	
					C.TC_NombreMadre				AS	NombreMadre,		
					C.TC_NombrePadre				AS	NombrePadre,
					C.TC_Carne						AS	Carne,
					C.TN_Salario					AS  Salario,
					'SplitPJ' AS SplitPJ,
					D.TU_CodPersona					AS	CodigoPersona,
					D.TC_Nombre						AS	Nombre,
					D.TC_NombreComercial			AS  NombreComercial,
					P.TC_Identificacion				AS	Identificacion,
					D.TC_NombreRepresentante		AS	NombreRepresentante,
					'SplitIdent' AS SplitIdent,
					T.TN_CodTipoIdentificacion		AS	Codigo,
					T.TC_Descripcion				AS	Descripcion,
					T.TC_Formato					AS	Formato,
					T.TB_EsIgnorado					AS  EsIgnorado,
					'SplitOtros' AS SplitOtros,
					B.TC_Intervencion 				AS Intervencion,
					Z.TC_TipoParticipacion			AS  TipoParticipacion,
					K.TC_CodSexo					AS	CodigoSexo,					
					K.TC_Descripcion				AS	SexoDescrip,
					J.TN_CodEstadoCivil				AS	CodigoEstadoCivil,			
					J.TC_Descripcion				AS	EstadoCivilDescrip,	
					A.TU_CodParentesco				AS CodigoParentesco,			
					L.TC_Descripcion				AS	DescripcionParentesco,
					E.TN_CodEtnia					As  CodigoEtnia,    
					E.TC_Descripcion				As  DescripcionEtnia,
					D.TN_CodTipoEntidad      		As  CodigoTipoEntidadJuridica,
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
	FROM			Expediente.Intervencion			AS	Z WITH (Nolock)
	Left Join		Expediente.Interviniente	    AS A WITH (NoLock)
	On				Z.TU_CodInterviniente			=	A.TU_CodInterviniente and 
					A.TN_CodTipoIntervencion		IS NOT NULL
	Left Join		Catalogo.TipoIntervencion		AS	B WITH (Nolock) 
	On				B.TN_CodTipoIntervencion		=	A.TN_CodTipoIntervencion
	Inner Join		Persona.Persona					AS	P WITH (Nolock) 
	On				Z.TU_CodPersona					=	P.TU_CodPersona
	left outer join	Persona.PersonaFisica			AS	C WITH (Nolock) 
	On				C.TU_CodPersona					=	P.TU_CodPersona
	Left Join		Catalogo.EstadoCivil			AS	J With(NoLock) 
	On				C.TN_CodEstadoCivil				=	J.TN_CodEstadoCivil	
	Left Join		Catalogo.Sexo					AS	K With(NoLock) 
	On				C.TC_CodSexo					=	K.TC_CodSexo
	Left Join		Catalogo.Parentesco				AS	L With(NoLock) 
	On				A.TU_CodParentesco				=	L.TC_CodParentesco
	Left Join       Catalogo.Pais					As	N With(NoLock)   
	On              A.TC_CodPais					=	N.TC_CodPais  
	Left Join		Catalogo.Profesion				As  S With(NoLock)   
	On				A.TN_CodProfesion				=   S.TN_CodProfesion  
	Left Join		Catalogo.Escolaridad			As  R With(NoLock)   
	On				A.TN_CodEscolaridad				=   R.TN_CodEscolaridad   
	Left Join		Catalogo.SituacionLaboral		As	I With(NoLock)   
	On				A.TN_CodSituacionLaboral		= I.TN_CodSituacionLaboral  
	left outer join	Persona.PersonaJuridica			AS	D WITH (Nolock) 
	On				D.TU_CodPersona					=	P.TU_CodPersona
	left outer join	Catalogo.TipoIdentificacion		AS	T WITH (Nolock) 
	On				P.TN_CodTipoIdentificacion		=	T.TN_CodTipoIdentificacion
	left outer join	Catalogo.TipoEntidadJuridica		AS	M WITH (Nolock) 
	On				M.TN_CodTipoEntidad		        =	D.TN_CodTipoEntidad
	Left Join       Catalogo.Etnia                  As  E With(Nolock)  
    On              C.TN_CodEtnia					=   E.TN_CodEtnia
	WHERE			Z.TC_NumeroExpediente			=	@L_NumeroExpediente
	And				(Z.TF_Fin_Vigencia				>=  getdate() or Z.TF_Fin_Vigencia	is null) 
    And				Z.TU_CodInterviniente			NOT IN (SELECT TU_CodInterviniente FROM 
															Expediente.LegajoIntervencion WITH (Nolock)
															WHERE TU_CodInterviniente = Z.TU_CodInterviniente)
END
GO
