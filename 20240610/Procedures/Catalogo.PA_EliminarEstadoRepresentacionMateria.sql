SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aída E Siles>
-- Fecha de creación:		<14/02/2019>
-- Descripción :			<Permite eliminar una asociación entre estado de representación y materia.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarEstadoRepresentacionMateria]
   @CodEstadoRepresentacion		smallint,
   @CodMateria					varchar(5)
AS 
BEGIN
	DELETE FROM		Catalogo.EstadoRepresentacionMateria
	WHERE			TN_CodEstadoRepresentacion	= @CodEstadoRepresentacion
	AND				TC_CodMateria				= @CodMateria;
END

GO
