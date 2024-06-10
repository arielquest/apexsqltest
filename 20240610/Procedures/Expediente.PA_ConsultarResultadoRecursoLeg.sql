SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles Rojas>
-- Fecha de creación:	<05/11/2020>
-- Descripción:			<Permite consultar el resultado de un legajo de un recurso itinerado.>
-- ==================================================================================================================================================================================
-- Modificado:              <Oscar Sánchez Hernández> <12/2022> HU 272425 <Modificar SP PA_ConsultarResultadoRecursoLeg, para traer los escritos asociados al resultado de recurso, left join con expediente.ResultadoRecursoEscrito.>
CREATE   PROCEDURE	[Expediente].[PA_ConsultarResultadoRecursoLeg]
@CodLegajo			UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_CodLegajo				 UNIQUEIDENTIFIER	=  @CodLegajo
	
	--Lógica
	SELECT		
				RR.TF_FechaCreacion					 AS FechaCreacion,
				RR.TF_FechaEnvio					 AS FechaEnvio,
				RR.TF_FechaRecepcion				 AS FechaRecepcion,	
				RR.TU_CodResultadoRecurso			 AS Codigo,
				'split'								 AS	split,
				RR.TU_CodLegajo						 AS CodigoLegajo,
				RR.TN_CodResultadoLegajo			 AS CodigoResultadoLegajo,
				RL.TC_Descripcion					 AS DescripcionResultadoLegajo,
				RR.TC_CodContextoOrigen				 AS CodigoContextoOrigen,
				C.TC_Descripcion					 AS DescripcionContextoOrigen,
				RR.TN_CodEstadoItineracion			 AS CodigoEstadoItineracion,
				EI.TC_Descripcion					 AS DescripcionEstadoItineracion,
				RR.TC_UsuarioRed					 AS UsuarioRed,
				F.TC_Nombre							 AS NombreFuncionario,
				F.TC_PrimerApellido					 AS PrimerApellidoFuncionario,
				F.TC_SegundoApellido				 AS SegundoApellidoFuncionario,
				RR.TU_CodHistoricoItineracion		 AS CodigoHistoricoItineracion,
				RR.TN_CodMotivoItineracion			 AS CodigoMotivoItineracion,
				MI.TC_Descripcion				     AS DescripcionMotivoItineracion,
				L.TC_NumeroExpediente				 AS NumeroExpediente
			
	FROM		Expediente.ResultadoRecurso			 RR WITH (NOLOCK)	
	INNER JOIN  Catalogo.EstadoItineracion			 EI WITH(NOLOCK)
	ON			EI.TN_CodEstadoItineracion			 = RR.TN_CodEstadoItineracion
	INNER JOIN  Catalogo.Funcionario				 F WITH(NOLOCK)
	ON			F.TC_UsuarioRed						 = RR.TC_UsuarioRed
	INNER JOIN	Catalogo.Contexto				     C WITH(NOLOCK)
	ON			C.TC_CodContexto					 = RR.TC_CodContextoOrigen
	INNER JOIN  Catalogo.MotivoItineracion			 MI WITH(NOLOCK)
	ON			RR.TN_CodMotivoItineracion			 = MI.TN_CodMotivoItineracion
	INNER JOIN  Catalogo.ResultadoLegajo			 RL WITH (NOLOCK)
	ON			RL.TN_CodResultadoLegajo			 = RR.TN_CodResultadoLegajo
	INNER JOIN	Expediente.Legajo					 L WITH (NOLOCK)
	ON			RR.TU_CodLegajo						 = L.TU_CodLegajo
LEFT JOIN   Expediente.ResultadoRecursoEscrito   RRE WITH (NOLOCK)
	ON          RR.TU_CodResultadoRecurso            = RRE.TU_CodResultadoRecurso

	WHERE		RR.TU_CodLegajo						 = @L_CodLegajo
END
GO
