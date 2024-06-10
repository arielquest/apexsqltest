SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto V>
-- Fecha de creación:		<22/02/2021>
-- Descripción :			<Permite consultar los legajos de apremio de un expediente> 
-- =================================================================================================================================================================================
-- Versión:					<2.0>
-- Creado por:				<Xinia Soto V>
-- Fecha de creación:		<9/04/2021>
-- Descripción :			<Se corrige porque devolvia un resultado por cada apremio del legajo> 
-- =================================================================================================================================================================================
-- MOdificación:			<Jonathan Aguilar Navarro><27/02/2023><PBI Incidente 301001 - Se quita inner join de Legajo contra LegajoApremio, para que unicamente valide
--							la existencia de un legajo de tipo Apremio>	

CREATE PROCEDURE [Expediente].[PA_ConsultarLegajoApremio]
	@Numero						CHAR(14),
	@CodContexto				VARCHAR(4)			= NULL
AS
BEGIN
--Declaración de variables
DECLARE @L_Numero				CHAR(14)			= @Numero
DECLARE @L_CodContexto			VARCHAR(4)			= @CodContexto


			SELECT DISTINCT	
					A.TU_CodLegajo							AS	Codigo,
					A.TC_NumeroExpediente					AS	NumeroExpediente,
					A.TF_Inicio								AS	FechaInicio,
					A.TC_Descripcion						AS	Descripcion,
					A.TF_Actualizacion						AS	FechaActualizacion,
					B.TF_Entrada							AS	FechaEntrada,
					IIF((HRR.TU_CodLegajo IS NULL 
					AND HSR.TU_CodLegajo IS NULL), 0, 1)	AS  CreadoPorItineracion,
					A.CARPETA								AS	CarpetaGestion,
					'SplitContextoCreacion'					AS	SplitContextoCreacion,
					C.TC_CodContexto						AS	Codigo,
					C.TC_Descripcion						AS  Descripcion,
					'SplitContexto'							AS	SplitContexto,
					D.TC_CodContexto						AS	Codigo,
					D.TC_Descripcion						AS  Descripcion,
					D.TB_EnvioEscrito_GL_AM					AS  EnvioEscrito_GL_AM,
					D.TB_EnvioDemandaDenuncia_GL_AM			AS  EnvioDemandaDenuncia_GL_AM,
					D.TB_ConsultaPublicaCiudadano			AS  ConsultaPublicaCiudadano,
					D.TB_ConsultaPrivadaCiudadano			AS  ConsultaPrivadaCiudadano,
					'SplitPrioridad'						AS	SplitPrioridad,
					E.TN_CodPrioridad						AS	Codigo,
					E.TC_Descripcion						AS  Descripcion,
					'SplitClaseAsunto'						AS	SplitClaseAsunto,
					F.TN_CodClaseAsunto						AS	Codigo,
					F.TC_Descripcion						AS  Descripcion,
					'SplitAsunto'							AS	SplitAsunto,
					G.TN_CodAsunto							AS	Codigo,
					G.TC_Descripcion						AS  Descripcion,
					'Split'									AS	Split,
					H.TC_CodContexto						AS	CodigoContextoDetalle,
					H.TC_Descripcion						AS  DescripcionContextoDetalle,
					I.TC_CodContexto						AS	CodigoContextoProcedencia,
					I.TC_Descripcion						AS  DescripcionContextoProcedencia,
					J.TN_CodGrupoTrabajo					AS	CodigoGrupo,
					J.TC_Descripcion						AS  DescripcionGrupo,
					B.TB_Habilitado							AS	Habilitado,
					U.TN_CodEstado							AS	CodigoEstado,
					U.TC_Descripcion						AS	DescripcionEstado,
					U.TC_Circulante							AS	EstadoCirculante,
					L.TC_CodMateria							AS  CodigoMateriaLegajo,
					L.TC_Descripcion						AS  DescripcionMateriaLegajo,
					M.TC_CodOficina							AS  CodigoOficinaContexto,
					M.TC_Nombre								AS	DescripcionOficinaContexto,
					N.TN_CodTipoOficina						AS  CodigoTipoOficina,
					N.TC_Descripcion						AS  DescripcionTipoOficina,
					HFO.TN_CodFase							AS  CodigoFase,
					HFO.TC_Descripcion						AS	DescripcionFase,
					0										AS  TotalRegistros
			  FROM			Expediente.Legajo				AS	A WITH (NOLOCK)
			  INNER JOIN	Expediente.LegajoDetalle		AS  B WITH (NOLOCK)
			  ON			B.TU_CodLegajo					=	A.TU_CodLegajo
			  INNER JOIN	Catalogo.Contexto				AS	C WITH (NOLOCK)
			  ON			C.TC_CodContexto				=	A.TC_CodContextoCreacion	
			  INNER JOIN	Catalogo.Contexto				AS	D WITH (NOLOCK)
			  ON			D.TC_CodContexto				=	A.TC_CodContexto	
			  LEFT JOIN		Catalogo.Prioridad				AS	E WITH (NOLOCK)
			  ON			E.TN_CodPrioridad				=	A.TN_CodPrioridad
			  LEFT JOIN		Catalogo.ClaseAsunto			AS	F WITH (NOLOCK)
			  ON			F.TN_CodClaseAsunto				=	B.TN_CodClaseAsunto
			  LEFT JOIN		Catalogo.Asunto					AS	G WITH (NOLOCK)
			  ON			G.TN_CodAsunto					=	B.TN_CodAsunto
			  INNER JOIN	Catalogo.Contexto				AS	H WITH (NOLOCK)
			  ON			H.TC_CodContexto				=	B.TC_CodContexto
			  INNER JOIN	Catalogo.Contexto				AS	I WITH (NOLOCK)
			  ON			I.TC_CodContexto				=	B.TC_CodContextoProcedencia
			  LEFT JOIN		Catalogo.GrupoTrabajo			AS	J WITH (NOLOCK)
			  ON			J.TN_CodGrupoTrabajo			=	B.TN_CodGrupoTrabajo
			  INNER JOIN	Catalogo.Materia				AS	L WITH (NOLOCK)
			  ON			L.TC_CodMateria					=	D.TC_CodMateria
			  INNER JOIN	Historico.LegajoMovimientoCirculante	AS	HL WITH (NOLOCK)
			  ON			HL.TU_CodLegajo					=	B.TU_CodLegajo
			  AND			HL.TF_Fecha						=	(SELECT TOP 1 TF_Fecha 
  																 FROM Historico.LegajoMovimientoCirculante
  																 WHERE TU_CodLegajo = B.TU_CodLegajo
																 AND	TC_CodContexto	= B.TC_CodContexto
																 AND	TC_NumeroExpediente	= A.TC_NumeroExpediente													
  																 ORDER BY TF_Fecha DESC)	
			  OUTER APPLY									(SELECT TOP(1)	HF.TN_CodFase, V.TC_Descripcion
															FROM			Historico.LegajoFase HF		WITH(NOLOCK)
															INNER JOIN		Catalogo.Fase				AS V WITH(NOLOCK)
															ON				V.TN_CodFase				= HF.TN_CodFase
															WHERE			HF.TU_CodLegajo				= B.TU_CodLegajo
															AND				HF.TC_CodContexto			= B.TC_CodContexto
															ORDER BY		HF.TF_Fase DESC)HFO
			  INNER JOIN	Catalogo.Oficina				AS  M WITH (NOLOCK)
			  ON			M.TC_CodOficina					=	D.TC_CodOficina
			  INNER JOIN	Catalogo.TipoOficina			AS  N WITH (NOLOCK)
			  ON			N.TN_CodTipoOficina				=	M.TN_CodTipoOficina
			  INNER JOIN	Catalogo.Estado					AS	U WITH (NOLOCK)
			  ON			U.TN_CodEstado					=	HL.TN_CodEstado	 
			  LEFT JOIN		Historico.ItineracionRecursoResultado AS	HRR WITH (NOLOCK)
			  ON			HRR.TU_CodLegajo				=	B.TU_CodLegajo
			  LEFT JOIN		Historico.ItineracionSolicitudResultado AS	HSR WITH (NOLOCK)
			  ON			HSR.TU_CodLegajo				=	B.TU_CodLegajo
			  WHERE			A.TC_NumeroExpediente			=	COALESCE(@L_Numero, A.TC_NumeroExpediente)
			  AND			A.TC_CodContexto				=   COALESCE(@L_CodContexto, A.TC_CodContexto)
			  AND			B.TC_CodContexto				=   COALESCE(@L_CodContexto, B.TC_CodContexto)
	
END
GO
