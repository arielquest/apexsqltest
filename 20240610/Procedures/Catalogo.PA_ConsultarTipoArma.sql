SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<05/11/2019>
-- Descripción:			<Permite consultar un registro en la tabla: TipoArma.>
-- ==================================================================================================================================================================================
CREATE Procedure [Catalogo].[PA_ConsultarTipoArma]
	@TN_CodTipoArma		SmallInt,
	@TC_Descripcion		VarChar(100),
	@TF_Inicio_Vigencia	DateTime2(3),
	@TF_Fin_Vigencia	DateTime2(3)	= Null
As
Begin
	--Variables.
	Declare	@L_TN_CodTipoArma		SmallInt		= @TN_CodTipoArma,
			@L_TF_Inicio_Vigencia	DateTime2(3)	= @TF_Inicio_Vigencia,
			@L_TF_Fin_Vigencia		DateTime2(3)	= @TF_Fin_Vigencia,
			@L_TC_Descripcion		VarChar(Max)	= Iif (@TC_Descripcion Is Not Null, '%' + @TC_Descripcion + '%', '%')
	--Lógica.
	If  @L_TF_Inicio_Vigencia Is Null
	And @L_TF_Fin_Vigencia Is Null
	And @L_TN_CodTipoArma Is Null
	Begin --Todos:
		Select		TN_CodTipoArma		Codigo,
					TC_Descripcion		Descripcion,
					TC_Observacion		Observacion,
					TF_Inicio_Vigencia	FechaActivacion,
					TF_Fin_Vigencia		FechaDesactivacion
		From		Catalogo.TipoArma		With(NoLock)
		Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@L_TC_Descripcion) 
		Order By	TC_Descripcion
	End	Else
	Begin --Por llave:
		If @L_TN_CodTipoArma Is Not Null
		Begin
			Select		TN_CodTipoArma	Codigo,
						TC_Descripcion		Descripcion,
						TC_Observacion		Observacion,
						TF_Inicio_Vigencia	FechaActivacion,
						TF_Fin_Vigencia		FechaDesactivacion
			From		Catalogo.TipoArma		With(NoLock)
			Where		TN_CodTipoArma			= @L_TN_CodTipoArma
			Order By	TC_Descripcion
		End Else
		Begin --Por activos y filtro de descripción:
			If @L_TF_Inicio_Vigencia Is Not Null
			And @L_TF_Fin_Vigencia Is Null
			Begin
				Select		TN_CodTipoArma	Codigo,
							TC_Descripcion		Descripcion,
							TC_Observacion		Observacion,
							TF_Inicio_Vigencia	FechaActivacion,
							TF_Fin_Vigencia		FechaDesactivacion
				From		Catalogo.TipoArma		With(NoLock)
				Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@L_TC_Descripcion) 
				And			TF_Inicio_Vigencia	< GetDate()
				And			(
								TF_Fin_Vigencia	Is Null
					Or		
								TF_Fin_Vigencia	>= GetDate()
							)
				Order By	TC_Descripcion
			End Else
			Begin --Por activos:
				If @L_TF_Fin_Vigencia Is Null
				Begin
					Select		TN_CodTipoArma	Codigo,
								TC_Descripcion		Descripcion,
								TC_Observacion		Observacion,
								TF_Inicio_Vigencia	FechaActivacion,
								TF_Fin_Vigencia		FechaDesactivacion
					From		Catalogo.TipoArma		With(NoLock)
					Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@L_TC_Descripcion)
					And			(
									TF_Fin_Vigencia	> GetDate()
								Or
									TF_Fin_Vigencia	< GetDate()
								)
					Order By	TC_Descripcion
				End 
				Else				
				--Inactivos
				If @L_TF_Inicio_Vigencia Is Null And @L_TF_Fin_Vigencia Is Not Null	
					Begin
						Select		TN_CodTipoArma	As	Codigo,				TC_Descripcion	As	Descripcion,
									TC_Observacion	As	Observacion,			TF_Inicio_Vigencia	As	FechaActivacion,	
									TF_Fin_Vigencia	As	FechaDesactivacion
						From		Catalogo.TipoArma With(Nolock) 
						Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@L_TC_Descripcion) 
						And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
						Order By	TC_Descripcion;
					End	
				Else
					Begin --Si las dos fechas no son nulas, se listan los datos por rango de fechas de los inactivos
					If @L_TF_Inicio_Vigencia Is Not Null
					And @L_TF_Fin_Vigencia Is Not Null
					Begin
						Select		TN_CodTipoArma		Codigo,
									TC_Descripcion			Descripcion,
									TC_Observacion		Observacion,
									TF_Inicio_Vigencia		FechaActivacion,
									TF_Fin_Vigencia			FechaDesactivacion
						From		Catalogo.TipoArma			With(NoLock)
						Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@L_TC_Descripcion) 
						And			(
										TF_Fin_Vigencia		<= @L_TF_Fin_Vigencia
									And
										TF_Inicio_Vigencia	>= @L_TF_Inicio_Vigencia
									)
						Order By	TC_Descripcion
					End
				End
			End
		End
	End
End
GO
