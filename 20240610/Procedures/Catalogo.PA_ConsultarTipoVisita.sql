SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<24/08/2015>
-- Descripción :			<Permite Consultar los tipo de visita de la tabla Catalogo.TipoVisita>
-- Modificado por:			<Olger Gamboa Castillo>
-- Fecha de creación:		<23/10/2015>
-- Descripción :			<Se agrega el filtro por fecha de activación para consultar los activos>
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de modificación:	<05/01/2016>
-- Descripción :			<Generar automáticamente el codigo de tipo de visita - item 5782.> 	
--
-- Modificación:			<11/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodTipoVisita a TN_CodTipoVisita de acuerdo al tipo de dato.>
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoVisita]
	@CodTipoVisita		smallint	= Null,
	@Descripcion		varchar(200)= Null,			
	@FechaDesactivacion datetime2	= Null,
	@FechaActivacion	datetime2(3)= null
As
Begin
	
	DECLARE @ExpresionLike varchar(257)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

		--Si todo es nulo se devuelven todos los registros
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodTipoVisita	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoVisita
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodTipoVisita=COALESCE(@CodTipoVisita,TN_CodTipoVisita) 
			Order By	TC_Descripcion;
	End
	--Por descripcion si hay. Si estan activos o desactivos dependiendo de valor de @FechaDesactivacion
	Else If @FechaDesactivacion Is Null And @FechaActivacion Is Not Null
	Begin
			Select		TN_CodTipoVisita	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoVisita
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia is null or TF_Fin_Vigencia  >= GETDATE ())
			And			TN_CodTipoVisita=COALESCE(@CodTipoVisita,TN_CodTipoVisita) 
			Order By	TC_Descripcion;
	End
	
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null
	Begin
			Select		TN_CodTipoVisita	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoVisita
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			(TF_Inicio_Vigencia  > GETDATE ()
			Or			TF_Fin_Vigencia  < GETDATE ())
			And			TN_CodTipoVisita=COALESCE(@CodTipoVisita,TN_CodTipoVisita) 
			Order By	TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
		Begin
			Select		TN_CodTipoVisita	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoVisita
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia	>= @FechaActivacion
			And			TF_Fin_Vigencia		<= @FechaDesactivacion 
			And			TN_CodTipoVisita=COALESCE(@CodTipoVisita,TN_CodTipoVisita) 
			Order By	TC_Descripcion;
	End
End




GO
