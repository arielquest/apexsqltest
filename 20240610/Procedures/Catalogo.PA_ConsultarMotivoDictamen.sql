SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<02/10/2015>
-- Descripción :			<Permite Consultar Motivos Dictamen> 

-- Modificado : Roger Lara
-- Fecha: 22/10/2015
-- Descripcion: Se incluyo parametro fecha de activacion
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<02/12/2016> <Pablo Alvarez> <Se modifican TN_CodMotivoDictamen por estandar.>
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<14/12/2017> <Ailyn López> <Se elimina la consulta por descripción, ya que se agrega como condición en todas 
--						    las demás consultas y se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarMotivoDictamen]
	@Codigo smallint=Null,
	@Descripcion Varchar(150)=Null,
	@FechaVencimiento Datetime2= Null,
	@FechaActivacion Datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If  @FechaVencimiento Is Null And @FechaActivacion Is Null
	Begin
			Select		TN_CodMotivoDictamen	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MotivoDictamen With(Nolock)
			WHERE	    TN_CodMotivoDictamen=COALESCE(@Codigo,TN_CodMotivoDictamen)
			AND			dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			Order By	TC_Descripcion;
	End

		--Por activos
	Else If  @FechaActivacion Is Not Null and @FechaVencimiento Is Null
	Begin
			Select		TN_CodMotivoDictamen	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MotivoDictamen With(Nolock) 
			Where		TF_Inicio_Vigencia  < GETDATE ()
			AND			dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			AND			TN_CodMotivoDictamen=COALESCE(@Codigo,TN_CodMotivoDictamen)
			Order By	TC_Descripcion;
	End
	Else		
		Begin--Por inactivos
			if  @FechaActivacion Is Null and @FechaVencimiento Is not Null
			begin
					Select		TN_CodMotivoDictamen	As	Codigo,				TC_Descripcion	As	Descripcion,		
								TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
					From		Catalogo.MotivoDictamen With(Nolock) 
					Where		(TF_Inicio_Vigencia  > GETDATE ()
					Or			TF_Fin_Vigencia  < GETDATE ())
					AND			TN_CodMotivoDictamen=COALESCE(@Codigo,TN_CodMotivoDictamen)
					AND			dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
					Order By	TC_Descripcion;
			end
			else 
			Begin
					--Si las dos fechas no son nulas traigase los datos por rango de fechas de los inactivos
					Select		TN_CodMotivoDictamen	As	Codigo,				TC_Descripcion	As	Descripcion,		
								TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
					From		Catalogo.MotivoDictamen With(Nolock) 
					Where		TF_Fin_Vigencia  <= @FechaVencimiento and TF_Inicio_Vigencia >=@FechaActivacion
					AND			TN_CodMotivoDictamen=COALESCE(@Codigo,TN_CodMotivoDictamen)
					AND			dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
					Order By	TC_Descripcion;
			end
		end
	End
 
 




GO
