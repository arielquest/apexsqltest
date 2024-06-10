SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Andrew Allen Dawson>
-- Fecha de creación:	<15/11/2019>
-- Descripción:			<Permite modificar un registro en la tabla: TipoAudiencia.>
-- ==================================================================================================================================================================================
CREATE Procedure [Catalogo].[PA_ModificarTipoAudiencia]
	@Codigo				SmallInt,
	@Descripcion		VarChar(120),
	@FechaActivacion	DateTime2(3)	= Null
As
Begin
	--Variables.
	Declare	@L_TN_CodTipoAudiencia	SmallInt		= @Codigo,
			@L_TC_Descripcion		VarChar(120)	= @Descripcion,
			@L_TF_Fin_Vigencia		DateTime2(3)	= @FechaActivacion
	--Lógica.
	Update	Catalogo.TipoAudiencia		With(RowLock)
	Set		TC_Descripcion		= @L_TC_Descripcion,
			TF_Fin_Vigencia		= @L_TF_Fin_Vigencia
	Where	TN_CodTipoAudiencia			= @L_TN_CodTipoAudiencia
End
GO
