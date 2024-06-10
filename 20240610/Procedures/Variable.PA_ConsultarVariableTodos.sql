SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<12/03/2021>
-- Descripción :			<Permite consultar todas las variables existes> 
-- =================================================================================================================================================

CREATE PROCEDURE [Variable].[PA_ConsultarVariableTodos]
AS
BEGIN

	SELECT	
			var_variable						AS id_variable,
			LTRIM(RTRIM(var_nombre))			AS nombre,
			var_tipo							AS tipo,
			var_multiple						AS multiple,
			LTRIM(RTRIM(var_formato))			AS nombre_formato,
			var_dato1							AS dato1,
			LTRIM(RTRIM(var_dato2))				AS dato2,
			LTRIM(RTRIM(var_observacion))		AS observacion,
			nombreConexion						AS nombreConexion
	FROM	
			Variable.Variable	WITH(NOLOCK)

		



END 
GO
