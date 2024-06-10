SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<17/08/2015>
-- Descripción :			<Permite Consultar tipos de viabilidad> 
--
-- Modificación:			<11/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodTipoViabilidad a TN_CodTipoViabilidad de acuerdo al tipo de dato.>
--
-- Modificación:			<2017/05/26><Andrés Díaz><Se cambia el tipo del parámetro código de int a smallint.>
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoViabilidad]
	@Codigo					Smallint=Null,
	@Descripcion			Varchar(255)=Null,
	@FechaActivacion		Datetime2= Null,
	@FechaDesactivacion		Datetime2= Null
 As
 Begin
 	
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(257)
	Set		@ExpresionLike	=	iif(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')
	
	--Si todo es nulo se devuelven todos los registros
	If	@FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin	
			Select		TN_CodTipoViabilidad     As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoViabilidad
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodTipoViabilidad=coalesce(@Codigo,TN_CodTipoViabilidad)
			Order By	TC_Descripcion;
	End

	--Activos 
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodTipoViabilidad		As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoViabilidad
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Fin_Vigencia Is Null Or TF_Fin_Vigencia  >= GETDATE ())	
			And			TN_CodTipoViabilidad=coalesce(@Codigo,TN_CodTipoViabilidad)
			Order By	TC_Descripcion;
	End
	--Inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null
			Select		TN_CodTipoViabilidad	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoViabilidad
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Fin_Vigencia Is Not Null And TF_Fin_Vigencia  < GETDATE ())
			And			TN_CodTipoViabilidad=coalesce(@Codigo,TN_CodTipoViabilidad)	
			Order By	TC_Descripcion;

	--Rango de Fechas para los inctivos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
		Begin
			Select		TN_CodTipoViabilidad	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoViabilidad			
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) 
			And			(TF_Inicio_Vigencia >=@FechaActivacion And TF_Fin_Vigencia  <= @FechaDesactivacion)
			And			TN_CodTipoViabilidad=coalesce(@Codigo,TN_CodTipoViabilidad)
			Order By	TC_Descripcion;
		end				
 End
GO
