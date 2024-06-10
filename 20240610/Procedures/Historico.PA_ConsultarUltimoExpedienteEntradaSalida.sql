SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================
-- Version:			  <1.0>
-- Creado por:		  <Cordero Soto Jose Gabriel>
-- Fecha de creación: <13/11/2019>
-- Descripción:		  <Obtiene ultimo registro de entrada y salida del expediente>
-- =============================================================================================================================
-- Modificación:	<Aida E Siles Rojas> <15/07/2020> <Se modifica el nombre de la columna TF_Envio por TF_CreacionItineracion>
-- =============================================================================================================================
CREATE PROCEDURE [Historico].[PA_ConsultarUltimoExpedienteEntradaSalida]
@NumeroExpediente varchar(14),
@CodContexto varchar(4)
AS
BEGIN

	DECLARE @L_NumeroExpediente varchar(14) = @NumeroExpediente
	DECLARE @L_CodContexto varchar(4) = @CodContexto

	SELECT TOP(1) 
			A.TF_Entrada						AS  FechaEntrada,			
			'splitOtros'						AS  splitOtros,
			A.TU_CodExpedienteEntradaSalida  	AS  CodigoExpedienteEntradaSalida,			
			A.TF_CreacionItineracion			AS  FechaCreacion,
			A.TF_Salida							AS  FechaSalida,
			A.TU_CodHistoricoItineracion		AS	CodigoHistoricoItineracion,			
			B.TC_CodContexto					AS  ContextoOrigen, 
			B.TC_Descripcion					AS  DescripcionOrigen,
			C.TC_CodContexto					AS  ContextoDestino,
			C.TC_Descripcion					AS  DescripcionDestino,
			A.TC_NumeroExpediente				AS  NumeroExpediente,
			D.TN_CodMotivoItineracion			AS  CodigoItineracion,
			D.TC_Descripcion					AS	DescripcionItineracion

	FROM Historico.ExpedienteEntradaSalida A
	LEFT JOIN  Catalogo.Contexto B				WITH(NOLOCK)
	ON			A.TC_CodContexto = B.TC_CodContexto 
	LEFT JOIN	Catalogo.Contexto C				WITH(NOLOCK)
	ON			A.TC_CodContextoDestino = C.TC_CodContexto
	LEFT JOIN	Catalogo.MotivoItineracion D	WITH(NOLOCK)
	ON			A.TN_CodMotivoItineracion = D.TN_CodMotivoItineracion

	WHERE A.TC_NumeroExpediente = @L_NumeroExpediente
	AND A.TC_CodContexto = @L_CodContexto
	ORDER BY TF_Entrada DESC

END
GO
