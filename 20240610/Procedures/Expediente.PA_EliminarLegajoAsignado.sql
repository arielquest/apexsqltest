SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Xinia Soto>
-- Fecha Creación:		<12/06/2020>
-- Descripcion:			<Eliminar un funcionario asignado a un legajo.>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarLegajoAsignado] 
	@CodigoLegajo				uniqueidentifier,
	@CodPuestoTrabajo			varchar(14)
AS
BEGIN

DECLARE @V_CodigoLegajo		uniqueidentifier = @CodigoLegajo
DECLARE @V_CodPuestoTrabajo	varchar(14)      = @CodPuestoTrabajo


	DELETE	Historico.LegajoAsignado
	WHERE	TU_CodLegajo					= @V_CodigoLegajo
	AND		TC_CodPuestoTrabajo				= @V_CodPuestoTrabajo
END
GO
