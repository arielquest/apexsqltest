SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Gerardo Lopez>
-- Fecha de creación:		<09/11/2015>
-- Descripción :			<Permite Consultar Tipos de telefono> 
--
-- Modificación:			<11/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================================================
-- Modificado por:                <Diego Chavarria>
-- Fecha:					    <4/10/2017>							
-- Modificación:                  <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							 también se elimina el IF Null de Código del select Todos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoTelefono]
 @Codigo smallint=Null,
 @Descripcion Varchar(100)=Null,
 @FechaActivacion Datetime2=Null,
 @FechaDesactivacion Datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodTipoTelefono	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoTelefono With(Nolock) 	
			Where		UPPER(TC_Descripcion) like UPPER(@ExpresionLike) 
			AND			TN_CodTipoTelefono=COALESCE(@Codigo,TN_CodTipoTelefono)
			Order By	TC_Descripcion;
	End	 
	--Activos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodTipoTelefono	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoTelefono With(Nolock) 
			Where		UPPER(TC_Descripcion) like UPPER(@ExpresionLike) 
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			AND			TN_CodTipoTelefono=COALESCE(@Codigo,TN_CodTipoTelefono)
			Order By	TC_Descripcion;
	End
	--Inactivos
	Else  If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null	
		Begin
			Select		TN_CodTipoTelefono	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoTelefono With(Nolock) 
			Where		UPPER(TC_Descripcion) like UPPER(@ExpresionLike) 
			And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			AND			TN_CodTipoTelefono=COALESCE(@Codigo,TN_CodTipoTelefono)
			Order By	TC_Descripcion;
	End
	--Inactivos por fecha
	Else  If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null	
	Begin
			Select		TN_CodTipoTelefono	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoTelefono With(Nolock) 
			Where		UPPER(TC_Descripcion) like UPPER(@ExpresionLike) 
			And			(TF_Inicio_Vigencia  > @FechaActivacion And TF_Fin_Vigencia  < @FechaDesactivacion)
			AND			TN_CodTipoTelefono=COALESCE(@Codigo,TN_CodTipoTelefono)
			Order By	TC_Descripcion;
	End	
 End
GO
