SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Méndez Chavarría>
-- Fecha de creación:		<25/04/2016>
-- Descripción :			<Permite eliminar un seccion de busqueda.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Consulta].[PA_EliminarSeccion]
 
	@CodSeccion		smallint
 
AS 
BEGIN
	 Delete 
	 From	Consulta.Seccion
	 Where	TN_CodSeccion = @CodSeccion
END
GO
