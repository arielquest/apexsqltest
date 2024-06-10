SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Andrew Allen Dawson>
-- Fecha de creación:	<15/11/2019>
-- Descripción:			<Permite agregar un registro en la tabla: TipoAudiencia.>
-- ==================================================================================================================================================================================
CREATE Procedure [Catalogo].[PA_AgregarTipoAudiencia]
	@Descripcion		VarChar(120),
	@FechaActivacion	DateTime2(3),
	@FechaDesactivacion	DateTime2(3)	= Null
As
Begin
	--Variables.
Declare @L_TC_Descripcion		VarChar(120)	= @Descripcion,
		@L_TF_Inicio_Vigencia	DateTime2(3)	= @FechaActivacion,
		@L_TF_Fin_Vigencia		DateTime2(3)	= @FechaDesactivacion
	--Lógica.
	Insert Into	Catalogo.TipoAudiencia With(RowLock)
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@L_TC_Descripcion,	@L_TF_Inicio_Vigencia,	@L_TF_Fin_Vigencia
	)
End
GO
