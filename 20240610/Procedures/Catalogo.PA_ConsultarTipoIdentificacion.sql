SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Autor:				<Roger Lara>
-- Fecha Creación:		<20 de agosto de 2015>
-- Descripcion:			<Permite Consultar  tipo de identificacion>
-- =================================================================================================================================================
-- Modificación:		<23/10/2015> <Roge Lara> <Incluir fecha de activación para realizar la consulta de activos.>
-- Modificación:		<06/01/2016> <Alejandro Villalta> <Cambiar tipo de dato del codigo del catalogo tipo identificación>
-- Modificación:		<07/04/2016> <Esteban Cordero Benavides.> <Se agrega el campo TB_Nacional para indicar los tipos de identificación nacional.>
-- Modificación:		<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:		<12/08/2016> <Johan Acosta.> <Se agrega el campo TC_Formato para indicar el formato del tipo de identificación.>
-- Modificación:		<02/12/2016> <Johan Acosta.> <Se cambio nombre de TC a TN>
-- Modificación:        <04/10/2017> <Diego Chavarria> <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--					     también se elimina el IF Null de Código del select Todos>
-- Modificación:        <28/11/2017> <Jonathan Aguilar Navarro> <Se agrea a la consulta el campo EsJuridico, ya que no lo traia>
-- Modificación:	    <15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- Modificación:	    <24/01/2018> <Jonathan Aguilar> <Se agrega a la consultas el campo TB_EsIgnorado>
-- =================================================================================================================================================

CREATE Procedure [Catalogo].[PA_ConsultarTipoIdentificacion]
	@TC_CodTipoIdentificacion	SmallInt		= Null,
	@TC_Descripcion				VarChar(255)	= Null,
	@TF_Inicio_Vigencia			DateTime2(3)	= Null,
	@TF_Fin_Vigencia			DateTime2(3)	= Null
As
Begin
	--Variable para almacenar la descripcion.
	Declare	@ExpresionLike VarChar(257);
	Set	@ExpresionLike	= iif(@TC_Descripcion Is Not Null, '%' + @TC_Descripcion + '%', '%')

	--Si todo es nulo se devuelven todos los registros
	If	@TF_Inicio_Vigencia Is Null And @TF_Fin_Vigencia Is Null
	Begin	
			Select		TN_CodTipoIdentificacion Codigo,	TC_Descripcion Descripcion,	TF_Inicio_Vigencia FechaActivacion,	TF_Fin_Vigencia FechaDesactivacion,
						TB_Nacional Nacional,				TC_Formato Formato,			TB_EsJuridico EsJuridico, 
						TB_EsIgnorado EsIgnorado
			From		Catalogo.TipoIdentificacion			With(NoLock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			and			TN_CodTipoIdentificacion=COALESCE(@TC_CodTipoIdentificacion,TN_CodTipoIdentificacion)
			Order By	TC_Descripcion
	End

		Else Begin
			If @TF_Fin_Vigencia Is Null And @TF_Inicio_Vigencia Is Not Null
			Begin
				Select		TN_CodTipoIdentificacion Codigo,	TC_Descripcion	Descripcion,	TF_Inicio_Vigencia FechaActivacion,	TF_Fin_Vigencia FechaDesactivacion,
							TB_Nacional Nacional,				TC_Formato Formato,			TB_EsJuridico EsJuridico,	
							TB_EsIgnorado EsIgnorado
				From		Catalogo.TipoIdentificacion			With(NoLock)
				Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
				And			TF_Inicio_Vigencia					< GetDate()
				And			(
								TF_Fin_Vigencia					Is Null
							Or
								TF_Fin_Vigencia					>= GetDate()
							)
				and			TN_CodTipoIdentificacion=COALESCE(@TC_CodTipoIdentificacion,TN_CodTipoIdentificacion)
				Order By	TC_Descripcion
			End
			Else Begin
				If @TF_Fin_Vigencia Is Not Null And @TF_Inicio_Vigencia Is Null
				Begin
					Select		TN_CodTipoIdentificacion Codigo,	TC_Descripcion Descripcion,	TF_Inicio_Vigencia FechaActivacion,	TF_Fin_Vigencia FechaDesactivacion,
								TB_Nacional Nacional,				TC_Formato Formato,	TB_EsJuridico EsJuridico,
								TB_EsIgnorado EsIgnorado
					From		Catalogo.TipoIdentificacion			With(NoLock)
					Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
					And			(
									TF_Inicio_Vigencia				> GetDate()
								Or
									TF_Fin_Vigencia					< GetDate()
								)
					and			TN_CodTipoIdentificacion=COALESCE(@TC_CodTipoIdentificacion,TN_CodTipoIdentificacion)
					Order By	TC_Descripcion
				End
				Else Begin
					If @TF_Fin_Vigencia Is Not Null And @TF_Inicio_Vigencia Is Not Null
					Begin
						Select		TN_CodTipoIdentificacion Codigo,	TC_Descripcion Descripcion,	TF_Inicio_Vigencia FechaActivacion,	TF_Fin_Vigencia FechaDesactivacion,
									TB_Nacional Nacional,				TC_Formato Formato,			TB_EsJuridico EsJuridico,
									TB_EsIgnorado EsIgnorado
						From		Catalogo.TipoIdentificacion			With(NoLock)
						Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
						And			TF_Inicio_Vigencia					>= @TF_Inicio_Vigencia
						And			TF_Fin_Vigencia						<= @TF_Fin_Vigencia 
						and			TN_CodTipoIdentificacion=COALESCE(@TC_CodTipoIdentificacion,TN_CodTipoIdentificacion)
						Order By	TC_Descripcion
					End
				End
			End
		End
	End
GO
