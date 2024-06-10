SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<10/08/2015>
-- Descripción :			<Permite Consultar oficinas> 
-- =================================================================================================================================================
-- Modificación:			<13/08/2015> <Olger Ariel Gamboa C> <Se adacta para entidad> 
-- Modificación:			<27/11/2015> <Gerardo Lopez> <Se agrega el filtro por fecha de activación para consultar los activos> 
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por nombre.>
-- Modificación:			<29/09/2016> <Johan Acosta> <Se agrega el campo de categoria oficina.>
-- Modificación:			<23/01/2017> <Roger Lara > <Se modifico el campo de categoria oficin para que sea un char(1)
-- Modificación:			<24/01/2017> <Roger Lara > <Se agrego split para oficnaOCJ
-- Modificación:			<25/01/2017> <Andrés Díaz> <Se agregar filtro por CategoriaOficina.>
-- Modificación:            <08/05/2017> <Stefany Quesada> <Se agrega en el select la columna OficinaDefensa .>
-- Modificación:            <14/07/2017> <Stefany Quesada> <Se agrega en el select la columna Materia .>
-- Modificación:			<04/10/2017> <Diego Navarrete>	<Se elimina la consulta por codigo y se agrega en todas las demas consultas con COALESCE>
-- Modificación:			<07/11/2017> <Diego Navarrete>	<Se agrega ha oficina Defensa el valor categoria>
-- Modificación:			<2017/11/09> <Andrés Díaz>	<Se cambia el parámetro @CodCircuito de varchar(2) a smallint.>
-- Modificación:			<10/11/2017> <Diego Navarrete>	<Se le aumenta la capacidad del @ExpresionLike de 200 a 257 ya que, el campo descripcion ser de 255 y llevar toda la descripcion no realizaba el expresion Like>
-- Modificación:			<14/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- Modificación:			<30/07/2018> <Jonathan Aguilar Navarro - Andres Díaz Bujan> <Quitar campos correspondientes a Contexto(TC_Telefono,TC_Fax,TC_Email)
--							Se elimina el join con OficinaOCJ>
-- Modificación:			<27/10/2020> <Isaac Dobles> <Se agrega filtro por tipo de oficina>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarOficina]
	@Codigo					varchar(4)		= Null,
	@Descripcion			varchar(255)	= Null,
	@FechaDesactivacion		datetime2(3)	= Null,
	@CodCircuito			smallint		= Null,
	@FechaActivacion		datetime2(3)	= Null,
	@CodCategoriaOficina	char(1)			= Null,
	@CodTipoOficina			smallint		= Null
