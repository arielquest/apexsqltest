SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<20/08/2015>
-- Descripción :			<Permite Consultar las Prioridades de la tabla Catalogo.Prioridad> 
-- Modificacion:			<Gerardo Lopez> <22/10/2015> <Incluir fecha de activación para realizar la consulta de activos.>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<21/12/2016> <Pablo Alvarez> <Se corrige TN_CodPrioridad por estandar.>
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<14/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarPrioridad]
	@Codigo smallint =Null,
	@Descripcion varchar(150)=Null,			
	@FechaActivacion datetime2= Null,
	@FechaDesactivacion datetime2= Null
As
Begin
	
	DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If  @FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin
			Select		TN_CodPrioridad		As	Codigo,				TC_Descripcion		As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia		As	FechaDesactivacion,	
						TC_ColorAlerta		As	ColorAlerta
			From		Catalogo.Prioridad	With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND			TN_CodPrioridad=COALESCE(@Codigo,TN_CodPrioridad)
			Order By	TC_Descripcion;
	End


	--Por activos y filtro por descripcion
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodPrioridad		As	Codigo,				TC_Descripcion		As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia		As	FechaDesactivacion,	
						TC_ColorAlerta		As	ColorAlerta
			From		Catalogo.Prioridad	With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			AND			TN_CodPrioridad=COALESCE(@Codigo,TN_CodPrioridad)
			Order By	TC_Descripcion;
	End
	
	--Por inactivos y filtro por descripcion
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
			Select		TN_CodPrioridad		As	Codigo,				TC_Descripcion		As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia		As	FechaDesactivacion,	
						TC_ColorAlerta		As	ColorAlerta
			From		Catalogo.Prioridad	With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			AND			TN_CodPrioridad=COALESCE(@Codigo,TN_CodPrioridad)
			Order By	TC_Descripcion;
	End
	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else IF @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
		Begin
			Select		TN_CodPrioridad		As	Codigo,				TC_Descripcion		As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia		As	FechaDesactivacion,	
						TC_ColorAlerta		As	ColorAlerta
			From		Catalogo.Prioridad	With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Fin_Vigencia  <= @FechaDesactivacion and TF_Inicio_Vigencia >=@FechaActivacion)
			AND			TN_CodPrioridad=COALESCE(@Codigo,TN_CodPrioridad)
			Order By	TC_Descripcion;
	End
End



GO
