SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<06/02/2020>
-- Descripción:			<Permite Des-agrupar el registro de objeto del objeto padre que tenga relacionado>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_DesAgruparObjeto]
	@Codigo					UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto				UNIQUEIDENTIFIER	= @Codigo
	--Lógica
	UPDATE	Objeto.Objeto				WITH (ROWLOCK)
	SET		TU_CodigoObjetoPadre		= NULL,			
			TF_Actualizacion			= GETDATE()
	WHERE	TU_CodObjeto				= @L_TU_CodObjeto
END
GO
