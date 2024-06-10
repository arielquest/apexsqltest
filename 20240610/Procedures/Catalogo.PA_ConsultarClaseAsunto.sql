SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<10/08/2015>
-- Descripción :			<Permite Consultar un ClaseAsunto> 
-- =================================================================================================================================================
-- Modificado:			<Pablo Alvarez> <23/10/2015> <Se incluyen filtros por fecha de activación.>
-- Modificado:			<Alejandro Villalta> <17/12/2015> <Autogenerar el codigo de clase de asunto>
-- Modificado:			<Andrés Díaz> <08/07/2016> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificado:			<Ailyn López> <29/11/2017> <Se llama a la función dbo.FN_RemoverTildes>
-- Modificado:			<Jonathan Aguilar Navarro> <21/02/2019> <Se agrega a la consulta el asunto>
-- Modificado:			<Isaac Dobles Mata> <06/05/2019> <Se agrega filtro de código de asunto>
-- Modificado:			<Roger Lara> <11/05/2021> <Se elimina join con catalogo Asunto>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarClaseAsunto]
 @Codigo int=Null,
 @Descripcion Varchar(100)=Null,
 @FechaActivacion datetime2=Null,
 @FechaDesactivacion datetime2= Null
 As
 Begin
  
  
	   DECLARE @ExpresionLike varchar(200)
	   Set	   @ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%',null)

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		A.TN_CodClaseAsunto			As	Codigo,				A.TC_Descripcion	As	Descripcion,		
						A.TF_Inicio_Vigencia	    As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.ClaseAsunto	  A With(Nolock) 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,A.TC_Descripcion)) 
			And TN_CodClaseAsunto = COALESCE(@Codigo,TN_CodClaseAsunto)
			Order By	A.TC_Descripcion;
	End	
	--Activos 
	Else If @FechaActivacion Is not Null And @FechaDesactivacion Is Null
	Begin
			Select		A.TN_CodClaseAsunto			As	Codigo,			    A.TC_Descripcion	As	Descripcion,		
						A.TF_Inicio_Vigencia		As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.ClaseAsunto		A With(Nolock) 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,A.TC_Descripcion)) and TN_CodClaseAsunto = COALESCE(@Codigo,TN_CodClaseAsunto) 
			And			A.TF_Inicio_Vigencia  < GETDATE ()
			And			(A.TF_Fin_Vigencia Is Null OR A.TF_Fin_Vigencia  >= GETDATE ())
			Order By	A.TC_Descripcion;
	End	 
	--Inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is not Null
	Begin
			Select		A.TN_CodClaseAsunto			As	Codigo,				A.TC_Descripcion	As	Descripcion,		
						A.TF_Inicio_Vigencia		As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.ClaseAsunto	  A With(Nolock) 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,A.TC_Descripcion)) and TN_CodClaseAsunto = COALESCE(@Codigo,TN_CodClaseAsunto) 
			And			(A.TF_Inicio_Vigencia  > GETDATE () Or A.TF_Fin_Vigencia  < GETDATE ())
			Order By	A.TC_Descripcion;
	End	
	--Por Rango de Fechas
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is not Null
	Begin
			Select		A.TN_CodClaseAsunto			As	Codigo,				A.TC_Descripcion	As	Descripcion,		
						A.TF_Inicio_Vigencia		As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.ClaseAsunto		A With(Nolock) 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,A.TC_Descripcion)) and TN_CodClaseAsunto = COALESCE(@Codigo,TN_CodClaseAsunto) 
			And			(A.TF_Fin_Vigencia  <= @FechaDesactivacion and A.TF_Inicio_Vigencia >=@FechaActivacion)
			Order By	A.TC_Descripcion;
	End	 
			
 End

GO
