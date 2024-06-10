SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Diego Navarrete Alvarez>
-- Fecha de creación:		<14/02/2017>
-- Descripción:				<El dia del Enumerador>
-- ===========================================================================================

	CREATE FUNCTION [Agenda].[FN_ObtenerDiaSemana] 
	( 
		@fecha DATE
	) 
	RETURNS  CHAR 

	BEGIN 

	   DECLARE @Dia char;
	   DECLARE @numeroDiaRecibido int;

       SET @numeroDiaRecibido  = ((DATEPART(weekday, @fecha) + @@DATEFIRST - 2) % 7 + 1)
	   
		 SET @Dia= Case @numeroDiaRecibido
						When		1 Then 'D'
						When		2 Then 'L'
						When		3 Then 'K'
						When		4 Then 'M'
						When		5 Then 'J'
						When		6 Then 'V'
						When		7 Then 'S'
					End
	
	  -- Se retorna la fecha del domingo
	 
	 return (@Dia)
	END
GO
