SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<31/08/2015>
-- Descripción :			<Permite Consultar Discapacidades> 
-- Modificacion:			<Gerardo Lopez> <22/10/2015> <Incluir fecha de activación para realizar la consulta de activos.>
-- Modificacion:			<Alejandro Villalta> <09/12/2015> <Autogenerar codigo de discapacidad.>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<29/11/2017><Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- =================================================================================================================================================

 
CREATE PROCEDURE [Catalogo].[PA_ConsultarDiscapacidad]
	@Codigo smallint=Null,
	@Descripcion Varchar(100)=Null,
	@FechaActivacion datetime2=Null,
	@FechaDesactivacion datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Activos e inactivos
	If  @FechaActivacion Is Null And  @FechaDesactivacion Is Null
	Begin
			Select		TN_CodDiscapacidad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Discapacidad With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			TN_CodDiscapacidad	=  Coalesce(@Codigo, TN_CodDiscapacidad) 
			Order By	TC_Descripcion;
	End
	

	--Activos
	Else If  @FechaActivacion Is Not Null And  @FechaDesactivacion Is Null 
	Begin
			Select		TN_CodDiscapacidad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Discapacidad With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			TN_CodDiscapacidad	=  Coalesce(@Codigo, TN_CodDiscapacidad)
			And			TF_Inicio_Vigencia	<=		GETDATE ()
			And			(TF_Fin_Vigencia		Is	Null OR TF_Fin_Vigencia  >= GETDATE ()) 
			Order By	TC_Descripcion;
	End
	
	--Inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
			Select		TN_CodDiscapacidad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Discapacidad With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			TN_CodDiscapacidad	=  Coalesce(@Codigo, TN_CodDiscapacidad)
			And			(TF_Inicio_Vigencia >		GETDATE () 
			Or			TF_Fin_Vigencia		<		GETDATE ())
			Order By	TC_Descripcion;
	End

	 --Por rango de fechas
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null			
		Begin
			Select		TN_CodDiscapacidad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Discapacidad With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			TN_CodDiscapacidad	=  Coalesce(@Codigo, TN_CodDiscapacidad)
			And			(TF_Inicio_Vigencia	>= @FechaActivacion
			And			TF_Fin_Vigencia		<= @FechaDesactivacion)
			Order By	TC_Descripcion;
	End
			
 End
GO
