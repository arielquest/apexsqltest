SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<11/03/2021>
-- Descripción :			<Permite eliminar un formato de variable> 
-- =================================================================================================================================================

CREATE PROCEDURE [Variable].[PA_EliminarFormatoVariable]
	@id_Formato			int
AS
BEGIN

DECLARE
	@L_idFormato	int				= @id_formato

	DELETE
	FROM	Variable.Formato
	WHERE	var_id_formato		=	@L_idFormato
END
GO
