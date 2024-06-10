SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<06/02/2020>
-- Descripción:			<Permite agrupar el registro de objeto con el objeto padre que se indica en el parámetro respectivo, siempre que no sea un contenedor>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_AgruparObjeto]
	@Codigo					UNIQUEIDENTIFIER,
	@CodObjetoPadre			UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto				UNIQUEIDENTIFIER	= @Codigo,
			@L_TU_CodObjetoPadre		UNIQUEIDENTIFIER	= @CodObjetoPadre
	--Lógica
	UPDATE	Objeto.Objeto				WITH (ROWLOCK)
	SET		TU_CodigoObjetoPadre		= @L_TU_CodObjetoPadre,			
			TF_Actualizacion			= GETDATE()
	WHERE	TU_CodObjeto				= @L_TU_CodObjeto
	AND 	TB_Contenedor 				= 0
END
GO
