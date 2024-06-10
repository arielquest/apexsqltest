SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<13/09/2015>
-- Descripción :			<Permite Consultar los intervinientes
-- Modificado :				<Johan Acosta> Se modificó el cambo Observaciones por Caracteristicas.
-- Fecha de modificación:	<26/04/2016>
-- Modificado :				<Johan Acosta> Se modificó para que retorne la intervención del interviniente.
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre de los campos TC_CodTipoIntervencion y TC_CodTipoIdentificacion a TN_CodTipoIntervencion y TN_CodTipoIdentificacion de acuerdo al tipo de dato.>
-- Modificación:			<25/01/2018> <Jonathan Aguilar> <Se agrega a la consulta el campo TB_EsIgnorado>
-- Modificación:			<20/07/2018> <Juan Ramírez V> <Se modifica la estructura a Intervencion>
-- =================================================================================================================================================
  
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervinienteBasicoEr]
  @NumeroExpediente varchar(14)
   As
 Begin
 
SELECT			Z.TF_Inicio_Vigencia			As FechaActivacion,		  
				Z.TF_Fin_Vigencia				As FechaDesactivacion, 
				Z.TF_Actualizacion				As FechaModificacion,		      																
				'SplitTI' As SplitTI,
				Z.TU_CodInterviniente			As CodigoInterviniente,		  
				A.TF_ComisionDelito				As FechaComisionDelito, 
				A.TC_Caracteristicas			As Caracteristicas,		      
				A.TC_Alias						As Alias, 
				A.TB_Droga						As Droga, (Select count(*) From Expediente.MedidaPena  As E	WITH(Nolock)
																		   Where E.TU_CodInterviniente = A.TU_CodInterviniente) As TieneMedidaPena,
				A.TB_Rebeldia					As Rebeldia,				
				'SplitTIn' As SplitTIn,
				A.TN_CodTipoIntervencion		As	Codigo,
				B.TC_Descripcion				As	Descripcion,				 'SplitPF' As SplitPF,
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
				'SplitPJ' As SplitPJ,
				D.TU_CodPersona					As	CodigoPersona,
				D.TC_Nombre						As	Nombre,
				P.TC_Identificacion				As	Identificacion,	
				'SplitIdent' As SplitIdent,
				T.TN_CodTipoIdentificacion		As	Codigo,
				T.TC_Descripcion				As	Descripcion,
				'SplitOtros' as SplitOtros,
				B.TC_Intervencion 				as Intervencion,
				Z.TC_TipoParticipacion			As  TipoParticipacion,
				K.TC_CodSexo					As	CodigoSexo,					K.TC_Descripcion				As	SexoDescrip,
				J.TN_CodEstadoCivil				As	CodigoEstadoCivil,			J.TC_Descripcion				As	EstadoCivilDescrip,	
				A.TU_CodParentesco				As CodigoParentesco,			L.TC_Descripcion				As	DescripcionParentesco
From			Expediente.Intervencion			As	Z WITH (Nolock)
Left Join		Expediente.Interviniente	    As A WITH (NoLock)
On				Z.TU_CodInterviniente			=	A.TU_CodInterviniente
Left Join		Catalogo.TipoIntervencion		As	B WITH (Nolock) 
On				B.TN_CodTipoIntervencion		=	A.TN_CodTipoIntervencion
Inner Join		Persona.Persona					As	P WITH (Nolock) 
On				Z.TU_CodPersona					=	P.TU_CodPersona
left outer join	Persona.PersonaFisica			As	C WITH (Nolock) 
On				C.TU_CodPersona					=	P.TU_CodPersona
Left Join		Catalogo.EstadoCivil			As	J With(NoLock) 
On				C.TN_CodEstadoCivil				=	J.TN_CodEstadoCivil	
Left Join		Catalogo.Sexo					As	K With(NoLock) 
On				C.TC_CodSexo					=	K.TC_CodSexo
Left Join		Catalogo.Parentesco				As	L With(NoLock) 
On				A.TU_CodParentesco				=	L.TC_CodParentesco
left outer join	Persona.PersonaJuridica			As	D WITH (Nolock) 
On				D.TU_CodPersona					=	P.TU_CodPersona
left outer join	Catalogo.TipoIdentificacion		As	T WITH (Nolock) 
On				P.TN_CodTipoIdentificacion		=	T.TN_CodTipoIdentificacion
WHERE			Z.TC_NumeroExpediente			=	@NumeroExpediente
And				(Z.TF_Fin_Vigencia				>=  getdate() or Z.TF_Fin_Vigencia	is null)
 End
GO
