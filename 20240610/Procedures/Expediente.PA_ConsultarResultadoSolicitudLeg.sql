SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles Rojas>
-- Fecha de creación:	<05/11/2020>
-- Descripción:			<Permite consultar el resultado de un legajo de una solicitud itinerada.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ConsultarResultadoSolicitudLeg]
@CodLegajo			UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_CodLegajo				 UNIQUEIDENTIFIER	=  @CodLegajo
	
	--Lógica
	SELECT		
				RS.TF_FechaCreacion					 AS FechaCreacion,
				RS.TF_FechaEnvio					 AS FechaEnvio,
				RS.TF_FechaRecepcion				 AS FechaRecepcion,	
				RS.TU_CodResultadoSolicitud			 AS Codigo,
				'split'								 AS	split,
				RS.TU_CodLegajo						 AS CodigoLegajo,
				RS.TN_CodResultadoLegajo			 AS CodigoResultadoLegajo,
				RL.TC_Descripcion					 AS DescripcionResultadoLegajo,
				RS.TC_CodContextoOrigen				 AS CodigoContextoOrigen,
				C.TC_Descripcion					 AS DescripcionContextoOrigen,
				RS.TN_CodEstadoItineracion			 AS CodigoEstadoItineracion,
				EI.TC_Descripcion					 AS DescripcionEstadoItineracion,
				RS.TC_UsuarioRed					 AS UsuarioRed,
				F.TC_Nombre							 AS NombreFuncionario,
				F.TC_PrimerApellido					 AS PrimerApellidoFuncionario,
				F.TC_SegundoApellido				 AS SegundoApellidoFuncionario,
				RS.TU_CodHistoricoItineracion		 AS CodigoHistoricoItineracion,
				RS.TN_CodMotivoItineracion			 AS CodigoMotivoItineracion,
				MI.TC_Descripcion				     AS DescripcionMotivoItineracion,
				L.TC_NumeroExpediente				 AS NumeroExpediente
			
	FROM		Expediente.ResultadoSolicitud		 RS WITH (NOLOCK)	
	INNER JOIN  Catalogo.EstadoItineracion			 EI WITH(NOLOCK)
	ON			EI.TN_CodEstadoItineracion			 = RS.TN_CodEstadoItineracion
	INNER JOIN  Catalogo.Funcionario				 F WITH(NOLOCK)
	ON			F.TC_UsuarioRed						 = RS.TC_UsuarioRed
	INNER JOIN	Catalogo.Contexto				     C WITH(NOLOCK)
	ON			C.TC_CodContexto					 = RS.TC_CodContextoOrigen
	INNER JOIN  Catalogo.MotivoItineracion			 MI WITH(NOLOCK)
	ON			RS.TN_CodMotivoItineracion			 = MI.TN_CodMotivoItineracion
	INNER JOIN  Catalogo.ResultadoLegajo			 RL WITH (NOLOCK)
	ON			RL.TN_CodResultadoLegajo			 = RS.TN_CodResultadoLegajo
	INNER JOIN	Expediente.Legajo					 L WITH (NOLOCK)
	ON			RS.TU_CodLegajo						 = L.TU_CodLegajo

	WHERE		RS.TU_CodLegajo						 = @L_CodLegajo
END
GO
