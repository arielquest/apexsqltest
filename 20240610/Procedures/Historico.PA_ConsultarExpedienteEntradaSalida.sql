SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara Hernandez>
-- Fecha de creación:		<03/12/2015>
-- Descripción :			<Consulta las entradas y salidas de un expediente> 
-- =================================================================================================================================================
-- Modificación:			<Johan Acosta> <05/12/2016> <Se cambio nombre de TC a TN>
-- Modificación:			<Jonathan Aguilar Navarro> <02/05/2018> <Se cambia TC_CodOficina y TC_CodContexto ademas de cambios el parametro
--							@CodOficina por @CodContexto, TC_CodOficinaDestino por TC_CodContextoDestino>
-- Modificación:			<Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- Modificación:			<Jonathan Aguilar Navarro> <16/01/2020> <Se modifican las ligas ya que no debe de ser al legajo si no a Expediente> 
-- Modificación:			<Aida E Siles Rojas> <15/07/2020> <Se modifica el nombre de la columna TF_Envio por TF_CreacionItineracion>
-- Modificación:			<Aida E Siles Rojas> <01/03/2021> <Se agrega parámetro ObtenerUltimoES es caso de requerir consultar ultimo registroES>
-- Modificación:			<Aida E Siles Rojas> <19/07/2021> <Se corrige consulta para obtener el código de contexto correctamente.>
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_ConsultarExpedienteEntradaSalida] 
	@NumeroExpediente			VARCHAR(14), 	
	@CodContexto				VARCHAR(4)	= NULL,
	@ObtenerUltimoES			BIT			= 0
AS
BEGIN
--Variables
DECLARE @L_NumeroExpediente			VARCHAR(14) =  	@NumeroExpediente,
		@L_CodContexto				VARCHAR(4)	=	@CodContexto,
		@L_ObtenerUltimoES			BIT			=	@ObtenerUltimoES
 
 IF (@L_ObtenerUltimoES = 0)
	BEGIN
		SELECT		A.TU_CodExpedienteEntradaSalida							AS Codigo,
					A.TF_Entrada											AS FechaEntrada,
					A.TF_Salida												AS FechaSalida,
					A.TF_CreacionItineracion								AS FechaCreacion,
					'SplitContexto'											AS SplitContexto, 
					A.TC_CodContexto										AS Codigo,
					B.TC_Descripcion										AS Descripcion,
					'SplitContextoD'										AS SplitContextoD, 
					A.TC_CodContextoDestino									AS Codigo,
					C.TC_Descripcion										AS Descripcion,
					'SplitOtros'											AS SplitOtros,
					A.TN_CodMotivoItineracion								AS CodigoMotivoItineracion,
					A.TU_CodHistoricoItineracion							AS CodigoHistoricoItineracion

		FROM		Historico.ExpedienteEntradaSalida					A WITH(NOLOCK)
		INNER JOIN	Catalogo.Contexto									B WITH(NOLOCK) 
		ON			A.TC_CodContexto									= B.TC_CodContexto
		LEFT JOIN	Catalogo.Contexto									C WITH (NOLOCK)
		ON			C.TC_CodContexto									= A.TC_CodContextoDestino
		WHERE		A.TC_NumeroExpediente								= @L_NumeroExpediente 
		AND			A.TC_CodContexto									= COALESCE (@L_CodContexto, A.TC_CodContexto)
	END
ELSE
	BEGIN
		SELECT		TOP 1
					A.TU_CodExpedienteEntradaSalida							AS Codigo,
					A.TF_Entrada											AS FechaEntrada,
					A.TF_Salida												AS FechaSalida,
					A.TF_CreacionItineracion								AS FechaCreacion,
					'SplitContexto'											AS SplitContexto, 
					A.TC_CodContexto										AS Codigo,
					B.TC_Descripcion										AS Descripcion,
					'SplitContextoD'										AS SplitContextoD, 
					A.TC_CodContextoDestino									AS Codigo,
					C.TC_Descripcion										AS Descripcion,
					'SplitOtro'												AS SplitOtros,
					A.TN_CodMotivoItineracion								AS CodigoMotivoItineracion,
					A.TU_CodHistoricoItineracion							AS CodigoHistoricoItineracion

		FROM		Historico.ExpedienteEntradaSalida					A WITH(NOLOCK)
		INNER JOIN	Catalogo.Contexto									B WITH(NOLOCK) 
		ON			A.TC_CodContexto									= B.TC_CodContexto
		LEFT JOIN	Catalogo.Contexto									C WITH (NOLOCK)
		ON			C.TC_CodContexto									= A.TC_CodContextoDestino
		WHERE		A.TC_NumeroExpediente								= @L_NumeroExpediente 
		AND			A.TC_CodContexto									= COALESCE (@L_CodContexto, A.TC_CodContexto)
		ORDER BY	A.TF_Entrada DESC
	END

END
GO
