SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Andrew Allen Dawson>
-- Fecha de creación:	<15/11/2019>
-- Descripción:			<Permite eliminar un registro en la tabla: TipoAudiencia.>
-- ==================================================================================================================================================================================
CREATE Procedure [Catalogo].[PA_EliminarTipoAudiencia]
	@Codigo	SmallInt
As
Begin
	--Variables.
	Declare @L_TN_CodTipoAudiencia	SmallInt	= @Codigo
	--Lógica.
	Delete
	From	Catalogo.TipoAudiencia	With(RowLock)
	Where	TN_CodTipoAudiencia		= @L_TN_CodTipoAudiencia
End
GO
