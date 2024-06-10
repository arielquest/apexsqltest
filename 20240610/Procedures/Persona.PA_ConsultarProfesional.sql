SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<11/09/2015>
-- Descripción :			<Permite Consultar personas físicas> 
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
  
CREATE PROCEDURE [Persona].[PA_ConsultarProfesional]
 @Nombre			Varchar(50)=Null,
 @PrimerApellido	Varchar(50)= Null,
 @SegundoApellido	Varchar(50)= Null,
 @Carne				Varchar(25)=Null
 As
 Begin
  
	Declare @CarneLike varchar(50)
	Set		@CarneLike = iIf(@Carne Is Not Null,'%' + @Carne + '%','%')
	Declare @NombreLike varchar(50)
	Set		@NombreLike = iIf(@Nombre Is Not Null,'%' + @Nombre + '%','%')
	Declare @PrimerApellidoLike varchar(50)
	Set		@PrimerApellidoLike = iIf(@PrimerApellido Is Not Null,'%' + @PrimerApellido + '%','%')
	Declare @SegundoApellidoLike varchar(50)
	Set		@SegundoApellidoLike = iIf(@SegundoApellido Is Not Null,'%' + @SegundoApellido + '%','%')
	
	--Todos
	If  @Carne Is Null And @Nombre Is Null And @PrimerApellido Is Null And @SegundoApellido Is Null
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.TF_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona			
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Inner Join		Persona.Profesional				as		F	With(Nolock)
			on			    A.TU_CodPersona					=		F.TU_CodPersona
			
	End
	 
	--Por carne
	Else If  @Carne Is Not Null
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.TF_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Inner Join		Persona.Profesional				as		F	With(Nolock)
			on			    A.TU_CodPersona					=		F.TU_CodPersona
			Where			A.TC_Carne						like	@CarneLike
	End

	--Por Nombre y apellido
	Else If @Nombre Is Not Null And @PrimerApellido Is Not Null And @SegundoApellido Is Not Null 
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.TF_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Inner Join		Persona.Profesional				as		F	With(Nolock)
			on			    A.TU_CodPersona					=		F.TU_CodPersona
			Where			A.TC_Nombre				like	@NombreLike				And
							A.TC_PrimerApellido		like	@PrimerApellidoLike		And
							A.TC_SegundoApellido	like	@SegundoApellidoLike		
	End
	
		--Por Nombre y primer Apellido
	Else If @Nombre Is Not Null And @PrimerApellido Is Not Null 
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.TF_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Inner Join		Persona.Profesional				as		F	With(Nolock)
			on			    A.TU_CodPersona					=		F.TU_CodPersona
			Where			A.TC_Nombre				like	@NombreLike				And
							A.TC_PrimerApellido		like	@PrimerApellidoLike			
	End
	--Por Nombre y Segundo apellido
	Else If @Nombre Is Not Null And @SegundoApellido Is Not Null 
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.TF_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Inner Join		Persona.Profesional				as		F	With(Nolock)
			on			    A.TU_CodPersona					=		F.TU_CodPersona
			Where			A.TC_Nombre				like	@NombreLike				And
							A.TC_SegundoApellido	like	@SegundoApellidoLike			
	End
	--Por Ambos apellidos
	Else If @PrimerApellido Is Not Null And @SegundoApellido Is Not Null 
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.TF_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Inner Join		Persona.Profesional				as		F	With(Nolock)
			on			    A.TU_CodPersona					=		F.TU_CodPersona
			Where			A.TC_PrimerApellido		like	@PrimerApellidoLike				And
							A.TC_SegundoApellido	like	@SegundoApellidoLike			
	End
	--Por Nombre
	Else If @Nombre Is Not Null
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.TF_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Inner Join		Persona.Profesional				as		F	With(Nolock)
			on			    A.TU_CodPersona					=		F.TU_CodPersona
			Where			A.TC_Nombre						like	@NombreLike							
	End
	--Por Primer Apellido
	Else If @PrimerApellido Is Not Null
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.TF_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Inner Join		Persona.Profesional				as		F	With(Nolock)
			on			    A.TU_CodPersona					=		F.TU_CodPersona
			Where			A.TC_PrimerApellido		like	@PrimerApellidoLike							
	
	End
	
		--Por Segundo Apellido
	Else If @SegundoApellido Is Not Null
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.TF_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Inner Join		Persona.Profesional				as		F	With(Nolock)
			on			    A.TU_CodPersona					=		F.TU_CodPersona
			Where			A.TC_SegundoApellido	like	@SegundoApellidoLike						
	End
			

 End




GO
