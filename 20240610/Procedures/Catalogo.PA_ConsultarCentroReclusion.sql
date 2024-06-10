SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<02/09/2015>
-- Descripción :			<Permite Consultar centros de reclusión.> 

-- Modificado : Roger Lara
-- Fecha: 22/10/2015
-- Descripcion: Se incluyo parametro fecha de activacion
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================

  
CREATE PROCEDURE [Catalogo].[PA_ConsultarCentroReclusion]
 @Codigo tinyint=Null,
 @Descripcion Varchar(255)=Null,
 @FechaVencimiento Datetime2= Null,
 @FechaActivacion Datetime2= Null
 As
 Begin

	   DECLARE @ExpresionLike varchar(257)
	   Set	   @ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaVencimiento Is Null
	Begin
			Select		TN_CodCentroReclusion	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.CentroReclusion With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) and TN_CodCentroReclusion = COALESCE(@Codigo,TN_CodCentroReclusion)
			Order By	TC_Descripcion;
	End	
	--Activos 
	Else If @FechaActivacion Is not Null And @FechaVencimiento Is Null
	Begin
			Select		TN_CodCentroReclusion	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.CentroReclusion With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) and TN_CodCentroReclusion = COALESCE(@Codigo,TN_CodCentroReclusion)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			Order By	TC_Descripcion;
	End	 
	--Inactivos
	Else If @FechaActivacion Is Null And @FechaVencimiento Is not Null
	Begin
			Select		TN_CodCentroReclusion	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.CentroReclusion With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) and TN_CodCentroReclusion = COALESCE(@Codigo,TN_CodCentroReclusion)
	        And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			Order By	TC_Descripcion;
	End	
	--Por Rango de Fechas
	Else If @FechaActivacion Is Null And @FechaVencimiento Is not Null
	Begin
			Select		TN_CodCentroReclusion	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.CentroReclusion With(Nolock) 		
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) and TN_CodCentroReclusion = COALESCE(@Codigo,TN_CodCentroReclusion)
		    And			(TF_Fin_Vigencia  <= @FechaVencimiento and TF_Inicio_Vigencia >=@FechaActivacion)
			Order By	TC_Descripcion;
	End	 			
 End





GO
