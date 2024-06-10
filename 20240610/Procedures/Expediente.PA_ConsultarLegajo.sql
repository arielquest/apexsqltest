SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<13/03/2019>
-- Descripción :			<Permite consultar los legajos de un expediente> 
-- =================================================================================================================================================================================
-- Modificación				<10/05/2019> <Jonathan Aguilar Navarro> <Se modifica para devolver el contexto y materia de la tabla Legajo.> 
-- Modificación				<11/06/2019> <Isaac Dobles Mata> <Se modifica para devolver el Estado del Circulante.> 
-- Modificación				<07/10/2019> <Isaac Dobles Mata> <Se agrega parámetro código de legajo.> 
-- Modificación				<14/04/2020> <Johan Manuel Acosta Ibañez> <Se agrega si el contexto donde se encuentra permite EnvioEscritos a Gestión en Linea y App Móvil 
--										  PBI 72302 Funcionalidad HU 11 Envío de Escritos GL- Funcionalidad búsqueda del expediente.> 
-- Modificación				<27/04/2020> <Kirvin Bennett Mathurin> <Se agrega si el contexto donde se encuentra permite EnvioDemandasDenuncias a Gestión en Linea y App Móvil PBI 102758 HU 08 FUN Registrar Datos Generales de la demanda > 
-- Modificación				<04/05/2020> <Daniel Ruiz Hernandez> <Se agrega parámetro movimiento.> 
-- Modificación				<14/05/2020> <Johan Manuel Acosta Ibañez> <Se agrega obtener el tipo de la oficina PBI 68962 HU 12 Envío de Escritos GL- Funcionalidad señalar datos de la entrega.> 
-- Modificación				<17/06/2020> <Xinia Soto Valerio> <Corrige nombres de valores devueltos en contexto de creación> 
-- Modificación				<09/07/2020> <Kirvin Bennett Mathurin> <Se agrega que retorne si el contexto donde se encuentra permite ConsultaPublicaCiudadadono y ConsultaPrivadaCiudadadono a Gestión en Linea y App Móvil>
-- Modificación				<24/08/2020> <Aida Elena Siles Rojas> <Se agrega el contexto a la busqueda para que retorne solo los del contexto donde esta logueado usuario>
-- Modificación				<05/11/2020> <Aida Elena Siles Rojas> <Se agrega a la consulta el indicador para saber si el legajo fue creado a partir de la recepción de un recurso o solicitud.>
-- Modificación				<25/11/2020> <Aida Elena Siles Rojas> <Se agrega a la consulta para que filtre por el contexto de LegajoDetalle.>
-- Modificación				<04/12/2020> <Jose Gabriel Cordero Soto> <Se hacen los ajustes y validaciones necesarias para utilizar consulta con paginación y sin ella.>
-- Modificación				<10/12/2020> <Daniel Ruiz Hernández> <Se agrega la consulta de la fase del legajo.>
-- Modificación				<18/01/2021> <Jose Gabriel Cordero Soto> <Se ajusta tipo de campo CodigoClase de SMALLINT a INT por error en desbordamiento>
-- Modificación				<28/01/2021> <Jose Gabriel Cordero Soto> <Se realiza ajuste en consulta final en los escenarios de resultado>
-- Modificación             <22/02/2021> <Karol Jiménez S.><Se agrega consulta de CarpetaGestion (CARPETA)>
-- Modificación             <27/04/2021> <Xinia Soto V.><Se ordena por fecha entrada desc>
-- Modificación             <05/07/2021> <Jose Gabriel Cordero Soto><Se realiza ajuste en tabla temporal, dado que el CodigoEstado era SMALLINT y realmente es INT>
-- Modificación             <18/08/2021> <Roger Lara><Se cambia validacion de Movimiento para que sea a Estado.TC_Circulante	 y no al LegajoMovimientoCirculante.TC_Movimiento >
-- Modificación             <14/10/2021> <Aida Elena Siles R><Se agrega a la consulta el dato LegajoSinExpediente, para identificar si el legajo esta asociado a un expediente que existe o no en SIAGPJ.>
-- Modificación				<10/11/2021> <Aarón Ríos Retana><se añade un inner join a Catalogo.Proceso, esto para que retorne el código de proceso y la descripción del proceso>
-- Modificación				<10/01/2022> <Aarón Ríos Retana><Se corrige inner join por left join Catalogo.Proceso, ya que estaba excluyendo resultados>
-- Modificación				<15/04/2022><Johan M. Acosta Ibañez><Se añade la ubicación y tarea a la consulta para el detalle del expediente  en tramitación masiva>
-- Modificación             <16/02/2023> <Ricardo Gutiérrez Peña><Se agrega para que retorne el contexto superior del contexto donde se encuentra el legajo>					
-- Modificación				<17/10/2022> <Josué Quirós Batista> <Se elimina la restricción de la consulta que asociaba el detalle del legajo con el contexto de la tabla Expediente.Expediente.>
-- Modificación				<05/10/2023> <Karol Jiménez Sánchez><Se modifica para incluir a la consulta el valor TB_EmbargosFisicos. PBI 347798.>												
-- =================================================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_ConsultarLegajo]
	@Numero						CHAR(14),
	@CodigoLegajo				UNIQUEIDENTIFIER	= NULL,
	@Movimiento					CHAR(1)				= NULL,
	@CodContexto				VARCHAR(4)			= NULL,
	@NumeroPagina				SMALLINT			= NULL,
	@CantidadRegistros			SMALLINT			= NULL
