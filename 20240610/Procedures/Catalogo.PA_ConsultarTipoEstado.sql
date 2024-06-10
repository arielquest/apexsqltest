SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<19/08/2015>
-- Descripción :			<Permite Consultar las Materias de la tabla Catalogo.TipoEstado> 
-- Modificado :				<Alejandro Villalta, 14/12/2015, Se modifica el tipo de dato del codigo de tipo estado.> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<14/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoEstado]
	@CodTipoEstado smallint=Null,
	@Descripcion varchar(150)=Null,			
	@FechaActivacion datetime2= Null,
	@FechaDesactivacion datetime2= Null
As
Begin
	
	DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin
			Select		TN_CodTipoEstado	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoEstado	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND			TN_CodTipoEstado=COALESCE(@CodTipoEstado,TN_CodTipoEstado)
			Order By	TC_Descripcion;
	End
		--Por activos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodTipoEstado	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoEstado
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			AND			TN_CodTipoEstado=COALESCE(@CodTipoEstado,TN_CodTipoEstado)
			Order By	TC_Descripcion;
	End
	--Por inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null	
		Begin
			Select		TN_CodTipoEstado	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoEstado
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > GETDATE ()
			Or			TF_Fin_Vigencia  < GETDATE ())
			AND			TN_CodTipoEstado=COALESCE(@CodTipoEstado,TN_CodTipoEstado)
			Order By	TC_Descripcion;
	End
		--Por inactivos por rango de fechas
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null	
		Begin
			Select		TN_CodTipoEstado	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoEstado
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Fin_Vigencia  > @FechaActivacion
			And			TF_Fin_Vigencia  < @FechaDesactivacion)
			AND			TN_CodTipoEstado=COALESCE(@CodTipoEstado,TN_CodTipoEstado)
			Order By	TC_Descripcion;
	End
End


GO
