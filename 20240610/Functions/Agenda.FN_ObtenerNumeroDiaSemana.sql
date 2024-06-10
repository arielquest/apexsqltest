SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Ronny Ramírez R.>
-- Fecha de creación:		<2020/11/06>
-- Descripción :			<Obtiene el día de la semana correspondiente a la fecha indicada, relativo al primer día de la semana indicado.> 
-- Nota: @DiaInicioSemana es el número de [1 - 7] que corresponden a los días de Lunes a Domingo
-- =================================================================================================================================================
CREATE FUNCTION [Agenda].[FN_ObtenerNumeroDiaSemana]
(
	@Fecha								DATETIME2,
	@DiaInicioSemana					INT
)
RETURNS INT
AS
BEGIN	  
    RETURN (DATEPART(dw, @Fecha) + @@DATEFIRST + 6 - @DiaInicioSemana) % 7 + 1
END
GO
