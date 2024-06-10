SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<11/03/2021>
-- Descripción :			<Permite modificar un formato de variable> 
-- =================================================================================================================================================

CREATE PROCEDURE [Variable].[PA_ConsultarFormatoVariable]
AS
BEGIN

	SELECT	var_id_formato				AS	id_formato,
			rtrim(var_nombre)			AS	nombre,
			rtrim(var_formato)			AS	formato
	FROM	Variable.Formato	

END 
GO
