SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jeffry Hernandez>
-- Fecha de creación:		<14/02/2017>
-- Descripción:				<Obtiene la fecha del domingo de la semana que contiene la fecha recibida>
-- ===========================================================================================

	CREATE FUNCTION [Agenda].[FN_ObtenerInicioSemana] 
	( 
		@fecha DATE
	) 
	RETURNS  DATE 

	BEGIN 

	   DECLARE @diasAtras INT;
	   DECLARE @numeroDiaRecibido int;

       SET @numeroDiaRecibido  = ((DATEPART(weekday, @fecha) + @@DATEFIRST - 2) % 7 + 1)

	   SET @numeroDiaRecibido = @numeroDiaRecibido-1

	   SET @diasAtras = @numeroDiaRecibido * -1

	  -- Se retorna la fecha del domingo
	  RETURN  DATEADD(DAY,  @diasAtras, @fecha)


	END



GO
