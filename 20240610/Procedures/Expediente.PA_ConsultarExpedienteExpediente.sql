SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles R>
-- Fecha de creación:	<21/10/2021>
-- Descripción:			<Permite consultar un registro en la tabla: Expediente.Expediente>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ConsultarExpedienteExpediente]
	@NumeroExpediente		CHAR(14)
AS
BEGIN
	--Variables
	DECLARE	@L_TC_NumeroExpediente		CHAR(14)		= @NumeroExpediente

	--Lógica
	SELECT	A.TF_Inicio						FechaInicio,			
			A.TB_Confidencial				Confidencial,			
			A.TC_Descripcion				Descripcion,
			A.TB_CasoRelevante				CasoRelevante,						
			A.TF_Hechos						FechaHechos,
			A.CARPETA						CarpetaGestion,
			A.TN_MontoCuantia				MontoCuantia,
			A.TN_MontoMensual				MontoMensual,
			A.TN_MontoAguinaldo				MontoAguinaldo,
			A.TN_MontoSalarioEscolar		MontoSalarioEscolar,
			A.TN_MontoEmbargo				MontoEmbargo,
			'Split'							Split, -- Contexto
			A.TC_CodContexto				CodContexto,
			'Split'							Split, -- ContextoCreacion
			A.TC_CodContextoCreacion		CodContextoCreacion
	FROM	Expediente.Expediente			A WITH (NOLOCK)
	WHERE	TC_NumeroExpediente				= @L_TC_NumeroExpediente
END
GO