AS
BEGIN
	--Declaración de variables
	DECLARE @L_Numero				CHAR(14)			= @Numero
	DECLARE @L_CodigoLegajo			UNIQUEIDENTIFIER	= @CodigoLegajo
	DECLARE @L_Movimiento			CHAR(1)				= @Movimiento
	DECLARE @L_CodContexto			VARCHAR(4)			= @CodContexto
	DECLARE @L_NumeroPagina			SMALLINT			= @NumeroPagina
	DECLARE @L_CantidadRegistros	SMALLINT			= @CantidadRegistros

	 --Para Obtener cantidad registros de la consulta
	DECLARE @L_TotalRegistros		INT	

	--Creación de tabla temporal
	DECLARE @Legajos AS TABLE
	(
		CodigoLegajo							UNIQUEIDENTIFIER,
		NumeroExpediente						VARCHAR(14),
		FechaInicio								DATETIME2(3),
		DescripcionLegajo						VARCHAR(255),
		FechaActualizacion						DATETIME2(3),
		FechaEntrada							DATETIME2(3),
		CreadoPorItineracion					BIT,
		CarpetaGestion							VARCHAR(14),
		LegajoSinExpediente						BIT,	
		EmbargosFisicos							BIT,
		SplitContextoCreacion					VARCHAR(21),
		CodigoContextoCreacion					VARCHAR(4),
		DescripcionContextoCreacion				VARCHAR(255),
		SplitContexto							VARCHAR(13),
		CodigoContexto							VARCHAR(4),
		DescripcionContexto						VARCHAR(255),
		EnvioEscrito_GL_AM						BIT,
		EnvioDemandaDenuncia_GL_AM				BIT,
		ConsultaPublicaCiudadano				BIT,
		ConsultaPrivadaCiudadano				BIT,
		SplitPrioridad							VARCHAR(14),
		CodigoPrioridad 						INT,
		DescripcionPrioridad					VARCHAR(150),
		SplitClaseAsunto						VARCHAR(16),
		CodigoClaseAsunto						INT,
		DescripcionClaseAsunto					VARCHAR(100),
		SplitAsunto								VARCHAR(11),
		CodigoAsunto							INT,
		DescripcionAsunto						VARCHAR(200),
		Split									VARCHAR(5),
		CodigoContextoDetalle					VARCHAR(4),
		DescripcionContextoDetalle				VARCHAR(255),
		CodigoContextoProcedencia				VARCHAR(4),
		DescripcionContextoProcedencia			VARCHAR(255),
		CodigoGrupo								SMALLINT,
		DescripcionGrupo						VARCHAR(255),
		Habilitado								BIT,
		CodigoEstado							INT,
		DescripcionEstado						VARCHAR(150),
		EstadoCirculante						CHAR(1),
		CodigoMateriaLegajo						VARCHAR(5),
		DescripcionMateriaLegajo				VARCHAR(50),
		CodigoOficinaContexto					VARCHAR(4),
		DescripcionOficinaContexto				VARCHAR(255),
		CodigoTipoOficina						SMALLINT,
		DescripcionTipoOficina					VARCHAR(255),
		CodigoFase								SMALLINT,
		DescripcionFase							VARCHAR(255),
		CodigoProceso							SMALLINT,
		DescripcionProceso						VARCHAR(100),
		CodigoUbicacion							SMALLINT,
		DescripcionUbicacion					VARCHAR(150),
		CodigoTarea								SMALLINT,
		DescripcionTarea						VARCHAR(255),
		ContextoSuperior				        VARCHAR(4),											 
		TotalRegistros							INT
	)

 --Si no es para listar paginada la lista de legajos 
 IF(@L_NumeroPagina IS NULL OR @L_CantidadRegistros IS NULL) 
 BEGIN
	 IF(@L_CodigoLegajo IS NOT NULL)
	 BEGIN
			SELECT	A.TU_CodLegajo							AS	Codigo,
					A.TC_NumeroExpediente					AS	NumeroExpediente,
					A.TF_Inicio								AS	FechaInicio,
					A.TC_Descripcion						AS	Descripcion,
					A.TF_Actualizacion						AS	FechaActualizacion,
					B.TF_Entrada							AS	FechaEntrada,
					IIF((HRR.TU_CodLegajo IS NULL 
					AND HSR.TU_CodLegajo IS NULL), 0, 1)	AS  CreadoPorItineracion,
					A.CARPETA								AS	CarpetaGestion,
					IIF(EED.TC_NumeroExpediente IS NULL, 
					1, 0)									AS  LegajoSinExpediente,										   
					A.TB_EmbargosFisicos					AS	EmbargosFisicos,
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
					PR.TN_CodProceso						AS  CodigoProceso,
					PR.TC_Descripcion						AS  DescripcionProceso,
					HUB.TN_CodUbicacion						AS	CodigoUbicacion,
					HUB.TC_Descripcion						AS	DescripcionUbicacion,
					TAR.TN_CodTarea							AS	CodigoTarea,
					TAR.TC_Descripcion						AS	DescripcionTarea,								 
					H.TC_CodContextoSuperior				AS  ContextoSuperior,											
					0										AS  TotalRegistros
			  FROM			Expediente.Legajo				AS	A WITH (NOLOCK)
			  INNER JOIN	Expediente.LegajoDetalle		AS  B WITH (NOLOCK)
			  ON			B.TU_CodLegajo					=	A.TU_CodLegajo
			  LEFT JOIN		CATALOGO.Proceso				AS PR WITH (NOLOCK)
			  ON			PR.TN_CodProceso				=	B.TN_CodProceso
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
			  OUTER APPLY										(SELECT TOP(1)	ED.TC_NumeroExpediente
																 FROM			Expediente.ExpedienteDetalle	ED WITH(NOLOCK)
																 WHERE			ED.TC_NumeroExpediente			= A.TC_NumeroExpediente)EED	
 			  OUTER APPLY   (SELECT TOP(1)	UB.TN_CodUbicacion,	UB.TC_Descripcion
							 FROM			Historico.LegajoUbicacion  EU WITH (NOLOCK)
							 INNER JOIN		Catalogo.Ubicacion			   UB With(Nolock)
							 ON				UB.TN_CodUbicacion			 = EU.TN_CodUbicacion
							 WHERE	        EU.TU_CodLegajo			     = B.TU_CodLegajo  AND
											EU.TC_CodContexto			 = B.TC_CodContexto
							 ORDER BY		EU.TF_FechaUbicacion DESC)	 HUB
			  OUTER APPLY	 (SELECT TOP(1)	TA.TN_CodTarea,TA.TC_Descripcion
							 FROM			Expediente.TareaPendiente			TP WITH(NOLOCK)
							 INNER JOIN		Catalogo.Tarea						TA WITH(NOLOCK)
							 ON				TA.TN_CodTarea				 = TP.TN_CodTarea
							 INNER JOIN		Catalogo.TareaTipoOficinaMateria	TTO	WITH(NOLOCK)
							 ON				TTO.TN_CodTarea				 = TP.TN_CodTarea
							 AND			TTO.TN_CodTipoOficina		 = M.TN_CodTipoOficina
							 AND			TTO.TC_CodMateria			 = D.TC_CodMateria	
							 WHERE			TP.TU_CodLegajo				 = B.TU_CodLegajo
							 AND			TP.TC_CodContexto			 = B.TC_CodContexto
							 AND			TP.TC_UsuarioRedFinaliza	 IS NULL
							 AND			TP.TF_Finalizacion			 IS NULL
						 	 AND			TP.TC_UsuarioRedReasigna	 IS NULL
							 AND			TP.TF_Reasignacion			 IS NULL
    						 ORDER BY		TP.TF_Recibido DESC)		 TAR 
			  WHERE			A.TU_CodLegajo					=	@L_CodigoLegajo
			  AND			ISNULL(HL.TC_Movimiento,'')		=	ISNULL(@L_Movimiento, ISNULL(HL.TC_Movimiento,''))
			  AND			B.TC_CodContexto				=   COALESCE(@L_CodContexto, B.TC_CodContexto)
			  Order by		FechaEntrada		Desc
	 END
	 ELSE
	 BEGIN
			SELECT	A.TU_CodLegajo							AS	Codigo,
					A.TC_NumeroExpediente					AS	NumeroExpediente,
					A.TF_Inicio								AS	FechaInicio,
					A.TC_Descripcion						AS	Descripcion,
					A.TF_Actualizacion						AS	FechaActualizacion,
					B.TF_Entrada							AS	FechaEntrada,
					IIF((HRR.TU_CodLegajo IS NULL 
					AND HSR.TU_CodLegajo IS NULL), 0, 1)	AS  CreadoPorItineracion,
					A.CARPETA								AS	CarpetaGestion,
					IIF(EED.TC_NumeroExpediente IS NULL, 
					1, 0)									AS  LegajoSinExpediente,
					A.TB_EmbargosFisicos					AS	EmbargosFisicos,
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
					PR.TN_CodProceso						AS  CodigoProceso,
					PR.TC_Descripcion						AS  DescripcionProceso,
					HUB.TN_CodUbicacion						AS	CodigoUbicacion,
					HUB.TC_Descripcion						AS	DescripcionUbicacion,
					TAR.TN_CodTarea							AS	CodigoTarea,
					TAR.TC_Descripcion						AS	DescripcionTarea,							 
					H.TC_CodContextoSuperior				AS  ContextoSuperior,											
					0										AS  TotalRegistros
			  FROM			Expediente.Legajo				AS	A WITH (NOLOCK)
			  INNER JOIN	Expediente.LegajoDetalle		AS  B WITH (NOLOCK)
			  ON			B.TU_CodLegajo					=	A.TU_CodLegajo
			  LEFT JOIN		CATALOGO.Proceso				AS PR WITH (NOLOCK)
			  ON			PR.TN_CodProceso				=	B.TN_CodProceso
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
			  AND			HL.TF_Fecha						=	(SELECT top 1 TF_Fecha 
  																 FROM	Historico.LegajoMovimientoCirculante
  																 WHERE	TU_CodLegajo = B.TU_CodLegajo
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
			  OUTER APPLY										(SELECT TOP(1)	ED.TC_NumeroExpediente
																 FROM			Expediente.ExpedienteDetalle	ED WITH(NOLOCK)
																 WHERE			ED.TC_NumeroExpediente			= A.TC_NumeroExpediente)EED
			  OUTER APPLY   (SELECT TOP(1)	UB.TN_CodUbicacion,	UB.TC_Descripcion
							 FROM			Historico.LegajoUbicacion  EU WITH (NOLOCK)
							 INNER JOIN		Catalogo.Ubicacion			   UB With(Nolock)
							 ON				UB.TN_CodUbicacion			 = EU.TN_CodUbicacion
							 WHERE	        EU.TU_CodLegajo			     = B.TU_CodLegajo  AND
											EU.TC_CodContexto			 = B.TC_CodContexto
							 ORDER BY		EU.TF_FechaUbicacion DESC)	 HUB
			  OUTER APPLY	 (SELECT TOP(1)	TA.TN_CodTarea,TA.TC_Descripcion
							 FROM			Expediente.TareaPendiente			TP WITH(NOLOCK)
							 INNER JOIN		Catalogo.Tarea						TA WITH(NOLOCK)
							 ON				TA.TN_CodTarea				 = TP.TN_CodTarea
							 INNER JOIN		Catalogo.TareaTipoOficinaMateria	TTO	WITH(NOLOCK)
							 ON				TTO.TN_CodTarea				 = TP.TN_CodTarea
							 AND			TTO.TN_CodTipoOficina		 = M.TN_CodTipoOficina
							 AND			TTO.TC_CodMateria			 = D.TC_CodMateria	
							 WHERE			TP.TU_CodLegajo				 = B.TU_CodLegajo
							 AND			TP.TC_CodContexto			 = B.TC_CodContexto
							 AND			TP.TC_UsuarioRedFinaliza	 IS NULL
							 AND			TP.TF_Finalizacion			 IS NULL
						 	 AND			TP.TC_UsuarioRedReasigna	 IS NULL
							 AND			TP.TF_Reasignacion			 IS NULL
    						 ORDER BY		TP.TF_Recibido DESC)		 TAR														
			  WHERE			A.TC_NumeroExpediente			=	@L_Numero
			  AND			ISNULL(HL.TC_Movimiento,'')		=	ISNULL(@L_Movimiento, ISNULL(HL.TC_Movimiento,''))
			  AND			B.TC_CodContexto				=   COALESCE(@L_CodContexto, B.TC_CodContexto)
			  Order By FechaEntrada desc
	 END	
 END
 ELSE
 BEGIN
	IF(@L_CodigoLegajo IS NOT NULL)
	 BEGIN
			INSERT INTO @Legajos (
						CodigoLegajo,
						NumeroExpediente,
						FechaInicio,
						DescripcionLegajo,
						FechaActualizacion,
						FechaEntrada,
						CreadoPorItineracion,
						CarpetaGestion,
						LegajoSinExpediente,	
						EmbargosFisicos,
						SplitContextoCreacion,
						CodigoContextoCreacion,
						DescripcionContextoCreacion,
						SplitContexto,
						CodigoContexto,
						DescripcionContexto,
						EnvioEscrito_GL_AM,
						EnvioDemandaDenuncia_GL_AM,
						ConsultaPublicaCiudadano,
						ConsultaPrivadaCiudadano,
						SplitPrioridad,
						CodigoPrioridad,
						DescripcionPrioridad,
						SplitClaseAsunto,
						CodigoClaseAsunto,
						DescripcionClaseAsunto,
						SplitAsunto,
						CodigoAsunto,
						DescripcionAsunto,
						Split,
						CodigoContextoDetalle,
						DescripcionContextoDetalle,
						CodigoContextoProcedencia,
						DescripcionContextoProcedencia,
						CodigoGrupo,
						DescripcionGrupo,
						Habilitado,
						CodigoEstado,
						DescripcionEstado,
						EstadoCirculante,
						CodigoMateriaLegajo,
						DescripcionMateriaLegajo,
						CodigoOficinaContexto,
						DescripcionOficinaContexto,
						CodigoTipoOficina,
						DescripcionTipoOficina,
						CodigoFase,
						DescripcionFase,
						CodigoProceso,
						DescripcionProceso,
						CodigoUbicacion,
						DescripcionUbicacion,
						CodigoTarea,
						DescripcionTarea,
					    ContextoSuperior
			)
			SELECT	A.TU_CodLegajo							AS	Codigo,
					A.TC_NumeroExpediente					AS	NumeroExpediente,
					A.TF_Inicio								AS	FechaInicio,
					A.TC_Descripcion						AS	Descripcion,
					A.TF_Actualizacion						AS	FechaActualizacion,
					B.TF_Entrada							AS	FechaEntrada,
					IIF((HRR.TU_CodLegajo IS NULL 
					AND HSR.TU_CodLegajo IS NULL), 0, 1)	AS  CreadoPorItineracion,
					A.CARPETA								AS	CarpetaGestion,
					IIF(EED.TC_NumeroExpediente IS NULL, 
					1, 0)									AS  LegajoSinExpediente,					   
					A.TB_EmbargosFisicos					AS	EmbargosFisicos,
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
					PR.TN_CodProceso						AS  CodigoProceso,
					PR.TC_Descripcion						AS  DescripcionProceso,
					HUB.TN_CodUbicacion						AS	CodigoUbicacion,
					HUB.TC_Descripcion						AS	DescripcionUbicacion,
					TAR.TN_CodTarea							AS	CodigoTarea,
					TAR.TC_Descripcion						AS	DescripcionTarea,
					H.TC_CodContextoSuperior				AS  ContextoSuperior															  
			  FROM			Expediente.Legajo				AS	A WITH (NOLOCK)
			  INNER JOIN	Expediente.LegajoDetalle		AS  B WITH (NOLOCK)
			  ON			B.TU_CodLegajo					=	A.TU_CodLegajo
			  LEFT JOIN	    CATALOGO.Proceso				AS PR WITH (NOLOCK)
			  ON			PR.TN_CodProceso				=	B.TN_CodProceso
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
			  OUTER APPLY										(SELECT TOP(1)	ED.TC_NumeroExpediente
																 FROM			Expediente.ExpedienteDetalle	ED WITH(NOLOCK)
																 WHERE			ED.TC_NumeroExpediente			= A.TC_NumeroExpediente)EED	
			  OUTER APPLY   (SELECT TOP(1)	UB.TN_CodUbicacion,	UB.TC_Descripcion
							 FROM			Historico.LegajoUbicacion  EU WITH (NOLOCK)
							 INNER JOIN		Catalogo.Ubicacion			   UB With(Nolock)
							 ON				UB.TN_CodUbicacion			 = EU.TN_CodUbicacion
							 WHERE	        EU.TU_CodLegajo			     = B.TU_CodLegajo  AND
											EU.TC_CodContexto			 = B.TC_CodContexto
							 ORDER BY		EU.TF_FechaUbicacion DESC)	 HUB
			  OUTER APPLY	 (SELECT TOP(1)	TA.TN_CodTarea,TA.TC_Descripcion
							 FROM			Expediente.TareaPendiente			TP WITH(NOLOCK)
							 INNER JOIN		Catalogo.Tarea						TA WITH(NOLOCK)
							 ON				TA.TN_CodTarea				 = TP.TN_CodTarea
							 INNER JOIN		Catalogo.TareaTipoOficinaMateria	TTO	WITH(NOLOCK)
							 ON				TTO.TN_CodTarea				 = TP.TN_CodTarea
							 AND			TTO.TN_CodTipoOficina		 = M.TN_CodTipoOficina
							 AND			TTO.TC_CodMateria			 = D.TC_CodMateria	
							 WHERE			TP.TU_CodLegajo				 = B.TU_CodLegajo
							 AND			TP.TC_CodContexto			 = B.TC_CodContexto
							 AND			TP.TC_UsuarioRedFinaliza	 IS NULL
							 AND			TP.TF_Finalizacion			 IS NULL
						 	 AND			TP.TC_UsuarioRedReasigna	 IS NULL
							 AND			TP.TF_Reasignacion			 IS NULL
    						 ORDER BY		TP.TF_Recibido DESC)		 TAR																 
			  WHERE			A.TU_CodLegajo					=	@L_CodigoLegajo
			  AND			ISNULL(HL.TC_Movimiento,'')		=	ISNULL(@L_Movimiento, ISNULL(HL.TC_Movimiento,''))
			  AND			A.TC_CodContexto				=   COALESCE(@L_CodContexto, A.TC_CodContexto)
			  AND			B.TC_CodContexto				=   COALESCE(@L_CodContexto, B.TC_CodContexto)

			 --Obtener cantidad registros de la consulta
			 SET @L_TotalRegistros = @@rowcount;

			  --retornar consultar
			  SELECT	X.CodigoLegajo						AS Codigo,
						X.NumeroExpediente					AS NumeroExpediente,
						X.FechaInicio,
						X.DescripcionLegajo					AS Descripcion,
						X.FechaActualizacion,
						X.FechaEntrada,
						X.CreadoPorItineracion,
						X.CarpetaGestion,
						X.LegajoSinExpediente,	
						X.EmbargosFisicos,
						X.SplitContextoCreacion,
						X.CodigoContextoCreacion			AS Codigo,
						X.DescripcionContextoCreacion		AS Descripcion,
						X.SplitContexto,
						X.CodigoContexto					AS Codigo,
						X.DescripcionContexto				AS Descripcion,
						X.EnvioEscrito_GL_AM,
						X.EnvioDemandaDenuncia_GL_AM,
						X.ConsultaPublicaCiudadano,
						X.ConsultaPrivadaCiudadano,
						X.SplitPrioridad,
						X.CodigoPrioridad					AS Codigo,
						X.DescripcionPrioridad				AS Descripcion,
						X.SplitClaseAsunto,
						X.CodigoClaseAsunto					AS Codigo,
						X.DescripcionClaseAsunto			AS Descripcion,
						X.SplitAsunto,
						X.CodigoAsunto						AS Codigo,
						X.DescripcionAsunto					AS Descripcion,
						X.Split,
						X.CodigoContextoDetalle,
						X.DescripcionContextoDetalle,
						X.CodigoContextoProcedencia,
						X.DescripcionContextoProcedencia,
						X.CodigoGrupo,
						X.DescripcionGrupo,
						X.Habilitado,
						X.CodigoEstado,
						X.DescripcionEstado,
						X.EstadoCirculante,
						X.CodigoMateriaLegajo,
						X.DescripcionMateriaLegajo,
						X.CodigoOficinaContexto,
						X.DescripcionOficinaContexto,
						X.CodigoTipoOficina,
						X.DescripcionTipoOficina,
						X.CodigoFase,
						X.DescripcionFase,
						X.CodigoProceso,
						X.DescripcionProceso,
						X.CodigoUbicacion,
						X.DescripcionUbicacion,
						X.CodigoTarea,
						X.DescripcionTarea,
						X.ContextoSuperior,  
						@L_TotalRegistros					AS TotalRegistros
			  FROM (
						SELECT		CodigoLegajo,
									NumeroExpediente,
									FechaInicio,
									DescripcionLegajo,
									FechaActualizacion,
									FechaEntrada,
									CreadoPorItineracion,
									CarpetaGestion,
									LegajoSinExpediente,	
									EmbargosFisicos,
									SplitContextoCreacion,
									CodigoContextoCreacion,
									DescripcionContextoCreacion,
									SplitContexto,
									CodigoContexto,
									DescripcionContexto,
									EnvioEscrito_GL_AM,
									EnvioDemandaDenuncia_GL_AM,
									ConsultaPublicaCiudadano,
									ConsultaPrivadaCiudadano,
									SplitPrioridad,
									CodigoPrioridad,
									DescripcionPrioridad,
									SplitClaseAsunto,
									CodigoClaseAsunto,
									DescripcionClaseAsunto,
									SplitAsunto,
									CodigoAsunto,
									DescripcionAsunto,
									Split,
									CodigoContextoDetalle,
									DescripcionContextoDetalle,
									CodigoContextoProcedencia,
									DescripcionContextoProcedencia,
									CodigoGrupo,
									DescripcionGrupo,
									Habilitado,
									CodigoEstado,
									DescripcionEstado,
									EstadoCirculante,
									CodigoMateriaLegajo,
									DescripcionMateriaLegajo,
									CodigoOficinaContexto,
									DescripcionOficinaContexto,
									CodigoTipoOficina,
									DescripcionTipoOficina,
									CodigoFase,
									DescripcionFase,
									CodigoProceso,
									DescripcionProceso,
									CodigoUbicacion,
									DescripcionUbicacion,
									CodigoTarea,
									DescripcionTarea,
									ContextoSuperior
						FROM		@Legajos
						ORDER BY	FechaEntrada		Desc
						OFFSET		(@NumeroPagina - 1) * @CantidadRegistros ROWS 
						FETCH NEXT	@CantidadRegistros ROWS ONLY
					)	As x

	 END
	 ELSE
	 BEGIN
			 INSERT INTO @Legajos (
						CodigoLegajo,
						NumeroExpediente,
						FechaInicio,
						DescripcionLegajo,
						FechaActualizacion,
						FechaEntrada,
						CreadoPorItineracion,
						CarpetaGestion,
						LegajoSinExpediente,	
						EmbargosFisicos,
						SplitContextoCreacion,
						CodigoContextoCreacion,
						DescripcionContextoCreacion,
						SplitContexto,
						CodigoContexto,
						DescripcionContexto,
						EnvioEscrito_GL_AM,
						EnvioDemandaDenuncia_GL_AM,
						ConsultaPublicaCiudadano,
						ConsultaPrivadaCiudadano,
						SplitPrioridad,
						CodigoPrioridad,
						DescripcionPrioridad,
						SplitClaseAsunto,
						CodigoClaseAsunto,
						DescripcionClaseAsunto,
						SplitAsunto,
						CodigoAsunto,
						DescripcionAsunto,
						Split,
						CodigoContextoDetalle,
						DescripcionContextoDetalle,
						CodigoContextoProcedencia,
						DescripcionContextoProcedencia,
						CodigoGrupo,
						DescripcionGrupo,
						Habilitado,
						CodigoEstado,
						DescripcionEstado,
						EstadoCirculante,
						CodigoMateriaLegajo,
						DescripcionMateriaLegajo,
						CodigoOficinaContexto,
						DescripcionOficinaContexto,
						CodigoTipoOficina,
						DescripcionTipoOficina,
						CodigoFase,
						DescripcionFase,
						CodigoProceso,
						DescripcionProceso,
						CodigoUbicacion,
						DescripcionUbicacion,
						CodigoTarea,
						DescripcionTarea,
						ContextoSuperior							 
			)
			SELECT	A.TU_CodLegajo							AS	Codigo,
					A.TC_NumeroExpediente					AS	NumeroExpediente,
					A.TF_Inicio								AS	FechaInicio,
					A.TC_Descripcion						AS	Descripcion,
					A.TF_Actualizacion						AS	FechaActualizacion,
					B.TF_Entrada							AS	FechaEntrada,
					IIF((HRR.TU_CodLegajo IS NULL 
					AND HSR.TU_CodLegajo IS NULL), 0, 1)	AS  CreadoPorItineracion,
					A.CARPETA								AS	CarpetaGestion,
					IIF(EED.TC_NumeroExpediente IS NULL, 
					1, 0)									AS  LegajoSinExpediente,	
					A.TB_EmbargosFisicos					AS	EmbargosFisicos,
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
					PR.TN_CodProceso						AS  CodigoProceso,
					PR.TC_Descripcion						AS  DescripcionProceso,
					HUB.TN_CodUbicacion						AS	CodigoUbicacion,
					HUB.TC_Descripcion						AS	DescripcionUbicacion,
					TAR.TN_CodTarea							AS	CodigoTarea,
					TAR.TC_Descripcion						AS	DescripcionTarea,
					H.TC_CodContextoSuperior				AS  ContextoSuperior																   
			  FROM			Expediente.Legajo				AS	A WITH (NOLOCK)
			  INNER JOIN	Expediente.LegajoDetalle		AS  B WITH (NOLOCK)
			  ON			B.TU_CodLegajo					=	A.TU_CodLegajo
			  LEFT JOIN	    CATALOGO.Proceso				AS PR WITH (NOLOCK)
			  ON			PR.TN_CodProceso				=	B.TN_CodProceso
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
			  AND			HL.TF_Fecha						=	(SELECT top 1 TF_Fecha 
  																 FROM	Historico.LegajoMovimientoCirculante
  																 WHERE	TU_CodLegajo = B.TU_CodLegajo
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
			  OUTER APPLY										(SELECT TOP(1)	ED.TC_NumeroExpediente
																 FROM			Expediente.ExpedienteDetalle	ED WITH(NOLOCK)
																 WHERE			ED.TC_NumeroExpediente			= A.TC_NumeroExpediente)EED	
			OUTER APPLY   (SELECT TOP(1)	UB.TN_CodUbicacion,	UB.TC_Descripcion
							 FROM			Historico.LegajoUbicacion  EU WITH (NOLOCK)
							 INNER JOIN		Catalogo.Ubicacion			   UB With(Nolock)
							 ON				UB.TN_CodUbicacion			 = EU.TN_CodUbicacion
							 WHERE	        EU.TU_CodLegajo			     = B.TU_CodLegajo  AND
											EU.TC_CodContexto			 = B.TC_CodContexto
							 ORDER BY		EU.TF_FechaUbicacion DESC)	 HUB
			  OUTER APPLY	 (SELECT TOP(1)	TA.TN_CodTarea,TA.TC_Descripcion
							 FROM			Expediente.TareaPendiente			TP WITH(NOLOCK)
							 INNER JOIN		Catalogo.Tarea						TA WITH(NOLOCK)
							 ON				TA.TN_CodTarea				 = TP.TN_CodTarea
							 INNER JOIN		Catalogo.TareaTipoOficinaMateria	TTO	WITH(NOLOCK)
							 ON				TTO.TN_CodTarea				 = TP.TN_CodTarea
							 AND			TTO.TN_CodTipoOficina		 = M.TN_CodTipoOficina
							 AND			TTO.TC_CodMateria			 = D.TC_CodMateria	
							 WHERE			TP.TU_CodLegajo				 = B.TU_CodLegajo
							 AND			TP.TC_CodContexto			 = B.TC_CodContexto
							 AND			TP.TC_UsuarioRedFinaliza	 IS NULL
							 AND			TP.TF_Finalizacion			 IS NULL
						 	 AND			TP.TC_UsuarioRedReasigna	 IS NULL
							 AND			TP.TF_Reasignacion			 IS NULL
    						 ORDER BY		TP.TF_Recibido DESC)		 TAR																 
			  WHERE			A.TC_NumeroExpediente			=	@L_Numero
			  AND			ISNULL(HL.TC_Movimiento,'')		=	ISNULL(@L_Movimiento, ISNULL(HL.TC_Movimiento,''))
			  AND			A.TC_CodContexto				=   COALESCE(@L_CodContexto, A.TC_CodContexto)
			  AND			B.TC_CodContexto				=   COALESCE(@L_CodContexto, B.TC_CodContexto)

			  --Obtener cantidad registros de la consulta
			  SET @L_TotalRegistros = @@rowcount;

			  --retornar consultar
			  SELECT	X.CodigoLegajo						AS Codigo,
						X.NumeroExpediente					AS NumeroExpediente,
						X.FechaInicio,
						X.DescripcionLegajo					AS Descripcion,
						X.FechaActualizacion,
						X.FechaEntrada,
						X.CreadoPorItineracion,
						X.CarpetaGestion,
						X.LegajoSinExpediente,	
						X.EmbargosFisicos,
						X.SplitContextoCreacion,
						X.CodigoContextoCreacion			AS Codigo,
						X.DescripcionContextoCreacion		AS Descripcion,
						X.SplitContexto,
						X.CodigoContexto					AS Codigo,
						X.DescripcionContexto				AS Descripcion,
						X.EnvioEscrito_GL_AM,
						X.EnvioDemandaDenuncia_GL_AM,
						X.ConsultaPublicaCiudadano,
						X.ConsultaPrivadaCiudadano,
						X.SplitPrioridad,
						X.CodigoPrioridad					AS Codigo,
						X.DescripcionPrioridad				AS Descripcion,
						X.SplitClaseAsunto,
						X.CodigoClaseAsunto					AS Codigo,
						X.DescripcionClaseAsunto			AS Descripcion,
						X.SplitAsunto,
						X.CodigoAsunto						AS Codigo,
						X.DescripcionAsunto					AS Descripcion,
						X.Split,
						X.CodigoContextoDetalle,
						X.DescripcionContextoDetalle,
						X.CodigoContextoProcedencia,
						X.DescripcionContextoProcedencia,
						X.CodigoGrupo,
						X.DescripcionGrupo,
						X.Habilitado,
						X.CodigoEstado,
						X.DescripcionEstado,
						X.EstadoCirculante,
						X.CodigoMateriaLegajo,
						X.DescripcionMateriaLegajo,
						X.CodigoOficinaContexto,
						X.DescripcionOficinaContexto,
						X.CodigoTipoOficina,
						X.DescripcionTipoOficina,
						X.CodigoFase,
						X.DescripcionFase,
						x.CodigoProceso,
						x.DescripcionProceso,
						X.CodigoUbicacion,
						X.DescripcionUbicacion,
						X.CodigoTarea,
						X.DescripcionTarea,
						X.ContextoSuperior,  
						@L_TotalRegistros					AS TotalRegistros
			  FROM (
						SELECT		CodigoLegajo,
									NumeroExpediente,
									FechaInicio,
									DescripcionLegajo,
									FechaActualizacion,
									FechaEntrada,
									CreadoPorItineracion,
									CarpetaGestion,
									LegajoSinExpediente,	
									EmbargosFisicos,
									SplitContextoCreacion,
									CodigoContextoCreacion,
									DescripcionContextoCreacion,
									SplitContexto,
									CodigoContexto,
									DescripcionContexto,
									EnvioEscrito_GL_AM,
									EnvioDemandaDenuncia_GL_AM,
									ConsultaPublicaCiudadano,
									ConsultaPrivadaCiudadano,
									SplitPrioridad,
									CodigoPrioridad,
									DescripcionPrioridad,
									SplitClaseAsunto,
									CodigoClaseAsunto,
									DescripcionClaseAsunto,
									SplitAsunto,
									CodigoAsunto,
									DescripcionAsunto,
									Split,
									CodigoContextoDetalle,
									DescripcionContextoDetalle,
									CodigoContextoProcedencia,
									DescripcionContextoProcedencia,
									CodigoGrupo,
									DescripcionGrupo,
									Habilitado,
									CodigoEstado,
									DescripcionEstado,
									EstadoCirculante,
									CodigoMateriaLegajo,
									DescripcionMateriaLegajo,
									CodigoOficinaContexto,
									DescripcionOficinaContexto,
									CodigoTipoOficina,
									DescripcionTipoOficina,
									CodigoFase,
									DescripcionFase,
									CodigoProceso,
									DescripcionProceso,
									CodigoUbicacion,
									DescripcionUbicacion,
									CodigoTarea,
									DescripcionTarea,
									ContextoSuperior
						FROM		@Legajos
						ORDER BY	FechaEntrada		Desc
						OFFSET		(@NumeroPagina - 1) * @CantidadRegistros ROWS 
						FETCH NEXT	@CantidadRegistros ROWS ONLY
					)	As x

	 END
 END
END


GO
