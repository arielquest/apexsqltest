SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aída E Siles>
-- Fecha de creación:		<31/01/2019>
-- Descripción :			<Permite eliminar una asociación entre tipo de caso y materia.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarTipoCasoMateria]
   @CodTipoCaso			smallint,
   @CodMateria			varchar(5)
AS 
BEGIN
	DELETE FROM		Catalogo.TipoCasoMateria
	WHERE			TN_CodTipoCaso		= @CodTipoCaso
	AND				TC_CodMateria		= @CodMateria;
END

GO
