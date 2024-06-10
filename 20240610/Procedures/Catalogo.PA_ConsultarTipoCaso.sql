SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Aída Elena Siles Rojas>
-- Fecha de creación:		<23/01/2019>
-- Descripción :			<Permite consultar tipos de caso de la defensa> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoCaso]
	@Codigo				smallint		=	Null,
	@Descripcion		varchar(255)	=	Null,
	@FechaActivacion	datetime2		=	Null,
	@FechaDesactivacion datetime2		=	Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(257)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Activos e inactivos
	If  @FechaActivacion Is Null And  @FechaDesactivacion  Is Null 
	Begin
			Select		TN_CodTipoCaso      	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoCaso		With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TN_CodTipoCaso			=  Coalesce(@Codigo, TN_CodTipoCaso) 
			Order By	TC_Descripcion;
	End
	 
	--Activos
	Else If  @FechaActivacion Is Not Null And  @FechaDesactivacion  Is Null 
	Begin
			Select		TN_CodTipoCaso		    As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoCaso With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TN_CodTipoCaso			=	Coalesce(@Codigo, TN_CodTipoCaso)
			And			TF_Inicio_Vigencia		<=	GETDATE ()
			And			(TF_Fin_Vigencia		Is	Null OR TF_Fin_Vigencia  >= GETDATE ()) 
			Order By	TC_Descripcion;
	End

	--Inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion  Is Not Null
	Begin
			Select		TN_CodTipoCaso		    As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoCaso With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TN_CodTipoCaso			=	Coalesce(@Codigo, TN_CodTipoCaso)
			And			(TF_Inicio_Vigencia		>	GETDATE () 
			Or			TF_Fin_Vigencia			<	GETDATE ())
			Order By	TC_Descripcion;
	End
	
	--Por rango de fechas
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion  Is Not Null		
	Begin
			Select		TN_CodTipoCaso			As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia		As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoCaso With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TN_CodTipoCaso			=	Coalesce(@Codigo, TN_CodTipoCaso)
			And			(TF_Inicio_Vigencia		>=	@FechaActivacion
			And			TF_Fin_Vigencia			<=	@FechaDesactivacion )
			Order By	TC_Descripcion;
	End	
			
 End
GO
