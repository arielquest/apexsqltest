SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<01/10/2015>
-- Descripción :			<Permite Consultar Tipos Dictamen>
 
-- Modificado por:			<Olger Gamboa Castillo>
-- Fecha de creación:		<23/10/2015>
-- Descripción :			<Se agrega el filtro por fecha de activación para consultar los activos>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoDictamen]
	@Codigo smallint=Null,
	@Descripcion Varchar(50)=Null,
	@FechaVencimiento Datetime2= Null,
	@FechaActivacion datetime2(3)= null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

		--Si todo es nulo se devuelven todos los registros
	If	@FechaActivacion Is Null And @FechaVencimiento Is Null 
	Begin
			Select		TN_CodTipoDictamen	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoDictamen With(Nolock) 	
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND         TN_CodTipoDictamen=COALESCE(@Codigo,TN_CodTipoDictamen)
			Order By	TC_Descripcion;
	End


	--Por descripcion si hay. Si estan activos o desactivos dependiendo de valor de @FechaDesactivacion
	Else If @FechaVencimiento Is Null And @FechaActivacion Is Not Null
	Begin
			Select		TN_CodTipoDictamen	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoDictamen With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia is null or TF_Fin_Vigencia  >= GETDATE ())
			AND         TN_CodTipoDictamen=COALESCE(@Codigo,TN_CodTipoDictamen)
			Order By	TC_Descripcion;
	End
	Else If @FechaVencimiento Is Not Null And @FechaActivacion Is Null
	Begin
			Select		TN_CodTipoDictamen	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoDictamen With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		     And		(TF_Inicio_Vigencia  > GETDATE ()
			Or			TF_Fin_Vigencia  < GETDATE ())
			AND         TN_CodTipoDictamen=COALESCE(@Codigo,TN_CodTipoDictamen)
			Order By	TC_Descripcion;
	End
	Else If @FechaVencimiento Is Not Null And @FechaActivacion Is Not Null
	begin	
			Select		TN_CodTipoDictamen	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoDictamen With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia	>= @FechaActivacion
			And			TF_Fin_Vigencia		<= @FechaVencimiento 
			AND         TN_CodTipoDictamen=COALESCE(@Codigo,TN_CodTipoDictamen)
			Order By	TC_Descripcion;
	End
			
 End





GO
