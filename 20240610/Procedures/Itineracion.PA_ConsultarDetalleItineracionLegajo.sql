SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<27/01/2021>
-- Descripción :			<Permite consultar el detalle de una itineración de tipo Legajo proveniente de Gestión>
-- =============================================================================================================================================================================
-- Modificación:			<05/02/2021> <Jonathan Aguialr Navarro> <Se agrega a la consulta la materia y el tipo de oficina del contexto.>
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<22/03/2021><Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:			<13/05/2021><Roger Lara> <Se agrega join con tabla intermedia ClaseAsuntoAsuntoTipoOficinaMateria>
-- Modificación:			<21/06/2021><Karol Jiménez S.> <Se ajusta para evitar productos cartesianos al buscar equivalencias>
-- Modificación:			<27/02/2023> <Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo Prioridad, Asunto
--							y ClaseAsunto)>
-- Modificación:			<20/04/2023> <Karol Jiménez S.> <Se agrega mapeo de Proceso - BUG 311661)>
-- Modificación:			<10/10/2023> <Karol Jiménez S.> <PBI 347803 Se agrega a la consulta el campo EmbargosFisicos el cual se obtiene de DCAR.EMBARGOF>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarDetalleItineracionLegajo]
	@CodItineracion Uniqueidentifier = null
AS 
BEGIN
	--Variables 
	DECLARE	@L_CodItineracion			Uniqueidentifier		= @CodItineracion,
			@L_XML						XML,
			@L_ASUNTO					SMALLINT,
			@L_DESPACHODESTINO			VARCHAR(4),
			@TipoOficina				SMALLINT,
			@Materia					VARCHAR(5),
			@TN_CodProcesoDefecto		SMALLINT;

	--Tabla temporal para registros
	DECLARE @Result TABLE	(
			--Legajo
			Codigo					uniqueidentifier,
			EmbargosFisicos			bit,
			NumeroExpediente		char(14),
			FechaInicio				datetime2(7),
			Contexto				varchar(4),
			TipoOficina				smallint,
			MateriaContexto			varchar(2),
			ContextoCreacion		varchar(4),
			Descripcion				varchar(255),
			Prioridad				smallint,
			Carpeta					varchar(14),
			--Legajo detalle
			ContextoDetalle			varchar(4),
			FechaEntrada			datetime2(7),
			Asunto					varchar(5),
			ClaseAsunto				int,
			ContextoProcedencia		varchar(4),		
			GrupoTrabajo			varchar(11),
			Habilitado				bit,
			CODPRO					varchar(5),
			TN_CodProceso			smallint	null
	)
	
	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SELECT	@L_XML								= VALUE 
	FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS	WITH(NOLOCK) 
	WHERE	ID									= @L_CodItineracion;

	SELECT		@L_DESPACHODESTINO						=	RECIPIENTADDRESS,
				@Materia								=	C.TC_CodMateria,
				@TipoOficina							=	O.TN_CodTipoOficina
	FROM		ItineracionesSIAGPJ.dbo.MESSAGES		M	WITH(NOLOCK) 
	INNER JOIN	Catalogo.Contexto						C	WITH(NOLOCK)
	ON			C.TC_CodContexto						=	M.RECIPIENTADDRESS	COLLATE DATABASE_DEFAULT		
	LEFT JOIN	Catalogo.Oficina						O	WITH(NOLOCK) 
	ON			O.TC_CodOficina							=	C.TC_CodOficina
	WHERE		M.ID									=	@L_CodItineracion;

	SELECT @TN_CodProcesoDefecto = CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_ProcesoPorDefecto',@L_DESPACHODESTINO));

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DCAR AS (
		SELECT	X.Y.value('(NUE)[1]',				'VARCHAR(14)')					NUE,
				X.Y.value('(CODDEJ)[1]',			'VARCHAR(4)')					CONTEXTOCREACION,
				X.Y.value('(DESCRIP)[1]',			'VARCHAR(255)')					DESCRIPCION,
				X.Y.value('(CODPRI)[1]',			'VARCHAR(9)')					PRIORIDAD,
				X.Y.value('(CARPETA)[1]',			'VARCHAR(14)')					CARPETA,
				TRY_CONVERT(DATETIME2(3), X.Y.value('(FECENT)[1]', 'VARCHAR(35)'))	FECHAENTRADA,
				X.Y.value('(CODASU)[1]',			'VARCHAR(9)')					ASUNTO,
				X.Y.value('(CODCLAS)[1]',			'VARCHAR(9)')					CLASEASUNTO,
				X.Y.value('(CODDEJ)[1]',			'VARCHAR(4)')					CONTEXTOPROCEDENCIA,
				X.Y.value('(CODPRO)[1]',			'VARCHAR(5)')					CODPRO,
				X.Y.value('(EMBARGOF)[1]',			'BIT')							EMBARGOFISICO
		FROM	@L_XML.nodes('(/*/DCAR)')			AS X(Y)
	)

	INSERT INTO @Result
	(
				Codigo,					EmbargosFisicos,
				NumeroExpediente,		FechaInicio,			Contexto,	ContextoCreacion,			
				Descripcion,			Prioridad,				Carpeta,									
				FechaEntrada,			Asunto,					ClaseAsunto,			
				ContextoProcedencia,	Habilitado,				CODPRO
	)
	SELECT		TOP 1
				NEWID()	AS CODIGO,			A.EMBARGOFISICO,
				A.NUE,						GETDATE() AS FECCHAENTRADA,				
				@L_DESPACHODESTINO,			A.CONTEXTOCREACION,		A.DESCRIPCION,			C.TN_CodPrioridad,
				A.CARPETA,					A.FECHAENTRADA,
				ISNULL(D.TN_CodAsunto,Itineracion.FN_ConsultarValorDefectoConfiguracion('C_AsuntoTipoLegajo',@L_DESPACHODESTINO)) AS ASUNTO,				
				E.TN_CodClaseAsunto,		A.CONTEXTOPROCEDENCIA,
				1 AS HABILITADO,
				A.CODPRO
	FROM		DCAR	A
	LEFT JOIN	Catalogo.Prioridad		C	WITH(NOLOCK) 
	ON			C.TN_CodPrioridad		=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_DESPACHODESTINO,'Prioridad', A.PRIORIDAD,0,0))
	LEFT JOIN	Catalogo.Asunto			D	WITH(NOLOCK)
	ON			D.TN_CodAsunto			=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_DESPACHODESTINO,'Asunto', A.ASUNTO,0,0))
	LEFT JOIN	Catalogo.ClaseAsunto	E	WITH(NOLOCK)
	ON			E.TN_CodClaseAsunto		=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_DESPACHODESTINO,'ClaseAsunto', A.CLASEASUNTO,0,0))
	LEFT JOIN	Catalogo.ClaseAsuntoAsuntoTipoOficinaMateria CA WITH(NOLOCK)
	ON			CA.TN_CodAsunto		 = ISNULL(D.TN_CodAsunto,Itineracion.FN_ConsultarValorDefectoConfiguracion('C_AsuntoTipoLegajo', @L_DESPACHODESTINO)) AND
				CA.TN_CodClaseAsunto = E.TN_CodClaseAsunto AND
				CA.TN_CodTipoOficina = (SELECT TN_CodTipoOficina FROM Catalogo.Oficina WITH(NOLOCK) WHERE TC_CodOficina = @L_DESPACHODESTINO) AND
				CA.TC_CodMateria	 = (SELECT TC_CodMateria FROM Catalogo.Contexto WITH(NOLOCK) WHERE TC_CodContexto = @L_DESPACHODESTINO)

	--Actualiza el tipo la Materia del Contexto
	UPDATE		A
	SET			A.MateriaContexto		= C.TC_CodMateria
	FROM		@Result					A
	INNER JOIN	Catalogo.Contexto		C WITH(NOLOCK)
	ON			C.TC_CodContexto		= A.Contexto

	--Actualiza el tipo de la Oficina del Contexto
	UPDATE		A
	SET			A.TipoOficina		=	C.TN_CodTipoOficina
	FROM		@Result				A, Catalogo.Contexto B WITH(NOLOCK)
	INNER JOIN	Catalogo.Oficina	C  WITH(NOLOCK)
	ON			C.TC_CodOficina		= B.TC_CodOficina
	WHERE		A.Contexto			= B.TC_CodContexto

	--Actualiza el proceso
	UPDATE	A
	SET		A.TN_CodProceso = (	SELECT			TOP 1 ISNULL(P.TN_CodProceso, @TN_CodProcesoDefecto)
								FROM			Catalogo.ClaseProcesoTipoOficinaMateria CPTOM WITH(NOLOCK)
								INNER JOIN		Catalogo.Proceso						P	WITH(NOLOCK)
								ON				P.TN_CodProceso							=	CPTOM.TN_CodProceso
								WHERE			P.TN_CodProceso							=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_DESPACHODESTINO,'Proceso', A.CODPRO,0,0))
								AND				CPTOM.TN_CodTipoOficina					=	@TipoOficina
								AND				CPTOM.TC_CodMateria						=	@Materia
								ORDER BY 		ISNULL(P.TF_Fin_Vigencia, GETDATE()) DESC
							  )
	FROM	@Result		A

	SELECT		Codigo					AS Codigo,
				EmbargosFisicos			AS EmbargosFisicos,
				'SplitOtros'			AS SplitOtros,
				NumeroExpediente		AS NumeroExpediente,
				@L_DESPACHODESTINO		AS Contexto,
				MateriaContexto			AS MateriaContexto,
				TipoOficina				AS TipoOficina,
				FechaInicio				AS FechaInicio,			
				ContextoCreacion		AS ContextoCreacion,			
				Descripcion				AS Descripcion,			
				Prioridad				AS Prioridad,
				Carpeta					AS Carpeta,		
				@L_DESPACHODESTINO		AS ContextoDetalle,
				FechaEntrada			AS FechaEntrada,	
				Asunto					AS Asunto,						
				ClaseAsunto				AS ClaseAsunto,			
				ContextoProcedencia		AS ContextoProcedencia,				
				Habilitado				AS Habilitado,
				TN_CodProceso			AS Proceso
	FROM		@Result
END
GO
