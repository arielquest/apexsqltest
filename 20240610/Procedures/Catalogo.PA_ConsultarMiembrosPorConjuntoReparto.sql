SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de creación:	<20/07/2021>
-- Descripción:			<Permite consultar los registros en la tabla: MiembrosPorConjuntoReparto, asociados a un conjunto de reparto.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarMiembrosPorConjuntoReparto]
	@CodMiembroReparto				UNIQUEIDENTIFIER = NULL,
	@CodConjutoReparto				UNIQUEIDENTIFIER
AS
BEGIN
	--Variables.
	DECLARE		@L_TU_CodMiembroReparto				UNIQUEIDENTIFIER	=	@CodMiembroReparto,
				@L_TU_CodConjutoReparto				UNIQUEIDENTIFIER	=	@CodConjutoReparto

	SELECT		TU_CodMiembroReparto				Codigo,
				TU_CodConjutoReparto				CodigoConjunto,
				TC_CodPuestoTrabajo					CodigoPuestoTrabajo,
				TN_Prioridad						PrioridadMiembro,
				TN_Limite							Limite,
				TN_CodUbicacion						CodigoUbicacion
	FROM		Catalogo.MiembrosPorConjuntoReparto	WITH(NOLOCK)
	WHERE		TU_CodMiembroReparto				=	COALESCE(@L_TU_CodMiembroReparto, TU_CodMiembroReparto)
	AND			TU_CodConjutoReparto				=	@L_TU_CodConjutoReparto
	ORDER BY	TN_Prioridad
END
GO
