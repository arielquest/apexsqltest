SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<11/09/2015>
-- Descripción :			<Permite Consultar personas físicas> 
-- Descripción :			<Se modifico para que se pueda filtrar por código de persona> 
-- =================================================================================================================================================
-- Modificación:			<21/03/2016><Johan Acosta><Se modifico para que se pueda filtrar por código de persona>
-- Modificación:			<05/12/2016><Johan Acosta><Se cambio nombre de TC a TN >
-- Modificación:			<20/09/2016><Johan Acosta><Se incluye paginación>
-- Modificación:			<08/10/2018><Isaac Dobles Mata><Se incluye columna TC_Origen para obtener el origen de los datos consultados (Migración, TSE, Digitados manualmente, etc)
--							Se modifica para filtrar por las personas cuyo origen no sea Migrado 'M'>
-- Modificación:			<05/05/2021><Karol Jiménez Sánchez><Se agrega bandera para identificar cuándo excluir personas migradas>
-- =================================================================================================================================================
CREATE PROCEDURE [Persona].[PA_ConsultarPersonaFisica]
	 @CodPersona		uniqueidentifier	= null,
	 @Identificacion	Varchar(21)			= Null,
	 @Nombre			Varchar(50)			= Null,
	 @PrimerApellido	Varchar(50)			= Null,
	 @SegundoApellido	Varchar(50)			= Null,
	 @IndicePagina		Smallint			= Null,
	 @CantidadPagina	Smallint			= Null,
	 @Migrado			Char(1),
	 @IncluirMigrados	Bit
 As
 Begin

 
	If (@IndicePagina Is Null Or @CantidadPagina Is Null)
	Begin
		SET @IndicePagina = 0;
		SET @CantidadPagina = 32767;
	End
  
	Declare @IdentificacionLike varchar(50)
	Set		@IdentificacionLike = iIf(@Identificacion Is Not Null,'%' + @Identificacion + '%','%')
	Declare @NombreLike varchar(50)
	Set		@NombreLike = iIf(@Nombre Is Not Null,'%' + @Nombre + '%','%')
	Declare @PrimerApellidoLike varchar(50)
	Set		@PrimerApellidoLike = iIf(@PrimerApellido Is Not Null,'%' + @PrimerApellido + '%','%')
	Declare @SegundoApellidoLike varchar(50)
	Set		@SegundoApellidoLike = iIf(@SegundoApellido Is Not Null,'%' + @SegundoApellido + '%','%')

	--Todos
	If @CodPersona Is Null And @Identificacion Is Null And @Nombre Is Null And @PrimerApellido Is Null And @SegundoApellido Is Null
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.TF_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitOrigen'				As  SplitOrigen,		B.TC_Origen				As	Origen,
					'SplitDatos'				As  SplitDatos,			A.TC_CodSexo			As	CodigoSexo,			F.TC_Descripcion		As SexoDescrip, 
					A.TN_CodEstadoCivil			As CodigoEstadoCivil,	g.TC_Descripcion		As 	EstadoCivilDescrip,
					COUNT(*) OVER()			As	Total
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona			
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Left Outer Join	Catalogo.Sexo 					As		F	With(Nolock)
			on				F.TC_CodSexo					=		A.TC_CodSexo 
			Left Outer Join	Catalogo.EstadoCivil 			As		G	With(Nolock)
			on				G.TN_CodEstadoCivil 			=		A.TN_CodEstadoCivil 
			WHERE			(@IncluirMigrados				=		1
							Or B.TC_Origen					<>		@Migrado)
			Order By	A.TC_Nombre						Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;
	End
	--Por Código
	Else If  @CodPersona Is Not Null
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.TF_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitOrigen'				As  SplitOrigen,		B.TC_Origen				As	Origen,
					'SplitDatos'				As  SplitDatos,			A.TC_CodSexo			As	CodigoSexo,			F.TC_Descripcion		As SexoDescrip, 
					A.TN_CodEstadoCivil			As CodigoEstadoCivil,	g.TC_Descripcion		As 	EstadoCivilDescrip,
					COUNT(*) OVER()			As	Total
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Left Outer Join	Catalogo.Sexo 					As		F	With(Nolock)
			on				F.TC_CodSexo					=		A.TC_CodSexo 
			Left Outer Join	Catalogo.EstadoCivil 			As		G	With(Nolock)
			on				G.TN_CodEstadoCivil 			=		A.TN_CodEstadoCivil 
			Where			B.TU_CodPersona					=		@CodPersona
			AND				(@IncluirMigrados				=		1
							Or B.TC_Origen					<>		@Migrado)
			Order By	A.TC_Nombre						Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;
	End

	--Por Identificación
	Else If  @Identificacion Is Not Null
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.TF_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitOrigen'				As  SplitOrigen,		B.TC_Origen				As	Origen,
					'SplitDatos'				As  SplitDatos,			A.TC_CodSexo			As	CodigoSexo,			F.TC_Descripcion		As SexoDescrip, 
					A.TN_CodEstadoCivil			As CodigoEstadoCivil,	g.TC_Descripcion		As 	EstadoCivilDescrip,
					COUNT(*) OVER()			As	Total
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Left Outer Join	Catalogo.Sexo 					As		F	With(Nolock)
			on				F.TC_CodSexo					=		A.TC_CodSexo 
			Left Outer Join	Catalogo.EstadoCivil 			As		G	With(Nolock)
			on				G.TN_CodEstadoCivil 			=		A.TN_CodEstadoCivil 
			Where			(@IncluirMigrados				=		1
							Or B.TC_Origen					<>		@Migrado)
			AND				B.TC_Identificacion		like	@IdentificacionLike						
			Order By	A.TC_Nombre						Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;
	End

	--Por Nombre y apellido
	Else If @Nombre Is Not Null And @PrimerApellido Is Not Null And @SegundoApellido Is Not Null 
	Begin
			Select	A.TC_Nombre					As	Nombre,				A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,	
					A.Tf_FechaNacimiento		As	FechaNacimiento,	A.TC_LugarNacimiento	As	LugarNacimiento,	A.TF_FechaDefuncion		As	FechaDefuncion,	A.TC_LugarDefuncion	As	LugarDefuncion,	
					A.TC_NombreMadre			As	NombreMadre,		A.TC_NombrePadre		As	NombrePadre,	
					B.TU_CodPersona				As	CodigoPersona,		B.TC_Identificacion		As	Identificacion,		A.TC_Carne as Carne,
					'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
					D.TN_CodTipoIdentificacion	As	Codigo,				D.TC_Descripcion		As	Descripcion,		D.TF_Inicio_Vigencia	As FechaActivacion, D.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitEtnia'				As	SplitEtnia,
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitOrigen'				As  SplitOrigen,		B.TC_Origen				As	Origen,
					'SplitDatos'				As  SplitDatos,			A.TC_CodSexo			As	CodigoSexo,			F.TC_Descripcion		As SexoDescrip, 
					A.TN_CodEstadoCivil			As CodigoEstadoCivil,	g.TC_Descripcion		As 	EstadoCivilDescrip,
					COUNT(*) OVER()			As	Total
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Left Outer Join	Catalogo.Sexo 					As		F	With(Nolock)
			on				F.TC_CodSexo					=		A.TC_CodSexo 
			Left Outer Join	Catalogo.EstadoCivil 			As		G	With(Nolock)
			on				G.TN_CodEstadoCivil 			=		A.TN_CodEstadoCivil 
			WHERE			(@IncluirMigrados				=		1
							Or B.TC_Origen					<>		@Migrado)
			AND				A.TC_Nombre				like	@NombreLike				And
							A.TC_PrimerApellido		like	@PrimerApellidoLike		And
							A.TC_SegundoApellido	like	@SegundoApellidoLike				
			Order By	A.TC_Nombre						Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;
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
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitOrigen'				As  SplitOrigen,		B.TC_Origen				As	Origen,
					'SplitDatos'				As  SplitDatos,			A.TC_CodSexo			As	CodigoSexo,			F.TC_Descripcion		As SexoDescrip, 
					A.TN_CodEstadoCivil			As CodigoEstadoCivil,	g.TC_Descripcion		As 	EstadoCivilDescrip,
					COUNT(*) OVER()			As	Total
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Left Outer Join	Catalogo.Sexo 					As		F	With(Nolock)
			on				F.TC_CodSexo					=		A.TC_CodSexo 
			Left Outer Join	Catalogo.EstadoCivil 			As		G	With(Nolock)
			on				G.TN_CodEstadoCivil 			=		A.TN_CodEstadoCivil 
			WHERE			(@IncluirMigrados				=		1
							Or B.TC_Origen					<>		@Migrado)
			AND				A.TC_Nombre				like	@NombreLike				And
							A.TC_PrimerApellido		like	@PrimerApellidoLike		
			Order By	A.TC_Nombre						Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;	
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
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitOrigen'				As  SplitOrigen,		B.TC_Origen				As	Origen,
					'SplitDatos'				As  SplitDatos,			A.TC_CodSexo			As	CodigoSexo,			F.TC_Descripcion		As SexoDescrip, 
					A.TN_CodEstadoCivil			As CodigoEstadoCivil,	g.TC_Descripcion		As 	EstadoCivilDescrip,
					COUNT(*) OVER()			As	Total
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Left Outer Join	Catalogo.Sexo 					As		F	With(Nolock)
			on				F.TC_CodSexo					=		A.TC_CodSexo 
			Left Outer Join	Catalogo.EstadoCivil 			As		G	With(Nolock)
			on				G.TN_CodEstadoCivil 			=		A.TN_CodEstadoCivil 
			Where			(@IncluirMigrados				=		1
							Or B.TC_Origen					<>		@Migrado)
			And				A.TC_Nombre						like	@NombreLike				And
							A.TC_SegundoApellido			like	@SegundoApellidoLike	
			Order By	A.TC_Nombre						Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;		
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
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitOrigen'				As  SplitOrigen,		B.TC_Origen				As	Origen,
					'SplitDatos'				As  SplitDatos,			A.TC_CodSexo			As	CodigoSexo,			F.TC_Descripcion		As SexoDescrip, 
					A.TN_CodEstadoCivil			As CodigoEstadoCivil,	g.TC_Descripcion		As 	EstadoCivilDescrip,
					COUNT(*) OVER()			As	Total
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Left Outer Join	Catalogo.Sexo 					As		F	With(Nolock)
			on				F.TC_CodSexo					=		A.TC_CodSexo 
			Left Outer Join	Catalogo.EstadoCivil 			As		G	With(Nolock)
			on				G.TN_CodEstadoCivil 			=		A.TN_CodEstadoCivil 
			Where			(@IncluirMigrados				=		1
							Or B.TC_Origen					<>		@Migrado)
			And				A.TC_PrimerApellido				like	@PrimerApellidoLike				And
							A.TC_SegundoApellido			like	@SegundoApellidoLike			
			Order By	A.TC_Nombre						Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;
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
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitOrigen'				As  SplitOrigen,		B.TC_Origen				As	Origen,
					'SplitDatos'				As  SplitDatos,			A.TC_CodSexo			As	CodigoSexo,			F.TC_Descripcion		As SexoDescrip, 
					A.TN_CodEstadoCivil			As CodigoEstadoCivil,	g.TC_Descripcion		As 	EstadoCivilDescrip,
					COUNT(*) OVER()			As	Total
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Left Outer Join	Catalogo.Sexo 					As		F	With(Nolock)
			on				F.TC_CodSexo					=		A.TC_CodSexo 
			Left Outer Join	Catalogo.EstadoCivil 			As		G	With(Nolock)
			on				G.TN_CodEstadoCivil 			=		A.TN_CodEstadoCivil 
			Where			(@IncluirMigrados				=		1
							Or B.TC_Origen					<>		@Migrado)
			And				A.TC_Nombre						like	@NombreLike		
			Order By		A.TC_Nombre						Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;				
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
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitOrigen'				As  SplitOrigen,		B.TC_Origen				As	Origen,
					'SplitDatos'				As  SplitDatos,			A.TC_CodSexo			As	CodigoSexo,			F.TC_Descripcion		As SexoDescrip, 
					A.TN_CodEstadoCivil			As CodigoEstadoCivil,	g.TC_Descripcion		As 	EstadoCivilDescrip,
					COUNT(*) OVER()			As	Total
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Left Outer Join	Catalogo.Sexo 					As		F	With(Nolock)
			on				F.TC_CodSexo					=		A.TC_CodSexo 
			Left Outer Join	Catalogo.EstadoCivil 			As		G	With(Nolock)
			on				G.TN_CodEstadoCivil 			=		A.TN_CodEstadoCivil 
			Where			(@IncluirMigrados				=		1
							Or B.TC_Origen					<>		@Migrado)
			And				A.TC_PrimerApellido				like	@PrimerApellidoLike		
			Order By		A.TC_Nombre						Asc
			Offset			@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;					
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
					E.TN_CodEtnia				As	Codigo,				E.TC_Descripcion		As	Descripcion,		E.TF_Inicio_Vigencia	As FechaActivacion, E.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitOrigen'				As  SplitOrigen,		B.TC_Origen				As	Origen,
					'SplitDatos'				As  SplitDatos,			COUNT(*) OVER()			As	Total,
					K.TC_CodSexo				As	CodigoSexo,					K.TC_Descripcion				As	SexoDescrip,
					J.TN_CodEstadoCivil			As	CodigoEstadoCivil,			J.TC_Descripcion				As	EstadoCivilDescrip	
			From			Persona.PersonaFisica			As		A	With(Nolock)
			Inner Join		Persona.Persona					As		B	With(Nolock)
			On				B.TU_CodPersona					=		A.TU_CodPersona
			Left Join		Catalogo.EstadoCivil			As	J With(NoLock) 
			On				A.TN_CodEstadoCivil				=	J.TN_CodEstadoCivil	
			Left Join		Catalogo.Sexo					As	K With(NoLock) 
			On				A.TC_CodSexo					=	K.TC_CodSexo
			Inner Join		Catalogo.TipoIdentificacion 	As		D	With(Nolock)
			on				D.TN_CodTipoIdentificacion		=		B.TN_CodTipoIdentificacion
			Left Outer Join	Catalogo.Etnia 					As		E	With(Nolock)
			on				E.TN_CodEtnia					=		A.TN_CodEtnia
			Where			(@IncluirMigrados				=		1
							Or B.TC_Origen					<>		@Migrado)
			And				A.TC_SegundoApellido			like	@SegundoApellidoLike			
			Order By	A.TC_Nombre						Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;			
	End
			

 End





GO
