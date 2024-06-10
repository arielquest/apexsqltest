SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<27/11/2020>
-- Descripción :			<Permite eliminar el resultado de un recurso> 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarResultadoRecurso]
	@CodResultadoRecurso					UNIQUEIDENTIFIER
AS  
BEGIN
			DECLARE @L_CodResultadoRecurso	UNIQUEIDENTIFIER	=	@CodResultadoRecurso
			
			DELETE FROM	
			[Expediente].[ResultadoRecurso]
			WHERE	
			[TU_CodResultadoRecurso]							=	@CodResultadoRecurso
END
GO
