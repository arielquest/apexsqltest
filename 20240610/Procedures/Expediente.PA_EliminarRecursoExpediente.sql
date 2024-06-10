SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<27/11/2020>
-- Descripción :			<Permite eliminar un recurso de un expediente> 
-- =================================================================================================================================================
-- Modificación:		<Aarón Ríos Retana><29/08/2022><Bug 269091 - Se para que sea posible eliminar un recurso cuando este es rechazado, ya que tiene asociado un registro en  historico.ItineracionRecursoResultado>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarRecursoExpediente]
	@CodRecurso					UNIQUEIDENTIFIER
AS  
BEGIN
			DECLARE @L_CodRecurso	UNIQUEIDENTIFIER	=	@CodRecurso

			DELETE 
			Historico.ItineracionRecursoResultado 
			WHERE TU_CodRecurso = @L_CodRecurso

			DELETE FROM	
			[Expediente].[RecursoExpediente]
			WHERE	
			[TU_CodRecurso]								=	@L_CodRecurso
END
GO
