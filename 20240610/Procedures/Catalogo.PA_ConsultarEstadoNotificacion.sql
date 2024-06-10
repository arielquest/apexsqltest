SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Donald Vargas>
-- Fecha de creación:		<10/05/2016>
-- Descripción :			<Permite consultar los estados de notificación de la tabla Catalogo.EstadoNotificacion> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<29/11/2017> <Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarEstadoNotificacion]
	@CodEstadoNotificacion  tinyint = null,
	@Descripcion Varchar(50) = null, 
	@FechaActivacion datetime2(7) = null,
	@FechaDesactivacion datetime2(7) = null
 As
 Begin
 	
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(200)
	Set		@ExpresionLike	=	iif(@Descripcion Is Not Null,'%' +  @Descripcion + '%','%')
	
	--Activos e inactivos
	If  @FechaActivacion Is Null And  @FechaDesactivacion Is Null
	Begin	
			Select		TN_CodEstadoNotificacion As Codigo,			TC_Descripcion	As	Descripcion,
						TF_Inicio_Vigencia	 As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.EstadoNotificacion  As A
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodEstadoNotificacion	=	Coalesce(@CodEstadoNotificacion,TN_CodEstadoNotificacion)
			Order By	TC_Descripcion;
	End
	
	--Activos
	Else  If  @FechaActivacion Is Not Null And  @FechaDesactivacion Is Null
	Begin
			Select		TN_CodEstadoNotificacion		As	Codigo,		TC_Descripcion	As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.EstadoNotificacion  As A
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodEstadoNotificacion	=	Coalesce(@CodEstadoNotificacion,TN_CodEstadoNotificacion)
			And			A.TF_Inicio_Vigencia	<=		GETDATE ()
			And			(A.TF_Fin_Vigencia		Is	Null OR A.TF_Fin_Vigencia  >= GETDATE ())
			Order By	TC_Descripcion;
	End	
	
	--Inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion Is Not Null	
	Begin
			Select		TN_CodEstadoNotificacion		As	Codigo,		TC_Descripcion	As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.EstadoNotificacion As A
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodEstadoNotificacion	=	Coalesce(@CodEstadoNotificacion,TN_CodEstadoNotificacion)
			And			(A.TF_Inicio_Vigencia >		GETDATE () 
			Or			A.TF_Fin_Vigencia		<		GETDATE ())
			Order By	TC_Descripcion;
	End


	--Por rango de Fechas
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null	
	Begin
		Select		TN_CodEstadoNotificacion		As	Codigo,		TC_Descripcion	As	Descripcion,
					TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.EstadoNotificacion  As A
		Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		And			TN_CodEstadoNotificacion	=	Coalesce(@CodEstadoNotificacion,TN_CodEstadoNotificacion)
		And			(A.TF_Inicio_Vigencia	>= @FechaActivacion
		And			A.TF_Fin_Vigencia		<= @FechaDesactivacion)
		Order By	TC_Descripcion;
	End
		
 End



GO
