SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<25/08/2015>
-- Descripción :			<Permite Consultar Escolaridad de la tabla Catalogo.Escolaridad> 
-- Modificacion :			<Gerardo lopez><02/11/2015><Se incluyen filtros por fecha de activación.> 

-- Modificado por:			<Olger Gamboa castillo>
-- Fecha de creación:		<14/12/2015>
-- Descripción :			<se modifica para que el @CodEscolaridad sea smallint> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEscolaridad]
			@CodEscolaridad smallint=Null,
			@Descripcion varchar(200)=Null,		
			@FechaActivacion datetime2=Null,	
			@FechaDesactivacion datetime2= Null
As
Begin
	
	   DECLARE @ExpresionLike varchar(202)
	   Set	   @ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodEscolaridad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Escolaridad With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) and TN_CodEscolaridad = COALESCE(@CodEscolaridad,TN_CodEscolaridad)
			Order By	TC_Descripcion;
	End	
	--Activos 
	Else If @FechaActivacion Is not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodEscolaridad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Escolaridad With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) and TN_CodEscolaridad = COALESCE(@CodEscolaridad,TN_CodEscolaridad)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			Order By	TC_Descripcion;
	End	 
	--Inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is not Null
	Begin
			Select		TN_CodEscolaridad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Escolaridad With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) and TN_CodEscolaridad = COALESCE(@CodEscolaridad,TN_CodEscolaridad)
	        And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			Order By	TC_Descripcion;
	End	
	--Por Rango de Fechas
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is not Null
	Begin
			Select		TN_CodEscolaridad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Escolaridad With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) and TN_CodEscolaridad = COALESCE(@CodEscolaridad,TN_CodEscolaridad)
		    And			(TF_Fin_Vigencia  <= @FechaDesactivacion and TF_Inicio_Vigencia >=@FechaActivacion)
			Order By	TC_Descripcion;
	End	 
End



GO
