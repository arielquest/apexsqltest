SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<18/08/2015>
-- Descripción :			<Permite Consultar los registros de resolucion de la tabla Catalogo.Pais> 

-- Modificado por:			<Olger Gamboa Castillo> <23/10/2015> <Se agrega el filtro por fecha de activación para consultar los activos> 
-- Modificado por:			<16/12/2015> <Johan Acosta> 	<Se cambia tipo dato TN_CodResultadoResolucion a smallint>		
-- Modificado:				<Gerardo Lopez  , 06/05/2016, Agregar campo TC_CodTipoOficina>
-- Modificado:				<Johan Acosta, 08/06/2016, Se quita el campo tipo oficina >
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificado:	            <05/12/2016> <Pablo Alvarez><Se corrige TN_CodResultadoesolucion por estandar >
--	Modificado:				<22/08/2016> <Diego Navarrete><Se optimizan las busquedas>
-- Modificación:			<29/11/2017> <Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarResultadoResolucion]
	@CodResultadoResolucion smallint	= Null,
	@Descripcion Varchar(150)			= Null,
	@FechaDesactivacion Datetime2		= Null,
	@FechaActivacion datetime2(3)		= null
As
 
 Begin
 	
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(200)
	Set		@ExpresionLike	= iif(@Descripcion Is Not Null,'%' +  @Descripcion + '%','%')
		
	--Activos e inactivos
	If	@FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
				
			Select		R.TN_CodResultadoResolucion		As	Codigo,				R.TC_Descripcion	As	Descripcion,
						R.TF_Inicio_Vigencia			As	FechaActivacion,	R.TF_Fin_Vigencia	As	FechaDesactivacion

			From		Catalogo.ResultadoResolucion R WITH (Nolock)
			Where		dbo.FN_RemoverTildes(R.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
			And			R.TN_CodResultadoResolucion	=	COALESCE(@CodResultadoResolucion,TN_CodResultadoResolucion)
			Order By	TC_Descripcion;
	End
	--Activos 
	Else If @FechaActivacion Is not Null And @FechaDesactivacion Is Null
	Begin
			Select		R.TN_CodResultadoResolucion		As	Codigo,				R.TC_Descripcion	As	Descripcion,
						R.TF_Inicio_Vigencia			As	FechaActivacion,	R.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.ResultadoResolucion R WITH (Nolock) 
			Where		dbo.FN_RemoverTildes(R.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
			And			R.TN_CodResultadoResolucion	=		COALESCE(@CodResultadoResolucion,TN_CodResultadoResolucion)
			And			R.TF_Inicio_Vigencia		<		GETDATE ()
			And		   (R.TF_Fin_Vigencia			Is		Null 
			OR			R.TF_Fin_Vigencia			>=		GETDATE ())
			Order By	R.TC_Descripcion;
	End
   --Inactivos
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null
	Begin
		Select		R.TN_CodResultadoResolucion		As	Codigo,				R.TC_Descripcion	As	Descripcion,
					R.TF_Inicio_Vigencia			As	FechaActivacion,	R.TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.ResultadoResolucion R WITH (Nolock) 
		Where		dbo.FN_RemoverTildes(R.TC_Descripcion) like	dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
		And			R.TN_CodResultadoResolucion	=	COALESCE(@CodResultadoResolucion,TN_CodResultadoResolucion)
	    And		   (R.TF_Inicio_Vigencia		>	GETDATE () 
		Or			R.TF_Fin_Vigencia			<	GETDATE ())
		Order By	R.TC_Descripcion;
	End	
	--Por rango
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
	Begin
		Select		R.TN_CodResultadoResolucion		As	Codigo,				R.TC_Descripcion	As	Descripcion,
					R.TF_Inicio_Vigencia			As	FechaActivacion,	R.TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.ResultadoResolucion R WITH (Nolock) 
		Where		dbo.FN_RemoverTildes(R.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
		And			R.TN_CodResultadoResolucion	=	COALESCE(@CodResultadoResolucion,TN_CodResultadoResolucion)
		And			(R.TF_Inicio_Vigencia		<=	@FechaDesactivacion 
		and			TF_Inicio_Vigencia			>=	@FechaActivacion) 
		Order By	R.TC_Descripcion;
	End	
 End
GO
