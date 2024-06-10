SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<11/03/2021>
-- Descripción :			<Permite modificar un formato de variable> 
-- =================================================================================================================================================

CREATE PROCEDURE [Variable].[PA_ModificarFormatoVariable]
	@id_Formato			int, 
	@nombre			varchar(30),
	@formato		varchar(100)
AS
BEGIN

DECLARE
	@L_idFormato	int				= @id_formato,
	@L_nombre		varchar(30)		= @nombre,
	@L_formato		varchar(100)	= @formato


	UPDATE	Variable.Formato
	SET     var_nombre			=	@L_nombre,
			var_formato			=	@L_formato
	WHERE	var_id_formato		=	@L_idFormato
END

GO
