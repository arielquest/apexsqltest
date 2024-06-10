SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<03/02/2017>
-- Descripción:				<Asocia una sala de juicio a las fechas indicadas del evento.>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_AsociarFechasSalaJuicio]
	@CodigoFechaEvento		UNIQUEIDENTIFIER,
	@CodigoSala				SMALLINT
AS  
BEGIN  

	UPDATE [Agenda].[FechaEvento]
	SET [TN_CodSala] = @CodigoSala
	WHERE [TU_CodFechaEvento] = @CodigoFechaEvento
	
END


GO
