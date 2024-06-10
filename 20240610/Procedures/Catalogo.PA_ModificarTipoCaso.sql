SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<28/01/2019>
-- Descripción :			<Permite Modificar un tipo de caso en la tabla Catalogo.TipoCaso> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoCaso] 
	@Codigo				smallint, 
	@Descripcion		varchar(255),
	@FechaDesactivacion datetime2
AS
BEGIN
	UPDATE Catalogo.TipoCaso
	SET TC_Descripcion      = @Descripcion,
		TF_Fin_Vigencia     = @FechaDesactivacion
	WHERE TN_CodTipoCaso	= @Codigo
END


GO
