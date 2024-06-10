SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Gerardo Lopez>
-- Fecha de creación:		<17/08/2015>
-- Descripción :			<Permite Consultar  estado civil> 
-- Modificado por:			<23/10/2015><Pablo Alvarez><Se incluyen filtros por fecha de activación.> 	
-- Modificado por:			<14/12/2015> <GerardoLopez> 	<Se cambia tipo dato CodEstadoCivil a smallint>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<29/11/2017><Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEstadoCivil]
	@Codigo smallint=Null,
	@Descripcion Varchar(100)=Null,
	@FechaActivacion datetime2=Null,
	@FechaDesactivacion datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Activos e inactivos
	If  @FechaActivacion Is Null And  @FechaDesactivacion  Is Null 
	Begin
			Select		TN_CodEstadoCivil      	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.EstadoCivil With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TN_CodEstadoCivil			=  Coalesce(@Codigo, TN_CodEstadoCivil) 
			Order By	TC_Descripcion;
	End
	 
	--Activos
	Else If  @FechaActivacion Is Not Null And  @FechaDesactivacion  Is Null 
	Begin
			Select		TN_CodEstadoCivil	    As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.EstadoCivil With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TN_CodEstadoCivil			=  Coalesce(@Codigo, TN_CodEstadoCivil)
			And			TF_Inicio_Vigencia	<=		GETDATE ()
			And			(TF_Fin_Vigencia		Is	Null OR TF_Fin_Vigencia  >= GETDATE ()) 
			Order By	TC_Descripcion;
	End

	--Inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion  Is Not Null
	Begin
			Select		TN_CodEstadoCivil	    As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.EstadoCivil With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TN_CodEstadoCivil			=  Coalesce(@Codigo, TN_CodEstadoCivil)
			And			(TF_Inicio_Vigencia >		GETDATE () 
			Or			TF_Fin_Vigencia		<		GETDATE ())
			Order By	TC_Descripcion;
	End
	
	--Por rango de fechas
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion  Is Not Null		
	Begin
			Select		TN_CodEstadoCivil       As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.EstadoCivil With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TN_CodEstadoCivil			=  Coalesce(@Codigo, TN_CodEstadoCivil)
			And			(TF_Inicio_Vigencia	>= @FechaActivacion
			And			TF_Fin_Vigencia		<= @FechaDesactivacion )
			Order By	TC_Descripcion;
	End	
			
 End
GO
