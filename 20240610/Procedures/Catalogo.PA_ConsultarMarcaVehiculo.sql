SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<14/10/2019>
-- Descripción :			<Permite consultar registros del catálogo de Marca Vehículo --> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarMarcaVehiculo]
 @Codigo smallint=Null,
 @Descripcion varchar(100)=Null,
 @Observacion varchar(255)=Null,
 @FechaActivacion Datetime2=Null,
 @FechaDesactivacion Datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodMarcaVehiculo	As	Codigo,				TC_Descripcion	As	Descripcion,
						TC_Observacion	As	Observacion,			TF_Inicio_Vigencia	As	FechaActivacion,	
						TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MarcaVehiculo With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike) 
			AND			TN_CodMarcaVehiculo=COALESCE(@Codigo,TN_CodMarcaVehiculo)
			Order By	TC_Descripcion;
	End	 
	--Activos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodMarcaVehiculo	As	Codigo,				TC_Descripcion	As	Descripcion,
						TC_Observacion	As	Observacion,			TF_Inicio_Vigencia	As	FechaActivacion,	
						TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MarcaVehiculo With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike) 
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			AND			TN_CodMarcaVehiculo=COALESCE(@Codigo,TN_CodMarcaVehiculo)
			Order By	TC_Descripcion;
	End
	--Inactivos
	Else  If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null	
		Begin
			Select		TN_CodMarcaVehiculo	As	Codigo,				TC_Descripcion	As	Descripcion,
						TC_Observacion	As	Observacion,			TF_Inicio_Vigencia	As	FechaActivacion,	
						TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MarcaVehiculo With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike) 
			And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			AND			TN_CodMarcaVehiculo=COALESCE(@Codigo,TN_CodMarcaVehiculo)
			Order By	TC_Descripcion;
	End
	--Inactivos por fecha
	Else  If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null	
	Begin
			Select		TN_CodMarcaVehiculo	As	Codigo,				TC_Descripcion	As	Descripcion,
						TC_Observacion	As	Observacion,			TF_Inicio_Vigencia	As	FechaActivacion,	
						TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MarcaVehiculo With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike) 
			And			(TF_Inicio_Vigencia  > @FechaActivacion And TF_Fin_Vigencia  < @FechaDesactivacion)
			AND			TN_CodMarcaVehiculo=COALESCE(@Codigo,TN_CodMarcaVehiculo)
			Order By	TC_Descripcion;
	End	
 End
GO
