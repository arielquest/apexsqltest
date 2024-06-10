SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<27/11/2020>
-- Descripción :			<Permite eliminar el resultado de una solicitud> 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarResultadoSolicitud]
	@CodResultadoSolicitud					UNIQUEIDENTIFIER
AS  
BEGIN
			DECLARE @L_CodResultadoSolicitud	UNIQUEIDENTIFIER	=	@CodResultadoSolicitud
			
			DELETE FROM	
			[Expediente].[ResultadoSolicitud]
			WHERE	
			[TU_CodResultadoSolicitud]							=	@L_CodResultadoSolicitud
END
GO
