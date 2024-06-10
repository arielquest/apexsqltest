SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<26/03/2020>
-- Descripción:			<Permite actualizar la oficina asignada a un registro en la tabla: Objeto.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ModificarOficinaRecibe]
	@Codigo					UNIQUEIDENTIFIER,
	@CodOficina				VARCHAR(4)
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto				UNIQUEIDENTIFIER	= @Codigo,
			@L_TC_CodOficina			VARCHAR(4)			= @CodOficina
	--Lógica
	UPDATE	Objeto.Objeto				WITH (ROWLOCK)
	SET		TC_CodOficina				= @L_TC_CodOficina,			
			TF_Actualizacion			= GETDATE()
	WHERE	TU_CodObjeto				= @L_TU_CodObjeto
END
GO
