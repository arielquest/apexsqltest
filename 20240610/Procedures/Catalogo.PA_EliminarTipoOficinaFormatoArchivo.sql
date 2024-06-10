SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================================
-- Autor:				<Esteban Cordero Benavides.>
-- Fecha Creación:		<04 de abril de 2016.>
-- Descripcion:			<Permitir eliminar un registro en la tabla TipoOficinaFormatoArchivo.>
-- ===========================================================================================
CREATE Procedure [Catalogo].[PA_EliminarTipoOficinaFormatoArchivo]
	@TC_CodTipoOficina		SmallInt,
	@TN_CodFormatoArchivo	Int
As
Begin
	Delete
	From	Catalogo.TipoOficinaFormatoArchivo	With(RowLock)
	Where	TN_CodTipoOficina					= @TC_CodTipoOficina
	And		TN_CodFormatoArchivo				= @TN_CodFormatoArchivo
End;

GO
