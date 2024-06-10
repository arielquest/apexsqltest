SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta I.>
-- Fecha de creación:		<11/07/2016>
-- Descripción :			<Permite Consultar puesto(s) de trabajo> 
-- =================================================================================================================================================
-- Modificación:			<05/12/2016> <Pablo Alvarez> <Se corrige TN_CodPerfilpuesto y TN_CodTipoFuncionario por estandar.>
-- Modificación:			<07/12/2016> <Andrés Díaz> <Se consulta información del funcionario activo en el puesto de trabajo.>
-- Modificación:			<07/02/2017> <Pablo Alvarez> <Se agrega split con jornada laboral.>
-- Modificación:			<22/03/2017> <Andrés Díaz> <Se agrega el horario y código de la jornada laboral.>
-- Modificación:			<12/08/2020> <Isaac Dobles Mata> <Se agrega el código de asignacion PuestoTrabajoFuncionario y las fechas de asignacion>
-- Modificación:			<14/08/2020> <Jonathan Aguilar Navarro> <Se agrega es split de Tipo Puesto de Trabajo ya que solo se habia incluido en la primer consulta> 
-- Modificación:			<26/08/2020> <Jonathan Aguilar Navarro> <Se aplica un left join con la tabla TipoFuncionario, este cambio es temporal, uan vez que se elimine el campo se debe de elimianr el JOIN> 
-- Modificación:			<20/01/2021> <Jonathan Aguilar Navarro> <Se agrega el parametro @ValidaFechaFuturo para que la consulta tome en cuenta funcionarios asignados en fechas futuras> 
-- Modificación:			<05/05/2021> <Aida Elena Siles R> <Corrección del Join con la tabla TipoFuncionario.> 
-- Modificación:			<19/07/2021> <Cristian Cerdas Camacho> <Se agrega en el uso de aplicación móvil para el tipo de puesto trabajo>
-- Modificación:			<10/01/2022> <Jose Gabriel Cordero Soto> <Se agrega en el WHERE el valor de que Fecha Desactivacion pueda ser NULO y no solo el rango de fecha establecido>
-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarPuestoTrabajo]
	@Codigo				Varchar (14)	=	Null,
	@CodOficina			Varchar(4)		=	Null,
	@Descripcion		Varchar(75)		=	Null,
	@FechaDesactivacion Datetime2(3)	=	Null,
	@FechaActivacion	Datetime2(3)	=	Null,
	@ValidaFechasFuturo bit				=	0	
