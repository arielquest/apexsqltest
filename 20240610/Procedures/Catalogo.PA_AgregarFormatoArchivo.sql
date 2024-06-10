SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================
-- Autor:				<Pablo Alvarez>
-- Fecha Creación:		<19 de febrero de 2016.>
-- Descripcion:			<Permitir agregar registro en la tabla FormatoArchivo.>
-- Modificación:		<Andrés Díaz>
-- Fecha Modificación:	<01 de abril de 2016.>
-- Descripcion:			<Se agrega el campo TC_Extensiones>
-- Modificación:		<Esteban Cordero Benavides.>
-- Fecha Modificación:	<04 de abril de 2016.>
-- Descripcion:			<Se Modifica todo el procedimiento para que se refiera a FormatoArchivo y no a TipoArchivo.>
-- =================================================================================================================
CREATE Procedure [Catalogo].[PA_AgregarFormatoArchivo]
	@TC_Descripcion		VarChar(100),
	@TC_Extensiones		VarChar(100),
	@TF_Inicio_Vigencia	DateTime2,
	@TF_Fin_Vigencia	DateTime2
As
Begin
	Insert Into	Catalogo.FormatoArchivo
	(
		TC_Descripcion,		TC_Extensiones,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@TC_Descripcion,	@TC_Extensiones,	@TF_Inicio_Vigencia,	@TF_Fin_Vigencia
	)
End;
GO
