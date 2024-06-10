SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<26/01/2016>
-- Descripción :			<Permite eliminar el registro de un perfil de victima de un interviniente.> 
-- ==========================================================================================================
-- Modificación				<29/06/2020> <Isaac Dobles> <Se agrega manejo de variables locales>
-- ==========================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarIntervinienteVictima]  
   @CodigoInterviniente uniqueidentifier,
   @CodigoVictima		uniqueidentifier

AS 
BEGIN

	DECLARE	
	@L_TU_CodInterviniente	uniqueidentifier	= @CodigoInterviniente,
	@L_TU_CodVictima		uniqueidentifier	= @CodigoVictima

	DELETE 
	FROM	Expediente.IntervinienteVictima
	WHERE	TU_CodInterviniente					= @L_TU_CodInterviniente
	AND		TU_CodVictima						= @L_TU_CodVictima

END
GO
