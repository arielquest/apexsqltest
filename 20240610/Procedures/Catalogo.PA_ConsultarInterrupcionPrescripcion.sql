SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<26/08/2015>
-- Descripción :			<Permite consultar los actos de interrupción de prescripción.> 

-- Modificado por:			<Olger Gamboa Castillo>
-- Fecha de creación:		<22/10/2015>
-- Descripción :			<Se agrega el filtro por fecha de activación para consultar los activos> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modifiacdo:               <22/08/2017><Diego Navarrete> <Se optimiza la consulta>
-- Modificación:			<29/11/2017> <Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarInterrupcionPrescripcion]
	@CodInterrupcion smallint=Null,
	@Descripcion Varchar(100)=Null,
	@FechaDesactivacion Datetime2(3)= Null,
	@FechaActivacion datetime2(3)= null
 As
 Begin
 	
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(200)
	Set		@ExpresionLike	= iif(@Descripcion Is Not Null,'%' +  @Descripcion + '%','%')
	
	--Activos e inactivos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
				
			Select		IP.TN_CodInterrupcion	As	Codigo,				IP.TC_Descripcion	As	Descripcion,
						IP.TF_Inicio_Vigencia	As	FechaActivacion,	IP.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.InterrupcionPrescripcion IP With(Nolock)
			Where		dbo.FN_RemoverTildes(IP.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,IP.TC_Descripcion))
			And			IP.TN_CodInterrupcion	=	COALESCE(@CodInterrupcion,IP.TN_CodInterrupcion)
			Order By	IP.TC_Descripcion;
	End
		
	--Activos 
	Else If @FechaActivacion Is not Null And @FechaDesactivacion Is Null
	Begin
			Select		IP.TN_CodInterrupcion	As	Codigo,				IP.TC_Descripcion	As	Descripcion,
						IP.TF_Inicio_Vigencia	As	FechaActivacion,	IP.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.InterrupcionPrescripcion IP With(Nolock)
			Where		dbo.FN_RemoverTildes(IP.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,IP.TC_Descripcion))
			And			IP.TN_CodInterrupcion	=	COALESCE(@CodInterrupcion,IP.TN_CodInterrupcion)
			And			IP.TF_Inicio_Vigencia	<	GETDATE ()
			And			(IP.TF_Fin_Vigencia		Is	Null 
			OR			IP.TF_Fin_Vigencia		>=	GETDATE ())
			Order By	IP.TC_Descripcion;
	End

	--Inactivos
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null
	Begin
		Select		IP.TN_CodInterrupcion	As	Codigo,				IP.TC_Descripcion	As	Descripcion,
						IP.TF_Inicio_Vigencia	As	FechaActivacion,	IP.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.InterrupcionPrescripcion IP With(Nolock)
			Where		dbo.FN_RemoverTildes(IP.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,IP.TC_Descripcion))
			And			IP.TN_CodInterrupcion	=	COALESCE(@CodInterrupcion,IP.TN_CodInterrupcion)
			And			(IP.TF_Inicio_Vigencia	>	GETDATE () 
			Or			IP.TF_Fin_Vigencia		<	GETDATE ())
			Order By	IP.TC_Descripcion;
	End

	
	--Por rango
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
	Begin
		Select		IP.TN_CodInterrupcion		As	Codigo,				IP.TC_Descripcion	As	Descripcion,
					IP.TF_Inicio_Vigencia		As	FechaActivacion,	IP.TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.InterrupcionPrescripcion IP With(Nolock)
		Where		dbo.FN_RemoverTildes(IP.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,IP.TC_Descripcion))
		And			(IP.TF_Fin_Vigencia		<=	@FechaDesactivacion 
		and			IP.TF_Inicio_Vigencia	>=	@FechaActivacion) 
		Order By	IP.TC_Descripcion;
	End

 End
GO