As
Begin
	Declare @ExpresionLike varchar(200) = iif(@Descripcion Is Not Null,'%' + @Descripcion + '%','%');

	IF (@ValidaFechasFuturo = 0)
	BEGIN
		If @FechaDesactivacion Is Null And @FechaActivacion Is Not Null --Activos
	Begin	
			Select	  	A.TC_CodPuestoTrabajo			As	Codigo,				
						A.TC_Descripcion				As	Descripcion,
						A.TF_Inicio_Vigencia			As	FechaActivacion,	
						A.TF_Fin_Vigencia				As	FechaDesactivacion,
						A.TB_UtilizaAppMovil			AS UtilizaAppMovil,
						'Split'							As	Split,				
						B.TC_CodOficina					As	Codigo,
						B.TC_Nombre						As	Descripcion,		
						'Split'							As	Split,			
						C.TN_CodTipoOficina				As	Codigo,
						C.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,			
						D.TN_CodTipoFuncionario			As	Codigo,
						D.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,
						F.UsuarioRed					As	UsuarioRed,
						F.Nombre						As	Nombre,
						F.PrimerApellido				As	PrimerApellido,
						F.SegundoApellido				As	SegundoApellido,
						F.CodigoPlaza					As	CodigoPlaza,
						F.FechaActivacion				As	FechaActivacion,
						F.FechaDesactivacion			As	FechaDesactivacion,
  						'Split'                         As  Split,
                        E.TN_CodJornadaLaboral          As  Codigo,
						E.TC_Descripcion                As  Descripcion,
						E.TF_HoraInicio					As	HoraInicio,
						E.TF_HoraFin					As	HoraFin,
						'Split'							AS  Split,
						TPT.TN_CodTipoPuestoTrabajo		AS	Codigo,
						TPT.TC_Descripcion				AS	Descripcion,
						TPT.TF_Inicio_Vigencia			AS 	FechaActivacion,
						TPT.TF_Fin_Vigencia				AS	FechaDesactivacion,
						F.Codigo						As  CodigoAsignacion,
						F.FechaActivacionAsignacion		As  FechaActivacionAsignacion,
						F.FechaDesactivacionAsignacion	As	FechaDesactivacionAsignacion
			From		Catalogo.PuestoTrabajo			As	A With(Nolock)
			Inner Join	Catalogo.Oficina				As	B With(Nolock)
			On			B.TC_CodOficina					=	A.TC_CodOficina
			Inner Join	Catalogo.TipoOficina			As	C With(Nolock)
			On			B.TN_CodTipoOficina				=	C.TN_CodTipoOficina
			Inner Join	Catalogo.JornadaLaboral 		As	E With(Nolock)
			On			A.TN_CodJornadaLaboral			=	E.TN_CodJornadaLaboral	
			Inner Join	Catalogo.TipoPuestoTrabajo		AS  TPT With(NoLock)
			On			TPT.TN_CodTipoPuestoTrabajo		=	A.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoFuncionario		As	D With(Nolock)
			On			D.TN_CodTipoFuncionario			=	TPT.TN_CodTipoFuncionario
			Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) As F	
			Where		A.TC_CodPuestoTrabajo			= COALESCE(@Codigo, A.TC_CodPuestoTrabajo)
			And			A.TC_Descripcion				like @ExpresionLike 
			And			A.TC_CodOficina					= COALESCE(@CodOficina, A.TC_CodOficina)
			And			A.TF_Inicio_Vigencia			< GETDATE()
			And			(A.TF_Fin_Vigencia				is null or A.TF_Fin_Vigencia  >= GETDATE ())
			Order By	A.TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Null and @FechaActivacion Is Null --Todos
	Begin	
			Select	  	A.TC_CodPuestoTrabajo			As	Codigo,				
						A.TC_Descripcion				As	Descripcion,
						A.TF_Inicio_Vigencia			As	FechaActivacion,	
						A.TF_Fin_Vigencia				As	FechaDesactivacion, 
						A.TB_UtilizaAppMovil			AS UtilizaAppMovil,
						'Split'							As	Split,				
						B.TC_CodOficina					As	Codigo,
						B.TC_Nombre						As	Descripcion,		
						'Split'							As	Split,			
						C.TN_CodTipoOficina				As	Codigo,
						C.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,			
						D.TN_CodTipoFuncionario			As	Codigo,
						D.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,
						F.UsuarioRed					As	UsuarioRed,
						F.Nombre						As	Nombre,
						F.PrimerApellido				As	PrimerApellido,
						F.SegundoApellido				As	SegundoApellido,
						F.CodigoPlaza					As	CodigoPlaza,
						F.FechaActivacion				As	FechaActivacion,
						F.FechaDesactivacion			As	FechaDesactivacion,
  						'Split'                         As  Split,
                        E.TN_CodJornadaLaboral          As  Codigo,
						E.TC_Descripcion                As  Descripcion,
						E.TF_HoraInicio					As	HoraInicio,
						E.TF_HoraFin					As	HoraFin,
						'Split'							AS  Split,
						TPT.TN_CodTipoPuestoTrabajo		AS	Codigo,
						TPT.TC_Descripcion				AS	Descripcion,
						TPT.TF_Inicio_Vigencia			AS 	FechaActivacion,
						TPT.TF_Fin_Vigencia				AS	FechaDesactivacion,
						F.Codigo						As  CodigoAsignacion,
						F.FechaActivacionAsignacion		As  FechaActivacionAsignacion,
						F.FechaDesactivacionAsignacion	As	FechaDesactivacionAsignacion
			From		Catalogo.PuestoTrabajo			As	A With(Nolock)
			Inner Join	Catalogo.Oficina				As	B With(Nolock)
			On			B.TC_CodOficina					=	A.TC_CodOficina
			Inner Join	Catalogo.TipoOficina			As	C With(Nolock)
			On			B.TN_CodTipoOficina				=	C.TN_CodTipoOficina	
			Inner Join	Catalogo.JornadaLaboral 		As	E With(Nolock)
			On			A.TN_CodJornadaLaboral			=	E.TN_CodJornadaLaboral	
			Inner Join	Catalogo.TipoPuestoTrabajo		AS  TPT With(NoLock)
			On			TPT.TN_CodTipoPuestoTrabajo		=	A.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoFuncionario		As	D With(Nolock)
			On			D.TN_CodTipoFuncionario			=	TPT.TN_CodTipoFuncionario
			Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) As F	
			Where		A.TC_CodPuestoTrabajo			= COALESCE(@Codigo, A.TC_CodPuestoTrabajo)
			And			A.TC_Descripcion				like @ExpresionLike 
			And			A.TC_CodOficina					= COALESCE(@CodOficina, A.TC_CodOficina)
			Order By	A.TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null --Inactivos
	Begin
			Select	  	A.TC_CodPuestoTrabajo			As	Codigo,				
						A.TC_Descripcion				As	Descripcion,
						A.TF_Inicio_Vigencia			As	FechaActivacion,	
						A.TF_Fin_Vigencia				As	FechaDesactivacion, 
						A.TB_UtilizaAppMovil			AS UtilizaAppMovil,
						'Split'							As	Split,				
						B.TC_CodOficina					As	Codigo,
						B.TC_Nombre						As	Descripcion,		
						'Split'							As	Split,			
						C.TN_CodTipoOficina				As	Codigo,
						C.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,			
						D.TN_CodTipoFuncionario			As	Codigo,
						D.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,
						F.UsuarioRed					As	UsuarioRed,
						F.Nombre						As	Nombre,
						F.PrimerApellido				As	PrimerApellido,
						F.SegundoApellido				As	SegundoApellido,
						F.CodigoPlaza					As	CodigoPlaza,
						F.FechaActivacion				As	FechaActivacion,
						F.FechaDesactivacion			As	FechaDesactivacion,
  						'Split'                         As  Split,
                        E.TN_CodJornadaLaboral          As  Codigo,
						E.TC_Descripcion                As  Descripcion,
						E.TF_HoraInicio					As	HoraInicio,
						E.TF_HoraFin					As	HoraFin,
						'Split'							AS  Split,
						TPT.TN_CodTipoPuestoTrabajo		AS	Codigo,
						TPT.TC_Descripcion				AS	Descripcion,
						TPT.TF_Inicio_Vigencia			AS 	FechaActivacion,
						TPT.TF_Fin_Vigencia				AS	FechaDesactivacion,
						F.Codigo						As  CodigoAsignacion,
						F.FechaActivacionAsignacion		As  FechaActivacionAsignacion,
						F.FechaDesactivacionAsignacion	As	FechaDesactivacionAsignacion
			From		Catalogo.PuestoTrabajo			As	A With(Nolock)
			Inner Join	Catalogo.Oficina				As	B With(Nolock)
			On			B.TC_CodOficina					=	A.TC_CodOficina
			Inner Join	Catalogo.TipoOficina			As	C With(Nolock)
			On			B.TN_CodTipoOficina				=	C.TN_CodTipoOficina
			Inner Join	Catalogo.JornadaLaboral 		As	E With(Nolock)
			On			A.TN_CodJornadaLaboral			=	E.TN_CodJornadaLaboral	
			Inner Join	Catalogo.TipoPuestoTrabajo		AS  TPT With(NoLock)
			On			TPT.TN_CodTipoPuestoTrabajo		=	A.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoFuncionario		As	D With(Nolock)
			On			D.TN_CodTipoFuncionario			=	TPT.TN_CodTipoFuncionario
			Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) As F	
			Where		A.TC_CodPuestoTrabajo			= COALESCE(@Codigo, A.TC_CodPuestoTrabajo)
			And			A.TC_Descripcion				like @ExpresionLike 
			And			A.TC_CodOficina					= COALESCE(@CodOficina, A.TC_CodOficina)
			And			(A.TF_Inicio_Vigencia			> GETDATE ()
			Or			A.TF_Fin_Vigencia				< GETDATE ())
			Order By	A.TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null -- Range de fechas
	Begin
			Select	  	A.TC_CodPuestoTrabajo			As	Codigo,				
						A.TC_Descripcion				As	Descripcion,
						A.TF_Inicio_Vigencia			As	FechaActivacion,	
						A.TF_Fin_Vigencia				As	FechaDesactivacion, 
						A.TB_UtilizaAppMovil			AS UtilizaAppMovil,
						'Split'							As	Split,				
						B.TC_CodOficina					As	Codigo,
						B.TC_Nombre						As	Descripcion,		
						'Split'							As	Split,			
						C.TN_CodTipoOficina				As	Codigo,
						C.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,			
						D.TN_CodTipoFuncionario			As	Codigo,
						D.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,
						F.UsuarioRed					As	UsuarioRed,
						F.Nombre						As	Nombre,
						F.PrimerApellido				As	PrimerApellido,
						F.SegundoApellido				As	SegundoApellido,
						F.CodigoPlaza					As	CodigoPlaza,
						F.FechaActivacion				As	FechaActivacion,
						F.FechaDesactivacion			As	FechaDesactivacion,
  						'Split'                         As  Split,
                        E.TN_CodJornadaLaboral          As  Codigo,
						E.TC_Descripcion                As  Descripcion,
						E.TF_HoraInicio					As	HoraInicio,
						E.TF_HoraFin					As	HoraFin,
						'Split'							AS  Split,
						TPT.TN_CodTipoPuestoTrabajo		AS	Codigo,
						TPT.TC_Descripcion				AS	Descripcion,
						TPT.TF_Inicio_Vigencia			AS 	FechaActivacion,
						TPT.TF_Fin_Vigencia				AS	FechaDesactivacion,
						F.Codigo						As  CodigoAsignacion,
						F.FechaActivacionAsignacion		As  FechaActivacionAsignacion,
						F.FechaDesactivacionAsignacion	As	FechaDesactivacionAsignacion
			From		Catalogo.PuestoTrabajo			As	A With(Nolock)
			Inner Join	Catalogo.Oficina				As	B With(Nolock)
			On			B.TC_CodOficina					=	A.TC_CodOficina
			Inner Join	Catalogo.TipoOficina			As	C With(Nolock)
			On			B.TN_CodTipoOficina				=	C.TN_CodTipoOficina
			Inner Join	Catalogo.JornadaLaboral 		As	E With(Nolock)
			On			A.TN_CodJornadaLaboral			=	E.TN_CodJornadaLaboral	
			Inner Join	Catalogo.TipoPuestoTrabajo		AS  TPT With(NoLock)
			On			TPT.TN_CodTipoPuestoTrabajo		=	A.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoFuncionario		As	D With(Nolock)
			On			D.TN_CodTipoFuncionario			=	TPT.TN_CodTipoFuncionario
			Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) As F	
			
			Where		A.TC_CodPuestoTrabajo			= COALESCE(@Codigo, A.TC_CodPuestoTrabajo)
			And			A.TC_Descripcion				like @ExpresionLike 
			And			A.TC_CodOficina					= COALESCE(@CodOficina, A.TC_CodOficina)
			And			A.TF_Inicio_Vigencia			>= @FechaActivacion
			And			(A.TF_Fin_Vigencia				<= @FechaDesactivacion 
			OR			 A.TF_Fin_Vigencia				IS NULL)
			
			Order By	A.TC_Descripcion;
	End
	END
	ELSE
	BEGIN
	If @FechaDesactivacion Is Null And @FechaActivacion Is Not Null --Activos
	Begin	
			Select	  	A.TC_CodPuestoTrabajo			As	Codigo,				
						A.TC_Descripcion				As	Descripcion,
						A.TF_Inicio_Vigencia			As	FechaActivacion,	
						A.TF_Fin_Vigencia				As	FechaDesactivacion, 
						A.TB_UtilizaAppMovil			AS UtilizaAppMovil,
						'Split'							As	Split,				
						B.TC_CodOficina					As	Codigo,
						B.TC_Nombre						As	Descripcion,		
						'Split'							As	Split,			
						C.TN_CodTipoOficina				As	Codigo,
						C.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,			
						D.TN_CodTipoFuncionario			As	Codigo,
						D.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,
						F.UsuarioRed					As	UsuarioRed,
						F.Nombre						As	Nombre,
						F.PrimerApellido				As	PrimerApellido,
						F.SegundoApellido				As	SegundoApellido,
						F.CodigoPlaza					As	CodigoPlaza,
						F.FechaActivacion				As	FechaActivacion,
						F.FechaDesactivacion			As	FechaDesactivacion,
  						'Split'                         As  Split,
                        E.TN_CodJornadaLaboral          As  Codigo,
						E.TC_Descripcion                As  Descripcion,
						E.TF_HoraInicio					As	HoraInicio,
						E.TF_HoraFin					As	HoraFin,
						'Split'							AS  Split,
						TPT.TN_CodTipoPuestoTrabajo		AS	Codigo,
						TPT.TC_Descripcion				AS	Descripcion,
						TPT.TF_Inicio_Vigencia			AS 	FechaActivacion,
						TPT.TF_Fin_Vigencia				AS	FechaDesactivacion,
						F.Codigo						As  CodigoAsignacion,
						F.FechaActivacionAsignacion		As  FechaActivacionAsignacion,
						F.FechaDesactivacionAsignacion	As	FechaDesactivacionAsignacion
			From		Catalogo.PuestoTrabajo			As	A With(Nolock)
			Inner Join	Catalogo.Oficina				As	B With(Nolock)
			On			B.TC_CodOficina					=	A.TC_CodOficina
			Inner Join	Catalogo.TipoOficina			As	C With(Nolock)
			On			B.TN_CodTipoOficina				=	C.TN_CodTipoOficina	
			Inner Join	Catalogo.JornadaLaboral 		As	E With(Nolock)
			On			A.TN_CodJornadaLaboral			=	E.TN_CodJornadaLaboral	
			Inner Join	Catalogo.TipoPuestoTrabajo		AS  TPT With(NoLock)
			On			TPT.TN_CodTipoPuestoTrabajo		=	A.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoFuncionario		As	D With(Nolock)
			On			D.TN_CodTipoFuncionario			=	TPT.TN_CodTipoFuncionario
			Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajoFuturo(A.TC_CodPuestoTrabajo) As F
			Where		A.TC_CodPuestoTrabajo			= COALESCE(@Codigo, A.TC_CodPuestoTrabajo)
			And			A.TC_Descripcion				like @ExpresionLike 
			And			A.TC_CodOficina					= COALESCE(@CodOficina, A.TC_CodOficina)
			And			A.TF_Inicio_Vigencia			< GETDATE()
			And			(A.TF_Fin_Vigencia				is null or A.TF_Fin_Vigencia  >= GETDATE ())
			Order By	A.TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Null and @FechaActivacion Is Null --Todos
	Begin	
			Select	  	A.TC_CodPuestoTrabajo			As	Codigo,				
						A.TC_Descripcion				As	Descripcion,
						A.TF_Inicio_Vigencia			As	FechaActivacion,	
						A.TF_Fin_Vigencia				As	FechaDesactivacion,
						A.TB_UtilizaAppMovil			AS UtilizaAppMovil,
						'Split'							As	Split,				
						B.TC_CodOficina					As	Codigo,
						B.TC_Nombre						As	Descripcion,		
						'Split'							As	Split,			
						C.TN_CodTipoOficina				As	Codigo,
						C.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,			
						D.TN_CodTipoFuncionario			As	Codigo,
						D.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,
						F.UsuarioRed					As	UsuarioRed,
						F.Nombre						As	Nombre,
						F.PrimerApellido				As	PrimerApellido,
						F.SegundoApellido				As	SegundoApellido,
						F.CodigoPlaza					As	CodigoPlaza,
						F.FechaActivacion				As	FechaActivacion,
						F.FechaDesactivacion			As	FechaDesactivacion,
  						'Split'                         As  Split,
                        E.TN_CodJornadaLaboral          As  Codigo,
						E.TC_Descripcion                As  Descripcion,
						E.TF_HoraInicio					As	HoraInicio,
						E.TF_HoraFin					As	HoraFin,
						'Split'							AS  Split,
						TPT.TN_CodTipoPuestoTrabajo		AS	Codigo,
						TPT.TC_Descripcion				AS	Descripcion,
						TPT.TF_Inicio_Vigencia			AS 	FechaActivacion,
						TPT.TF_Fin_Vigencia				AS	FechaDesactivacion,
						F.Codigo						As  CodigoAsignacion,
						F.FechaActivacionAsignacion		As  FechaActivacionAsignacion,
						F.FechaDesactivacionAsignacion	As	FechaDesactivacionAsignacion
			From		Catalogo.PuestoTrabajo			As	A With(Nolock)
			Inner Join	Catalogo.Oficina				As	B With(Nolock)
			On			B.TC_CodOficina					=	A.TC_CodOficina
			Inner Join	Catalogo.TipoOficina			As	C With(Nolock)
			On			B.TN_CodTipoOficina				=	C.TN_CodTipoOficina	
			Inner Join	Catalogo.JornadaLaboral 		As	E With(Nolock)
			On			A.TN_CodJornadaLaboral			=	E.TN_CodJornadaLaboral	
			Inner Join	Catalogo.TipoPuestoTrabajo		AS  TPT With(NoLock)
			On			TPT.TN_CodTipoPuestoTrabajo		=	A.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoFuncionario		As	D With(Nolock)
			On			D.TN_CodTipoFuncionario			=	TPT.TN_CodTipoFuncionario
			Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajoFuturo(A.TC_CodPuestoTrabajo) As F	
			Where		A.TC_CodPuestoTrabajo			= COALESCE(@Codigo, A.TC_CodPuestoTrabajo)
			And			A.TC_Descripcion				like @ExpresionLike 
			And			A.TC_CodOficina					= COALESCE(@CodOficina, A.TC_CodOficina)
			Order By	A.TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null --Inactivos
	Begin
			Select	  	A.TC_CodPuestoTrabajo			As	Codigo,				
						A.TC_Descripcion				As	Descripcion,
						A.TF_Inicio_Vigencia			As	FechaActivacion,	
						A.TF_Fin_Vigencia				As	FechaDesactivacion, 
						A.TB_UtilizaAppMovil			AS UtilizaAppMovil,
						'Split'							As	Split,				
						B.TC_CodOficina					As	Codigo,
						B.TC_Nombre						As	Descripcion,		
						'Split'							As	Split,			
						C.TN_CodTipoOficina				As	Codigo,
						C.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,			
						D.TN_CodTipoFuncionario			As	Codigo,
						D.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,
						F.UsuarioRed					As	UsuarioRed,
						F.Nombre						As	Nombre,
						F.PrimerApellido				As	PrimerApellido,
						F.SegundoApellido				As	SegundoApellido,
						F.CodigoPlaza					As	CodigoPlaza,
						F.FechaActivacion				As	FechaActivacion,
						F.FechaDesactivacion			As	FechaDesactivacion,
  						'Split'                         As  Split,
                        E.TN_CodJornadaLaboral          As  Codigo,
						E.TC_Descripcion                As  Descripcion,
						E.TF_HoraInicio					As	HoraInicio,
						E.TF_HoraFin					As	HoraFin,
						'Split'							AS  Split,
						TPT.TN_CodTipoPuestoTrabajo		AS	Codigo,
						TPT.TC_Descripcion				AS	Descripcion,
						TPT.TF_Inicio_Vigencia			AS 	FechaActivacion,
						TPT.TF_Fin_Vigencia				AS	FechaDesactivacion,
						F.Codigo						As  CodigoAsignacion,
						F.FechaActivacionAsignacion		As  FechaActivacionAsignacion,
						F.FechaDesactivacionAsignacion	As	FechaDesactivacionAsignacion
			From		Catalogo.PuestoTrabajo			As	A With(Nolock)
			Inner Join	Catalogo.Oficina				As	B With(Nolock)
			On			B.TC_CodOficina					=	A.TC_CodOficina
			Inner Join	Catalogo.TipoOficina			As	C With(Nolock)
			On			B.TN_CodTipoOficina				=	C.TN_CodTipoOficina
			Inner Join	Catalogo.JornadaLaboral 		As	E With(Nolock)
			On			A.TN_CodJornadaLaboral			=	E.TN_CodJornadaLaboral	
			Inner Join	Catalogo.TipoPuestoTrabajo		AS  TPT With(NoLock)
			On			TPT.TN_CodTipoPuestoTrabajo		=	A.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoFuncionario		As	D With(Nolock)
			On			D.TN_CodTipoFuncionario			=	TPT.TN_CodTipoFuncionario
			Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajoFuturo(A.TC_CodPuestoTrabajo) As F		
			Where		A.TC_CodPuestoTrabajo			= COALESCE(@Codigo, A.TC_CodPuestoTrabajo)
			And			A.TC_Descripcion				like @ExpresionLike 
			And			A.TC_CodOficina					= COALESCE(@CodOficina, A.TC_CodOficina)
			And			(A.TF_Inicio_Vigencia			> GETDATE ()
			Or			A.TF_Fin_Vigencia				< GETDATE ())
			Order By	A.TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null -- Range de fechas
	Begin
			Select	  	A.TC_CodPuestoTrabajo			As	Codigo,				
						A.TC_Descripcion				As	Descripcion,
						A.TF_Inicio_Vigencia			As	FechaActivacion,	
						A.TF_Fin_Vigencia				As	FechaDesactivacion, 
						A.TB_UtilizaAppMovil			AS UtilizaAppMovil,
						'Split'							As	Split,				
						B.TC_CodOficina					As	Codigo,
						B.TC_Nombre						As	Descripcion,		
						'Split'							As	Split,			
						C.TN_CodTipoOficina				As	Codigo,
						C.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,			
						D.TN_CodTipoFuncionario			As	Codigo,
						D.TC_Descripcion				As	Descripcion,
						'Split'							As	Split,
						F.UsuarioRed					As	UsuarioRed,
						F.Nombre						As	Nombre,
						F.PrimerApellido				As	PrimerApellido,
						F.SegundoApellido				As	SegundoApellido,
						F.CodigoPlaza					As	CodigoPlaza,
						F.FechaActivacion				As	FechaActivacion,
						F.FechaDesactivacion			As	FechaDesactivacion,
  						'Split'                         As  Split,
                        E.TN_CodJornadaLaboral          As  Codigo,
						E.TC_Descripcion                As  Descripcion,
						E.TF_HoraInicio					As	HoraInicio,
						E.TF_HoraFin					As	HoraFin,
						'Split'							AS  Split,
						TPT.TN_CodTipoPuestoTrabajo		AS	Codigo,
						TPT.TC_Descripcion				AS	Descripcion,
						TPT.TF_Inicio_Vigencia			AS 	FechaActivacion,
						TPT.TF_Fin_Vigencia				AS	FechaDesactivacion,
						F.Codigo						As  CodigoAsignacion,
						F.FechaActivacionAsignacion		As  FechaActivacionAsignacion,
						F.FechaDesactivacionAsignacion	As	FechaDesactivacionAsignacion
			From		Catalogo.PuestoTrabajo			As	A With(Nolock)
			Inner Join	Catalogo.Oficina				As	B With(Nolock)
			On			B.TC_CodOficina					=	A.TC_CodOficina
			Inner Join	Catalogo.TipoOficina			As	C With(Nolock)
			On			B.TN_CodTipoOficina				=	C.TN_CodTipoOficina
			Inner Join	Catalogo.JornadaLaboral 		As	E With(Nolock)
			On			A.TN_CodJornadaLaboral			=	E.TN_CodJornadaLaboral	
			Inner Join	Catalogo.TipoPuestoTrabajo		AS  TPT With(NoLock)
			On			TPT.TN_CodTipoPuestoTrabajo		=	A.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoFuncionario		As	D With(Nolock)
			On			D.TN_CodTipoFuncionario			=	TPT.TN_CodTipoFuncionario
			Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajoFuturo(A.TC_CodPuestoTrabajo) As F
			Where		A.TC_CodPuestoTrabajo			= COALESCE(@Codigo, A.TC_CodPuestoTrabajo)
			And			A.TC_Descripcion				like @ExpresionLike 
			And			A.TC_CodOficina					= COALESCE(@CodOficina, A.TC_CodOficina)
			And			A.TF_Inicio_Vigencia			>= @FechaActivacion
			And 	   (A.TF_Fin_Vigencia				<= @FechaDesactivacion 
			OR			A.TF_Fin_Vigencia				IS NULL)
			Order By	A.TC_Descripcion;
	End
	END
End

GO