As
Begin

	DECLARE @ExpresionLike varchar(257) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%',null);
	
	If @FechaDesactivacion Is Null And @FechaActivacion Is Not Null --Activos
	Begin	
		Select		A.TC_CodOficina							As Codigo,	
					A.TC_Nombre								As Descripcion,
					A.TF_Inicio_Vigencia					As FechaActivacion, 
					A.TF_Fin_Vigencia						As FechaDesactivacion,
					A.TC_DescripcionAbreviada				As DescripcionAbreviada,	
					A.TC_Domicilio							As Domicilio,
					'SplitTipoOficina'						As SplitTipoOficina, 
					C.TN_CodTipoOficina						As Codigo, 
					C.TC_Descripcion						As Descripcion, 
					C.TF_Inicio_Vigencia					As FechaActivacion, 
					C.TF_Fin_Vigencia						As FechaVencimiento,
					'SplitCircuito'							As SplitCircuito,
					B.TN_CodCircuito						As Codigo,
					B.TC_Descripcion						As Descripcion,
					B.TF_Inicio_Vigencia					As FechaActivacion,
					B.TF_Fin_Vigencia						As FechaVencimiento,
					'SplitCategoriaOficina'					As SplitCategoriaOficina,
					A.TC_CodCategoriaOficina				As MCategoriaOficina,
					'SplitOficinaDefensa'					As SplitOficinaDefensa,
					E.TC_CodOficina							As Codigo,
					E.TC_Nombre								As Descripcion,
					E.TF_Inicio_Vigencia					As FechaActivacion,
					E.TF_Fin_Vigencia						As FechaDesactivacion,
					'SplitCategoriaOD'						AS SplitCategoriaOD,
					E.TC_CodCategoriaOficina				As CategoriaOficina
		From		Catalogo.Oficina						A With(Nolock) 
		Inner Join	Catalogo.Circuito						B With(Nolock) 
		On			A.TN_CodCircuito						= B.TN_CodCircuito
		Inner Join	Catalogo.TipoOficina					C With(Nolock) 
		On			A.TN_CodTipoOficina						= C.TN_CodTipoOficina
		Left Join	Catalogo.Oficina						E With(Nolock) 
		On			E.TC_CodOficina							= A.TC_CodOficinaDefensa
		Where		dbo.FN_RemoverTildes(A.TC_Nombre)		like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike , A.TC_Nombre))
		And			A.TN_CodCircuito						= COALESCE(@CodCircuito, A.TN_CodCircuito)
		And			COALESCE(A.TC_CodCategoriaOficina, '')	= COALESCE(@CodCategoriaOficina, A.TC_CodCategoriaOficina, '')
		And			A.TC_CodOficina							= COALESCE(@Codigo,A.TC_CodOficina)
		And			A.TN_CodTipoOficina						= COALESCE(@CodTipoOficina,A.TN_CodTipoOficina)
		And			A.TF_Inicio_Vigencia					< GETDATE ()
		And			(A.TF_Fin_Vigencia						Is Null Or A.TF_Fin_Vigencia >= GETDATE ())
		Order By	A.TC_Nombre;
	End
	Else If  @FechaDesactivacion Is Null And @FechaActivacion Is Null --Todos
	Begin	
		Select		A.TC_CodOficina							As Codigo,	
					A.TC_Nombre								As Descripcion,
					A.TF_Inicio_Vigencia					As FechaActivacion, 
					A.TF_Fin_Vigencia						As FechaDesactivacion,
					A.TC_DescripcionAbreviada				As DescripcionAbreviada,	
					A.TC_Domicilio							As Domicilio,
					'SplitTipoOficina'						As SplitTipoOficina, 
					C.TN_CodTipoOficina						As Codigo, 
					C.TC_Descripcion						As Descripcion, 
					C.TF_Inicio_Vigencia					As FechaActivacion, 
					C.TF_Fin_Vigencia						As FechaVencimiento,
					'SplitCircuito'							As SplitCircuito,
					B.TN_CodCircuito						As Codigo,
					B.TC_Descripcion						As Descripcion,
					B.TF_Inicio_Vigencia					As FechaActivacion,
					B.TF_Fin_Vigencia						As FechaVencimiento,
					'SplitCategoriaOficina'					As SplitCategoriaOficina,
					A.TC_CodCategoriaOficina				As MCategoriaOficina,
					'SplitOficinaDefensa'					As SplitOficinaDefensa,
					E.TC_CodOficina							As Codigo,
					E.TC_Nombre								As Descripcion,
					E.TF_Inicio_Vigencia					As FechaActivacion,
					E.TF_Fin_Vigencia						As FechaDesactivacion,
					'SplitCategoriaOD'						AS SplitCategoriaOD,
					E.TC_CodCategoriaOficina				As CategoriaOficina
		From		Catalogo.Oficina						A With(Nolock) 
		Inner Join	Catalogo.Circuito						B With(Nolock) 
		On			A.TN_CodCircuito						= B.TN_CodCircuito
		Inner Join	Catalogo.TipoOficina					C With(Nolock) 
		On			A.TN_CodTipoOficina						= C.TN_CodTipoOficina
		Left Join	Catalogo.Oficina						E With(Nolock) 
		On			E.TC_CodOficina							= A.TC_CodOficinaDefensa
		Where		dbo.FN_RemoverTildes(A.TC_Nombre)		like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike , A.TC_Nombre))
		And			A.TN_CodCircuito						= COALESCE(@CodCircuito, A.TN_CodCircuito)
		And			COALESCE(A.TC_CodCategoriaOficina, '')	= COALESCE(@CodCategoriaOficina, A.TC_CodCategoriaOficina, '')
		And			A.TC_CodOficina							= COALESCE(@Codigo,A.TC_CodOficina)
		And			A.TN_CodTipoOficina						= COALESCE(@CodTipoOficina,A.TN_CodTipoOficina)
		Order By	A.TC_Nombre;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null --Inactivos
	Begin
		Select		A.TC_CodOficina							As Codigo,	
					A.TC_Nombre								As Descripcion,
					A.TF_Inicio_Vigencia					As FechaActivacion, 
					A.TF_Fin_Vigencia						As FechaDesactivacion,
					A.TC_DescripcionAbreviada				As DescripcionAbreviada,	
					A.TC_Domicilio							As Domicilio,
					'SplitTipoOficina'						As SplitTipoOficina, 
					C.TN_CodTipoOficina						As Codigo, 
					C.TC_Descripcion						As Descripcion, 
					C.TF_Inicio_Vigencia					As FechaActivacion, 
					C.TF_Fin_Vigencia						As FechaVencimiento,
					'SplitCircuito'							As SplitCircuito,
					B.TN_CodCircuito						As Codigo,
					B.TC_Descripcion						As Descripcion,
					B.TF_Inicio_Vigencia					As FechaActivacion,
					B.TF_Fin_Vigencia						As FechaVencimiento,
					'SplitCategoriaOficina'					As SplitCategoriaOficina,
					A.TC_CodCategoriaOficina				As MCategoriaOficina,
					'SplitOficinaDefensa'					As SplitOficinaDefensa,
					E.TC_CodOficina							As Codigo,
					E.TC_Nombre								As Descripcion,
					E.TF_Inicio_Vigencia					As FechaActivacion,
					E.TF_Fin_Vigencia						As FechaDesactivacion,
					'SplitCategoriaOD'						AS SplitCategoriaOD,
					E.TC_CodCategoriaOficina				As CategoriaOficina
		From		Catalogo.Oficina						A With(Nolock) 
		Inner Join	Catalogo.Circuito						B With(Nolock) 
		On			A.TN_CodCircuito						= B.TN_CodCircuito
		Inner Join	Catalogo.TipoOficina					C With(Nolock) 
		On			A.TN_CodTipoOficina						= C.TN_CodTipoOficina
		Left Join	Catalogo.Oficina						E With(Nolock) 
		On			E.TC_CodOficina							= A.TC_CodOficinaDefensa
		Where		dbo.FN_RemoverTildes(A.TC_Nombre)		like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike , A.TC_Nombre))
		And			A.TN_CodCircuito						= COALESCE(@CodCircuito, A.TN_CodCircuito)
		And			COALESCE(A.TC_CodCategoriaOficina, '')	= COALESCE(@CodCategoriaOficina, A.TC_CodCategoriaOficina, '')
		And			A.TC_CodOficina							= COALESCE(@Codigo,A.TC_CodOficina)
		And			A.TN_CodTipoOficina						= COALESCE(@CodTipoOficina,A.TN_CodTipoOficina)
		And			(A.TF_Inicio_Vigencia					> GETDATE () Or A.TF_Fin_Vigencia < GETDATE ())
		Order By	A.TC_Nombre;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null --Rango de fechas
	Begin
		Select		A.TC_CodOficina							As Codigo,	
					A.TC_Nombre								As Descripcion,
					A.TF_Inicio_Vigencia					As FechaActivacion, 
					A.TF_Fin_Vigencia						As FechaDesactivacion,
					A.TC_DescripcionAbreviada				As DescripcionAbreviada,	
					A.TC_Domicilio							As Domicilio,
					'SplitTipoOficina'						As SplitTipoOficina, 
					C.TN_CodTipoOficina						As Codigo, 
					C.TC_Descripcion						As Descripcion, 
					C.TF_Inicio_Vigencia					As FechaActivacion, 
					C.TF_Fin_Vigencia						As FechaVencimiento,
					'SplitCircuito'							As SplitCircuito,
					B.TN_CodCircuito						As Codigo,
					B.TC_Descripcion						As Descripcion,
					B.TF_Inicio_Vigencia					As FechaActivacion,
					B.TF_Fin_Vigencia						As FechaVencimiento,
					'SplitCategoriaOficina'					As SplitCategoriaOficina,
					A.TC_CodCategoriaOficina				As MCategoriaOficina,
					'SplitOficinaDefensa'					As SplitOficinaDefensa,
					E.TC_CodOficina							As Codigo,
					E.TC_Nombre								As Descripcion,
					E.TF_Inicio_Vigencia					As FechaActivacion,
					E.TF_Fin_Vigencia						As FechaDesactivacion,
					'SplitCategoriaOD'						AS SplitCategoriaOD,
					E.TC_CodCategoriaOficina				As CategoriaOficina
		From		Catalogo.Oficina						A With(Nolock) 
		Inner Join	Catalogo.Circuito						B With(Nolock) 
		On			A.TN_CodCircuito						= B.TN_CodCircuito
		Inner Join	Catalogo.TipoOficina					C With(Nolock) 
		On			A.TN_CodTipoOficina						= C.TN_CodTipoOficina
		Left Join	Catalogo.Oficina						E With(Nolock) 
		On			E.TC_CodOficina							= A.TC_CodOficinaDefensa
		Where		dbo.FN_RemoverTildes(A.TC_Nombre)		like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike , A.TC_Nombre))
		And			A.TN_CodCircuito						= COALESCE(@CodCircuito, A.TN_CodCircuito)
		And			COALESCE(A.TC_CodCategoriaOficina, '')	= COALESCE(@CodCategoriaOficina, A.TC_CodCategoriaOficina, '')
		And			A.TC_CodOficina							= COALESCE(@Codigo,A.TC_CodOficina)
		And			A.TN_CodTipoOficina						= COALESCE(@CodTipoOficina,A.TN_CodTipoOficina)
		And			A.TF_Inicio_Vigencia					>= @FechaActivacion
		And			A.TF_Fin_Vigencia						<= @FechaDesactivacion
		Order By	A.TC_Nombre;
	End
End
GO
