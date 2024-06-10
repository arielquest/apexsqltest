SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<11/09/2015>
-- Descripción :			<Permite Consultar personas Jurídicas> 
-- Modificado por:			<Johan Acosta Ibañez>
-- Fecha :					<21/03/2016>
-- Descripción :			<Se modifico para que se pueda filtrar por código de persona> 
-- =================================================================================================================================================
-- Modificación:			<21/03/2016><Johan Acosta><Se modifico para que se pueda filtrar por código de persona>
-- Modificación:			<05/12/2016><Johan Acosta><Se cambio nombre de TC a TN >
-- Modificación:			<20/09/2016><Johan Acosta><Se incluye paginación>
-- Modificación:			<08/10/2018><Isaac Dobles Mata><Se incluye columna TC_Origen para obtener el origen de los datos consultados (Migración, TSE, Digitados manualmente, etc)
--							Se modifica para filtrar por las personas cuyo origen no sea Migrado 'M'>
-- Modificación:			<05/05/2021><Karol Jiménez Sánchez><Se agrega bandera para identificar cuándo excluir personas migradas>
-- =================================================================================================================================================
CREATE PROCEDURE [Persona].[PA_ConsultarPersonaJuridica]
	@CodPersona			uniqueidentifier = Null,
	@Identificacion		Varchar(21)		 = Null,
	@Nombre				Varchar(100)	 = Null,
	@IndicePagina		Smallint		 = Null,
	@CantidadPagina		Smallint		 = Null,
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


	--Todos
	If @CodPersona Is Null And  @Identificacion Is Null And @Nombre Is Null 
	Begin
			Select		A.TC_Nombre					As	Nombre,					A.TC_NombreComercial	As	NombreComercial,	
						B.TU_CodPersona				As	CodigoPersona,			B.TC_Identificacion		As	Identificacion,						
						'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
						D.TN_CodTipoIdentificacion	As	Codigo,					D.TC_Descripcion		As	Descripcion,		
						D.TF_Inicio_Vigencia		As	FechaActivacion,		D.TF_Fin_Vigencia		As	FechaDesactivacion,
						'SplitTipoEntidadJuridica'	As	SplitTipoEntidadJuridica, 
						E.TN_CodTipoEntidad			As	Codigo,					E.TC_Descripcion		As	Descripcion,
						E.TF_Inicio_Vigencia		As	FechaActivacion,		E.TF_Fin_Vigencia		As	FechaDesactivacion,
						'SplitOrigen' 				As 	SplitOrigen,
						B.TC_Origen					As	Origen,						
						'SplitDatos'				As  SplitDatos,			COUNT(*) OVER()			As	Total
			from		Persona.PersonaJuridica		As	A	With(Nolock)
			Inner Join	Persona.Persona				As	B	With(Nolock)
			On			B.TU_CodPersona				=	A.TU_CodPersona
			Inner Join	Catalogo.TipoIdentificacion As	D	With(Nolock)
			on			D.TN_CodTipoIdentificacion	=	B.TN_CodTipoIdentificacion
			Inner Join	Catalogo.TipoEntidadJuridica As	E	With(Nolock)
			on			E.TN_CodTipoEntidad			=	A.TN_CodTipoEntidad
			WHERE		(@IncluirMigrados			=	1
						Or B.TC_Origen				<>	'M')
			Order By	A.TC_Nombre						Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;
	End
	
	--Por código de persona
	Else If  @CodPersona Is Not Null
	Begin
			Select		A.TC_Nombre					As	Nombre,					A.TC_NombreComercial	As	NombreComercial,	
						B.TU_CodPersona				As	CodigoPersona,			B.TC_Identificacion		As	Identificacion,	
						'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
						D.TN_CodTipoIdentificacion	As	Codigo,					D.TC_Descripcion		As	Descripcion,		
						D.TF_Inicio_Vigencia		As	FechaActivacion,		D.TF_Fin_Vigencia		As	FechaDesactivacion,
						'SplitTipoEntidadJuridica'	As	SplitTipoEntidadJuridica, 
						E.TN_CodTipoEntidad			As	Codigo,					E.TC_Descripcion		As	Descripcion,		
						E.TF_Inicio_Vigencia		As	FechaActivacion,		E.TF_Fin_Vigencia		As	FechaDesactivacion,
						'SplitOrigen' 				As 	SplitOrigen,
						B.TC_Origen					As	Origen,		
						'SplitDatos'				As  SplitDatos,			COUNT(*) OVER()			As	Total
			from		Persona.PersonaJuridica		As	A	With(Nolock)
			Inner Join	Persona.Persona				As	B	With(Nolock)
			On			B.TU_CodPersona				=	A.TU_CodPersona
			Inner Join	Catalogo.TipoIdentificacion As	D	With(Nolock)
			on			D.TN_CodTipoIdentificacion	=	B.TN_CodTipoIdentificacion
			Inner Join	Catalogo.TipoEntidadJuridica As	E	With(Nolock)
			on			E.TN_CodTipoEntidad			=	A.TN_CodTipoEntidad
			WHERE		(@IncluirMigrados			=	1
						Or B.TC_Origen				<>	'M')
			And			B.TU_CodPersona				=	@CodPersona
			Order By	A.TC_Nombre						Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;
	End
	 
	--Por Identificación
	Else If  @Identificacion Is Not Null
	Begin
			Select		A.TC_Nombre					As	Nombre,					A.TC_NombreComercial	As	NombreComercial,	
						B.TU_CodPersona				As	CodigoPersona,			B.TC_Identificacion		As	Identificacion,	
						'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
						D.TN_CodTipoIdentificacion	As	Codigo,					D.TC_Descripcion		As	Descripcion,		
						D.TF_Inicio_Vigencia		As	FechaActivacion,		D.TF_Fin_Vigencia		As	FechaDesactivacion,
						'SplitTipoEntidadJuridica'	As	SplitTipoEntidadJuridica, 
						E.TN_CodTipoEntidad			As	Codigo,					E.TC_Descripcion		As	Descripcion,		
						E.TF_Inicio_Vigencia		As	FechaActivacion,		E.TF_Fin_Vigencia		As	FechaDesactivacion,
						'SplitOrigen' 				As 	SplitOrigen,
						B.TC_Origen					As	Origen,		
						'SplitDatos'				As  SplitDatos,			COUNT(*) OVER()			As	Total
			from		Persona.PersonaJuridica		As	A	With(Nolock)
			Inner Join	Persona.Persona				As	B	With(Nolock)
			On			B.TU_CodPersona				=	A.TU_CodPersona
			Inner Join	Catalogo.TipoIdentificacion As	D	With(Nolock)
			on			D.TN_CodTipoIdentificacion	=	B.TN_CodTipoIdentificacion
			Inner Join	Catalogo.TipoEntidadJuridica As	E	With(Nolock)
			on			E.TN_CodTipoEntidad			=	A.TN_CodTipoEntidad
			WHERE		(@IncluirMigrados			=	1
						Or B.TC_Origen				<>	'M')
			And			B.TC_Identificacion			like	@IdentificacionLike
			Order By	A.TC_Nombre					Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;
	End

	--Por Nombre
	Else If @Nombre Is Not Null
	Begin
			Select		A.TC_Nombre					As	Nombre,					A.TC_NombreComercial	As	NombreComercial,	
						B.TU_CodPersona				As	CodigoPersona,			B.TC_Identificacion		As	Identificacion,						
						'SplitTipoIdentificacion'	As	SplitTipoIdentificacion, 
						D.TN_CodTipoIdentificacion	As	Codigo,					D.TC_Descripcion		As	Descripcion,		
						D.TF_Inicio_Vigencia		As	FechaActivacion,		D.TF_Fin_Vigencia		As	FechaDesactivacion,
						'SplitTipoEntidadJuridica'	As	SplitTipoEntidadJuridica, 
						E.TN_CodTipoEntidad			As	Codigo,					E.TC_Descripcion		As	Descripcion,		
						E.TF_Inicio_Vigencia		As	FechaActivacion,		E.TF_Fin_Vigencia		As	FechaDesactivacion,
						'SplitOrigen' 				As 	SplitOrigen,
						B.TC_Origen					As	Origen,		
						'SplitDatos'				As  SplitDatos,			COUNT(*) OVER()			As	Total
			from		Persona.PersonaJuridica		As	A	With(Nolock)
			Inner Join	Persona.Persona				As	B	With(Nolock)
			On			B.TU_CodPersona				=	A.TU_CodPersona
			Inner Join	Catalogo.TipoIdentificacion As	D	With(Nolock)
			on			D.TN_CodTipoIdentificacion	=	B.TN_CodTipoIdentificacion
			Inner Join	Catalogo.TipoEntidadJuridica As	E	With(Nolock)
			on			E.TN_CodTipoEntidad			=	A.TN_CodTipoEntidad
			WHERE		(@IncluirMigrados			=	1
						Or B.TC_Origen				<>	'M')
			And			A.TC_Nombre						like	@NombreLike			
			Order By	A.TC_Nombre						Asc
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;				
	End
			
 End






GO
