SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<20/07/2021>
-- Descripción :			<Modifica los valores de un conjunto de reparto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarConjuntoReparto]     
	@CodEquipo					UNIQUEIDENTIFIER,
	@CodConjunto				UNIQUEIDENTIFIER,
	@NombreConjunto				VARCHAR(100),
	@UbicaExpedientesNuevos     BIT,
	@Prioridad					VARCHAR(1)
AS  
BEGIN  
	DECLARE 
			@L_CodEquipo				UNIQUEIDENTIFIER  = @CodEquipo,
			@L_CodConjunto				UNIQUEIDENTIFIER  = @CodConjunto,
			@L_NombreConjunto			VARCHAR(100)      = @NombreConjunto,
			@L_UbicaExpedientesNuevos	BIT				  = @UbicaExpedientesNuevos,
			@L_Prioridad				VARCHAR(1)		  = @Prioridad					

			
	UPDATE	Catalogo.ConjuntosReparto
	SET		TC_Nombre					=	@L_NombreConjunto,
			TC_Prioridad				=	@L_Prioridad,
			TB_UbicaExpedientesNuevos	=	@L_UbicaExpedientesNuevos
	WHERE	
			TU_CodEquipo				=	@L_CodEquipo

	AND		TU_CodConjutoReparto		=	@L_CodConjunto
END
GO
