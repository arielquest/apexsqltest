SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<09/07/2021>
-- Descripción :			<Modifica un equipo de reparto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarEquipoReparto]     
	@CodEquipo					UNIQUEIDENTIFIER ,
	@NombreEquipo				VARCHAR(100)
AS  
BEGIN  
	DECLARE 
			@L_NombreEquipo			VARCHAR(100)      = @NombreEquipo,
			@L_CodEquipo			UNIQUEIDENTIFIER  = @CodEquipo
			

	UPDATE  Catalogo.EquiposReparto 
	SET		TC_NombreEquipo = @L_NombreEquipo
	WHERE   TU_CodEquipo    = @L_CodEquipo
	
END
GO
