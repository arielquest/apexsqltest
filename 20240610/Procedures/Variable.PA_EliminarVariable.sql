SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<12/03/2021>
-- Descripción :			<Permite eliminar una variable existe> 
-- =================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_EliminarVariable]
	@var_variable int
AS

DECLARE
	@L_var_variable int	= @var_variable;

DELETE FROM 
	[Variable].[Variable]
WHERE 
	var_variable = @L_var_variable;
GO
