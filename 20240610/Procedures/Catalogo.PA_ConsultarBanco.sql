SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<14/11/2018>
-- Descripción :			<Permite consultar bancos> 
-- =================================================================================================================================================
-- Modificado por:			<Daniel Ruiz Hernández>
-- Fecha:					<10/03/2020>
-- Descripción:				<Se modifica la variable @ExpresionLike para que admita 255 caracteres de busqueda mas los signos % del like.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarBanco]
	@Codigo				char(4)			=	Null,
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
			Select		TC_CodigoBanco      	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Banco		With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TC_CodigoBanco		=  Coalesce(@Codigo, TC_CodigoBanco) 
			Order By	TC_Descripcion;
	End
	 
	--Activos
	Else If  @FechaActivacion Is Not Null And  @FechaDesactivacion  Is Null 
	Begin
			Select		TC_CodigoBanco	    As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Banco With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TC_CodigoBanco		=	Coalesce(@Codigo, TC_CodigoBanco)
			And			TF_Inicio_Vigencia		<=	GETDATE ()
			And			(TF_Fin_Vigencia		Is	Null OR TF_Fin_Vigencia  >= GETDATE ()) 
			Order By	TC_Descripcion;
	End

	--Inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion  Is Not Null
	Begin
			Select		TC_CodigoBanco	    As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Banco With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TC_CodigoBanco		=	Coalesce(@Codigo, TC_CodigoBanco)
			And			(TF_Inicio_Vigencia		>	GETDATE () 
			Or			TF_Fin_Vigencia			<	GETDATE ())
			Order By	TC_Descripcion;
	End
	
	--Por rango de fechas
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion  Is Not Null		
	Begin
			Select		TC_CodigoBanco		As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia		As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Banco With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TC_CodigoBanco		=	Coalesce(@Codigo, TC_CodigoBanco)
			And			(TF_Inicio_Vigencia		>=	@FechaActivacion
			And			TF_Fin_Vigencia			<=	@FechaDesactivacion )
			Order By	TC_Descripcion;
	End	
			
 End
GO
