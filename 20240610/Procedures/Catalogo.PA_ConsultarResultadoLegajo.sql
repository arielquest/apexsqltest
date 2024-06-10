SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<10/09/2019>
-- Descripción :			<Permite consultar los resultados de legajo> 
-- =================================================================================================================================================
-- Modificación:            <2019/09/25> <Jose Gabriel Cordero Soto> 
--                          <Por observacion recibida en BUG 0020 - HU 26 Filtrar Resultado Legajo - Ampliacion en tamaño de variable temporal @ExpresionLike a 257  
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarResultadoLegajo]
	@Codigo				smallint		=	NULL,
	@Descripcion		varchar(255)	=	NULL,
	@FechaActivacion	datetime2		=	NULL,
	@FechaDesactivacion datetime2		=	NULL
 As
 Begin  
   DECLARE @ExpresionLike varchar(257)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Activos e inactivos
	If  @FechaActivacion Is Null And  @FechaDesactivacion  Is Null 
	Begin
			Select		A.TN_CodResultadoLegajo				As	Codigo,
						A.TC_Descripcion					As	Descripcion,
						A.TF_FechaInicioVigencia			As	FechaActivacion,
						A.TF_FechaFinVigencia				As	FechaDesactivacion
			From		Catalogo.ResultadoLegajo			A	With(Nolock)
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			A.TN_CodResultadoLegajo			=	Coalesce(@Codigo, A.TN_CodResultadoLegajo)
			Order By	A.TC_Descripcion;
	End
	 
	--Activos
	Else If  @FechaActivacion Is Not Null And  @FechaDesactivacion  Is Null 
	Begin
			Select		A.TN_CodResultadoLegajo			As	Codigo,
						A.TC_Descripcion					As	Descripcion,
						A.TF_FechaInicioVigencia				As	FechaActivacion,
						A.TF_FechaFinVigencia					As	FechaDesactivacion
			From		Catalogo.ResultadoLegajo			A	With(Nolock)
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			A.TN_CodResultadoLegajo			=	Coalesce(@Codigo, A.TN_CodResultadoLegajo)
			And			A.TF_FechaInicioVigencia				<=	GETDATE ()
			And			(A.TF_FechaFinVigencia	Is	Null OR A.TF_FechaFinVigencia  >= GETDATE ()) 
			Order By	A.TC_Descripcion;
	End

	--Inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion  Is Not Null
	Begin
			Select		A.TN_CodResultadoLegajo			As	Codigo,
						A.TC_Descripcion					As	Descripcion,
						A.TF_FechaInicioVigencia				As	FechaActivacion,
						A.TF_FechaFinVigencia					As	FechaDesactivacion
			From		Catalogo.ResultadoLegajo			A	With(Nolock)
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			A.TN_CodResultadoLegajo			=	Coalesce(@Codigo, A.TN_CodResultadoLegajo)
			And			(A.TF_FechaInicioVigencia				>	GETDATE () 
			Or			A.TF_FechaFinVigencia					<	GETDATE ())
			Order By	A.TC_Descripcion;
	End
	
	--Por rango de fechas
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion  Is Not Null		
	Begin
			Select		A.TN_CodResultadoLegajo			As	Codigo,
						A.TC_Descripcion					As	Descripcion,
						A.TF_FechaInicioVigencia				As	FechaActivacion,
						A.TF_FechaFinVigencia					As	FechaDesactivacion
			From		Catalogo.ResultadoLegajo			A	With(Nolock)
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			A.TN_CodResultadoLegajo			=	Coalesce(@Codigo, A.TN_CodResultadoLegajo)
			And			(A.TF_FechaInicioVigencia				>=	@FechaActivacion
			And			A.TF_FechaFinVigencia					<=	@FechaDesactivacion )
			Order By	A.TC_Descripcion;
	End				
 End
GO
