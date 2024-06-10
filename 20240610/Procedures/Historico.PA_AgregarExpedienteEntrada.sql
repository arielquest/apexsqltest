SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<14/09/2015>
-- Descripción :			<Crea un nuevo registro en el hitorico ExpedienteEntradaSalida para la entrada de un expediente> 
-- =================================================================================================================================================
-- Modificación		<Johan Acosta> <05/12/2016> <Se cambio nombre de TC a TN>
-- Modificación		<Jonathan Aguilar Navarro> <30/04/2018> <Se cambia el campo TC_CodOficina por TC_CodContexto>
-- Modificación		<Andrew Allen Dawson> <04/11/2019> <Se agregan los campos TC_NumeroExpediente y TN_CodMotivoItineracion>
-- Modificación		<Andrew Allen Dawson> <11/11/2019> <Modifica para que se ajuste a la nueva estructaura de la tabla>
-- Modificación		<Aida E Siles Rojas> <15/07/2020> <Se modifica el nombre de la columna TF_Envio por TF_CreacionItineracion>
-- Modificación		<Aida E Siles Rojas> <30/07/2020> <Ajuste la fecha de creacion itineración debe ir NULL>
-- Modificación		<Andrew Allen Dawson> <04/08/2020> <Quita el parametro de fecha dde entrada y se sustituye por la funcion GETDATE()>
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_AgregarExpedienteEntrada] 
	@CodExpedienteEntradaSalida	uniqueidentifier, 
	@CodContexto				varchar(4),
	@NumeroExpediente			char(14)
	
AS
BEGIN
	INSERT INTO Historico.ExpedienteEntradaSalida
	(
		TU_CodExpedienteEntradaSalida,	TC_NumeroExpediente,	TC_CodContexto,			TF_Entrada,
		TF_CreacionItineracion,			TF_Salida,				TC_CodContextoDestino,	TN_CodMotivoItineracion
	)
	VALUES
	(
		@CodExpedienteEntradaSalida,	@NumeroExpediente,		@CodContexto,			GETDATE(),
		NULL,							Null,					Null,					Null
	)
END
GO
