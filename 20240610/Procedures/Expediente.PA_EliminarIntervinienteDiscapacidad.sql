SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<01/12/2015>
-- Descripción :			<Permite eliminar una Discapacidad de interviniente .> 
--
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodDiscapacidad a TN_CodDiscapacidad de acuerdo al tipo de dato.>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarIntervinienteDiscapacidad]  
   @CodInterviniente uniqueidentifier,
   @CodDiscapacidad smallint
 AS 
BEGIN          
	DELETE 
	FROM	Expediente.IntervinienteDiscapacidad
	WHERE	TU_CodInterviniente = @CodInterviniente
	And		TN_CodDiscapacidad		= @CodDiscapacidad
	
END
GO
