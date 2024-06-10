SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Cordero Benavides>
-- Fecha de creación:		<10 de octubre de 2019>
-- Descripción:				<Permite conusltar un catálogo de práctica en la tabla PracticaECB.>
-- =============================================================================================
CREATE Procedure [Catalogo].[PA_ConsultarPracticaECB]
		@TN_CodPracticaECB	Int				= Null,
		@TC_Descripcion		VarChar(255)	= Null,
		@TF_Inicio_Vigencia	DateTime2(2)	= Null,
		@TF_Fin_Vigencia	DateTime2(2)	= Null
As
Begin
	--Variables.
	Declare @L_TN_CodPracticaECB	Int				= @TN_CodPracticaECB,
			@L_TC_Descripcion		VarChar(255)	= @TC_Descripcion,
			@L_TF_Inicio_Vigencia	DateTime2(2)	= @TF_Inicio_Vigencia,
			@L_TF_Fin_Vigencia		DateTime2(2)	= @TF_Fin_Vigencia
	--
	Declare	@L_ExpresionLike	VarChar(Max) = Iif	(@L_TC_Descripcion Is Not Null, '%' + @L_TC_Descripcion + '%', '%')
     --Lógica.
	If  @L_TF_Inicio_Vigencia Is Null And @L_TF_Fin_Vigencia Is Null And @L_TN_CodPracticaECB Is Null  
	Begin --Todos:
			Select		TN_CodPracticaECB		Codigo,
						TC_Descripcion			Descripcion,
						TF_Inicio_Vigencia		FechaActivacion,
						TF_Fin_Vigencia			FechaDesactivacion
			From		Catalogo.PracticaECB	With(NoLock)
			Where		TC_Descripcion			Like @L_ExpresionLike
			Order By	TC_Descripcion;
	End	Else
	Begin --Por llave:
		If @L_TN_CodPracticaECB Is Not Null
		Begin
			Select		TN_CodPracticaECB		Codigo,
						TC_Descripcion			Descripcion,
						TF_Inicio_Vigencia		FechaActivacion,
						TF_Fin_Vigencia			FechaDesactivacion
			From		Catalogo.PracticaECB	With(NoLock)
			Where		TN_CodPracticaECB		= @L_TN_CodPracticaECB
			Order By	TC_Descripcion;
		End Else
		Begin --Por activos y filtro de descripción:
			If @L_TF_Inicio_Vigencia Is Not Null And @L_TF_Fin_Vigencia Is Null
			Begin
				Select		TN_CodPracticaECB		Codigo,
							TC_Descripcion			Descripcion,
							TF_Inicio_Vigencia		FechaActivacion,
							TF_Fin_Vigencia			FechaDesactivacion
				From		Catalogo.PracticaECB	With(NoLock)
				Where		TC_Descripcion			Like @L_ExpresionLike
				And			TF_Inicio_Vigencia		< GetDate()
				And			(
								TF_Fin_Vigencia		Is Null
							Or
								TF_Fin_Vigencia		>= GetDate()
							)
				Order By	TC_Descripcion;
			End Else
			Begin --Por activos:
				If @L_TF_Fin_Vigencia Is Null
				Begin
					Select		TN_CodPracticaECB		Codigo,
								TC_Descripcion			Descripcion,
								TF_Inicio_Vigencia		FechaActivacion,
								TF_Fin_Vigencia			FechaDesactivacion
					From		Catalogo.PracticaECB	With(NoLock)
					Where		TC_Descripcion			Like @L_ExpresionLike
					And			(
									TF_Fin_Vigencia		> GetDate()
								Or
									TF_Fin_Vigencia		< GetDate()
								)
					Order By	TC_Descripcion;
				End Else
				Begin --Si las dos fechas no son nulas, se listan los datos por rango de fechas de los inactivos
					If @L_TF_Inicio_Vigencia Is Not Null And @L_TF_Fin_Vigencia Is Not Null
					Begin
						Select		TN_CodPracticaECB		Codigo,
									TC_Descripcion			Descripcion,
									TF_Inicio_Vigencia		FechaActivacion,
									TF_Fin_Vigencia			FechaDesactivacion
						From		Catalogo.PracticaECB	With(NoLock)
						Where		TC_Descripcion			Like @L_ExpresionLike
						And			(
										TF_Fin_Vigencia		<= @L_TF_Fin_Vigencia
									And
										TF_Inicio_Vigencia	>= @L_TF_Inicio_Vigencia
									)
						Order By	TC_Descripcion;
					End
				End
			End
		End
	End
	

End
GO
