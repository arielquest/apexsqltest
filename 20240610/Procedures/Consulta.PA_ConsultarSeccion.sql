SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================
-- Autor:				<Esteban Cordero Benavides.>
-- Fecha Creación:		<26 de abril de 2016.>
-- Descripcion:			<Permite realizar consultas de las secciones que se encuentren creados en la base de datos.>
-- =================================================================================================================
CREATE Procedure [Consulta].[PA_ConsultarSeccion]
	@TN_CodSeccion			SmallInt		= Null,
	@TC_Nombre				VarChar(50)		= Null,
	@TF_Inicio_Vigencia		DateTime2(3)	= Null,
	@TF_Fin_Vigencia		DateTime2(3)	= Null
As
Begin
	--Variable para almacenar la descripcion.
	Declare	@ExpresionLike VarChar(200);
	Set	@ExpresionLike	= iif(@TC_Nombre Is Not Null, '%' + @TC_Nombre + '%', '%')

	--Si todo es nulo se devuelven todos los registros.
	If	@TF_Inicio_Vigencia Is Null 
	And @TF_Fin_Vigencia Is Null 
	And @TN_CodSeccion Is Null
	Begin	
			Select	TN_CodSeccion Codigo,	TC_Nombre Nombre,	TF_Inicio_Vigencia FechaActivacion,	TF_Fin_Vigencia FechaDesactivacion
			From	Consulta.Seccion		With(NoLock)
			Where	TC_Nombre				Like @TC_Nombre
	End
	Else Begin
		--Sólo por codigo.
		If	@TN_CodSeccion Is Not Null
		Begin
			Select	TN_CodSeccion Codigo,	TC_Nombre Nombre,	TF_Inicio_Vigencia FechaActivacion,	TF_Fin_Vigencia FechaDesactivacion
			From	Consulta.Seccion		With(NoLock)
			Where	TN_CodSeccion			= @TN_CodSeccion
		End
		Else Begin
			--Filtros de fechas.
			If @TF_Fin_Vigencia Is Null 
			And @TF_Inicio_Vigencia Is Not Null
			Begin
				Select	TN_CodSeccion Codigo,	TC_Nombre Nombre,	TF_Inicio_Vigencia FechaActivacion,	TF_Fin_Vigencia FechaDesactivacion
				From	Consulta.Seccion		With(NoLock)
				Where	TC_Nombre				Like @TC_Nombre
				And		TF_Inicio_Vigencia		< GetDate()
				And		(
							TF_Fin_Vigencia		Is Null
						Or
							TF_Fin_Vigencia		>= GetDate()
						)
			End
			Else Begin
				If @TF_Fin_Vigencia Is Not Null 
				And @TF_Inicio_Vigencia Is Null
				Begin
					Select	TN_CodSeccion Codigo,	TC_Nombre Nombre,	TF_Inicio_Vigencia FechaActivacion,	TF_Fin_Vigencia FechaDesactivacion
					From	Consulta.Seccion		With(NoLock)
					Where	TC_Nombre				Like @TC_Nombre
					And		(
								TF_Inicio_Vigencia	> GetDate()
							Or
								TF_Fin_Vigencia		< GetDate()
							)
				End
				Else Begin
					If @TF_Fin_Vigencia Is Not Null 
					And @TF_Inicio_Vigencia Is Not Null
					Begin
						Select	TN_CodSeccion Codigo,	TC_Nombre Nombre,	TF_Inicio_Vigencia FechaActivacion,	TF_Fin_Vigencia FechaDesactivacion
						From	Consulta.Seccion		With(NoLock)
						Where	TC_Nombre				Like @TC_Nombre
						And		TF_Inicio_Vigencia		>= @TF_Inicio_Vigencia
						And		TF_Fin_Vigencia			<= @TF_Fin_Vigencia 
					End
				End
			End
		End
	End
End;

GO
