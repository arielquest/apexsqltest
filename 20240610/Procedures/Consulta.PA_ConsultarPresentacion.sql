SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<26/04/2016>
-- Descripción :			<Permite Consultar las columnas de presentación de la consulta.>
-- =================================================================================================================================================

CREATE PROCEDURE [Consulta].[PA_ConsultarPresentacion]
	@CodPresentacion	int				= Null,
	@CodModulo			int				= Null,
	@NombreColumna		varchar(50)		= Null,
	@Nombre				varchar(50)		= Null,		
	@FechaActivacion	datetime2		= Null,	
	@FechaDesactivacion	datetime2		= Null
AS
BEGIN
	
	Declare @ExpresionNombreLike varchar(200) = iIf(@Nombre Is Not Null,'%' + @Nombre + '%','%')
	Declare @ExpresionNombreColumnaLike varchar(200) = iIf(@NombreColumna Is Not Null,'%' + @NombreColumna + '%','%')

	--Todos
	If  @FechaDesactivacion Is Null And @CodModulo Is Null And @CodPresentacion Is Null
	Begin
			Select		A.TN_CodPresentacion	As CodigoPresentacion,
						A.TC_NombreColumna		As NombreColumna,
						A.TC_Nombre				As Nombre,
						A.TB_Predeterminada		As Predeterminada,
						A.TF_Inicio_Vigencia	As FechaActivacion,
						A.TF_Fin_Vigencia		As FechaDesactivacion,
						'SplitModulo'			As SplitModulo,
						B.TN_CodModulo			As Codigo,
						B.TC_Nombre				As Nombre
			From		Consulta.Presentacion	A With(NoLock)
			Inner Join	Consulta.Modulo			B With(NoLock)
			On			B.TN_CodModulo			= A.TN_CodModulo
			Where		A.TC_Nombre				like @ExpresionNombreLike
			And			A.TC_NombreColumna		like @ExpresionNombreColumnaLike;
	End

	--Por Llave @CodPresentacion
	Else If  @CodPresentacion Is Not Null
	Begin
			Select		A.TN_CodPresentacion	As CodigoPresentacion,
						A.TC_NombreColumna		As NombreColumna,
						A.TC_Nombre				As Nombre,
						A.TB_Predeterminada		As Predeterminada,
						A.TF_Inicio_Vigencia	As FechaActivacion,
						A.TF_Fin_Vigencia		As FechaDesactivacion,
						'SplitModulo'			As SplitModulo,
						B.TN_CodModulo			As Codigo,
						B.TC_Nombre				As Nombre
			From		Consulta.Presentacion	A With(NoLock)
			Inner Join	Consulta.Modulo			B With(NoLock)
			On			B.TN_CodModulo			= A.TN_CodModulo
			Where		A.TN_CodPresentacion	= @CodPresentacion;
	End

	--Por Llave @CodModulo
	Else If  @CodModulo Is Not Null
	Begin
			Select		A.TN_CodPresentacion	As CodigoPresentacion,
						A.TC_NombreColumna		As NombreColumna,
						A.TC_Nombre				As Nombre,
						A.TB_Predeterminada		As Predeterminada,
						A.TF_Inicio_Vigencia	As FechaActivacion,
						A.TF_Fin_Vigencia		As FechaDesactivacion,
						'SplitModulo'			As SplitModulo,
						B.TN_CodModulo			As Codigo,
						B.TC_Nombre				As Nombre
			From		Consulta.Presentacion	A With(NoLock)
			Inner Join	Consulta.Modulo			B With(NoLock)
			On			B.TN_CodModulo			= A.TN_CodModulo
			Where		A.TN_CodModulo			= @CodModulo;
	End

	--Por activos
	Else If  @FechaDesactivacion Is Null And @FechaActivacion Is Not Null
	Begin
			Select		A.TN_CodPresentacion	As CodigoPresentacion,
						A.TC_NombreColumna		As NombreColumna,
						A.TC_Nombre				As Nombre,
						A.TB_Predeterminada		As Predeterminada,
						A.TF_Inicio_Vigencia	As FechaActivacion,
						A.TF_Fin_Vigencia		As FechaDesactivacion,
						'SplitModulo'			As SplitModulo,
						B.TN_CodModulo			As Codigo,
						B.TC_Nombre				As Nombre
			From		Consulta.Presentacion	A With(NoLock)
			Inner Join	Consulta.Modulo			B With(NoLock)
			On			B.TN_CodModulo			= A.TN_CodModulo
			Where		A.TC_Nombre				like @ExpresionNombreLike
			And			A.TC_NombreColumna		like @ExpresionNombreColumnaLike
			And			A.TF_Inicio_Vigencia	< GETDATE()
			And		(	A.TF_Fin_Vigencia		Is Null
					Or	A.TF_Fin_Vigencia		>= GETDATE()	);
	End

	--Por inactivos
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null		
		Begin
			Select		A.TN_CodPresentacion	As CodigoPresentacion,
						A.TC_NombreColumna		As NombreColumna,
						A.TC_Nombre				As Nombre,
						A.TB_Predeterminada		As Predeterminada,
						A.TF_Inicio_Vigencia	As FechaActivacion,
						A.TF_Fin_Vigencia		As FechaDesactivacion,
						'SplitModulo'			As SplitModulo,
						B.TN_CodModulo			As Codigo,
						B.TC_Nombre				As Nombre
			From		Consulta.Presentacion	A With(NoLock)
			Inner Join	Consulta.Modulo			B With(NoLock)
			On			B.TN_CodModulo			= A.TN_CodModulo
			Where		A.TC_Nombre				like @ExpresionNombreLike
			And			A.TC_NombreColumna		like @ExpresionNombreColumnaLike
			And		(	A.TF_Inicio_Vigencia	> GETDATE()
					Or	A.TF_Fin_Vigencia		< GETDATE()	);
		End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
	Begin
			Select		A.TN_CodPresentacion	As CodigoPresentacion,
						A.TC_NombreColumna		As NombreColumna,
						A.TC_Nombre				As Nombre,
						A.TB_Predeterminada		As Predeterminada,
						A.TF_Inicio_Vigencia	As FechaActivacion,
						A.TF_Fin_Vigencia		As FechaDesactivacion,
						'SplitModulo'			As SplitModulo,
						B.TN_CodModulo			As Codigo,
						B.TC_Nombre				As Nombre
			From		Consulta.Presentacion	A With(NoLock)
			Inner Join	Consulta.Modulo			B With(NoLock)
			On			B.TN_CodModulo			= A.TN_CodModulo
			Where		A.TC_Nombre				like @ExpresionNombreLike
			And			A.TC_NombreColumna		like @ExpresionNombreColumnaLike
			And			A.TF_Inicio_Vigencia	>= @FechaActivacion
			And			A.TF_Fin_Vigencia		<= @FechaDesactivacion;
	End
END
GO
