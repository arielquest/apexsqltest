SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =======================================================================================================================================================================================================
-- Versión:					<1.2>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<10/10/2018>
-- Descripción :			<Permite Consultar los escritos de un expediente para el buzon de escritos>
-- =======================================================================================================================================================================================================
-- Modificado por:			<Andrew Allen Dawson>
-- Fecha de modificación	<14/11/2019>
-- Modificación				<Se corrige la numeración>
-- =======================================================================================================================================================================================================
-- Modificado por:			<Andrew Allen Dawson>
-- Fecha de modificación	<14/11/2019>
-- Modificación				<Se corrige la validación de fechas>
-- =======================================================================================================================================================================================================
-- Modificado por:			<Jose Gabriel Cordero Soto>
-- Fecha de modificación	<09/12/2019>
-- Modificación				<Se agrega ID del Archivo asociado>
-- =======================================================================================================================================================================================================
-- Modificado por:			<Luis Alonso Leiva Tames>
-- Fecha de modificación	<14/07/2020>
-- Modificación				<Se agrega el campo VariasGestiones en el retorno>
-- =======================================================================================================================================================================================================
-- Modificado por:			<Daniel Ruiz Hernández>
-- Fecha de modificación	<23/03/2021>
-- Modificación				<Se modifica la validacion de los parametros para mejorar el rendimiento del SP>
-- =======================================================================================================================================================================================================
-- Modificado por:			<Luis Alonso Leiva Tames>
-- Fecha de modificación	<19/05/2021>
-- Modificación				<Se modifica rendimiento y paginacion >
-- =======================================================================================================================================================================================================
-- Modificado por:			<Isaac Santiago Méndez Castillo>
-- Fecha de modificación	<27/05/2021>
-- Modificación				<Se modifica tipo de variable (de SMALLINT a INT) en la variable CodigoEstado de @Escritos, el dato original es un INT
--							 y al existir datos que no soporta el SMALLINT la consulta de escritos falla. Además, se indexan algunas partes del código>
-- =======================================================================================================================================================================================================
-- Modificado por:			<Fabian Sequeira Gamboa>
-- Fecha de modificación	<21/06/2021>
-- Modificación				<Se modifica para que se muestren los escritos del legajo y los puestos de trabajo del expediente y del legajo. >
-- =======================================================================================================================================================================================================
-- Modificado por:			<Isaac Santiago Méndez Castillo>
-- Fecha de modificación	<25/06/2021>
-- Modificación				<Se modifica el select principal para que cuando ingresen el parametro NULL en VariasGestiones, se obtienenen
--							 todos los datos, no importa si posee o no varias gestiones>
-- =======================================================================================================================================================================================================
-- Modificado por:			<Josué Quirós Batista>
-- Fecha de modificación	<25/06/2021>
-- Modificación				<Se modifica con el objetivo de listar los escritos asociados a un expediente aunque el tipo de escrito no está asociado a la oficina destino.>
-- =======================================================================================================================================================================================================
-- Modificado por:			<Isaac Santiago Méndez Castillo>
-- Fecha de modificación	<17/08/2021>
-- Modificación				<Se modifica el select de cuando el código del puesto de trabajo no es nulo. Se modifica de manera que haya un select
--							 para que obtenga los escritos de los expedientes asignados y otro para los escritos de los legajos asignados a
--							 dicho código de trabajo.>
-- =======================================================================================================================================================================================================
-- Modificado por:			<Aaron Rios Retana>
-- Fecha de modificación	<18/11/2021>
-- Modificación				<Se modifica con el objetivo de traer el dato clase asunto del legajo y ConsecutivoHistorialProcesal del escrito>
-- =======================================================================================================================================================================================================
-- Modificación:			<Aida Elena Siles R> <09/02/2022> <Se optimiza la consulta. Adicionalmente se pasa la paginación al negocio.>
-- =======================================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarBuzonEscritos]   
 	@NumeroPagina				INT,
	@CantidadRegistros			INT,
	@EsUrgente					BIT				= NULL,
	@FechaDesde					DATETIME2		= NULL,
	@FechaHasta					DATETIME2		= NULL,
	@NumeroExpediente			VARCHAR(14)		= NULL,
	@EstadoEscrito				CHAR(1)			= NULL,
	@CodTipoEscrito				SMALLINT		= NULL,
	@CodContexto				VARCHAR(4)		= NULL,
	@CodTipoOficina				SMALLINT		= NULL,
	@VariasGestiones			BIT				= NULL,
	@CodPuestoTrabajo			VARCHAR(14)		= NULL

