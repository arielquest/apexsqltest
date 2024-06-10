SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<20/08/2015>
-- Descripción :			<Permite Consultar el Sexo en la tabla Catalogo.Sexo> 
-- Modificado por:			<Pablo Alvarez>
-- Fecha de creación:		<23/10/2015>
-- Descripción :			<Se incluyen filtros por fecha de activación.> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarSexo]
	@Codigo Varchar(2)=Null,
	@Descripcion Varchar(100)=Null,
	@FechaActivacion datetime2=Null,
	@FechaDesactivacion datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaActivacion Is Null And @FechaDesactivacion Is Null And @Codigo Is Null  
	Begin
			Select		TC_CodSexo      	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Sexo With(Nolock) 	
			Where		TC_Descripcion like @ExpresionLike 
			Order By	TC_Descripcion;
	End
	 
	--Por Llave
	Else If  @Codigo Is Not Null
	Begin
			Select		TC_CodSexo	        As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Sexo With(Nolock) 
			Where		TC_CodSexo		=	@Codigo
			Order By	TC_Descripcion;
	End

	--Por activos y filtro por descripcion
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TC_CodSexo	        As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Sexo With(Nolock) 
			Where		TC_Descripcion like @ExpresionLike 
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			Order By	TC_Descripcion;
	End
	
	--Por inactivos y filtro por descripcion
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
			Select		TC_CodSexo       	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Sexo With(Nolock) 
			Where		TC_Descripcion		like	@ExpresionLike 
	        And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			Order By	TC_Descripcion;
	End
	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else IF @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
		Begin
			Select		TC_CodSexo	        As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Sexo With(Nolock) 
			Where		TC_Descripcion		like	@ExpresionLike 
		    And			(TF_Fin_Vigencia  <= @FechaDesactivacion and TF_Inicio_Vigencia >=@FechaActivacion)
			Order By	TC_Descripcion;
	End
			
 End




GO
