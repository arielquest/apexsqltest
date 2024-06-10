SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<02/10/2015>
-- Descripción :			<Permite Consultar un Delito> 

-- Modificado por:			<Olger Gamboa Castillo>
-- Fecha de creación:		<22/10/2015>
-- Descripción :			<Se agrega el filtro por fecha de activación para consultar los activos> 
--
-- Modificado por:			<Olger Gamboa Castillo>
-- Fecha de creación:		<09/12/2015>
-- Descripción :			<Se cambia el tipo de dato del codigo a smallint> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
--
-- Modificación:			<2017-11-22> <Andrés Díaz> <Se tabula todo el archivo. Se elimina la consulta por código.>
--
-- Modificación:			<2017-21-01> <Andrés Díaz> <Se agrega la función dbo.FN_RemoverTildes.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEstadoActividadProgramada]
	@CodEstadoActividad	smallint		= Null,
	@Descripcion		varchar(50)		= Null,			
	@FechaDesactivacion	datetime2(3)	= Null,			
	@FechaActivacion	datetime2(3)	= null
As
Begin
	
	DECLARE @ExpresionLike varchar(200) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%');

	--Todos
	If	@FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		A.TN_CodEstadoActividad				As Codigo,
						A.TC_Descripcion					As Descripcion,
						A.TF_Inicio_Vigencia				As FechaActivacion,
						A.TF_Fin_Vigencia					As FechaDesactivacion
			From		Catalogo.EstadoActividadProgramada	A With(Nolock)
			Where		A.TN_CodEstadoActividad				= COALESCE(@CodEstadoActividad, A.TN_CodEstadoActividad)
			And			dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			Order By	A.TC_Descripcion;
	End
	 
	--Activos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		A.TN_CodEstadoActividad				As Codigo,
						A.TC_Descripcion					As Descripcion,
						A.TF_Inicio_Vigencia				As FechaActivacion,
						A.TF_Fin_Vigencia					As FechaDesactivacion
			From		Catalogo.EstadoActividadProgramada	A With(Nolock)
			Where		A.TN_CodEstadoActividad				= COALESCE(@CodEstadoActividad, A.TN_CodEstadoActividad)
			And			dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TF_Inicio_Vigencia				< GETDATE()
			And			(A.TF_Fin_Vigencia					Is Null Or A.TF_Fin_Vigencia >= GETDATE())
			Order By	A.TC_Descripcion;
	End

	--Inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null
	Begin
			Select		A.TN_CodEstadoActividad				As Codigo,
						A.TC_Descripcion					As Descripcion,
						A.TF_Inicio_Vigencia				As FechaActivacion,
						A.TF_Fin_Vigencia					As FechaDesactivacion
			From		Catalogo.EstadoActividadProgramada	A With(Nolock)
			Where		A.TN_CodEstadoActividad				= COALESCE(@CodEstadoActividad, A.TN_CodEstadoActividad)
			And			dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			(A.TF_Inicio_Vigencia				> GETDATE () Or A.TF_Fin_Vigencia < GETDATE())
			Order By	A.TC_Descripcion;
	End

	--Rango de fechas
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null
		Begin
			Select		A.TN_CodEstadoActividad				As Codigo,
						A.TC_Descripcion					As Descripcion,
						A.TF_Inicio_Vigencia				As FechaActivacion,
						A.TF_Fin_Vigencia					As FechaDesactivacion
			From		Catalogo.EstadoActividadProgramada	A With(Nolock)
			Where		A.TN_CodEstadoActividad				= COALESCE(@CodEstadoActividad, A.TN_CodEstadoActividad)
			And			dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) 
			And			A.TF_Inicio_Vigencia				>= @FechaActivacion
			And			A.TF_Fin_Vigencia					<= @FechaDesactivacion 
			Order By	A.TC_Descripcion;
	End
End
GO
