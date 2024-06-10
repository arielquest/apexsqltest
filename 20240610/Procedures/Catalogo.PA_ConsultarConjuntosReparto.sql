SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<12/07/2021>
-- Descripción :			<Consulta los conjuntos de reparto de un equipo> 
-- Modificado por:			<Johan Acosta Ibañez>
-- Fecha de creación:		<20/07/2021>
-- Descripción :			<Consulta un conjunto de reparto específico> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarConjuntosReparto]
	@CodEquipoReparto	UNIQUEIDENTIFIER,
	@CodConjutoReparto  UNIQUEIDENTIFIER = NULL
AS  
BEGIN  
	DECLARE	@L_CodEquipoReparto		UNIQUEIDENTIFIER = @CodEquipoReparto,
			@L_CodConjutoReparto	UNIQUEIDENTIFIER = @CodConjutoReparto

	SELECT  A.TC_Nombre					Nombre,
			A.TU_CodConjutoReparto		Codigo,
			A.TU_CodEquipo				CodigoEquipo,
			A.TB_UbicaExpedientesNuevos	UbicaExpedientesNuevos,
			'split'						split,  
			A.TC_Prioridad				Prioridad
	FROM    Catalogo.ConjuntosReparto	A	WITH(NOLOCK)
	WHERE   A.TU_CodEquipo				=	@L_CodEquipoReparto
	AND		A.TU_CodConjutoReparto		=	COALESCE(@L_CodConjutoReparto, A.TU_CodConjutoReparto)	
END
GO
