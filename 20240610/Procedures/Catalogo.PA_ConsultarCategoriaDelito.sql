SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<20/08/2015>
-- Descripción :			<Permite Consultar las Materias de la tabla Catalogo.CategoriaDelito> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<10/10/2016> <Diego Navarrete> <Se modifican las consulta y se agrega el codigo de categoria a delito a todas las
--																las consultas en caso de ser null sera ingnorado, se elimino la consulta por llave>
-- Modificación:			<29/11/2017><Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarCategoriaDelito]
@CodCategoriaDelito int=Null,
@Descripcion varchar(150)=Null,			
@FechaActivacion datetime2= Null,
@FechaDesactivacion datetime2= Null

As
Begin
		
	   DECLARE @ExpresionLike varchar(200)
	   Set	   @ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%',null)

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodCategoriaDelito	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.CategoriaDelito
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion)) and TN_CodCategoriaDelito = COALESCE(@CodCategoriaDelito,TN_CodCategoriaDelito)
			Order By	TC_Descripcion;
	End	
	--Activos 
	Else If @FechaActivacion Is not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodCategoriaDelito	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.CategoriaDelito
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion)) and TN_CodCategoriaDelito = COALESCE(@CodCategoriaDelito,TN_CodCategoriaDelito)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			Order By	TC_Descripcion;
	End	 
	--Inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is not Null
	Begin
			Select		TN_CodCategoriaDelito	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.CategoriaDelito
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion)) and TN_CodCategoriaDelito = COALESCE(@CodCategoriaDelito,TN_CodCategoriaDelito)
	        And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			Order By	TC_Descripcion;
	End	
	--Por Rango de Fechas
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is not Null
	Begin
			Select		TN_CodCategoriaDelito	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.CategoriaDelito
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion)) and TN_CodCategoriaDelito= COALESCE(@CodCategoriaDelito,TN_CodCategoriaDelito)
		    And			(TF_Fin_Vigencia  <= @FechaDesactivacion and TF_Inicio_Vigencia >=@FechaActivacion)
			Order By	TC_Descripcion;
	End	 
End

GO
