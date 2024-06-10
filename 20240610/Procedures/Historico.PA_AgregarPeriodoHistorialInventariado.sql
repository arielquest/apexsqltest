SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Versión:		<1.0>
-- Creado por:	<Oscar Sánchez Hernández>
-- Create date:	<27-12-2022>
-- Description:	<Permite agregar un registro en la tabla: Historico.HistoricoInventariado.>
-- =============================================
CREATE   PROCEDURE [Historico].[PA_AgregarPeriodoHistorialInventariado]
	@CodigoHistoricoInventariado	UNIQUEIDENTIFIER,
	@CodigoPeriodo					UNIQUEIDENTIFIER,
	@CodigoLegajo					UNIQUEIDENTIFIER,
	@NumeroExpediente				char(14),
	@DetalleInventariado			VARCHAR(255),
	@FechaAplicado					DATETIME2,
	@Funcionario					VARCHAR(30)
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodHistoricoInventariado UNIQUEIDENTIFIER = @CodigoHistoricoInventariado,
			@L_TU_CodPeriodo	UNIQUEIDENTIFIER	= @CodigoPeriodo,
			@L_TU_CodigoLegajo	UNIQUEIDENTIFIER			= @CodigoLegajo,
			@L_TC_NumeroExpediente	char(14)			= @NumeroExpediente,
			@L_TC_DetalleInventariado		VARCHAR(255)		= @DetalleInventariado,
			@L_TF_FechaAplicado		DATETIME2		= @FechaAplicado,
			@L_TC_Funcionario		VARCHAR(30)		= @Funcionario

	INSERT INTO Historico.HistoricoInventariado 
	(
		TU_CodHistoricoInventariado,
		TU_CodPeriodo,
		TU_CodLegajo,
		TC_NumeroExpediente,
		TC_DetalleInventariado,
		TF_FechaAplicacion,
		TC_UsuarioRed
	)
	VALUES
	(
		@L_TU_CodHistoricoInventariado,
		@L_TU_CodPeriodo,
		@L_TU_CodigoLegajo,
		@L_TC_NumeroExpediente,
		@L_TC_DetalleInventariado,
		@L_TF_FechaAplicado,
		@L_TC_Funcionario
	)
END
GO
