SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<30/11/2016>
-- Descripción :			<Permite consultar registros de Agenda.JornadaTrabajoEspecial.> 
--
-- Modificación:			<Andrés Díaz><07/12/2016><Se consulta información del funcionario activo en el puesto de trabajo.>
-- =================================================================================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarJornadaTrabajoEspecial]
	@CodJornadaTrabajo		smallint		= Null,
	@CodPuestoTrabajo		varchar(14)		= Null,
	@CodOficina				varchar(4)		= Null,
	@FechaActivacion		datetime2		= Null,
	@FechaDesactivacion		datetime2		= Null
 As
 Begin

	--Todos
	If @FechaActivacion Is Null And @FechaActivacion Is Null And @FechaDesactivacion Is Null And @CodJornadaTrabajo Is Null  
	Begin
		Select		A.TN_CodJornadaTrabajo			As Codigo,
					A.TF_HoraInicio					As HoraInicio,
					A.TF_HoraFin					As HoraFin,
					A.TF_Inicio_Vigencia			As FechaActivacion,
					A.TF_Fin_Vigencia				As FechaDesactivacion,
					'Split'							As Split,
					B.TC_CodPuestoTrabajo			As Codigo,
					B.TC_Descripcion				As Descripcion,
					'Split'							As Split,
					A.TC_DiaSemana					As DiaSemana,
					'Split'							As Split,
					C.UsuarioRed					As	UsuarioRed,
					C.Nombre						As	Nombre,
					C.PrimerApellido				As	PrimerApellido,
					C.SegundoApellido				As	SegundoApellido,
					C.CodigoPlaza					As	CodigoPlaza,
					C.FechaActivacion				As	FechaActivacion,
					C.FechaDesactivacion			As	FechaDesactivacion
		From		Agenda.JornadaTrabajoEspecial	A With(NoLock)
		Inner Join	Catalogo.PuestoTrabajo			B With(NoLock)
		On			B.TC_CodPuestoTrabajo			= A.TC_CodPuestoTrabajo
		Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) C
		Where		A.TC_CodPuestoTrabajo			= ISNULL(@CodPuestoTrabajo, A.TC_CodPuestoTrabajo)
		And			B.TC_CodOficina					= ISNULL(@CodOficina, b.TC_CodOficina)
		Order By	B.TC_Descripcion;
	End
	 
	--Por Llave
	Else If  @CodJornadaTrabajo Is Not Null
	Begin
		Select		A.TN_CodJornadaTrabajo			As Codigo,
					A.TF_HoraInicio					As HoraInicio,
					A.TF_HoraFin					As HoraFin,
					A.TF_Inicio_Vigencia			As FechaActivacion,
					A.TF_Fin_Vigencia				As FechaDesactivacion,
					'Split'							As Split,
					B.TC_CodPuestoTrabajo			As Codigo,
					B.TC_Descripcion				As Descripcion,
					'Split'							As Split,
					A.TC_DiaSemana					As DiaSemana,
					'Split'							As Split,
					C.UsuarioRed					As	UsuarioRed,
					C.Nombre						As	Nombre,
					C.PrimerApellido				As	PrimerApellido,
					C.SegundoApellido				As	SegundoApellido,
					C.CodigoPlaza					As	CodigoPlaza,
					C.FechaActivacion				As	FechaActivacion,
					C.FechaDesactivacion			As	FechaDesactivacion
		From		Agenda.JornadaTrabajoEspecial	A With(NoLock)
		Inner Join	Catalogo.PuestoTrabajo			B With(NoLock)
		On			B.TC_CodPuestoTrabajo			= A.TC_CodPuestoTrabajo
		Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) C
		Where		A.TN_CodJornadaTrabajo			= @CodJornadaTrabajo	
		And			A.TC_CodPuestoTrabajo			= ISNULL(@CodPuestoTrabajo, A.TC_CodPuestoTrabajo)
		And			B.TC_CodOficina					= ISNULL(@CodOficina, b.TC_CodOficina)
		Order By	B.TC_Descripcion;
	End

	--Por activos y filtro por CodPuestoTrabajo
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
		Select		A.TN_CodJornadaTrabajo			As Codigo,
					A.TF_HoraInicio					As HoraInicio,
					A.TF_HoraFin					As HoraFin,
					A.TF_Inicio_Vigencia			As FechaActivacion,
					A.TF_Fin_Vigencia				As FechaDesactivacion,
					'Split'							As Split,
					B.TC_CodPuestoTrabajo			As Codigo,
					B.TC_Descripcion				As Descripcion,
					'Split'							As Split,
					A.TC_DiaSemana					As DiaSemana,
					'Split'							As Split,
					C.UsuarioRed					As	UsuarioRed,
					C.Nombre						As	Nombre,
					C.PrimerApellido				As	PrimerApellido,
					C.SegundoApellido				As	SegundoApellido,
					C.CodigoPlaza					As	CodigoPlaza,
					C.FechaActivacion				As	FechaActivacion,
					C.FechaDesactivacion			As	FechaDesactivacion
		From		Agenda.JornadaTrabajoEspecial	A With(NoLock)
		Inner Join	Catalogo.PuestoTrabajo			B With(NoLock)
		On			B.TC_CodPuestoTrabajo			= A.TC_CodPuestoTrabajo
		Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) C
		Where		A.TC_CodPuestoTrabajo			= ISNULL(@CodPuestoTrabajo, A.TC_CodPuestoTrabajo)
		And			B.TC_CodOficina					= ISNULL(@CodOficina, b.TC_CodOficina)
		And			(A.TF_Fin_Vigencia				Is Null Or A.TF_Fin_Vigencia >= GETDATE())
		Order By	B.TC_Descripcion;
	End
	
	--Por inactivos y filtro por CodPuestoTrabajo
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
		Select		A.TN_CodJornadaTrabajo			As Codigo,
					A.TF_HoraInicio					As HoraInicio,
					A.TF_HoraFin					As HoraFin,
					A.TF_Inicio_Vigencia			As FechaActivacion,
					A.TF_Fin_Vigencia				As FechaDesactivacion,
					'Split'							As Split,
					B.TC_CodPuestoTrabajo			As Codigo,
					B.TC_Descripcion				As Descripcion,
					'Split'							As Split,
					A.TC_DiaSemana					As DiaSemana,
					'Split'							As Split,
					C.UsuarioRed					As	UsuarioRed,
					C.Nombre						As	Nombre,
					C.PrimerApellido				As	PrimerApellido,
					C.SegundoApellido				As	SegundoApellido,
					C.CodigoPlaza					As	CodigoPlaza,
					C.FechaActivacion				As	FechaActivacion,
					C.FechaDesactivacion			As	FechaDesactivacion
		From		Agenda.JornadaTrabajoEspecial	A With(NoLock)
		Inner Join	Catalogo.PuestoTrabajo			B With(NoLock)
		On			B.TC_CodPuestoTrabajo			= A.TC_CodPuestoTrabajo
		Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) C
		Where		A.TC_CodPuestoTrabajo			= ISNULL(@CodPuestoTrabajo, A.TC_CodPuestoTrabajo)
		And			B.TC_CodOficina					= ISNULL(@CodOficina, b.TC_CodOficina)
		And			(A.TF_Inicio_Vigencia			> GETDATE() Or A.TF_Fin_Vigencia < GETDATE())
		Order By	B.TC_Descripcion;
	End

	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
	Begin
		Select		A.TN_CodJornadaTrabajo			As Codigo,
					A.TF_HoraInicio					As HoraInicio,
					A.TF_HoraFin					As HoraFin,
					A.TF_Inicio_Vigencia			As FechaActivacion,
					A.TF_Fin_Vigencia				As FechaDesactivacion,
					'Split'							As Split,
					B.TC_CodPuestoTrabajo			As Codigo,
					B.TC_Descripcion				As Descripcion,
					'Split'							As Split,
					A.TC_DiaSemana					As DiaSemana,
					'Split'							As Split,
					C.UsuarioRed					As	UsuarioRed,
					C.Nombre						As	Nombre,
					C.PrimerApellido				As	PrimerApellido,
					C.SegundoApellido				As	SegundoApellido,
					C.CodigoPlaza					As	CodigoPlaza,
					C.FechaActivacion				As	FechaActivacion,
					C.FechaDesactivacion			As	FechaDesactivacion
		From		Agenda.JornadaTrabajoEspecial	A With(NoLock)
		Inner Join	Catalogo.PuestoTrabajo			B With(NoLock)
		On			B.TC_CodPuestoTrabajo			= A.TC_CodPuestoTrabajo
		Outer Apply	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) C
		Where		A.TC_CodPuestoTrabajo			= ISNULL(@CodPuestoTrabajo, A.TC_CodPuestoTrabajo)
		And			B.TC_CodOficina					= ISNULL(@CodOficina, b.TC_CodOficina)
		And			(A.TF_Fin_Vigencia				<= @FechaDesactivacion And A.TF_Inicio_Vigencia >= @FechaActivacion)
		Order By	B.TC_Descripcion;
	End
			
 End






GO
