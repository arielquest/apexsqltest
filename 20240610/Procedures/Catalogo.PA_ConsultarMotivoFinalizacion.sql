SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Aída Elena Siles Rojas>
-- Fecha de creación:		<19/02/2019>
-- Descripción :			<Permite consultar los motivos de finalización de la defensa> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarMotivoFinalizacion]
	@Codigo				smallint		=	Null,
	@Descripcion		varchar(150)	=	Null,
	@FechaActivacion	datetime2		=	Null,
	@FechaDesactivacion datetime2		=	Null
 As
 Begin  
   DECLARE @ExpresionLike varchar(152)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Activos e inactivos
	If  @FechaActivacion Is Null And  @FechaDesactivacion  Is Null 
	Begin
			Select		A.TN_CodMotivoFinalizacion			As	Codigo,
						A.TC_Descripcion					As	Descripcion,
						A.TF_Inicio_Vigencia				As	FechaActivacion,
						A.TF_Fin_Vigencia					As	FechaDesactivacion
			From		Catalogo.MotivoFinalizacion			A	With(Nolock)
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			A.TN_CodMotivoFinalizacion			=	Coalesce(@Codigo, A.TN_CodMotivoFinalizacion)
			Order By	A.TC_Descripcion;
	End
	 
	--Activos
	Else If  @FechaActivacion Is Not Null And  @FechaDesactivacion  Is Null 
	Begin
			Select		A.TN_CodMotivoFinalizacion			As	Codigo,
						A.TC_Descripcion					As	Descripcion,
						A.TF_Inicio_Vigencia				As	FechaActivacion,
						A.TF_Fin_Vigencia					As	FechaDesactivacion
			From		Catalogo.MotivoFinalizacion			A	With(Nolock)
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			A.TN_CodMotivoFinalizacion			=	Coalesce(@Codigo, A.TN_CodMotivoFinalizacion)
			And			A.TF_Inicio_Vigencia				<=	GETDATE ()
			And			(A.TF_Fin_Vigencia		Is	Null OR A.TF_Fin_Vigencia  >= GETDATE ()) 
			Order By	A.TC_Descripcion;
	End

	--Inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion  Is Not Null
	Begin
			Select		A.TN_CodMotivoFinalizacion			As	Codigo,
						A.TC_Descripcion					As	Descripcion,
						A.TF_Inicio_Vigencia				As	FechaActivacion,
						A.TF_Fin_Vigencia					As	FechaDesactivacion
			From		Catalogo.MotivoFinalizacion			A	With(Nolock)
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			A.TN_CodMotivoFinalizacion			=	Coalesce(@Codigo, A.TN_CodMotivoFinalizacion)
			And			(A.TF_Inicio_Vigencia				>	GETDATE () 
			Or			A.TF_Fin_Vigencia					<	GETDATE ())
			Order By	A.TC_Descripcion;
	End
	
	--Por rango de fechas
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion  Is Not Null		
	Begin
			Select		A.TN_CodMotivoFinalizacion			As	Codigo,
						A.TC_Descripcion					As	Descripcion,
						A.TF_Inicio_Vigencia				As	FechaActivacion,
						A.TF_Fin_Vigencia					As	FechaDesactivacion
			From		Catalogo.MotivoFinalizacion			A	With(Nolock)
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			A.TN_CodMotivoFinalizacion			=	Coalesce(@Codigo, A.TN_CodMotivoFinalizacion)
			And			(A.TF_Inicio_Vigencia				>=	@FechaActivacion
			And			A.TF_Fin_Vigencia					<=	@FechaDesactivacion )
			Order By	A.TC_Descripcion;
	End				
 End
GO
