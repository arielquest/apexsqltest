SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<31/08/2015>
-- Descripción :			<Permite Consultar Tipos de Medida Cautelar> 
-- =================================================================================================================================================
-- Modificado por:			<23/10/2015> <Olger Gamboa Castillo> <Se agrega el filtro por fecha de activación para consultar los activos> 		
-- Modificado por:			<05/01/2016> <Alejandro Villalta> <Modificar el tipo de dato del codigo de tipo medida cautelar para autogenerar el valor>
-- Modificado por:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción>
-- Modificado por:			<02/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN> 
-- Modificado por:          <03/10/2017> <Diego Chavarria> <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas, también se elimina el IF Null de Código del select Todos>
-- Modificado por:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- Modificado por:			<24/10/2022> <Rafa Badilla Alvarado> <Se modifica para filtrar los registros activos por materia> 
-- Modificado por:			<02/11/2022> <Jose Gabriel Cordero Soto> <Se renombra tabla TipoMedidaCautelar, entonces se actualiza referencia a tabla en el procedimiento> 
-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarTipoMedida]
	@Codigo smallint=Null,
	@Descripcion Varchar(150)=Null,
	@FechaVencimiento Datetime2= Null,
	@FechaActivacion datetime2(3)= null,
	@CodMateria    varchar(4)	= null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaVencimiento Is Null And @CodMateria Is Null
	Begin
			Select		TN_CodTipoMedida	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoMedida With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND         TN_CodTipoMedida=COALESCE(@Codigo,TN_CodTipoMedida)
			Order By	TC_Descripcion;
	End

	--Por descripcion si hay. Si estan activos o desactivos dependiendo de valor de @FechaDesactivacion
	Else If @FechaVencimiento Is Null And @FechaActivacion Is Not Null And @CodMateria Is Null
	Begin
			Select		TN_CodTipoMedida	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoMedida With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia is null or TF_Fin_Vigencia  >= GETDATE ())
			AND         TN_CodTipoMedida=COALESCE(@Codigo,TN_CodTipoMedida)
			Order By	TC_Descripcion;

	End
	Else If @FechaVencimiento Is Not Null And @FechaActivacion Is Null And @CodMateria Is Null
	Begin
			Select		TN_CodTipoMedida	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoMedida With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			(TF_Inicio_Vigencia  > GETDATE ()
			Or			TF_Fin_Vigencia  < GETDATE ())
			AND         TN_CodTipoMedida=COALESCE(@Codigo,TN_CodTipoMedida)

			Order By	TC_Descripcion;
	End
	Else If @FechaVencimiento Is Not Null And @FechaActivacion Is Not Null And @CodMateria Is Null		
		Begin
			Select		TN_CodTipoMedida	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoMedida With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia	>= @FechaActivacion
			And			TF_Fin_Vigencia		<= @FechaVencimiento 
			AND         TN_CodTipoMedida=COALESCE(@Codigo,TN_CodTipoMedida)

			Order By	TC_Descripcion;
	End
		Else If @CodMateria Is Not Null	
		Begin
		print ('Con Materia')
			Select		B.TN_CodTipoMedida	    As	Codigo,				    B.TC_Descripcion	As	Descripcion,		
						B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion
				FROM		Catalogo.TipoMedidaMateria		AS	A WITH (Nolock) 
				INNER JOIN	Catalogo.TipoMedida			AS	B WITH (Nolock)
				ON			B.TN_CodTipoMedida				   =	A.TN_CodTipoMedida
				INNER JOIN  Catalogo.Materia					AS	C WITH (Nolock)
				ON			C.TC_CodMateria						=	A.TC_CodMateria				
				WHERE		A.TC_CodMateria						=	COALESCE(@CodMateria, A.TC_CodMateria)
				AND		   (B.TF_Inicio_Vigencia				<= @FechaVencimiento	
				AND		    B.TF_Inicio_Vigencia				>= @FechaActivacion or B.TF_Fin_Vigencia is null) 
				AND		   (C.TF_Inicio_Vigencia				<= @FechaVencimiento	
				AND		    C.TF_Inicio_Vigencia				>= @FechaActivacion or C.TF_Fin_Vigencia is null)
		ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
	End
			
 End






GO
