SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================================================
-- Version:			  <1.0>
-- Creado por:		  <Cordero Soto Jose Gabriel>
-- Fecha de creación: <13/11/2019>
-- Descripción:		  <Obtiene ultimo registro de entrada y salida del legajo>
-- =========================================================================================================================================
-- Modificación:	 <Aida E Siles R> <15/07/2020> <Se modifica el nombre de la columna TF_Envio por TF_CreacionItineracion>
-- Modificación:	 <Luis Alonso Leiva Tames> <23/04/2023> <Se modifica para consultar el Codigo Historico Itineracion>
-- =========================================================================================================================================


CREATE PROCEDURE [Historico].[PA_ConsultarUltimoLegajoEntradaSalida]
@CodLegajo uniqueidentifier,
@CodContexto varchar(4), 
@CodHistorico uniqueidentifier = null
AS
BEGIN

	Declare @L_CodLegajo uniqueidentifier = @CodLegajo
	DECLARE @L_CodContexto varchar(4) = @CodContexto
	DECLARE @L_CodHistorico uniqueidentifier = @CodHistorico


	if(@L_CodHistorico is null or @L_CodHistorico = '00000000-0000-0000-0000-000000000000')  
	Begin

		SELECT TOP(1) 			
				A.TF_Entrada						AS  FechaEntrada,			
				'splitOtros'						AS  splitOtros,
				A.TU_CodLegajoEntradaSalida			AS  CodigoLegajoEntradaSalida,			
				A.TF_CreacionItineracion			AS  FechaCreacion,
				A.TF_SALIDA							AS  FechaSalida,
				A.TU_CodHistoricoItineracion		AS	CodigoHistoricoItineracion,			
				B.TC_CodContexto					AS  ContextoOrigen, 
				B.TC_Descripcion					AS  DescripcionOrigen,
				C.TC_CodContexto					AS  ContextoDestino,
				C.TC_Descripcion					AS  DescripcionDestino,
				A.TU_CodLegajo						AS  CodigoLegajo,
				D.TN_CodMotivoItineracion			AS  CodigoItineracion,
				D.TC_Descripcion					AS	DescripcionItineracion

		FROM		Historico.LegajoEntradaSalida A WITH(NOLOCK)
		LEFT JOIN  Catalogo.Contexto B				WITH(NOLOCK)
		ON			A.TC_CodContexto = B.TC_CodContexto 
		LEFT JOIN	Catalogo.Contexto C				WITH(NOLOCK)
		ON			A.TC_CodContextoDestino = C.TC_CodContexto
		LEFT JOIN	Catalogo.MotivoItineracion D	WITH(NOLOCK)
		ON			A.TN_CodMotivoItineracion = D.TN_CodMotivoItineracion

		WHERE A.TU_CodLegajo = @L_CodLegajo
		AND A.TC_CodContexto = @L_CodContexto
		ORDER BY TF_Entrada DESC

	End  
	else begin 

		SELECT TOP(1) 			
				A.TF_Entrada						AS  FechaEntrada,			
				'splitOtros'						AS  splitOtros,
				A.TU_CodLegajoEntradaSalida			AS  CodigoLegajoEntradaSalida,			
				A.TF_CreacionItineracion			AS  FechaCreacion,
				A.TF_SALIDA							AS  FechaSalida,
				A.TU_CodHistoricoItineracion		AS	CodigoHistoricoItineracion,			
				B.TC_CodContexto					AS  ContextoOrigen, 
				B.TC_Descripcion					AS  DescripcionOrigen,
				C.TC_CodContexto					AS  ContextoDestino,
				C.TC_Descripcion					AS  DescripcionDestino,
				A.TU_CodLegajo						AS  CodigoLegajo,
				D.TN_CodMotivoItineracion			AS  CodigoItineracion,
				D.TC_Descripcion					AS	DescripcionItineracion

		FROM		Historico.LegajoEntradaSalida A WITH(NOLOCK)
		LEFT JOIN  Catalogo.Contexto B				WITH(NOLOCK)
		ON			A.TC_CodContexto = B.TC_CodContexto 
		LEFT JOIN	Catalogo.Contexto C				WITH(NOLOCK)
		ON			A.TC_CodContextoDestino = C.TC_CodContexto
		LEFT JOIN	Catalogo.MotivoItineracion D	WITH(NOLOCK)
		ON			A.TN_CodMotivoItineracion = D.TN_CodMotivoItineracion

		WHERE A.TU_CodHistoricoItineracion = @L_CodHistorico
		ORDER BY TF_Entrada DESC

	End
END
GO
