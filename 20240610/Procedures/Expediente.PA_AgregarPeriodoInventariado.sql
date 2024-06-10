SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Versión:		<1.0>
-- Creado por:	<Aaron Rios Retana>
-- Create date:	<13-12-2022>
-- Description:	<Permite agregar un registro en la tabla: Expediente.PeriodoInventariado.>
-- =============================================
CREATE   PROCEDURE [Expediente].[PA_AgregarPeriodoInventariado]
	@CodPeriodo					UNIQUEIDENTIFIER,
	@CodContexto				VARCHAR(4),
	@NombrePeriodo				VARCHAR(20),
	@FechaInicio				DATETIME2,
	@FechaFinal					DATETIME2
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodPeriodo	UNIQUEIDENTIFIER	= @CodPeriodo,
			@L_TC_CodContexto	VARCHAR(4)			= @CodContexto,
			@L_TC_NombrePeriodo	VARCHAR(20)			= @NombrePeriodo,
			@L_TF_FechaInicio		DATETIME2		= @FechaInicio,
			@L_TF_FechaFinal		DATETIME2		= @FechaFinal

	INSERT INTO Expediente.PeriodoInventariado 
	(
		TU_CodPeriodo,
		TC_CodContexto,
		TC_NombrePeriodo,
		TF_Fechainicio,
		TF_FechaFinal
	)
	VALUES
	(
		@L_TU_CodPeriodo,
		@L_TC_CodContexto,
		@L_TC_NombrePeriodo,
		@L_TF_FechaInicio,
		@L_TF_FechaFinal
	)
END
GO
