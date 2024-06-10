SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<25/01/2021>
-- Descripción :			<Permite consultar el valor del campo COONVERSATIONTOPIC en la BD de Itineraciones, necesario para enviar respuestas a Itineraciones Gestión>
-- =============================================================================================================================================================================
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarConversationTopic]
	@CodItineracion Uniqueidentifier = null
AS 

BEGIN
--Variables 
DECLARE	@L_CodItineracion	Uniqueidentifier	= @CodItineracion

--Cuerpo

SELECT	CONVERSATIONTOPIC 
FROM	ItineracionesSIAGPJ.dbo.MESSAGES 
WHERE	ID										= @L_CodItineracion

END
GO
