SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan  Manuel Acosta Ibañez>
-- Fecha de creación:	<22/04/2021>
-- Descripción:			<Permite Modificar un registro en la tabla: RepartoEvento.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Historico].[PA_ModificarRepartoEvento]
	@CodContexto				VARCHAR(4),
	@CodPuestoTrabajo			VARCHAR(14)
AS
BEGIN

	--Variables
	DECLARE			@L_TC_CodContexto		            VARCHAR(4)		    = @CodContexto,
					@L_TC_CodPuestoTrabajo				VARCHAR(14)			= @CodPuestoTrabajo

	UPDATE	[Historico].[RepartoEvento]
	SET		TN_CantidadCitas	= TN_CantidadCitas + 1,
			TF_Actualizacion	= Getdate()		
	WHERE	TC_CodContexto		= @L_TC_CodContexto
	AND		TC_CodPuestoTrabajo	= @L_TC_CodPuestoTrabajo
END
GO
