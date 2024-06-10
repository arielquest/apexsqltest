SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<20/08/2015>
-- Descripción :			<Permite Consultar los Idiomas de la tabla Catalogo.Idioma> 
-- Modificacion:  08/12/2015  Modificar tipo dato CodMoneda a smallint
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<21/11/2017> <Jonathan Aguilar Navarro> <Se modifican las consulta quitanto el filtro por código. Y se reemplaza
--							<el where de ExpresionLike>
--
-- Modificación:			<2017-21-01> <Andrés Díaz> <Se agrega la función dbo.FN_RemoverTildes. Se tabula todo el PA.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarIdioma]
	@CodIdioma smallint				= Null,
	@Descripcion varchar(150)		= Null,			
	@FechaActivacion datetime2		= Null,
	@FechaDesactivacion datetime2	= Null
As
Begin
	
	DECLARE @ExpresionLike varchar(200) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%');

	--Activos e Inactivos
	If  @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodIdioma		As	Codigo,				
						TC_Descripcion		As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	
						TF_Fin_Vigencia		As	FechaDesactivacion
			From		Catalogo.Idioma
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodIdioma		= Coalesce(@CodIdioma,TN_CodIdioma) 
			Order By	TC_Descripcion;
	End
	
	--Por activos
	Else If @FechaActivacion Is Not Null And  @FechaDesactivacion Is Null
	Begin
			Select		TN_CodIdioma		As	Codigo,				
						TC_Descripcion		As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	
						TF_Fin_Vigencia		As	FechaDesactivacion
			From		Catalogo.Idioma
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodIdioma		= Coalesce(@CodIdioma,TN_CodIdioma) 
			And			TF_Inicio_Vigencia	< GETDATE()
			And			(TF_Fin_Vigencia	Is Null Or TF_Fin_Vigencia >= GETDATE())
			Order By	TC_Descripcion;
	End
	--Por inactivos
	Else If @FechaActivacion Is Null And  @FechaDesactivacion Is Not Null	
	Begin
			Select		TN_CodIdioma		As	Codigo,				
						TC_Descripcion		As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	
						TF_Fin_Vigencia		As	FechaDesactivacion
			From		Catalogo.Idioma
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodIdioma		= Coalesce(@CodIdioma,TN_CodIdioma) 
			And			(TF_Inicio_Vigencia	> GETDATE() Or TF_Fin_Vigencia < GETDATE())
			Order By	TC_Descripcion;
	End
	--Por rango de fechas de desactivacion
	Else If @FechaActivacion Is Not Null And  @FechaDesactivacion Is Not Null	
	Begin
			Select		TN_CodIdioma		As	Codigo,				
						TC_Descripcion		As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	
						TF_Fin_Vigencia		As	FechaDesactivacion
			From		Catalogo.Idioma
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodIdioma		= Coalesce(@CodIdioma,TN_CodIdioma) 
			And			(TF_Fin_Vigencia	>=@FechaActivacion And TF_Fin_Vigencia <= @FechaDesactivacion)
			Order By	TC_Descripcion;
	End
End
GO
