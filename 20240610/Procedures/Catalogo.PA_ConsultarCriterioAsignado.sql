SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<09/9/2021>
-- Descripción :			<Consulta sí criterio se encuentra asignado a un puesto> 
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Creado por:				<Xinia Soto>
-- Fecha de creación:		10/09/2021>
-- Descripción :			<Se agrega columna de TU_CodConjuntoReparto a la tabla Catalogo.CriterioAsignacion> 
-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarCriterioAsignado]	
	@CodCriterio      UNIQUEIDENTIFIER,
	@CodPuesto        VARCHAR(14),
	@CodConjunto      UNIQUEIDENTIFIER = NULL
AS	
BEGIN
DECLARE
	@L_CodCriterio		UNIQUEIDENTIFIER    = @CodCriterio,
	@L_CodPuesto        VARCHAR(14)         = @CodPuesto,
	@L_CodConjunto	    UNIQUEIDENTIFIER	= @CodConjunto

	SELECT	ISNULL(1,0) FROM Catalogo.CriterioAsignacion
	WHERE	TU_CodCriterio		  = @L_CodCriterio AND
			TC_CodPuestoTrabajo   = @L_CodPuesto   AND
			TU_CodConjuntoReparto = COALESCE(@L_CodConjunto,	    TU_CodConjuntoReparto)
END
GO
