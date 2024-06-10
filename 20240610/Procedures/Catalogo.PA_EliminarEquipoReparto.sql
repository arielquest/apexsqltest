SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<09/07/2021>
-- Descripción :			<Consulta sí un equipo tiene criterios de reparto asociados> 
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<30/07/2021>
-- Descripción :			<Se agrega transacción> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarEquipoReparto]
	@CodEquipo   UNIQUEIDENTIFIER
AS  
BEGIN  
	DECLARE
		    @L_CodEquipo	UNIQUEIDENTIFIER = @CodEquipo
	
BEGIN TRY;
	BEGIN TRANSACTION; 	
		DELETE		Catalogo.MiembrosPorConjuntoReparto 
		FROM		Catalogo.MiembrosPorConjuntoReparto M
		INNER JOIN	Catalogo.ConjuntosReparto			C ON C.TU_CodConjutoReparto = M.TU_CodConjutoReparto
		WHERE		C.TU_CodEquipo = @L_CodEquipo

		DELETE Catalogo.ConjuntosReparto	WHERE TU_CodEquipo = @L_CodEquipo

		DELETE Catalogo.EquiposReparto		WHERE TU_CodEquipo = @L_CodEquipo
	COMMIT TRANSACTION;  
END TRY
BEGIN CATCH
	PRINT 'ERROR!!'
	ROLLBACK TRAN;
	THROW;
END CATCH
END
GO
