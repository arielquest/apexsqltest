SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez>
-- Fecha de creación:		<31/08/2020>
-- Descripción :			<Permite eliminar registros de expedientes bloqueados>
-- ===========================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarBloqueo]
	@CodBloqueo				uniqueidentifier	=	Null,
	@NumeroExpediente		char(14)			=	Null,
	@CodLegajo				uniqueidentifier	=	Null
	
AS
BEGIN

--Variables.
	DECLARE	@L_CodBloqueo		uniqueidentifier	=	@CodBloqueo,
			@L_NumeroExpediente	char(14)			=	@NumeroExpediente,	  
			@L_CodLegajo		uniqueidentifier	=	@CodLegajo

	IF	@L_CodBloqueo	IS NOT NULL		BEGIN --Bloqueo por codigo		DELETE	
		FROM	Expediente.Bloqueo
		WHERE	TU_CodBloqueo		=	@L_CodBloqueo	END ELSE	BEGIN		--Bloqueo de expediente		IF	@L_NumeroExpediente	IS NOT NULL					BEGIN			DELETE	
			FROM	Expediente.Bloqueo
			WHERE	TC_NumeroExpediente		=	@L_NumeroExpediente		END ELSE		BEGIN				--Bloqueo de legajo			DELETE	
			FROM	Expediente.Bloqueo
			WHERE	TU_CodLegajo			=	@L_CodLegajo			
		END
	END
End
GO
