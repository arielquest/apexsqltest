SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Creado por:		Jose Gabriel Cordero Soto
-- Fecha creacion:	18/02/2022
-- Descripción:		Obtener las representaciones por medio del numero expediente
-- ==========================================================================================
-- Modificado por:  <22/02/2022><Jose Gabriel Cordero Soto><Se ajusta nombre de campos de fecha a los esperados en la entidad FechaActivacion y FechaDesactivacion>
-- ==========================================================================================
--ALTER   PROCEDURE [Expediente].[PA_ConsultarRepresentacionesExpedientePorNumero] - AAA
CREATE   PROCEDURE [Expediente].[PA_ConsultarRepresentacionesExpedientePorNumero]
@NumeroExpediente VARCHAR(14)
AS
BEGIN
	
	DECLARE		@L_NumeroExpediente VARCHAR(14)		= @NumeroExpediente

	SELECT		A.TF_Inicio_Vigencia				FechaActivacion,
				A.TF_Fin_Vigencia					FechaDesactivacion,
				A.TB_Principal						Principal,
				A.TB_NotificaRepresentante			NotificacaRepresentante,
				'splitOtros'						splitOtros,				
				A.TU_CodInterviniente				CodigoIntervencionRepresentada,
				C.TU_CodPersona						CodigoPersonaRepresentada,
				C.TC_Identificacion					IdentificacionPersonaRepresentada,				
				A.TU_CodIntervinienteRepresentante	CodigoIntervencionRepresentante,
				E.TU_CodPersona						CodigoPersonaRepresentante,
				E.TC_Identificacion					IdentificacionPersonaRepresentante

	FROM		Expediente.Representacion			A	WITH(NOLOCK) 
	INNER JOIN	Expediente.Intervencion				B	WITH(NOLOCK) 
	ON			A.TU_CodInterviniente				=   B.TU_CodInterviniente
	INNER JOIN	Persona.Persona						C	WITH(NOLOCK) 
	ON			C.TU_CodPersona						=	B.TU_CodPersona
	INNER JOIN	Expediente.Intervencion				D	WITH(NOLOCK) 
    ON			D.TU_CodInterviniente				=	A.TU_CodIntervinienteRepresentante
	INNER JOIN	Persona.Persona						E	WITH(NOLOCK) 
	ON			E.TU_CodPersona						=	D.TU_CodPersona

	WHERE		B.TC_NumeroExpediente				=	@L_NumeroExpediente
	
END
GO
