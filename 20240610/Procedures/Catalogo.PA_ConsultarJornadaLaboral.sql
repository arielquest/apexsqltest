SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:			     <1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<30/09/2015>
-- Descripción :			<Permite Consultar Jornada Laboral> 
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarJornadaLaboral]
	@Codigo smallint=Null,
	@Descripcion Varchar(100)=Null,
	@FechaActivacion Datetime2=Null,
	@FechaDesactivacion Datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin
			Select		TN_CodJornadaLaboral	As	Codigo,				TC_Descripcion	As	Descripcion, TF_HoraInicio as HoraInicio,	TF_HoraFin as HoraFin,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.JornadaLaboral With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND         TN_CodJornadaLaboral = COALESCE(@Codigo, TN_CodJornadaLaboral)
			Order By	TC_Descripcion;
	End	 	
	--Activos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodJornadaLaboral	As	Codigo,				TC_Descripcion	As	Descripcion, TF_HoraInicio as HoraInicio,	TF_HoraFin as HoraFin,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.JornadaLaboral With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			AND         TN_CodJornadaLaboral = COALESCE(@Codigo, TN_CodJornadaLaboral)
			Order By	TC_Descripcion;
	End
	--Inactivos
	Else  If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null	
		Begin
			Select		TN_CodJornadaLaboral	As	Codigo,				TC_Descripcion	As	Descripcion, TF_HoraInicio as HoraInicio,	TF_HoraFin as HoraFin,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.JornadaLaboral With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			AND         TN_CodJornadaLaboral = COALESCE(@Codigo, TN_CodJornadaLaboral)
			Order By	TC_Descripcion;
	End
	--Inactivos por fecha
	Else  If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null	
	Begin
			Select		TN_CodJornadaLaboral	As	Codigo,				TC_Descripcion	As	Descripcion, TF_HoraInicio as HoraInicio,	TF_HoraFin as HoraFin,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.JornadaLaboral With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > @FechaActivacion And TF_Fin_Vigencia  < @FechaDesactivacion)
			AND         TN_CodJornadaLaboral = COALESCE(@Codigo, TN_CodJornadaLaboral)
			Order By	TC_Descripcion;
	End	
 End




GO
