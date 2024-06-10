SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<02/09/2015>
-- Descripción :			<Permite Consultar Vulnerabilidad> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<22/10/2015>
-- Descripción :			<Se incluyen filtros por fecha de activación.> 
--
-- Modificación:			<11/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodVulnerabilidad a TN_CodVulnerabilidad de acuerdo al tipo de dato.>
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<4/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarVulnerabilidad]
	@CodVulnerabilidad smallint	= Null,
	@Descripcion varchar(255)		= Null,
	@FechaActivacion datetime2(3)	= Null,
	@FechaVencimiento datetime2		= Null
 As
Begin
  
		  DECLARE @ExpresionLike varchar(257)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaVencimiento Is Null 
	Begin
			Select		TN_CodVulnerabilidad      	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Vulnerabilidad With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			and			TN_CodVulnerabilidad=COALESCE(@CodVulnerabilidad,TN_CodVulnerabilidad)
			Order By	TC_Descripcion;
	End

	--Por activos y filtro por descripcion
	Else If  @FechaActivacion Is Not Null And @FechaVencimiento Is Null
	Begin
			Select		TN_CodVulnerabilidad	    As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Vulnerabilidad With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			and			TN_CodVulnerabilidad=COALESCE(@CodVulnerabilidad,TN_CodVulnerabilidad)
			Order By	TC_Descripcion;
	End
	
	--Por inactivos y filtro por descripcion
	Else IF @FechaActivacion Is Null And @FechaVencimiento Is Not Null		
	Begin
			Select		TN_CodVulnerabilidad       As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Vulnerabilidad With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
	        And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
		   and			TN_CodVulnerabilidad=COALESCE(@CodVulnerabilidad,TN_CodVulnerabilidad)
			Order By	TC_Descripcion;
	End
	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else IF @FechaActivacion Is Not Null And @FechaVencimiento Is Not Null		
		Begin
			Select		TN_CodVulnerabilidad	    As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	    As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Vulnerabilidad With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			(TF_Fin_Vigencia  <= @FechaVencimiento and TF_Inicio_Vigencia >=@FechaActivacion)
		    and			TN_CodVulnerabilidad=COALESCE(@CodVulnerabilidad,TN_CodVulnerabilidad)
			Order By	TC_Descripcion;
	End
			
 End
GO
