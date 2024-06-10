SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:				<Esteban Cordero Benavides.>
-- Fecha Creación:		<04 de abril de 2016.>
-- Descripcion:			<Permitir agregar un registro en la tabla TipoOficinaFormatoArchivo.>
-- ==========================================================================================
CREATE Procedure [Catalogo].[PA_AgregarTipoOficinaFormatoArchivo]
	@TC_CodTipoOficina			SmallInt,
	@TN_CodFormatoArchivo		Int,
	@TN_LimiteSubida			BigInt,
	@TN_LimiteSubidaMasivo		BigInt,
	@TN_LimiteDescargaMasivo	BigInt,
	@TF_Inicio_Vigencia			DateTime2

As
Begin
	Insert Into	Catalogo.TipoOficinaFormatoArchivo
	(
		TN_CodTipoOficina,			TN_CodFormatoArchivo,	TN_LimiteSubida,	TN_LimiteSubidaMasivo,
		TN_LimiteDescargaMasivo,	TF_Inicio_Vigencia
	)
	Values
	(
		@TC_CodTipoOficina,			@TN_CodFormatoArchivo,	@TN_LimiteSubida,	@TN_LimiteSubidaMasivo,
		@TN_LimiteDescargaMasivo,	@TF_Inicio_Vigencia
	)
End;
GO
