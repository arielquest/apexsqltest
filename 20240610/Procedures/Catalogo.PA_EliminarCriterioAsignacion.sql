SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<24/08/2021>
-- Descripción :			<Elimina criterios de asignación> 
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Creado por:				<Xinia Soto>
-- Fecha de creación:		10/09/2021>
-- Descripción :			<Se agrega columna de TU_CodConjuntoReparto a la tabla Catalogo.CriterioAsignacion> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarCriterioAsignacion]
	@CodCriterio				UNIQUEIDENTIFIER,
	@CodPuestoTrabajo			VARCHAR(14)	     = NULL,
	@CodConjunto                UNIQUEIDENTIFIER = NULL
AS  
BEGIN  
	DECLARE 
			@L_CodCriterio				UNIQUEIDENTIFIER	=	@CodCriterio,
			@L_CodPuestoTrabajo			VARCHAR(14)			=	@CodPuestoTrabajo,
			@L_CodConjunto	        	UNIQUEIDENTIFIER	=	@CodConjunto


			
	
	DELETE	Catalogo.CriterioAsignacion
	WHERE	TU_CodCriterio				=	@L_CodCriterio
	AND		TC_CodPuestoTrabajo			=	COALESCE(@L_CodPuestoTrabajo,	TC_CodPuestoTrabajo)
	AND     TU_CodConjuntoReparto       =	COALESCE(@L_CodConjunto,	    TU_CodConjuntoReparto)
END
GO
