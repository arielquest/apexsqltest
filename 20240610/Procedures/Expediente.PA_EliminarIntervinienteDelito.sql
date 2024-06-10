SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger>
-- Fecha de creación:		<22/09/2015>
-- Descripción :			<Permite eliminar un delito de interviniente imputado.> 
-- Modificado :				<Donald Vargas><02/12/2016><Se corrige el nombre del campo TC_CodDelito a TN_CodDelito de acuerdo al tipo de dato> 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarIntervinienteDelito]  
   @CodigoInterviniente uniqueidentifier,
   @CodigoDelito int
 AS 
BEGIN          
	DELETE 
	FROM	Expediente.IntervinienteDelito
	WHERE	TU_CodInterviniente = @CodigoInterviniente
	And		TN_CodDelito		= @CodigoDelito
	
END
GO
