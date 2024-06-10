SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=============================================================================================================================================
-- Autor:		   <Diego Navarrete>
-- Fecha Creación: <04/04/2018>
-- Descripcion:	   <Elimina un registro a la tabla Agenda.SolicitudLiberacionParticipacion>
-- Modificación:   <04/04/2018. Jeffry Hernández. Se agrega parámetro @CodParticipacion y condición>
--=============================================================================================================================================
CREATE PROCEDURE  [Agenda].[PA_EliminarSolicitudLiberacionParticipacion]  
	@CodigoSolicitudLiberacion	uniqueidentifier,
	@CodParticipacion	uniqueidentifier
As
Begin

	IF(@CodigoSolicitudLiberacion IS NOT NULL)
	BEGIN
		
		DELETE 
		FROM	Agenda.SolicitudLiberacionParticipacion		
		WHERE 	TU_CodSolicitudLiberacion = @CodigoSolicitudLiberacion		

	END
	ELSE
	BEGIN

		DELETE 
		FROM	Agenda.SolicitudLiberacionParticipacion		
		WHERE 	TU_CodParticipacion =  @CodParticipacion

	END
	
	
End





GO
