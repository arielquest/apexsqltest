SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<27/08/2015>
-- Descripción :			<Permite Consultar Periodos Antirretovirales> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<22/10/2015>
-- Descripción :			<Incluir filtro por fecha de activación> 
-- Modificado por:			<08/12/2015> <GerardoLopez> 	<Se cambia tipo dato codigo a smallint>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================================================
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<4/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarPeriodoAntirretroviral]
	@Codigo smallint				=null,
	@Descripcion Varchar(150)		=Null, 
	@FechaActivacion datetime2(3)	= Null,
	@FechaVencimiento Datetime2		= Null
 As
 Begin
  
	DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaVencimiento Is Null 
	Begin
		Select		TN_CodPeriodoAntirretro	As	Codigo,				TC_Descripcion	As	Descripcion,		
					TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.PeriodoAntirretroviral With(Nolock) 	
		Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		and			TN_CodPeriodoAntirretro=coalesce(@Codigo,TN_CodPeriodoAntirretro) 
		Order By	TC_Descripcion;
	End

	--Por activos
	Else If @FechaVencimiento Is Null And @FechaActivacion Is Not Null
	Begin
		Select		TN_CodPeriodoAntirretro	As	Codigo,				TC_Descripcion	As	Descripcion,		
					TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.PeriodoAntirretroviral With(Nolock) 
		Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			TF_Inicio_Vigencia		< GETDATE ()
		And			(	TF_Fin_Vigencia		Is Null 
					OR	TF_Fin_Vigencia		>= GETDATE ())
		and			TN_CodPeriodoAntirretro=coalesce(@Codigo,TN_CodPeriodoAntirretro) 
		Order By	TC_Descripcion;
	End
	--Por inactivos
	Else If @FechaVencimiento Is Not Null And @FechaActivacion Is Null		
	Begin
		Select		TN_CodPeriodoAntirretro	As	Codigo,				TC_Descripcion	As	Descripcion,		
					TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.PeriodoAntirretroviral With(Nolock) 
		Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			(	TF_Inicio_Vigencia  > GETDATE ()
					Or	TF_Fin_Vigencia  < GETDATE ())
		and			TN_CodPeriodoAntirretro=coalesce(@Codigo,TN_CodPeriodoAntirretro) 
		Order By	TC_Descripcion;
	End
	Else If @FechaVencimiento Is Not Null And @FechaActivacion Is Not Null
	Begin
		Select		TN_CodPeriodoAntirretro	As	Codigo,				TC_Descripcion	As	Descripcion,		
					TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.PeriodoAntirretroviral With(Nolock) 
		Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			TF_Inicio_Vigencia	>= @FechaActivacion
		And			TF_Fin_Vigencia		<= @FechaVencimiento 
		and			TN_CodPeriodoAntirretro=coalesce(@Codigo,TN_CodPeriodoAntirretro) 
		Order By	TC_Descripcion;
	End
 End





GO
