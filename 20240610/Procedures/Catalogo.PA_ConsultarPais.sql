SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery15.sql|7|0|C:\Users\jaguilarn\AppData\Local\Temp\~vs4F54.sql
-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<17/08/2015>
-- Descripción :			<Permite Consultar los paises de la tabla Catalogo.Pais> 

-- Modificado por:			<Pablo Alvarez>  <23/10/2015> <Se incluyen filtros por fecha de activación.> 
-- Modificacion             <Gerardo Lopez R><16/11/2015> <Agregar campo cod area>
-- Modificación:			<21/01/2016> <Donald Vargas> <Se elimina la condición @FechaActivacion Is Null del primer if para que liste catálogos desactivados.>
-- Modificación:			<18/02/2016> <Andrés Díaz> <Se agregan los campos TC_CodArea y TB_RequiereRegionalidad a las consultas.>
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<08/07/2016> <Jonathan Gómez> <Se amplia la longitud del parámetro para código de país a 3 caracteres>
-- Modificación:			<04/10/2016> <Diego Navarrete> <Se elimina la consulta por codigo y se agrega con coalesce en las demas consultas>
-- Modificación:			<14/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarPais]
	@Codigo Varchar(3)=Null,
	@Descripcion Varchar(100)=Null,
	@FechaActivacion datetime2=Null,
	@FechaDesactivacion datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%',null)

	--Todos
	If  @FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin
			Select		TC_CodPais      	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TC_CodArea			As CodigoArea,			TB_RequiereRegionalidad As RequiereRegionalidad,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion,
						TC_CodArea  as CodigoArea
			From		Catalogo.Pais With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
			And			TC_CodPais = COALESCE(@Codigo,TC_CodPais)
			Order By	TC_Descripcion;
	End
	--Por activos y filtro por descripcion
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TC_CodPais	        As	Codigo,				TC_Descripcion	As	Descripcion,	
						TC_CodArea			As CodigoArea,			TB_RequiereRegionalidad As RequiereRegionalidad,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
						,TC_CodArea  as CodigoArea
			From		Catalogo.Pais With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
						And	TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			And			TC_CodPais = COALESCE(@Codigo,TC_CodPais)
			Order By	TC_Descripcion;
	End	
	
	--Por inactivos y filtro por descripcion
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
			Select		TC_CodPais       	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TC_CodArea			As CodigoArea,			TB_RequiereRegionalidad As RequiereRegionalidad,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
						,TC_CodArea  as CodigoArea
			From		Catalogo.Pais With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
	        And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			And			TC_CodPais = COALESCE(@Codigo,TC_CodPais)
			Order By	TC_Descripcion;
	End
	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else IF @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
		Begin
			Select		TC_CodPais	        As	Codigo,				TC_Descripcion	As	Descripcion,	
						TC_CodArea			As CodigoArea,			TB_RequiereRegionalidad As RequiereRegionalidad,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
						,TC_CodArea  as CodigoArea
			From		Catalogo.Pais With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
		    And			(TF_Fin_Vigencia  <= @FechaDesactivacion and TF_Inicio_Vigencia >=@FechaActivacion)
			And			TC_CodPais = COALESCE(@Codigo,TC_CodPais)
			Order By	TC_Descripcion;
	End
			
 End
GO
