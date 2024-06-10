SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<18/08/2015>
-- Descripción :			<Permite Consultar profesiones> 

-- Modificado : Roger Lara  22/10/2015 Se incluyo parametro fecha de activacion
-- Modificado por:			<14/12/2015> <GerardoLopez> 	<Se cambia tipo dato @Codigo a smallint>
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificado por:          <Ailyn López> <13/12/2017> <Se elimina la consulta por descripción, ya que se agrega como condición en todas 
--						    las demás consultas y se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarProfesion]
	@Codigo  smallint=Null,
	@Descripcion Varchar(255)=Null,
	@FechaVencimiento Datetime2= Null,
	@FechaActivacion Datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(257)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%',null)

	--Todos
	If  @FechaVencimiento Is Null And @FechaActivacion Is Null  
	Begin
			Select		TN_CodProfesion	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Profesion With(Nolock)
			WHERE		TN_CodProfesion=COALESCE(@Codigo,TN_CodProfesion)
			AND			dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
			Order By	TC_Descripcion;
	End

	
		--Por activos
	Else If  @FechaActivacion Is Not Null and @FechaVencimiento Is Null
	Begin
			Select		TN_CodProfesion	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Profesion With(Nolock) 
			Where		TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
		    AND			TN_CodProfesion=COALESCE(@Codigo,TN_CodProfesion)
			AND		    dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion)) 
			Order By	TC_Descripcion;
	End
	
	Else		
		Begin --Por inactivos
			 if  @FechaActivacion Is Null and @FechaVencimiento Is not Null
			 Begin 
					Select		TN_CodProfesion	As	Codigo,				TC_Descripcion	As	Descripcion,		
								TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
					From		Catalogo.Profesion With(Nolock) 
					Where		(TF_Inicio_Vigencia  > GETDATE ()
								Or		TF_Fin_Vigencia  < GETDATE ())
					AND			TN_CodProfesion=COALESCE(@Codigo,TN_CodProfesion)
					AND			dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
					Order By	TC_Descripcion;
			end 
			Else
			Begin	--Si las dos fechas no son nulas traigase los datos por rango de fechas de los inactivos
					Select		TN_CodProfesion	As	Codigo,				TC_Descripcion	As	Descripcion,		
								TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
					From		Catalogo.Profesion With(Nolock) 
					Where		TF_Fin_Vigencia  <= @FechaVencimiento and TF_Inicio_Vigencia >=@FechaActivacion
					AND			TN_CodProfesion=COALESCE(@Codigo,TN_CodProfesion)
					AND         dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
					Order By	TC_Descripcion;
			end
	End
 End





GO
