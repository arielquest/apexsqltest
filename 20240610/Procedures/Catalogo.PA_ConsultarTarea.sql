SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:					<Pablo Alvarez>
-- Fecha de creación:				<10/09/2015>
-- Descripción :				<Permite Consultar los Tareaes de la tabla Catalogo.Tarea> 

-- Modificado : Roger Lara
-- Fecha: 22/10/2015
-- Descripcion: Se incluyo parametro fecha de activacion
-- Modificado : Pablo Alvarez
-- Fecha: 15/12/2015
-- Descripcion: Se cambio la llave a int secuence
--
-- Modificado :         <08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificado : 	<02/12/2016> <Johan Acosta> <Descripcion: Se cambio nombre de TC a TN >
-- Modificado : 	<08/03/2017> <Roger Lara >  <Se agrego TC_Descripcion like @ExpresionLike  en los where para que filtrara por descripcion>
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<4/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTarea]
	@CodTarea smallint	   	      = Null,
	@Descripcion Varchar(255)     = Null,
	@FechaDesactivacion Datetime2 = Null,
	@FechaActivacion Datetime2    = Null
 As
 Begin
 	
  
    DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodTarea	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Tarea With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND			TN_CodTarea=COALESCE(@CodTarea,TN_CodTarea)
			Order By	TC_Descripcion;
	End	 
	
	--Activos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodTarea	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Tarea With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			AND			TN_CodTarea=COALESCE(@CodTarea,TN_CodTarea)
			Order By	TC_Descripcion;
	End
	--Inactivos
	Else  If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null	
		Begin
			Select		TN_CodTarea	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Tarea With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			AND			TN_CodTarea=COALESCE(@CodTarea,TN_CodTarea)
			Order By	TC_Descripcion;
	End
	--Inactivos por fecha
	Else  If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null	
	Begin
			Select		TN_CodTarea	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Tarea With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > @FechaActivacion And TF_Fin_Vigencia  < @FechaDesactivacion)
			AND			TN_CodTarea=COALESCE(@CodTarea,TN_CodTarea)
			Order By	TC_Descripcion;
	End	

			
 End
GO
