SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Ronny Ramírez R.>
-- Fecha de creación:		<2020/10/29>
-- Descripción :			<Obtiene la cantidad de días hábiles entre un par de fechas para una oficina en específico.> 
-- =================================================================================================================================================
CREATE FUNCTION [Agenda].[FN_CantidadDiasHabiles]
(
	@FechaInicio						DATETIME2,
	@FechaFin							DATETIME2,
	@CodigoOficina 						VARCHAR(4)
)
RETURNS INT
AS
BEGIN

	--Variables
	DECLARE	@L_TF_FechaInicio					DATETIME2		= @FechaInicio,
			@L_TF_FechaFin						DATETIME2		= @FechaFin,
			@L_TC_CodigoOficina					VARCHAR(4)		= @CodigoOficina,
			@L_TN_Feriados 						INT 			= 0,
			@L_TNResultado 						INT 			= 0		

	SET @L_TN_Feriados = (SELECT 	COUNT(*)
	FROM	Agenda.DiaFestivoCircuito				A	WITH(NOLOCK)	
	JOIN	Catalogo.Oficina						B	WITH(NOLOCK)
	ON		B.TN_CodCircuito						=	A.TN_CodCircuito
	WHERE	B.TC_CodOficina							=	@L_TC_CodigoOficina
	AND		A.TF_FechaFestivo 						>=	@L_TF_FechaInicio
	AND		A.TF_FechaFestivo 						<=	@L_TF_FechaFin
	AND 	Agenda.FN_ObtenerNumeroDiaSemana(A.TF_FechaFestivo, 1)	NOT IN (6,7))

	SET @L_TNResultado = (
						   (DATEDIFF(dd, @L_TF_FechaInicio, @L_TF_FechaFin) + 1)
						  -(DATEDIFF(wk, @L_TF_FechaInicio, @L_TF_FechaFin) * 2)
						  -(CASE Agenda.FN_ObtenerNumeroDiaSemana(@L_TF_FechaInicio, 1) WHEN 7 THEN 1 ELSE 0 END) 	-- domingo
						  -(CASE Agenda.FN_ObtenerNumeroDiaSemana(@L_TF_FechaFin, 1) WHEN 6 THEN 1 ELSE 0 END)		-- sábado
						  -@L_TN_Feriados
						)

	Return @L_TNResultado;
END
GO
