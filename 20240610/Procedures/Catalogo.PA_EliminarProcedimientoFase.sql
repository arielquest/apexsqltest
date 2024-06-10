SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<19/08/2015>
-- Descripción :			<Permite Eliminar una asociacion clase asunto -Procedimiento> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarProcedimientoFase]
   @CodProcedimiento varchar(5),
   @Codfase varchar(6)
 
AS 
    BEGIN
          
			 DELETE FROM Catalogo.ProcedimientoFase
			 WHERE rtrim(ltrim(TC_CodProcedimiento)) = @CodProcedimiento AND
			 TC_CodFase=@Codfase

   END
 

GO
