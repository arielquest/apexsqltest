SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================
-- Autor:				<Pablo Alvarez>
-- Fecha Creación:		<19 de febrero de 2016.>
-- Descripcion:			<Permite Consultar un tipo FormatoArchivo>
-- Modificación:		<Andrés Díaz>
-- Fecha Modificación:	<01 de abril de 2016.>
-- Descripcion:			<Se agrega el campo TC_Extensiones>
-- Modificación:		<Esteban Cordero Benavides.>
-- Fecha Modificación:	<04 de abril de 2016.>
-- Descripcion:			<Se Modifica todo el procedimiento para que se refiera a FormatoArchivo y no a TipoArchivo.>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<29/11/2017> <Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- =================================================================================================================
CREATE Procedure [Catalogo].[PA_ConsultarFormatoArchivo]
	@TN_CodFormatoArchivo	SmallInt = null,
	@TC_Descripcion			VarChar(100) = null,
	@TF_Inicio_Vigencia		DateTime2 = null,
	@TF_Fin_Vigencia		DateTime2 = null
As
Begin
	
	Declare @ExpresionLike	VarChar(100);
	Set		@ExpresionLike	= iif(@TC_Descripcion Is Not Null,'%' + @TC_Descripcion + '%','%');

	--Activos e inactivos
	If  @TF_Inicio_Vigencia Is Null And  @TF_Fin_Vigencia Is Null 
	Begin
		Select		TN_CodFormatoArchivo Codigo,			TC_Descripcion	Descripcion,	TC_Extensiones Extensiones,	TF_Inicio_Vigencia FechaActivacion,
					TF_Fin_Vigencia FechaDesactivacion
		From		Catalogo.FormatoArchivo		AS A			With(Nolock)
		Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		And			TN_CodFormatoArchivo		=	Coalesce(@TN_CodFormatoArchivo,TN_CodFormatoArchivo) 
		Order By	TC_Descripcion;
	End

	--Activos
	Else 
	Begin 
		If  @TF_Inicio_Vigencia Is Not Null And  @TF_Fin_Vigencia Is Null 
		Begin
			Select		TN_CodFormatoArchivo Codigo,			TC_Descripcion	Descripcion,	TC_Extensiones Extensiones,	TF_Inicio_Vigencia FechaActivacion,
						TF_Fin_Vigencia FechaDesactivacion
			From		Catalogo.FormatoArchivo AS A					With(Nolock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodFormatoArchivo		=	Coalesce(@TN_CodFormatoArchivo,TN_CodFormatoArchivo) 
			And			A.TF_Inicio_Vigencia	<=		GETDATE ()
			And			(A.TF_Fin_Vigencia		Is	Null OR A.TF_Fin_Vigencia  >= GETDATE ())
		
			Order By	TC_Descripcion;
		End
		Else 
		Begin

			--Inactivos.
			If  @TF_Inicio_Vigencia Is Null And @TF_Fin_Vigencia Is Not Null
			Begin
				Select		TN_CodFormatoArchivo Codigo,			TC_Descripcion	Descripcion,	TC_Extensiones Extensiones,	TF_Inicio_Vigencia FechaActivacion,
							TF_Fin_Vigencia FechaDesactivacion
				From		Catalogo.FormatoArchivo	AS A				With(Nolock)
				Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
				And			TN_CodFormatoArchivo		=	Coalesce(@TN_CodFormatoArchivo,TN_CodFormatoArchivo) 
				And			(A.TF_Inicio_Vigencia	> GETDATE ()
				Or			A.TF_Fin_Vigencia		< GETDATE ())
				Order By	TC_Descripcion;
	
			End
			Else 
			Begin

				--Por rango de fechas
				If @TF_Fin_Vigencia Is Not Null And @TF_Inicio_Vigencia Is Not Null
				Begin
					Select		TN_CodFormatoArchivo Codigo,			TC_Descripcion	Descripcion,	TC_Extensiones Extensiones,	TF_Inicio_Vigencia FechaActivacion,
								TF_Fin_Vigencia FechaDesactivacion
					From		Catalogo.FormatoArchivo		AS A			With(Nolock)
					Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
					And			TN_CodFormatoArchivo		=		Coalesce(@TN_CodFormatoArchivo,TN_CodFormatoArchivo) 
					And			(A.TF_Inicio_Vigencia	>= @TF_Inicio_Vigencia
					And			A.TF_Fin_Vigencia		<= @TF_Fin_Vigencia)
					Order By	TC_Descripcion;
		
				End		
			End
		End
	End
End;
GO
