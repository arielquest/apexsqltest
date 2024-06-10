SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================================================
-- Author:		<Aida Elena Siles R>
-- Create date: <17/08/2021>
-- Description:	<Determina la cantidad de horas que hay entre dos fechas excluyendo feriados, fines de semana, etc.
-- =================================================================================================================================================================================
CREATE FUNCTION [Utilitario].[FN_CantidadHorasEntreDosFechas]
(
	@CodOficina		VARCHAR(5),	 
	@FechaInicial	DATETIME2, --FechaInicial
	@FechaFinal		DATETIME2  --FechaFinal	
)
RETURNS SMALLINT
AS
BEGIN	
	--Variable local de la funcion
	DECLARE @L_Circuito			SMALLINT = 0
	DECLARE @L_Horas			INT = 0
    DECLARE @L_Dia				INT   
	DECLARE @L_Dias				INT   	
	DECLARE @L_FechaInicial		DATETIME = @FechaInicial
    DECLARE @L_FechaFinal		DATETIME = @FechaFinal
    DECLARE @L_FechaAux			DATE
	DECLARE @L_Sabado			TINYINT
	declare @L_Domingo			TINYINT

    SELECT @L_Dia	= 0   
    SELECT @L_Dias	= 0       

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
	
	If @L_FechaFinal > @L_FechaInicial
	BEGIN
		If CONVERT(Date, @L_FechaFinal) = CONVERT(Date, @L_FechaInicial)
		BEGIN
			--Obtener la cantidad de horas pendientes totales
			SELECT @L_Horas = CEILING(DATEDIFF(SECOND, @L_FechaInicial, @L_FechaFinal) / 3600.0)
		END
		ELSE
		BEGIN
			--Obtener la cantidad de horas pendientes totales
			SELECT @L_Horas = CEILING(DATEDIFF(SECOND, @L_FechaInicial, @L_FechaFinal) / 3600.0)
			--Verificar desde hoy hasta la fecha de vencimiento si ese dia es feriado o fin de semana, si lo es entonces se restan 24 horas a la cantidad de horas pendientes.
			WHILE @L_FechaFinal > @L_FechaInicial
			BEGIN
				SELECT @L_FechaInicial = DATEADD(dd, 1,@L_FechaInicial) -- Sumamos 1 dia a la fecha actual
			
				SELECT @L_Dia = DATEPART(dw,@L_FechaInicial)

				IF (@L_Dia <> @L_Sabado AND @L_Dia <> @L_Domingo)
				BEGIN
					SELECT @L_FechaAux = @L_FechaInicial
					-- Se verifica si la fecha está en la lista de fechas no hábiles por ley, festivos o cierre colectivo 
					IF ((( SELECT	COUNT(*) 
						  FROM		Agenda.DiaFestivo			A WITH(NOLOCK)
						  LEFT JOIN	Agenda.DiaFestivoCircuito	B WITH(NOLOCK)
						  ON		A.TF_FechaFestivo			= B.TF_FechaFestivo
						  WHERE		A.TF_FechaFestivo			= @L_FechaAux
						  AND		B.TF_FechaFestivo			IS NULL ) > 0)
						  OR
						  (( SELECT	COUNT(*) 
						  FROM		Agenda.DiaFestivo			A WITH(NOLOCK)
						  LEFT JOIN	Agenda.DiaFestivoCircuito	B WITH(NOLOCK)
						  ON		A.TF_FechaFestivo			= B.TF_FechaFestivo
						  WHERE		A.TF_FechaFestivo			= @L_FechaAux
						  AND		B.TN_CodCircuito			= @L_Circuito) > 0)
						)
					BEGIN
						SELECT @L_Horas = @L_Horas - 24		
					END
				END 
				ELSE 
				BEGIN
					SELECT @L_Horas = @L_Horas - 24
				END
			END
		END
	END
	ELSE
	BEGIN
		SELECT @L_Horas = 0
	END
	
	RETURN @L_Horas
END
GO
