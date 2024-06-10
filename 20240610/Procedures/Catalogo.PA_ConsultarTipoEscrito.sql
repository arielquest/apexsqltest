SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<19/09/2019>
-- Descripción :			<Permite consultar tipo de escrito> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoEscrito]
	@Codigo				int			=	Null,
	@Descripcion		varchar(255)	=	Null,
	@FechaActivacion	datetime2		=	Null,
	@FechaDesactivacion datetime2		=	Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(255)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Activos e inactivos
	If  @FechaActivacion Is Null And  @FechaDesactivacion  Is Null 
	Begin
			Select		TN_CodTipoEscrito      		As	Codigo,				TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From	    Catalogo.TipoEscrito		With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TN_CodTipoEscrito		=  Coalesce(@Codigo, TN_CodTipoEscrito) 
			Order By	TC_Descripcion;
	End
	 
	--Activos
	Else If  @FechaActivacion Is Not Null And  @FechaDesactivacion  Is Null 
	Begin
			Select		TN_CodTipoEscrito				As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoEscrito With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TN_CodTipoEscrito		=	Coalesce(@Codigo, TN_CodTipoEscrito)
			And			TF_Inicio_Vigencia		<=	GETDATE ()
			And			(TF_Fin_Vigencia		Is	Null OR TF_Fin_Vigencia  >= GETDATE ()) 
			Order By	TC_Descripcion;
	End

	--Inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion  Is Not Null
	Begin
			Select		TN_CodTipoEscrito				As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoEscrito With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TN_CodTipoEscrito		=	Coalesce(@Codigo, TN_CodTipoEscrito)
			And			(TF_Inicio_Vigencia		>	GETDATE () 
			Or			TF_Fin_Vigencia			<	GETDATE ())
			Order By	TC_Descripcion;
	End
	
	--Por rango de fechas
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion  Is Not Null		
	Begin
			Select		TN_CodTipoEscrito				As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia		As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoEscrito With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TN_CodTipoEscrito		=	Coalesce(@Codigo, TN_CodTipoEscrito)
			And			(TF_Inicio_Vigencia		>=	@FechaActivacion
			And			TF_Fin_Vigencia			<=	@FechaDesactivacion )
			Order By	TC_Descripcion;
	End	
			
 End
GO
