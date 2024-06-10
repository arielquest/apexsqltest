SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<18/08/2015>
-- Descripción :			<Permite Eliminar una asociacion clase asunto -Procedimiento> 
-- Modificado:				<Alejandro Villalta><17/12/2015><Autogenerar el codigo de clase de asunto, de varchar a int>
-- Modificado :				<12/02/2019> <Isaac Dobles Mata>, Se modifica para ajustarse a tabla ClaseProceso.> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarClaseProceso]
   @CodClase	int,
   @CodProceso	smallint
 
AS 
    BEGIN
          
			 DELETE FROM Catalogo.ClaseProceso
			 WHERE TN_CodClase =	@CodClase
			 AND   TN_CodProceso =  @CodProceso

   END
 
GO
