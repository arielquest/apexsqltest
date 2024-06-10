SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Cristian Cerdas Camacho>
-- Fecha de creación:		<17/04/2020>
-- Descripción:				<Registra la notificación de un medio accesorio, cuando el contexto tiene activo el envío automático
--                           al medio accesorio.> 
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ObtenerCorreoContexto]
(
	@CodigoContexto			VARCHAR(4)
)
AS
BEGIN
	SET NOCOUNT ON;

	 SELECT TC_Email AS 'Correo' FROM [Catalogo].[Contexto] WHERE TC_CodContexto = @CodigoContexto

END
GO
