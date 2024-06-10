SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<14/03/2021>
-- Descripción :			<Se crea procedimiento para consultar el tipo de variables> 
-- =================================================================================================================================================

CREATE PROCEDURE [Variable].[PA_ConsultarTipoVariable] 
AS
BEGIN

SELECT 
	var_id_tipo AS Codigo, 
	var_nombre  AS Nombre
FROM 
	Variable.Tipo  WITH(NOLOCK)

END
GO
