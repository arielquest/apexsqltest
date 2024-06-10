SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================
-- Autor:				<Esteban Cordero Benavides.>
-- Fecha Creación:		<15 de abril de 2016.>
-- Descripcion:			<Permite modificar un tipo de archivo en la tabla Catalogo.TipoArchivo.>
-- ==========================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE Procedure [Catalogo].[PA_ModificarTipoArchivo]
	@TN_CodTipoArchivo	Int,
	@TC_Descripcion		VarChar(100),
	@TC_CodMateria		VarChar(5),
	@TC_CodPrioridad	SmallInt,
	@TF_Inicio_Vigencia	DateTime2,
	@TF_Fin_Vigencia	DateTime2
As
Begin
	Update	Catalogo.TipoArchivo	With(RowLock)
	Set		TC_Descripcion			= @TC_Descripcion,
			TC_CodMateria			= @TC_CodMateria,
			TN_CodPrioridad			= @TC_CodPrioridad,
			TF_Inicio_Vigencia		= @TF_Inicio_Vigencia,
			TF_Fin_Vigencia			= @TF_Fin_Vigencia
	Where	TN_CodTipoArchivo		= @TN_CodTipoArchivo
End;
GO
