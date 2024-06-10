SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<02/02/2017>
-- Descripción:				<Obtiene las salas disponibles para las fechas indicadas> 
-- Modificación:            <Cambio de nombre del SP y se declara el parametro @Cancelada tipo BIT> 
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarSalaJuicioDisponible]
	@JsonFechasSolicitadas	NVARCHAR(MAX),
	@CodCircuito SMALLINT,
	@Cancelada BIT
AS
BEGIN

	DECLARE @FechaActual Datetime = GETDATE()

	DECLARE @FechasSolicitadas	TABLE
	(
		TF_FechaInicio	DATETIME2(7),
		TF_FechaFin		DATETIME2(7)
	)

	--Obtiene las fechas del evento
	INSERT INTO @FechasSolicitadas
	(
		TF_FechaInicio, 
		TF_FechaFin
	)
	SELECT *  
	FROM OPENJSON(@JsonFechasSolicitadas)  
	WITH (
		FechaInicio datetime2 'strict $.FechaInicio',
		FechaFin datetime2 'strict $.FechaFin'
	)  

	DECLARE @SalasAsignadas TABLE
	(
		TN_CodSala		SMALLINT,
		TF_FechaInicio	DATETIME2(7),
		TF_FechaFin		DATETIME2(7)
	)

	DECLARE @SalasNoDisponibles TABLE
	(
		TN_CodSala		SMALLINT,
		TF_FechaInicio	DATETIME2(7),
		TF_FechaFin		DATETIME2(7)
	)

	--Obtiene las salas de juicio asignadas
	INSERT INTO @SalasAsignadas
	(
		TN_CodSala,
		TF_FechaInicio,
		TF_FechaFin
	)
	SELECT  fe.[TN_CodSala], 
			fe.[TF_FechaInicio],
			fe.[TF_FechaFin]
	FROM [Agenda].[FechaEvento] fe
	WHERE [TN_CodSala] IS NOT NULL
	AND fe.[TF_FechaFin] > @FechaActual AND [TB_Cancelada] = @Cancelada

	--Obtiene las salas no disponibles para las fechas indicadas
	INSERT INTO @SalasNoDisponibles
	(
		TN_CodSala,
		TF_FechaInicio,
		TF_FechaFin
	)
	SELECT	sa.TN_CodSala,
			sa.TF_FechaInicio,
			sa.TF_FechaFin
	FROM @SalasAsignadas sa
	CROSS APPLY @FechasSolicitadas fs
	WHERE

		(sa.TF_FechaInicio >= fs.TF_FechaInicio AND sa.TF_FechaInicio < fs.TF_FechaFin 
		 OR sa.TF_FechaFin > fs.TF_FechaInicio AND sa.TF_FechaFin <= fs.TF_FechaFin) 
	OR
		(fs.TF_FechaInicio >= sa.TF_FechaInicio AND fs.TF_FechaInicio < sa.TF_FechaFin 
		OR fs.TF_FechaFin > sa.TF_FechaInicio AND fs.TF_FechaFin <= sa.TF_FechaFin)

	--Obtiene las salas de juicio vigentes, habilitadas y disponibles para las fechas indicadas
	SELECT 
		sj.TN_CodSala AS Codigo, 
		sj.TC_Descripcion AS Descripcion, 
		sj.TC_Observaciones AS Observaciones, 
		sj.TN_Capacidad AS Capacidad, 
		--La columna habilitada, en este caso, me indica si esta o no disponibles la sala para las fechas indicadas
		CONVERT(BIT, CASE WHEN 
			(SELECT COUNT(1) FROM @SalasNoDisponibles snd WHERE snd.TN_CodSala = sj.TN_CodSala) = 0 THEN 1
			ELSE 0
		END) AS Habilitada,
		sj.TF_Inicio_Vigencia AS FechaActivacion, 
		sj.TF_Fin_Vigencia AS FechaDesactivacion,
		'SplitCircuito' AS SplitCircuito,
		c.TN_CodCircuito AS Codigo, 
		c.TC_Descripcion AS Descripcion, 
		c.TF_Inicio_Vigencia AS FechaActivacion, 
		c.TF_Fin_Vigencia AS FechaDesactivacion
	FROM [Catalogo].[SalaJuicio] sj
	JOIN [Catalogo].[Circuito] c ON sj.TN_CodCircuito = c.TN_CodCircuito
	WHERE sj.TB_Habilitada = 1 
	AND sj.TF_Inicio_Vigencia <= @FechaActual 
	AND (sj.TF_Fin_Vigencia >= @FechaActual OR sj.TF_Fin_Vigencia IS NULL)
	AND c.TN_CodCircuito = @CodCircuito
END

GO