AS
BEGIN
	--Variables
	DECLARE	@L_NumeroPagina			INT					=	@NumeroPagina		,
			@L_CantidadRegistros	INT					=	@CantidadRegistros	,	
			@L_FechaDesde			DATETIME2			=	@FechaDesde			,
			@L_FechaHasta			DATETIME2			=	@FechaHasta			,
			@L_NumeroExpediente		VARCHAR(14)			=	@NumeroExpediente	,
			@L_EstadoEscrito		CHAR(1)				=	@EstadoEscrito		,	
			@L_CodTipoEscrito		SMALLINT			=	@CodTipoEscrito		,	
			@L_CodContexto			VARCHAR(4)			=	@CodContexto		,
			@L_CodTipoOficina		SMALLINT			=	@CodTipoOficina		, 
			@L_VariasGestiones		BIT					=	@VariasGestiones	,
			@L_EsUrgente			BIT					=   @EsUrgente			,
			@L_CodPuestoTrabajo		VARCHAR(14)			=	@CodPuestoTrabajo	
			

  IF( @L_NumeroPagina IS NULL) SET @L_NumeroPagina=1;

  	IF (@L_CodPuestoTrabajo IS NULL)
	BEGIN
			SELECT		A.TU_CodEscrito										Codigo,
						A.TC_Descripcion									Descripcion,
						A.TF_FechaIngresoOficina							FechaIngresoOficina,
						A.TF_FechaEnvio										FechaEnvio,
						A.TC_EstadoEscrito									EstadoEscrito,
						A.TB_VariasGestiones								VariasGestiones,
						IIF(G.TU_CodLegajo IS NULL, 'EXPEDIENTE', 'LEGAJO') Tipo,
						A.TN_Consecutivo									ConsecutivoHistorialProcesal,
						A.TN_CodTipoEscrito									CodigoTipoEscrito,
						C.TC_Descripcion									DescripcionTipoEscrito,
						NULL												CodigoPuestoTrabajo,
						'Split'												Split,
						G.TU_CodLegajo										Codigo,
						'Split'												Split,
						H.TC_Descripcion									Descripcion, --AsuntoLegajo
						'Split'												Split,
						A.TC_NumeroExpediente								Numero,
						B.TC_Descripcion									Descripcion,
						'Split'												Split,						
						ISNULL(D.EsUrgente, 0)								EsUrgente,					
						'Split'												Split,
						E.Codigo											Codigo,
						E.Descripcion										Descripcion,
						'Split'												Split,
						A.TC_IDARCHIVO										Codigo						
					
			FROM        Expediente.EscritoExpediente						A WITH(NOLOCK)
			INNER JOIN	Expediente.Expediente								B WITH(NOLOCK)
			ON			B.TC_NumeroExpediente								= A.TC_NumeroExpediente
			INNER JOIN	Catalogo.TipoEscrito								C WITH(NOLOCK)
			ON			C.TN_CodTipoEscrito									= A.TN_CodTipoEscrito
			OUTER APPLY	(
							SELECT		X.TB_Urgente						EsUrgente,
										Y.TN_CodTipoOficina					CodigoTipoOficina
							FROM		Catalogo.Contexto					Z WITH(NOLOCK)
							INNER JOIN	Catalogo.Oficina					Y WITH(NOLOCK)
							ON			Y.TC_CodOficina						= Z.TC_CodOficina
							LEFT JOIN	Catalogo.TipoEscritoTipoOficina		X WITH(NOLOCK)
							ON			X.TC_CodMateria						= Z.TC_CodMateria
							AND			X.TN_CodTipoEscrito					= A.TN_CodTipoEscrito
							AND			X.TN_CodTipoOficina					= Y.TN_CodTipoOficina
							WHERE		Z.TC_CodContexto					= A.TC_CodContexto
						) D
			OUTER APPLY	(
							SELECT TOP 1	W.TN_CodEstado								Codigo,
											V.TC_Descripcion							Descripcion
							FROM			Historico.ExpedienteMovimientoCirculante	W WITH(NOLOCK)
							INNER JOIN		Catalogo.Estado								V WITH(NOLOCK)
							ON				V.TN_CodEstado								= W.TN_CodEstado
							WHERE			W.TC_NumeroExpediente						= A.TC_NumeroExpediente
							ORDER BY		W.TF_Fecha									DESC
						) E
			OUTER APPLY (
							SELECT  T.TU_CodLegajo
							FROM    Expediente.EscritoLegajo				T WITH(NOLOCK)
							WHERE   T.TU_CodEscrito							= A.TU_CodEscrito
						) G
			OUTER APPLY (	SELECT		ASU.TC_Descripcion
							FROM		Expediente.LegajoDetalle			LD  WITH(NOLOCK)
							INNER JOIN	Catalogo.Asunto						ASU WITH(NOLOCK)
							ON			LD.TN_CodAsunto						= ASU.TN_CodAsunto
							WHERE		TU_CodLegajo						= G.TU_CodLegajo
						) H
			WHERE		A.TC_NumeroExpediente   =       ISNULL(@L_NumeroExpediente, A.TC_NumeroExpediente)
			AND			A.TN_CodTipoEscrito     =       ISNULL(@L_CodTipoEscrito, A.TN_CodTipoEscrito)		
			AND			A.TC_EstadoEscrito      =       ISNULL(@L_EstadoEscrito, A.TC_EstadoEscrito)
			AND			A.TC_CodContexto        =       ISNULL(@L_CodContexto, A.TC_CodContexto)			
			AND			ISNULL(D.EsUrgente, '') =		ISNULL(@L_EsUrgente, ISNULL(D.EsUrgente, ''))
			AND			D.CodigoTipoOficina     =       ISNULL(@L_CodTipoOficina, D.CodigoTipoOficina)		
			AND			(@L_FechaHasta                  IS NULL OR DATEDIFF(DAY, A.TF_FechaIngresoOficina,@L_FechaHasta) >= 0)
			AND			(@L_FechaDesde                  IS NULL OR DATEDIFF(DAY, A.TF_FechaIngresoOficina,@L_FechaDesde) <= 0)		
			AND			A.TB_VariasGestiones    =		ISNULL(@L_VariasGestiones, A.TB_VariasGestiones)	
			ORDER BY	A.TF_FechaEnvio							
	END 
	ELSE
	BEGIN 	
			SELECT		A.TU_CodEscrito										Codigo,
						A.TC_Descripcion									Descripcion,
						A.TF_FechaIngresoOficina							FechaIngresoOficina,
						A.TF_FechaEnvio										FechaEnvio,
						A.TC_EstadoEscrito									EstadoEscrito,
						A.TB_VariasGestiones								VariasGestiones,
						IIF(F.TU_CodLegajo IS NULL, 'EXPEDIENTE', 'LEGAJO')	Tipo,					
						A.TN_Consecutivo									ConsecutivoHistorialProcesal,
						A.TN_CodTipoEscrito									CodigoTipoEscrito,
						C.TC_Descripcion									DescripcionTipoEscrito,
						IIF(F.TU_CodLegajo IS NULL,	G.TC_CodPuestoTrabajo, H.TC_CodPuestoTrabajo)		CodigoPuestoTrabajo,
						'Split'												Split,
						F.TU_CodLegajo										Codigo,
						'Split'												Split,
						I.TC_Descripcion									Descripcion, --AsuntoLegajo
						'Split'												Split,
						A.TC_NumeroExpediente								Numero,
						B.TC_Descripcion									Descripcion,
						'Split'												Split,
						ISNULL(D.EsUrgente, 0)								EsUrgente,
						'Split'												Split,
						E.Codigo											Codigo,
						E.Descripcion										Descripcion,
						'Split'												Split,
						A.TC_IDARCHIVO										Codigo						
														  
			FROM        Expediente.EscritoExpediente						A WITH(NOLOCK)
			INNER JOIN	Expediente.Expediente								B WITH(NOLOCK)
			ON			B.TC_NumeroExpediente								= A.TC_NumeroExpediente
			INNER JOIN	Catalogo.TipoEscrito								C WITH(NOLOCK)
			ON			C.TN_CodTipoEscrito									= A.TN_CodTipoEscrito
			OUTER APPLY	(
							SELECT		X.TB_Urgente						EsUrgente,
										Y.TN_CodTipoOficina					CodigoTipoOficina
							FROM		Catalogo.Contexto					Z WITH(NOLOCK)
							INNER JOIN	Catalogo.Oficina					Y WITH(NOLOCK)
							ON			Y.TC_CodOficina						= Z.TC_CodOficina
							LEFT JOIN	Catalogo.TipoEscritoTipoOficina		X WITH(NOLOCK)
							ON			X.TC_CodMateria						= Z.TC_CodMateria
							AND			X.TN_CodTipoEscrito					= A.TN_CodTipoEscrito
							AND			X.TN_CodTipoOficina					= Y.TN_CodTipoOficina
							WHERE		Z.TC_CodContexto					= A.TC_CodContexto
						) D
			OUTER APPLY	(
							SELECT TOP 1	W.TN_CodEstado								Codigo,
											V.TC_Descripcion							Descripcion
							FROM			Historico.ExpedienteMovimientoCirculante	W WITH(NOLOCK)
							INNER JOIN		Catalogo.Estado								V WITH(NOLOCK)
							ON				V.TN_CodEstado								= W.TN_CodEstado
							WHERE			W.TC_NumeroExpediente						= A.TC_NumeroExpediente
							ORDER BY		W.TF_Fecha									DESC
						) E
			OUTER APPLY (
							SELECT  T.TU_CodLegajo
							FROM    Expediente.EscritoLegajo				T WITH(NOLOCK)
							WHERE   T.TU_CodEscrito							= A.TU_CodEscrito
						) F
			OUTER APPLY (
							SELECT      U.TC_CodPuestoTrabajo
							FROM        Historico.ExpedienteAsignado	U WITH(NOLOCK)
							WHERE       U.TC_NumeroExpediente           = A.TC_NumeroExpediente
							AND			F.TU_CodLegajo					IS NULL
							AND         U.TC_CodPuestoTrabajo           = @L_CodPuestoTrabajo
							AND         U.TF_Inicio_Vigencia            <= GETDATE()
							AND         (
											U.TF_Fin_Vigencia           IS NULL
										OR
											U.TF_Fin_Vigencia           >= GETDATE()
										)
						) G
			OUTER APPLY (
							SELECT      U.TC_CodPuestoTrabajo
							FROM        Historico.LegajoAsignado		U WITH(NOLOCK)
							WHERE       U.TU_CodLegajo		            = F.TU_CodLegajo
							AND         U.TC_CodPuestoTrabajo           = @L_CodPuestoTrabajo
							AND         U.TF_Inicio_Vigencia            <= GETDATE()
							AND         (
											U.TF_Fin_Vigencia           IS NULL
										OR
											U.TF_Fin_Vigencia           >= GETDATE()
										)							 
						) H
			OUTER APPLY (	SELECT		ASU.TC_Descripcion
							FROM		Expediente.LegajoDetalle		LD  WITH(NOLOCK)
							INNER JOIN	Catalogo.Asunto					ASU WITH(NOLOCK)
							ON			LD.TN_CodAsunto					= ASU.TN_CodAsunto
							WHERE		TU_CodLegajo					= F.TU_CodLegajo
						) I								  													
			WHERE	A.TC_NumeroExpediente	=       ISNULL(@L_NumeroExpediente, A.TC_NumeroExpediente)
			AND     A.TN_CodTipoEscrito     =       ISNULL(@L_CodTipoEscrito, A.TN_CodTipoEscrito)			
			AND     A.TC_EstadoEscrito      =       ISNULL(@L_EstadoEscrito, A.TC_EstadoEscrito)		
			AND		(
						(G.TC_CodPuestoTrabajo = @L_CodPuestoTrabajo AND F.TU_CodLegajo IS NULL)
					OR
						(H.TC_CodPuestoTrabajo = @L_CodPuestoTrabajo AND F.TU_CodLegajo IS NOT NULL)
					)
			AND		ISNULL(D.EsUrgente, '') =		ISNULL(@L_EsUrgente, ISNULL(D.EsUrgente, ''))
			AND     A.TC_CodContexto        =       ISNULL(@L_CodContexto, A.TC_CodContexto)
			AND     D.CodigoTipoOficina     =       ISNULL(@L_CodTipoOficina, D.CodigoTipoOficina)		
			AND     (@L_FechaHasta                  IS NULL OR DATEDIFF(DAY, A.TF_FechaIngresoOficina,@L_FechaHasta) >= 0)
			AND     (@L_FechaDesde                  IS NULL OR DATEDIFF(DAY, A.TF_FechaIngresoOficina,@L_FechaDesde) <= 0)
			AND     A.TB_VariasGestiones    =		ISNULL(@L_VariasGestiones, A.TB_VariasGestiones)								
			ORDER BY	A.TF_FechaEnvio
	END
	
END
GO
