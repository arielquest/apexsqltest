SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>-- Creado por:			<Henry Méndez Ch>-- Fecha de creación:	<08/10/2020>-- Descripción:			<Permite eliminar un registro en la tabla: AudienciaLegajo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_EliminarAudienciaLegajo]

	@CodAudiencia				bigint,
	@CodLegajo					uniqueidentifier
AS
BEGIN
	--Variables
	DECLARE	@L_CodAudiencia		bigint				=	@CodAudiencia
	DECLARE	@L_CodLegajo		uniqueidentifier	=	@CodLegajo

	--Lógica
	DELETE
	FROM	Expediente.AudienciaLegajo	WITH (ROWLOCK)
	WHERE	TN_CodAudiencia				=	@L_CodAudiencia
	AND		TU_CodLegajo				=	@L_CodLegajo
END
GO
