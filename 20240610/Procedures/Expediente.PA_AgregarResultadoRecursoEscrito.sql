SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Oscar Sanchez H>
-- Fecha de creación:	<12/08/2022>
-- Descripción:			<Permite agregar un registro en la tabla: ResultadoRecursoEscrito.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarResultadoRecursoEscrito]
	@CodResultadoRecurso		UNIQUEIDENTIFIER,
	@CodEscrito				UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodResultadoRecurso		UNIQUEIDENTIFIER		= @CodResultadoRecurso,
			@L_TU_CodEscrito    			UNIQUEIDENTIFIER		= @CodEscrito
	--Cuerpo
	INSERT INTO	Expediente.ResultadoRecursoEscrito	WITH (ROWLOCK)
	(
		TU_CodResultadoRecurso,			TU_CodEscrito			
	)
	VALUES
	(
		@L_TU_CodResultadoRecurso,		@L_TU_CodEscrito				
	)
END
GO
