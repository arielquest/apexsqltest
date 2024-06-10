SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<02/02/2017>
-- Descripción:				<Verifica la disponibilidad de la sala en las fechas solicitadas> 
-- Modificado:				<28/11/2017> <Ailyn López> <Se modificó el SP para no tomar como choque 
--                          cuando un evento termina a la misma hora que otro comienza.>  
-- =========================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<13/08/2019>
-- Descripción:				<Se modifica para cambiar parámetro código de legajo por número de expediente>
-- =========================================================================================================
CREATE PROCEDURE [Agenda].[PA_VerificarDisponibilidadSalaJuicio]
	@CodigoSala SMALLINT,
	@JsonFechasSolicitadas	NVARCHAR(MAX)
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

	DECLARE @FechasSala TABLE
	(
		TU_CodFechaEvento UNIQUEIDENTIFIER,
		TN_CodSala		SMALLINT,
		TF_FechaInicio	DATETIME2(7),
		TF_FechaFin		DATETIME2(7)
	)

	DECLARE @ChoquesSala TABLE
	(
		TU_CodFechaEvento UNIQUEIDENTIFIER,
		TN_CodSala		SMALLINT,
		TF_FechaInicio	DATETIME2(7),
		TF_FechaFin		DATETIME2(7)
	)

	--Obtiene las fechas asignadas para la sala
	INSERT INTO @FechasSala
	(
		TU_CodFechaEvento,
		TN_CodSala,
		TF_FechaInicio,
		TF_FechaFin
	)
	SELECT  
			fe.TU_CodFechaEvento,
			fe.[TN_CodSala], 
			fe.[TF_FechaInicio],
			fe.[TF_FechaFin]
	FROM [Agenda].[FechaEvento] fe
	WHERE [TN_CodSala] IS NOT NULL
	AND fe.[TF_FechaFin] > @FechaActual AND [TB_Cancelada] = 0 AND fe.TN_CodSala = @CodigoSala

	--Obtiene los choques de la sala con las fechas indicadas
	INSERT INTO @ChoquesSala
	(
		TU_CodFechaEvento,
		TN_CodSala,
		TF_FechaInicio,
		TF_FechaFin
	)
	SELECT	sa.TU_CodFechaEvento,
			sa.TN_CodSala,
			sa.TF_FechaInicio,
			sa.TF_FechaFin
	FROM @FechasSala sa
	CROSS APPLY @FechasSolicitadas fs
	WHERE (
		(sa.TF_FechaInicio >= fs.TF_FechaInicio AND sa.TF_FechaInicio < fs.TF_FechaFin OR sa.TF_FechaFin > fs.TF_FechaInicio AND sa.TF_FechaFin <= fs.TF_FechaFin) OR
		(fs.TF_FechaInicio >= sa.TF_FechaInicio AND fs.TF_FechaInicio < sa.TF_FechaFin OR fs.TF_FechaFin > sa.TF_FechaInicio AND fs.TF_FechaFin <= sa.TF_FechaFin)
	) AND sa.TN_CodSala = @CodigoSala

	SELECT 
		ae.TU_CodFechaEvento	AS Codigo, 
		ae.TF_FechaInicio		AS FechaInicio, 
		ae.TF_FechaFin			AS FechaFin, 
		ae.TC_Observaciones		AS Observaciones, 
		ae.TB_Cancelada			AS Cancelada, 
		ae.TN_MontoRemate		AS MontoRemate,
		'SplitEvento'			AS SplitEvento,
		e.TU_CodEvento			AS Codigo, 
		e.TC_NumeroExpediente	AS NumeroExpediente, 
		e.TC_Titulo				AS Titulo, 
		e.TC_Descripcion		AS Descripcion,  
		e.TB_RequiereSala		AS RequiereSala, 
		e.TF_FechaCreacion		AS FechaCreacion, 
		e.TF_Actualizacion		AS FechaActualizacion
	FROM @ChoquesSala cs
	JOIN [Agenda].[FechaEvento]	AS ae 
	ON ae.[TU_CodFechaEvento]	= cs.TU_CodFechaEvento
	JOIN [Agenda].[Evento]		AS e 
	ON e.TU_CodEvento			= ae.TU_CodEvento
END

GO
