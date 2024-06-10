SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<04/11/2019>
-- Descripción :			<Crea un nuevo registro en el hitorico ExpedienteEntradaSalida para la entrada de un legajo> 
-- =================================================================================================================================================
-- Modificación:		    <Andrew Allen Dawson> <11/11/2019> <Modifica para que se ajuste a la nueva estructaura de la tabla.>
-- Modificación:			<Aida E Siles Rojas> <15/07/2020> <Se modifica el nombre de la columna TF_Envio por TF_CreacionItineracion>
-- Modificación				<Aida E Siles Rojas> <31/07/2020> <Ajuste la fecha de creacion itineración debe ir NULL>
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_AgregarLegajoEntrada] 
	@CodExpedienteEntradaSalida	uniqueidentifier, 
	@CodContexto				varchar(4),
	@CodLegajo					uniqueidentifier
	
AS
BEGIN
	
	INSERT INTO [Historico].[LegajoEntradaSalida]
	(
		TU_CodLegajoEntradaSalida,		TC_CodContexto,			TF_Entrada,					TF_Salida,			
		TF_CreacionItineracion,			TC_CodContextoDestino,	TN_CodMotivoItineracion,	TU_CodLegajo

	)
	VALUES
	(
		@CodExpedienteEntradaSalida,	@CodContexto,			GETDATE(),					Null,
		NULL,						Null,					Null,						@CodLegajo
	)
END
GO
