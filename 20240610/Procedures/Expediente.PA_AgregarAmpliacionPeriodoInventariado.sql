SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Versión:		<1.0>
-- Creado por:	<Aaron Rios Retana>
-- Create date:	<13-12-2022>
-- Description:	<Permite agregar un registro en la tabla: Expediente.PeriodoInventarioAmpliacion.>
-- =============================================
CREATE   PROCEDURE [Expediente].[PA_AgregarAmpliacionPeriodoInventariado]
	@CodAmpliacion				UNIQUEIDENTIFIER,
	@CodPeriodo					UNIQUEIDENTIFIER,
	@Justificacion				varchar(255),
	@Funcionario				VARCHAR(30),
	@FechaAnterior				DATETIME2,
	@FechaAplicacion			DATETIME2,
	@NuevaFecha					DATETIME2
AS
BEGIN
	--Variables
	DECLARE	@L_CodAmpliacion				UNIQUEIDENTIFIER	=	@CodAmpliacion,
			@L_CodPeriodo					UNIQUEIDENTIFIER	=	@CodPeriodo,
			@L_Justificacion				varchar(255)		=	@Justificacion,
			@L_Funcionario					VARCHAR(30)			=	@Funcionario,
			@L_FechaAnterior				DATETIME2			=	@FechaAnterior,
			@L_FechaAplicacion				DATETIME2			=	@FechaAplicacion,
			@L_NuevaFecha					DATETIME2			=	@NuevaFecha

	UPDATE 
	EXPEDIENTE.PeriodoInventariado 
	SET 
	TF_FechaFinal = @L_NuevaFecha 
	WHERE 
	TU_CodPeriodo = @L_CodPeriodo

	INSERT INTO Expediente.PeriodoInventarioAmpliacion 
	(
		TU_CodPeriodo,
		TU_CodAmpliacion,
		TC_Justificacion,
		TF_FechaFinalAnterior,
		TF_FechaAplicacion,
		TC_UsuarioRed
	)
	VALUES
	(
		@L_CodPeriodo,
		@L_CodAmpliacion,
		@L_Justificacion,
		@L_FechaAnterior,
		@L_FechaAplicacion,
		@L_Funcionario
	)
END
GO
