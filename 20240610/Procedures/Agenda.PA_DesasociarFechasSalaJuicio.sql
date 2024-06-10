SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ailyn López>
-- Fecha de creación:		<21/06/2018>
-- Descripción:				<Desasocia una sala de juicio a las fechas indicadas del evento.>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_DesasociarFechasSalaJuicio]
	@CodigoFechaEvento		UNIQUEIDENTIFIER
AS  
BEGIN  

	UPDATE [Agenda].[FechaEvento]
	SET [TN_CodSala] = NULL
	WHERE [TU_CodFechaEvento] = @CodigoFechaEvento
	
END


GO
