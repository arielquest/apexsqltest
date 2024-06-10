SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<20/12/2015>
-- Descripción :			<Permite Consultar HorarioMedioComunicacion> 
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarHorarioMedioComunicacion]
	@Codigo smallint=Null,
	@Descripcion Varchar(50)=Null,
	@FechaActivacion Datetime2=Null,
	@FechaDesactivacion Datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodHorario		As	Codigo,			TC_Descripcion	As	Descripcion,
						TF_HoraInicio		As	HoraInicio,		TF_HoraFin		As	HoraFin,
						TF_Inicio_Vigencia	As	FechaActivacion,TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.HorarioMedioComunicacion With(Nolock) 	

			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodHorario	=	COALESCE(@Codigo,TN_CodHorario)
			Order By	TC_Descripcion;
	End	
	--Activos 
	Else If @FechaActivacion Is not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodHorario		As	Codigo,			TC_Descripcion	As	Descripcion,
						TF_HoraInicio		As	HoraInicio,		TF_HoraFin		As	HoraFin,
						TF_Inicio_Vigencia	As	FechaActivacion,TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.HorarioMedioComunicacion With(Nolock) 	

			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodHorario		=		COALESCE(@Codigo,TN_CodHorario)
			And			TF_Inicio_Vigencia  <		GETDATE ()
			And			(TF_Fin_Vigencia	Is Null 
			OR			TF_Fin_Vigencia		>=		GETDATE ())
			Order By	TC_Descripcion;
	End	 
	--Inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is not Null
	Begin
			Select		TN_CodHorario		As	Codigo,			TC_Descripcion	As	Descripcion,
						TF_HoraInicio		As	HoraInicio,		TF_HoraFin		As	HoraFin,
						TF_Inicio_Vigencia	As	FechaActivacion,TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.HorarioMedioComunicacion With(Nolock) 	

			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodHorario		=		COALESCE(@Codigo,TN_CodHorario)
	        And			(TF_Inicio_Vigencia >		GETDATE () 
			Or			TF_Fin_Vigencia		<		GETDATE ())
			Order By	TC_Descripcion;
	End	
	--Por Rango de Fechas
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is not Null
	Begin
			Select		TN_CodHorario		As	Codigo,			TC_Descripcion	As	Descripcion,
						TF_HoraInicio		As	HoraInicio,		TF_HoraFin		As	HoraFin,
						TF_Inicio_Vigencia	As	FechaActivacion,TF_Fin_Vigencia	As	FechaDesactivacion

			From		Catalogo.HorarioMedioComunicacion With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			and			TN_CodHorario		=		COALESCE(@Codigo,TN_CodHorario)
		    And			(TF_Fin_Vigencia	<=		@FechaDesactivacion 
			and			TF_Inicio_Vigencia	>=		@FechaActivacion)
			Order By	TC_Descripcion;
	End	  

 End
GO
