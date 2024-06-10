SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<19/08/2021>
-- Descripcion:			<Elimina una entidad jurídica>
-- ======================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarEntidadJuridica]
	@Identificacion				Varchar(255)
AS
BEGIN

	DECLARE
	@L_Identificacion			Varchar(255) = @Identificacion

	DELETE 	FROM	Catalogo.EntidadJuridica
	Where	TC_Identificacion	= @L_Identificacion
END
GO
