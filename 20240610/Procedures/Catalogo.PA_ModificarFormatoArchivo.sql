SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================
-- Autor:				<Pablo Alvarez>
-- Fecha Creación:		<19 de febrero de 2016.>
-- Descripcion:			<Modificar un FormatoArchivo.>
-- Modificación:		<Andrés Díaz>
-- Fecha Modificación:	<01 de abril de 2016.>
-- Descripcion:			<Se agrega el campo TC_Extensiones>
-- Modificación:		<Esteban Cordero Benavides.>
-- Fecha Modificación:	<04 de abril de 2016.>
-- Descripcion:			<Se Modifica todo el procedimiento para que se refiera a FormatoArchivo y no a TipoArchivo.>
-- =================================================================================================================
CREATE Procedure [Catalogo].[PA_ModificarFormatoArchivo]
	@TN_CodFormatoArchivo	SmallInt,
	@TC_Descripcion			VarChar(100),
	@TC_Extensiones			VarChar(100),
	@TF_Inicio_Vigencia		DateTime2,
	@TF_Fin_Vigencia		DateTime2
As
Begin
	Update	Catalogo.FormatoArchivo		With(RowLock)
	Set		TC_Descripcion				= @TC_Descripcion,
			TC_Extensiones				= @TC_Extensiones,
			TF_Inicio_Vigencia			= @TF_Inicio_Vigencia,
			TF_Fin_Vigencia				= @TF_Fin_Vigencia
	Where	TN_CodFormatoArchivo		= @TN_CodFormatoArchivo
End;
GO
