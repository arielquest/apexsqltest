SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan  Manuel Acosta Ibañez>
-- Fecha de creación:	<22/04/2021>
-- Descripción:			<Permite agregar un registro en la tabla: RepartoEvento.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_AgregarRepartoEvento]
	@CodContexto				VARCHAR(4),
	@CodPuestoTrabajo			VARCHAR(14),
	@CantidadCitas				INT
AS
BEGIN
	--Variables
	DECLARE			@L_TC_CodContexto		            VARCHAR(4)		    = @CodContexto,
					@L_TC_CodPuestoTrabajo				VARCHAR(14)			= @CodPuestoTrabajo,
					@L_TN_CantidadCitas					INT					= @CantidadCitas
	--Cuerpo
	INSERT INTO	Historico.RepartoEvento	WITH (ROWLOCK)
	(
		TC_CodContexto,		TC_CodPuestoTrabajo,	TN_CantidadCitas,		TF_Actualizacion					
	)
	VALUES
	(
		@L_TC_CodContexto,	@L_TC_CodPuestoTrabajo,	@L_TN_CantidadCitas,	GETDATE()				
	)
END
GO
