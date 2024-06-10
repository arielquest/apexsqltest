SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Andrew Allen Dawson>
-- Fecha de creación:	<15/11/2019>
-- Descripción:			<Permite consultar un registro en la tabla: TipoAudiencia.>
-- ==================================================================================================================================================================================
CREATE Procedure [Catalogo].[PA_ConsultarTipoAudiencia]
	@Codigo				SmallInt		= Null,
	@Descripcion		VarChar(120)	= Null,
	@FechaActivacion	DateTime2		= Null,
	@FechaDesactivacion	DateTime2		= Null
As
Begin
	--Variables.
	Declare	@L_TN_CodTipoAudiencia	SmallInt		= @Codigo,
			@L_TF_Inicio_Vigencia	DateTime2(3)	= @FechaActivacion,
			@L_TF_Fin_Vigencia		DateTime2(3)	= @FechaDesactivacion,
			@L_TC_Descripcion		VarChar(Max)	= Iif (@Descripcion Is Not Null, '%' + dbo.FN_RemoverTildes(@Descripcion) + '%', '%')
	--Lógica.
	--Todos.
	If	@L_TF_Inicio_Vigencia	Is Null
	And	@L_TF_Fin_Vigencia		Is Null
	Begin
		Select		TN_CodTipoAudiencia							Codigo,
					TC_Descripcion							Descripcion,
					TF_Inicio_Vigencia						FechaActivacion,
					TF_Fin_Vigencia							FechaDesactivacion
		From		Catalogo.TipoAudiencia							With(NoLock)
		Where		dbo.FN_RemoverTildes(TC_Descripcion)	Like @L_TC_Descripcion
		And			TN_CodTipoAudiencia							= Coalesce(@L_TN_CodTipoAudiencia, TN_CodTipoAudiencia)
		Order By	TC_Descripcion
	End	Else
	Begin
		--Activos.
		If	@L_TF_Inicio_Vigencia	Is Not Null
		And	@L_TF_Fin_Vigencia		Is Null
		Begin
			Select			TN_CodTipoAudiencia							Codigo,
							TC_Descripcion							Descripcion,
							TF_Inicio_Vigencia						FechaActivacion,
							TF_Fin_Vigencia							FechaDesactivacion
			From			Catalogo.TipoAudiencia							With(NoLock)
			Where			dbo.FN_RemoverTildes(TC_Descripcion)	Like @L_TC_Descripcion
			And				TF_Inicio_Vigencia						< GetDate()
			And				(
								TF_Fin_Vigencia						Is Null
							Or
								TF_Fin_Vigencia						>= GetDate()
							)
			And				TN_CodTipoAudiencia							= Coalesce(@L_TN_CodTipoAudiencia, TN_CodTipoAudiencia)
			Order By		TC_Descripcion
		End Else
		Begin
			--Inactivos.
			If	@L_TF_Inicio_Vigencia	Is Null
			And	@L_TF_Fin_Vigencia		Is Not Null
			Begin
				Select			TN_CodTipoAudiencia							Codigo,
								TC_Descripcion							Descripcion,
								TF_Inicio_Vigencia						FechaActivacion,
								TF_Fin_Vigencia							FechaDesactivacion
				From			Catalogo.TipoAudiencia							With(NoLock)
				Where			dbo.FN_RemoverTildes(TC_Descripcion)	Like @L_TC_Descripcion
				And				(
									TF_Inicio_Vigencia					> GetDate()
								Or
									TF_Fin_Vigencia						< GetDate()
								)
				And				TN_CodTipoAudiencia							= Coalesce(@L_TN_CodTipoAudiencia, TN_CodTipoAudiencia)
				Order By		TC_Descripcion
			End Else
			Begin
				--Inactivos por fecha.
				If	@L_TF_Inicio_Vigencia	Is Not Null
				And	@L_TF_Fin_Vigencia		Is Not Null
				Begin
					Select			TN_CodTipoAudiencia							Codigo,
									TC_Descripcion							Descripcion,
									TF_Inicio_Vigencia						FechaActivacion,
									TF_Fin_Vigencia							FechaDesactivacion
					From			Catalogo.TipoAudiencia							With(NoLock)
					Where			dbo.FN_RemoverTildes(TC_Descripcion)	Like @L_TC_Descripcion
					And				(
										TF_Inicio_Vigencia					> @L_TF_Inicio_Vigencia
									Or
										TF_Fin_Vigencia						< @L_TF_Fin_Vigencia
									)
					And				TN_CodTipoAudiencia							= Coalesce(@L_TN_CodTipoAudiencia, TN_CodTipoAudiencia)
					Order By		TC_Descripcion
				End
			End
		End
	End
End
GO
