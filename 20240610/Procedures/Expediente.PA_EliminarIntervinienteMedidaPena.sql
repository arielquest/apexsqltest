SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger>
-- Fecha de creación:		<25/09/2015>
-- Descripción :			<Permite eliminar una medida pena de un interviniente imputado.> 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarIntervinienteMedidaPena]  
   @CodigoMedidaPEna uniqueidentifier
   AS 
BEGIN          
	DELETE 
	FROM	Expediente.MedidaPena
	WHERE	TU_CodMedidaPena=@CodigoMedidaPEna
END
GO
