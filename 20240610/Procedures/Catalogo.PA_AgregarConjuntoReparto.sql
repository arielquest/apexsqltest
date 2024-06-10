SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<12/07/2021>
-- Descripción :			<Registra un conjunto de reparto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarConjuntoReparto]     
	@CodConjunto				UNIQUEIDENTIFIER,
	@CodEquipo					UNIQUEIDENTIFIER,
	@NombreConjunto				VARCHAR(100),
	@UbicaExpedientesNuevos     BIT,
	@Prioridad					VARCHAR(1)
AS  
BEGIN  
	DECLARE 
			@L_NombreConjunto			VARCHAR(100)      = @NombreConjunto,
			@L_CodConjunto				UNIQUEIDENTIFIER  = @CodConjunto,
			@L_CodEquipo				UNIQUEIDENTIFIER  = @CodEquipo,
			@L_UbicaExpedientesNuevos	BIT				  = @UbicaExpedientesNuevos,
			@l_Prioridad				VARCHAR(1)		  = @Prioridad					
			

	INSERT INTO Catalogo.ConjuntosReparto(
				TU_CodConjutoReparto,	TU_CodEquipo,			   TC_Nombre,			TC_Prioridad, 
				TF_FechaParticion,		TB_UbicaExpedientesNuevos, TF_FechaCreacion) 
	VALUES (
				@L_CodConjunto,			@L_CodEquipo,			   @L_NombreConjunto,	@L_Prioridad,
				GETDATE(),				@L_UbicaExpedientesNuevos, GETDATE())
	
END
GO
