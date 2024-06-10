SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Mario Camacho Flores>
-- Fecha de creación:		<03/01/2023>
-- Descripción :			<Permite Consultar Instituciones> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_ConsultarInstituciones]
	@CedulaJuridica					Varchar(20)		=NULL,
	@Descripcion					Varchar(255)	=NULL,
	@Siglas							Varchar(10)		=NULL,
	@FechaActivacion				Datetime2(7)	=NULL,
	@FechaDesactivacion				Datetime2(7)	=NULL
 As
 Begin
  
	DECLARE @ExpresionLike varchar(255) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%'),
	@L_CedulaJuridica					Varchar(20)		=	@CedulaJuridica	,
	@L_Descripcion						Varchar(255)	=	@Descripcion,
	@L_Siglas							Varchar(10)		=	@Siglas,
	@L_FechaActivacion					Datetime2(7)	=	@FechaActivacion,
	@L_FechaDesactivacion				Datetime2(7)	=	@FechaDesactivacion

	--Activos e inactivos
	If  @L_FechaActivacion Is Null And  @L_FechaDesactivacion  Is Null 
	Begin
			Select		TU_CodInstitucion			As  Codigo,
						TC_Cedula_Juridica	      	As	CedulaJuridica,				
						TC_Descripcion				As	Descripcion,
						TC_Siglas					As	Siglas,		
						TF_Inicio_Vigencia			As	FechaActivacion,	
						TF_Fin_Vigencia				As	FechaDesactivacion
			From	    Catalogo.Institucion		With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TC_Cedula_Juridica			=  Coalesce(@L_CedulaJuridica	, TC_Cedula_Juridica	) 
			Order By	TC_Descripcion;
	End
	 
	--Activos
	Else If  @L_FechaActivacion Is Not Null And  @L_FechaDesactivacion  Is Null 
	Begin
			Select		TU_CodInstitucion			As  Codigo,
						TC_Cedula_Juridica			As	CedulaJuridica,				
						TC_Descripcion				As	Descripcion,
						TC_Siglas					As	Siglas,
						TF_Inicio_Vigencia			As	FechaActivacion,	
						TF_Fin_Vigencia				As	FechaDesactivacion
			From		Catalogo.Institucion	With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TC_Cedula_Juridica			=	Coalesce(@L_CedulaJuridica	, TC_Cedula_Juridica	)
			And			TF_Inicio_Vigencia			<=	GETDATE ()
			And			(TF_Fin_Vigencia Is	Null OR TF_Fin_Vigencia  >= GETDATE ()) 
			Order By	TC_Descripcion;
	End

	--Inactivos
	Else If  @L_FechaActivacion Is Null And @L_FechaDesactivacion  Is Not Null
	Begin
			Select		TU_CodInstitucion			As  Codigo,
						TC_Cedula_Juridica			As	CedulaJuridica,				
						TC_Descripcion				As	Descripcion,
						TC_Siglas					As	Siglas,
						TF_Inicio_Vigencia			As	FechaActivacion,	
						TF_Fin_Vigencia				As	FechaDesactivacion
			From		Catalogo.Institucion		With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TC_Cedula_Juridica			=	Coalesce(@L_CedulaJuridica, TC_Cedula_Juridica)
			And			(TF_Inicio_Vigencia			>	GETDATE () 
			Or			TF_Fin_Vigencia				<	GETDATE ())
			Order By	TC_Descripcion;
	End
	
	--Por rango de fechas
	Else If  @L_FechaActivacion Is Not Null And @L_FechaDesactivacion  Is Not Null		
	Begin
			Select		TU_CodInstitucion			As  Codigo,
						TC_Cedula_Juridica				As	CedulaJuridica,				
						TC_Descripcion					As	Descripcion,
						TC_Siglas						As	Siglas,
						TF_Inicio_Vigencia				As	FechaActivacion,	
						TF_Fin_Vigencia					As	FechaDesactivacion
			From		Catalogo.Institucion			With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			TC_Cedula_Juridica				=	Coalesce(@L_CedulaJuridica, TC_Cedula_Juridica)
			And			(TF_Inicio_Vigencia				>=	@L_FechaActivacion
			And			TF_Fin_Vigencia					<=	@L_FechaDesactivacion )
			Order By	TC_Descripcion;
	End
			
 End
GO
