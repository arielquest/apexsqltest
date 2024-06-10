SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================================================
-- Author:		<Jose Miguel Avendaño Rosales>
-- Create date: <03/08/2021>
-- Description:	<Determina las horas pendientes para que se cumpla la fecha de vencimiento>
-- =================================================================================================================================================================================
-- Modificación: <17/08/2021> <Aida Elena Siles R> <Ajuste en la fecha que se utiliza para comparar si es día festivo>
-- =================================================================================================================================================================================
--Se modifica a solicitud de Paulo, la funcion no existe y debe cambiarse el ALTER por CREATE. druizh
CREATE FUNCTION [Expediente].[FN_HorasPendientesFechaVence]
(
	@CodOficina		VARCHAR(5),	 
	@FechaVence		DATETIME2  
)
RETURNS SMALLINT
AS
BEGIN	
	--Variable local de la funcion
	DECLARE @L_Circuito			SMALLINT = 0
	DECLARE @L_HorasPendientes	INT = 0
    DECLARE @L_Dia				INT   
	DECLARE @L_Dias				INT  
 	DECLARE @L_Horas			INT   
    DECLARE @L_FechaVence		DATETIME = @FechaVence
	DECLARE @L_FechaActual		DATETIME = GetDate()
    DECLARE @L_FechaAux			DATE
	DECLARE @L_Sabado			TINYINT
	declare @L_Domingo			TINYINT

    SELECT @L_Dia	= 0   
    SELECT @L_Dias	= 0   
    SELECT @L_Horas	= 0    

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
	
	If @FechaVence > @L_FechaActual
	BEGIN
		If CONVERT(Date, @FechaVence) = CONVERT(Date, @L_FechaActual)
		BEGIN
			--Obtener la cantidad de horas pendientes totales
			SELECT @L_HorasPendientes = CEILING(DATEDIFF(second, @L_FechaActual, @FechaVence) / 3600.0)
		END
		ELSE
		BEGIN
			--Obtener la cantidad de horas pendientes totales
			SELECT @L_HorasPendientes = CEILING(DATEDIFF(second, @L_FechaActual, @FechaVence) / 3600.0)
			--Verificar desde hoy hasta la fecha de vencimiento si ese dia es feriado o fin de semana, si lo es entonces se restan 24 horas a la cantidad de horas pendientes.
			WHILE @FechaVence > @L_FechaActual
			BEGIN
				SELECT @L_FechaActual = DATEADD(dd, 1,@L_FechaActual) -- Sumamos 1 dia a la fecha actual
			
				SELECT @L_Dia = DATEPART(dw,@L_FechaActual)

				IF (@L_Dia <> @L_Sabado AND @L_Dia <> @L_Domingo)
				BEGIN
					SELECT @L_FechaAux = @L_FechaActual
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
						SELECT @L_HorasPendientes = @L_HorasPendientes - 24		
					END
				END 
				ELSE 
				BEGIN
					SELECT @L_HorasPendientes = @L_HorasPendientes - 24
				END
			END
		END
	END
	ELSE
	BEGIN
		SELECT @L_HorasPendientes = 0
	END
	
	RETURN @L_HorasPendientes
END
GO
