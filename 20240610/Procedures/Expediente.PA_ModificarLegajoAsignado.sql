SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<25/03/2019>
-- Descripcion:			<Modificar un funcionario asignado a un legajo.>
-- =================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto> <Se agrega parametor de ESRESPONSABLE para modificación>
-- =================================================================================================================================================
CREATE   PROCEDURE [Expediente].[PA_ModificarLegajoAsignado] 
	@CodigoLegajo				UNIQUEIDENTIFIER,
	@CodPuestoTrabajo			VARCHAR(14),
	@FechaFinVigencia			DATETIME2(7),
	@EsResponsable				BIT
AS
BEGIN

	 DECLARE	@L_CodigoLegajo				UNIQUEIDENTIFIER	=	@CodigoLegajo,
				@L_CodPuestoTrabajo			VARCHAR(14)			=	@CodPuestoTrabajo,
				@L_FechaFinVigencia			DATETIME2(7)		=	@FechaFinVigencia,
				@L_EsResponsable			BIT					=	@EsResponsable

	UPDATE		Historico.LegajoAsignado
	SET			TF_Fin_Vigencia									=	@L_FechaFinVigencia,
				TB_EsResponsable								=   @L_EsResponsable
	WHERE		TU_CodLegajo									=	@L_CodigoLegajo
	AND			TC_CodPuestoTrabajo								=	@L_CodPuestoTrabajo
END
GO
