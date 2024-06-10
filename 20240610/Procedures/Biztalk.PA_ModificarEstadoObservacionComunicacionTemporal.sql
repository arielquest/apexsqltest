SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=====================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Fabian Sequeira Gamboa>
-- Fecha de creación:		<18/05/2021>
-- Descripción:				<Modificar las comunicaciones temporales para una comunicacion automatica.>
-- =====================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<26/05/2021>
-- Descripción:				<Se modifica lógica de actualización para que sume 1 a columna TN_Intento,
--							cuando el estado anterior sean "Pendiente">
-- =====================================================================================================
-- Modificado por:			<Olger Gamboa C>
-- Fecha:					<30/05/2021>
-- Descripción:				<Se modifica lógica de actualización para que el intento lo maneje biztalk y 
--							por parámetro, se mantiene que solo actualice cuando el estado anterior sean "Pendiente">
-- =====================================================================================================

CREATE PROCEDURE [Biztalk].[PA_ModificarEstadoObservacionComunicacionTemporal]
(
	@TU_CodComunicacionAut UNIQUEIDENTIFIER,
	@TC_EstadoEnvio char(1),
	@TC_Observaciones varchar(255),
	@TN_Intento int=NULL
)
AS
	DECLARE @L_TU_CodComunicacionAut AS UNIQUEIDENTIFIER	=	@TU_CodComunicacionAut; 
	DECLARE @L_TC_EstadoEnvio AS CHAR(1)					=	@TC_EstadoEnvio; 
	DECLARE @L_TC_Observaciones AS varchar(255)				=	@TC_Observaciones; 
	DECLARE @L_TN_INTENTO INT								=	@TN_Intento;
BEGIN

	UPDATE		Comunicacion.ComunicacionRegistroAutomatico	
	SET			TC_EstadoEnvio			=	@TC_EstadoEnvio,
				TC_Observaciones		=	@L_TC_Observaciones,
				TN_Intento				=	ISNULL(@L_TN_INTENTO,TN_Intento)
	WHERE		TU_CodComunicacionAut	=	@L_TU_CodComunicacionAut
	AND			TC_EstadoEnvio			<>	'X'

END
GO
