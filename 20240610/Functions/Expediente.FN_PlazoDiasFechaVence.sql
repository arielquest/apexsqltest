SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================================================
-- Author:		<Jose Gabriel Cordero Soto>
-- Create date: <17/11/2020>
-- Description:	<Determina el plazo de dias para la fecha vence en finalizar tarea>
-- =================================================================================================================================================================================
-- Modificación: <13/07/2021> <Aida Elena Siles R> <Ajuste calculo de la fecha de vencimiento contemplando sabados y domingos. Feriados nacionales y los feriados de un circuito.>
-- =================================================================================================================================================================================
-- Modificación: <17/08/2021> <Aida Elena Siles R> <Se agrega parámetro horasPaseFallo se utiliza solo para cuando se asigna tarea de inclusión pase a fallo para recalcular la fecha vencimiento>
-- =================================================================================================================================================================================
CREATE FUNCTION [Expediente].[FN_PlazoDiasFechaVence]
(
	@CodTarea		SMALLINT,	 
	@CodMateria		VARCHAR(5),
	@CodOficina		VARCHAR(5),   
	@CodTipoOficina SMALLINT,	 
	@fecha			DATETIME2,
	@horasPaseFallo	SMALLINT = 0						
)
RETURNS DATETIME2
AS
BEGIN	
	--Variable local de la funcion
	DECLARE @L_Circuito		SMALLINT = 0
	DECLARE @L_Plazo		SMALLINT = 0
    DECLARE @L_Dia			INT   
	DECLARE @L_Dias			INT  
 	DECLARE @L_Horas		INT   
    DECLARE @L_fecha		DATETIME
    DECLARE @L_FechaAux		DATE
	DECLARE @L_Sabado		TINYINT
	declare @L_Domingo		TINYINT

    SELECT @L_Dia	= 0   
    SELECT @L_Dias	= 0   
    SELECT @L_Horas	= 0    

	

	--Se obtiene la cantidad de horas registradas de la tarea
	SELECT  @L_Plazo						= TN_CantidadHoras 
	FROM	Catalogo.TareaTipoOficinaMateria WITH(NOLOCK)
	WHERE	TC_CodMateria					= @CodMateria 
	AND		TN_CodTarea						= @CodTarea 
	AND		TN_CodTipoOficina				= @CodTipoOficina

	IF (@horasPaseFallo > 0)
	BEGIN
		SET @L_Plazo = (@L_Plazo - @horasPaseFallo)
	END

	--Obtener el Circuito al que pertenece el contexto
	SELECT		@L_Circuito			= C.TN_CodCircuito
	FROM		Catalogo.Contexto	A WITH(NOLOCK)
	INNER JOIN	Catalogo.Oficina	B WITH(NOLOCK)
	ON			A.TC_CodOficina		= B.TC_CodOficina
	INNER JOIN	Catalogo.Circuito	C WITH(NOLOCK)
	ON			B.TN_CodCircuito	= C.TN_CodCircuito
	WHERE		A.TC_CodContexto	= @CodOficina

	IF ((SELECT @@DATEFIRST) = 7) --Si el primer dia de la semana esta definido como domingo
	BEGIN
		SET @L_Sabado = 7
		SET @L_Domingo = 1
	END
	ELSE
	BEGIN
		SET @L_Sabado = 6
		SET @L_Domingo = 7
	END

	IF @L_Plazo < 24  --Plazo es menos de un día, agrego las horas a fecha de cambio ubicación
	BEGIN
		SELECT @L_fecha = DATEADD(hh,@L_Plazo,@fecha)
		SELECT @L_Dias = 1

		WHILE @L_Dias  >= 0 
		BEGIN 
			SELECT @L_Dia = DATEPART(dw,@L_fecha)

			IF (@L_Dia <> @L_Sabado AND @L_Dia <> @L_Domingo)
			BEGIN											
				SELECT @L_FechaAux = @L_fecha

				-- Se verifica si la fecha está en la lista de fechas no hábiles por ley, festivos o cierre colectivo 
				IF ((( SELECT	COUNT(*) 
					  FROM		Agenda.DiaFestivo			A WITH(NOLOCK)
					  LEFT JOIN	Agenda.DiaFestivoCircuito	B WITH(NOLOCK)
					  ON		A.TF_FechaFestivo			= B.TF_FechaFestivo
					  WHERE		A.TF_FechaFestivo			= @L_FechaAux
					  AND		B.TF_FechaFestivo			IS NULL ) = 0)
					  AND 
					  ((SELECT	COUNT(*) 
					  FROM		Agenda.DiaFestivo			A WITH(NOLOCK)
					  LEFT JOIN	Agenda.DiaFestivoCircuito	B WITH(NOLOCK)
					  ON		A.TF_FechaFestivo			= B.TF_FechaFestivo
					  WHERE		A.TF_FechaFestivo			= @L_FechaAux
					  AND		B.TN_CodCircuito			= @L_Circuito ) = 0)) OR (@L_Plazo = 0)
				BEGIN
					SELECT @L_Dias= @L_Dias - 1			
				END

			END 
			ELSE 
			BEGIN
				IF (@L_Plazo = 0) 
				BEGIN
					SELECT @L_Dias= @L_Dias - 1
				END
			END

			IF (@L_fecha > @fecha AND @L_Dias > 0)
			BEGIN
			--Antes de avanzar al siguiente día, asignamos a @L_Fecha la hora, minutos y segundos de la fecha original.
				SET @L_fecha = DATETIMEFROMPARTS(YEAR(@L_fecha), MONTH(@L_fecha), DAY(@L_fecha), DATEPART(hour, @fecha), DATEPART(minute, @fecha), DATEPART(SECOND, @fecha), DATEPART(MILLISECOND, @fecha)) 
			END

			IF @L_Dias > 0 --Avanzamos siguiente dia
				SELECT @L_fecha = DATEADD(hh, @L_Plazo, @L_fecha)   

		END -- WHILE @L_Dias >= 0
	END -- IF @L_Plazo < 24
	ELSE 
	BEGIN   --Plazo es al menos más de un día, 
		SELECT @L_Dias  = @L_Plazo / 24 -- Obtengo los días del plazo
		SELECT @L_Horas = @L_Plazo % 24 -- Obtengo las horas sobrantes del plazo

		SELECT @L_fecha = DATEADD(hh,@L_Horas,@fecha) -- Sumamos las horas a fecha

		WHILE @L_Dias >= 0 --Inicia el recorrido de cada día
		BEGIN 
			SELECT @L_Dia = DATEPART(dw,@L_fecha) 
			IF (@L_Dia <> @L_Sabado AND @L_Dia <> @L_Domingo) 
			BEGIN
				SELECT @L_FechaAux = @L_fecha

				-- Se verifica si la fecha está en la lista de fechas no hábiles por ley, festivos o cierre colectivo 
				IF ((( SELECT	COUNT(*) 
					  FROM		Agenda.DiaFestivo			A WITH(NOLOCK)
					  LEFT JOIN	Agenda.DiaFestivoCircuito	B WITH(NOLOCK)
					  ON		A.TF_FechaFestivo			= B.TF_FechaFestivo
					  WHERE		A.TF_FechaFestivo			= @L_FechaAux
					  AND		B.TF_FechaFestivo			IS NULL ) = 0)
					  AND 
					  ((SELECT	COUNT(*) 
					  FROM		Agenda.DiaFestivo			A WITH(NOLOCK)
					  LEFT JOIN	Agenda.DiaFestivoCircuito	B WITH(NOLOCK)
					  ON		A.TF_FechaFestivo			= B.TF_FechaFestivo
					  WHERE		A.TF_FechaFestivo			= @L_FechaAux
					  AND		B.TN_CodCircuito			= @L_Circuito ) = 0) )
				BEGIN
					SELECT @L_Dias= @L_Dias - 1			
				END
			END

			IF @L_Dias >= 0 --Avanzamos siguiente día 
				SELECT @L_fecha = DATEADD(dd, 1, @L_fecha)   

	END -- WHILE @L_Dias >= 0
END
	RETURN @L_fecha
END
GO
