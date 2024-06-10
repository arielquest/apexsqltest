SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<01/10/2015>
-- Descripción :			<Permite Consultar los tipos de diligencia de la tabla Catalogo.TipoDiligencia> 
-- Modificado por:			<Pablo Alvarez>
-- Fecha de creación:		<23/10/2015>
-- Descripción :			<Se incluyen filtros por fecha de activación.> 
-- Modificacion             <Gerardo Lopez> <09/11/2015> <Agregar estado diligencia>
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
-- Modificación:			<14/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoDiligencia]
	@Codigo smallint=Null,
	@Descripcion Varchar(100)=Null,
	@FechaActivacion datetime2=Null,
	@FechaDesactivacion datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If  @FechaActivacion Is Null And @FechaDesactivacion Is Null  
	Begin
			Select		TN_CodTipoDiligencia      	As	Codigo,				A.TC_Descripcion	As	Descripcion,		
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoDiligencia A With(Nolock) 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) 
			AND         TN_CodTipoDiligencia=COALESCE(@Codigo,TN_CodTipoDiligencia)
			Order By	TC_Descripcion;
	End
	 
	--Por activos y filtro por descripcion
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodTipoDiligencia      	As	Codigo,				A.TC_Descripcion	As	Descripcion,		
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoDiligencia A With(Nolock) 	 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) 
			And			A.TF_Inicio_Vigencia  < GETDATE ()
			And			(A.TF_Fin_Vigencia Is Null OR A.TF_Fin_Vigencia  >= GETDATE ())
			AND         TN_CodTipoDiligencia=COALESCE(@Codigo,TN_CodTipoDiligencia)
			Order By	TC_Descripcion;
	End
	
	--Por inactivos y filtro por descripcion
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
			Select		TN_CodTipoDiligencia      	As	Codigo,				A.TC_Descripcion	As	Descripcion,		
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoDiligencia A With(Nolock) 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) 
	        And			(A.TF_Inicio_Vigencia  > GETDATE () Or A.TF_Fin_Vigencia  < GETDATE ())
		   AND          TN_CodTipoDiligencia=COALESCE(@Codigo,TN_CodTipoDiligencia)
			Order By	TC_Descripcion;
	End
	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else IF @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
		Begin
		    Select		TN_CodTipoDiligencia      	As	Codigo,				A.TC_Descripcion	As	Descripcion,		
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoDiligencia A With(Nolock)  
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) 
		    And			(A.TF_Fin_Vigencia  <= @FechaDesactivacion and A.TF_Inicio_Vigencia >=@FechaActivacion)
		    AND         TN_CodTipoDiligencia=COALESCE(@Codigo,TN_CodTipoDiligencia)
			Order By	TC_Descripcion;
	End
			
 End





GO
