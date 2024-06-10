SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<31/08/2015>
-- Descripción :			<Permite Consultar diversidad sexual> 
-- Modificado:			    <Pablo Alvarez Espinoza>
-- Fecha Modifica:          <18/12/2015>
-- Descripcion:	            <Se cambia la llave a smallint squence>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<29/11/2017><Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- =================================================================================================================================================

  
CREATE PROCEDURE [Catalogo].[PA_ConsultarDiversidadSexual]
 @CodDiversidadSexual smallint=Null,
 @Descripcion Varchar(255)=Null,
 @FechaVencimiento Datetime2= Null,
 @FechaActivacion Datetime2= Null

 As
 Begin 
  	
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(257)
	Set		@ExpresionLike	=	iif(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')
	
	--Activos e inactivos
	If  @FechaActivacion Is Null And  @FechaVencimiento Is Null
	Begin	
			Select		TN_CodDiversidadSexual     As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.DiversidadSexual
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			TN_CodDiversidadSexual	=  Coalesce(@CodDiversidadSexual, TN_CodDiversidadSexual) 
			Order By	TC_Descripcion;
	End
	
	--Activos
	Else If  @FechaActivacion Is Not Null And  @FechaVencimiento Is Null
	Begin
			Select		TN_CodDiversidadSexual	As	Codigo,			TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.DiversidadSexual
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			TN_CodDiversidadSexual	=  Coalesce(@CodDiversidadSexual, TN_CodDiversidadSexual)
			And			TF_Inicio_Vigencia	<=		GETDATE ()
			And			(TF_Fin_Vigencia		Is	Null OR TF_Fin_Vigencia  >= GETDATE ()) 
			Order By	TC_Descripcion;
	End	 

	--Inactivos
	Else 
	If  @FechaActivacion Is Null And @FechaVencimiento Is Not Null
	Begin
			Select		TN_CodDiversidadSexual		As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.DiversidadSexual
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			TN_CodDiversidadSexual	=  Coalesce(@CodDiversidadSexual, TN_CodDiversidadSexual)
			And			(TF_Inicio_Vigencia >		GETDATE () 
			Or			TF_Fin_Vigencia		<		GETDATE ()) 
			Order By	TC_Descripcion;
	End

	--Por rango de fechas
	Else
	Begin 
		If  @FechaActivacion Is Not Null And @FechaVencimiento Is Not Null
		
			Select		TN_CodDiversidadSexual	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.DiversidadSexual
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			TN_CodDiversidadSexual	=  Coalesce(@CodDiversidadSexual, TN_CodDiversidadSexual)
			And			(TF_Inicio_Vigencia	>= @FechaActivacion
			And			TF_Fin_Vigencia		<= @FechaVencimiento ) 
			Order By	TC_Descripcion;		
		
	end  
 End

GO
