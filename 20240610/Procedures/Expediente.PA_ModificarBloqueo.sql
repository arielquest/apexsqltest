SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Henry Mendez Ch>
-- Fecha de creación:	<20/07/2020>
-- Descripción:			<Permite modificar un bloqueo de un expediente o legajo>
-- ==================================================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ModificarBloqueo]
	@NumeroExpediente		char(14)			=	Null,
	@CodLegajo				uniqueidentifier	=	Null
 
AS 
BEGIN

--Variables.
	DECLARE	@L_NumeroExpediente	char(14)			=	@NumeroExpediente,	  
			@L_CodLegajo		uniqueidentifier	=	@CodLegajo,
			@L_FechaBloqueo		datetime2(3)		=	GetDate()

--Lógica.	
	--Bloqueo de expediente
	IF	@L_NumeroExpediente	IS NOT NULL		BEGIN		UPDATE	Expediente.Bloqueo		SET		TF_FechaBloqueo			=	@L_FechaBloqueo		WHERE	TC_NumeroExpediente		=	@L_NumeroExpediente	END ELSE	BEGIN		--Bloqueo de legajo		IF	@L_CodLegajo	IS NOT NULL					BEGIN			UPDATE	Expediente.Bloqueo			SET		TF_FechaBloqueo			=	@L_FechaBloqueo			WHERE	TU_CodLegajo			=	@L_CodLegajo		END
	END
END
GO
