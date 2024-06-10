SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez>
-- Fecha de creación:		<22/04/2016>
-- Descripción :			<Permite eliminar un criterio de busqueda.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Consulta].[PA_EliminarCriterio]
 
	@CodCriterio				smallint
 
AS 
BEGIN
	 Delete from Consulta.Criterio Where TN_CodCriterio = @CodCriterio
END
GO
