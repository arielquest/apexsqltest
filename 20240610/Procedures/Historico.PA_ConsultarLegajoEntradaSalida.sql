SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Karol Jiménez Sánchez>
-- Fecha de creación:		<26/02/2021>
-- Descripción :			<Consulta las entradas y salidas de un legajo> 
-- =================================================================================================================================================
-- Modificación:			<Aida Elena Siles R> <01/03/2021> <Se agrega parámetro ObtenerUltimoES en caso de requerir consultar ultimo registro ES>
-- =================================================================================================================================================
CREATE PROCEDURE [Historico].[PA_ConsultarLegajoEntradaSalida] 
	@CodLegajo					UNIQUEIDENTIFIER, 	
	@CodContexto				VARCHAR(4) =	NULL,
	@ObtenerUltimoES			BIT		   =	0
AS
BEGIN
--VARIABLES
DECLARE @L_CodLegajo					UNIQUEIDENTIFIER	= @CodLegajo,
		@L_CodContexto					VARCHAR(4)			= @CodContexto,
		@L_ObtenerUltimoES				BIT					= @ObtenerUltimoES

IF (@L_ObtenerUltimoES = 0)
	BEGIN
		SELECT		A.TU_CodLegajoEntradaSalida			Codigo,
					A.TF_Entrada						FechaEntrada,
					A.TF_Salida							FechaSalida,
					A.TF_CreacionItineracion			FechaCreacion,
					'SplitContexto'						SplitContexto, 
					A.TC_CodContexto					Codigo,
					B.TC_Descripcion					Descripcion,
					'SplitContextoD'					SplitContextoD, 
					A.TC_CodContextoDestino				Codigo,
					C.TC_Descripcion					Descripcion,
					'SplitOtros'						SplitOtros,
					A.TN_CodMotivoItineracion			CodigoMotivoItineracion,
					A.TU_CodHistoricoItineracion		CodigoHistoricoItineracion
		FROM		Historico.LegajoEntradaSalida		A WITH (NOLOCK)
		INNER JOIN	Catalogo.Contexto					B WITH (NOLOCK) 
		ON			A.TC_CodContexto					= B.TC_CodContexto
		LEFT JOIN	Catalogo.Contexto					C WITH (NOLOCK) 
		ON			A.TC_CodContextoDestino				= C.TC_CodContexto
		WHERE		A.TU_CodLegajo						= @L_CodLegajo
		AND			A.TC_CodContexto					= COALESCE(@L_CodContexto, A.TC_CodContexto)
	END
ELSE
	BEGIN
		SELECT		TOP 1
					A.TU_CodLegajoEntradaSalida			Codigo,
					A.TF_Entrada						FechaEntrada,
					A.TF_Salida							FechaSalida,
					A.TF_CreacionItineracion			FechaCreacion,
					'SplitContexto'						SplitContexto, 
					A.TC_CodContexto					Codigo,
					B.TC_Descripcion					Descripcion,
					'SplitContextoD'					SplitContextoD, 
					A.TC_CodContextoDestino				Codigo,
					C.TC_Descripcion					Descripcion,
					'SplitOtros'						SplitOtros,
					A.TN_CodMotivoItineracion			CodigoMotivoItineracion,
					A.TU_CodHistoricoItineracion		CodigoHistoricoItineracion
		FROM		Historico.LegajoEntradaSalida		A WITH (NOLOCK)
		INNER JOIN	Catalogo.Contexto					B WITH (NOLOCK) 
		ON			A.TC_CodContexto					= B.TC_CodContexto
		LEFT JOIN	Catalogo.Contexto					C WITH (NOLOCK) 
		ON			A.TC_CodContextoDestino				= C.TC_CodContexto
		WHERE		A.TU_CodLegajo						= @L_CodLegajo
		AND			A.TC_CodContexto					= COALESCE(@L_CodContexto, A.TC_CodContexto)
		ORDER BY	A.TF_Entrada DESC
	END
END


GO
