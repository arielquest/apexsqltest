SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Henry Mendez Ch>
-- Fecha de creación:	<20/07/2020>
-- Descripción:			<Permite consultar los bloqueos de un expediente o legajo>
-- ==================================================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ConsultarBloqueo]
	@NumeroExpediente		char(14)			=	Null,
	@CodLegajo				uniqueidentifier	=	Null
 
AS 
BEGIN

--Variables.
	DECLARE	@L_NumeroExpediente	char(14)			=	@NumeroExpediente,	  
			@L_CodLegajo		uniqueidentifier	=	@CodLegajo

--Lógica.	
	--Bloqueo de expediente
	IF	@L_NumeroExpediente	IS NOT NULL	
	BEGIN
		SELECT	B.TU_CodBloqueo			As	Codigo,
				B.TF_FechaBloqueo		As	FechaBloqueo,
				'Split'					As	Split,
				B.TC_NumeroExpediente	As	Numero,
				'Split'					As	Split,
				B.TU_CodLegajo			As	Codigo,
				'Split'					As	Split,
				C.TC_CodContexto		As	Codigo,
				C.TC_Descripcion		As	Descripcion,
				'Split'					As	Split,
				F.TC_UsuarioRed			As	UsuarioRed,
				F.TC_Nombre				As	Nombre,
				F.TC_PrimerApellido		As	PrimerApellido,
				F.TC_SegundoApellido	As	SegundoApellido

		FROM	Expediente.Bloqueo		B
		JOIN	Catalogo.Contexto		C	With(Nolock)	ON	C.TC_CodContexto	=	B.TC_CodContexto	
		JOIN	Catalogo.Funcionario	F	With(Nolock)	ON	F.TC_UsuarioRed		=	B.TC_UsuarioRed
		WHERE	B.TC_NumeroExpediente	=	@L_NumeroExpediente
	END ELSE
	BEGIN
		--Bloqueo de legajo
		IF	@L_CodLegajo	IS NOT NULL			
		BEGIN
			SELECT	B.TU_CodBloqueo			As	Codigo,
					B.TF_FechaBloqueo		As	FechaBloqueo,
					'Split'					As	Split,
					B.TC_NumeroExpediente	As	Numero,
					'Split'					As	Split,
					B.TU_CodLegajo			As	Codigo,
					'Split'					As	Split,
					C.TC_CodContexto		As	Codigo,
					C.TC_Descripcion		As	Descripcion,
					'Split'					As	Split,
					F.TC_UsuarioRed			As	UsuarioRed,
					F.TC_Nombre				As	Nombre,
					F.TC_PrimerApellido		As	PrimerApellido,
					F.TC_SegundoApellido	As	SegundoApellido

			FROM	Expediente.Bloqueo		B
			JOIN	Catalogo.Contexto		C	With(Nolock)	ON	C.TC_CodContexto	=	B.TC_CodContexto	
			JOIN	Catalogo.Funcionario	F	With(Nolock)	ON	F.TC_UsuarioRed		=	B.TC_UsuarioRed
			WHERE	B.TU_CodLegajo			=	@L_CodLegajo
		END
	END
END
GO
