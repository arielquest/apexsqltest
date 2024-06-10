SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<12/03/2021>
-- Descripción :			<Permite consultar una las variables existes> 
-- =================================================================================================================================================

CREATE PROCEDURE [Variable].[PA_ConsultarVariable]
	@var_variable int
AS
BEGIN

DECLARE
	@L_var_variable int	= @var_variable;


	SELECT	
			[var_variable]		AS id_variable, 
			[var_nombre]		AS nombre, 
			[var_tipo]			AS tipo, 
			[var_multiple]		AS multiple, 
			[var_formato]		AS nombre_formato, 
			[var_dato1]			AS dato1, 
			[var_dato2]			AS dato2, 
			[var_observacion]	AS observacion
	FROM	
			Variable.Variable	WITH(NOLOCK)
	WHERE 
			var_variable = @L_var_variable;

END 
GO
