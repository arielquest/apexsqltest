SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<01/10/2015>
-- Descripción :			<Permite Consultar los estados  de diligencia de la tabla Catalogo.TipoDiligencia> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<22/10/2015>
-- Descripción :			<Incluir la consulta por fecha de activación.> 
--
-- Modificado por:			<14/12/2015> <GerardoLopez> 	<Se cambia tipo dato CodEstadoDiligencia a smallint>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificado:              <23/08/2017> <Diego Navarrete> <se optimiza la consulta>
-- Modificación:			<29/11/2017> <Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEstadoDiligencia]
	@CodEstadoDiligencia  smallint	= Null,
	@Descripcion Varchar(100)		= Null, 
	@FechaActivacion datetime2(3)	= Null,
	@FechaDesactivacion Datetime2	= Null
 As
 Begin
 	
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(200)
	Set		@ExpresionLike	=	iif(@Descripcion Is Not Null,'%' +  @Descripcion + '%','%')
		
	--Activos e inactivos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin				
		Select		ED.TN_CodEstadoDiligencia	As	Codigo,		 ED.TC_Descripcion		As	Descripcion,
					ED.TF_Inicio_Vigencia		As	FechaActivacion, ED.TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.EstadoDiligencia ED With(Nolock)
		Where		dbo.FN_RemoverTildes(ED.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
		And			ED.TN_CodEstadoDiligencia	=	COALESCE(@CodEstadoDiligencia,TN_CodEstadoDiligencia)
		Order By	ED.TC_Descripcion;
	End

	--Activos 
	Else If @FechaActivacion Is not Null And @FechaDesactivacion Is Null
	Begin
		Select		ED.TN_CodEstadoDiligencia	As	Codigo,		 ED.TC_Descripcion		As	Descripcion,
					ED.TF_Inicio_Vigencia		As	FechaActivacion, ED.TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.EstadoDiligencia ED With(Nolock)
		Where		dbo.FN_RemoverTildes(ED.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
		And			ED.TN_CodEstadoDiligencia	=	COALESCE(@CodEstadoDiligencia,TN_CodEstadoDiligencia)
		And			ED.TF_Inicio_Vigencia		<	GETDATE ()
		And			(ED.TF_Fin_Vigencia			Is	Null 
		OR			ED.TF_Fin_Vigencia			>=	GETDATE ())
		Order By	ED.TC_Descripcion;
	End
	
	--Inactivos
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null
	Begin
		Select		ED.TN_CodEstadoDiligencia	As	Codigo,		 ED.TC_Descripcion		As	Descripcion,
					ED.TF_Inicio_Vigencia		As	FechaActivacion, ED.TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.EstadoDiligencia ED With(Nolock)
		Where		dbo.FN_RemoverTildes(ED.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
		And			ED.TN_CodEstadoDiligencia	=	COALESCE(@CodEstadoDiligencia,TN_CodEstadoDiligencia)
		And			(ED.TF_Inicio_Vigencia			>	GETDATE () 
		Or			ED.TF_Fin_Vigencia				<	GETDATE ())
		Order By	ED.TC_Descripcion;
	End

	--Por rango
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
	Begin
		Select		ED.TN_CodEstadoDiligencia	As	Codigo,		 ED.TC_Descripcion		As	Descripcion,
					ED.TF_Inicio_Vigencia		As	FechaActivacion, ED.TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.EstadoDiligencia ED With(Nolock)
		Where		dbo.FN_RemoverTildes(ED.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
		And			ED.TN_CodEstadoDiligencia	=	COALESCE(@CodEstadoDiligencia,TN_CodEstadoDiligencia)
		And			(ED.TF_Fin_Vigencia	<=		@FechaDesactivacion 
		and			ED.TF_Inicio_Vigencia	>=		@FechaActivacion) 
		Order By	ED.TC_Descripcion;
	End
 End



GO
