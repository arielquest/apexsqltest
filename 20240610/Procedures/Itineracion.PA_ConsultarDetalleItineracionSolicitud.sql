SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<22/01/2021>
-- Descripción :			<Permite consultar el detalle de una itineración de tipo solicitud proveniente de Gestión>
-- =============================================================================================================================================================================
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<12/03/2021><Karol Jiménez S.> <Se agrega a la consulta la materia y el tipo de oficina del contexto.>
-- Modificación:			<15/03/2021><Karol Jiménez S.> <Se cambia tipo dato variables @L_CLASEASUNTO, @L_ASUNTO a INT por error desbordamiento, y el tipo de Dato de Asunto y Clase asunto a int en la tabla @Result,
--							Se agrega el campo IDACO de DACOSOL, para ser guardado como IDACOSOL en SIAGPJ y utilizado en Resultado para DCARTD9>
-- Modificación:			<22/03/2021><Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:			<05/04/2021><Karol Jiménez S.> <Se corrije join con tabla Catalogo.ClaseAsunto, que estaba incorrecto>
-- Modificación:			<13/05/2021><Roger Lara> <Se agrega join con tabla intermedia ClaseAsuntoAsuntoTipoOficinaMateria>
-- Modificación:			<21/06/2021> <Karol Jiménez S.> <Se ajusta para evitar productos cartesianos al buscar equivalencias>
-- Modificación:			<25/10/2021> <Ronny Ramírez R.> <Se aplica corrección para tomar equivalencia de la tabla Catalogo.Prioridad>
-- Modificación:			<27/02/2023> <Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo Prioridad, Asunto
--							y ClaseAsunto)>
-- Modificación:			<27/04/2023> <Karol Jiménez S.> <Se agrega proceso por defecto. Bug 312924)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarDetalleItineracionSolicitud]
	@CodItineracion Uniqueidentifier = null
AS 

BEGIN
	--Variables 
	DECLARE	@L_CodItineracion			Uniqueidentifier		= @CodItineracion
	DECLARE @L_XML						XML
	DECLARE @L_CONTEXTODESTINO			VARCHAR(4)
	DECLARE @L_CLASEASUNTO				INT
	DECLARE @L_ASUNTO					INT

	--Tabla temporal para registros
	DECLARE @Result TABLE	(
			--Legajo
			Codigo					uniqueidentifier,
			NumeroExpediente		char(14),
			FechaInicio				datetime2(7),
			CodigoContexto			varchar(4),	
			TipoOficina				smallint,
			MateriaContexto			varchar(2),
			ContextoCreacion		varchar(4),
			Descripcion				varchar(255),
			Prioridad				varchar(9),
			Carpeta					varchar(14),
			Idacosol				int,
			--Legajo detalle
			Contexto				varchar(4),
			FechaEntrada			datetime2(7),
			Asunto					int,
			ClaseAsunto				int,
			ContextoProcedencia		varchar(4),		
			GrupoTrabajo			varchar(11),
			Habilitado				bit,
			Proceso					smallint
	)


	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SELECT	@L_XML								= VALUE 
	FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS	WITH(NOLOCK) 
	WHERE	ID									= @L_CodItineracion;
	
	--Obtengo el contexto destino deL XML para la consulta de las configuraciones
	SELECT @L_CONTEXTODESTINO= RECIPIENTADDRESS FROM ItineracionesSIAGPJ.dbo.MESSAGES WITH(NOLOCK) WHERE ID = @L_CodItineracion;

	SELECT @L_ASUNTO = Itineracion.FN_ConsultarValorDefectoConfiguracion('C_AsuntoTipoRecurso',@L_CONTEXTODESTINO);
	select @L_CLASEASUNTO = TN_CodClaseAsunto from Catalogo.ClaseAsunto WITH(NOLOCK) where TN_CodAsunto = @L_ASUNTO and CODCLAS = 'DMS';

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DCAR AS (
		SELECT	X.Y.value('(NUE)[1]',				'VARCHAR(14)')						NUE,
				X.Y.value('(CODDEJ)[1]',			'VARCHAR(4)')						CONTEXTO,
				X.Y.value('(CODDEJ)[1]',			'VARCHAR(4)')						CONTEXTOCREACION,
				X.Y.value('(DESCRIP)[1]',			'VARCHAR(255)')						DESCRIPCION,
				X.Y.value('(CODPRI)[1]',			'VARCHAR(9)')						PRIORIDAD,
				X.Y.value('(CARPETA)[1]',			'VARCHAR(14)')						CARPETA,
				X.Y.value('(CODDEJ)[1]',			'VARCHAR(4)')						CONTEXTODETALLE,
				TRY_CONVERT(DATETIME2(3), X.Y.value('(FECENT)[1]', 'VARCHAR(35)'))		FECHAENTRADA,
				X.Y.value('(CODASU)[1]',			'VARCHAR(9)')						ASUNTO,
				X.Y.value('(CODCLAS)[1]',			'VARCHAR(9)')						CLASEASUNTO,
				X.Y.value('(CODGT)[1]',				'VARCHAR(11)')						GRUPOTRABAJO				
		FROM	@L_XML.nodes('(/*/DCAR)')			AS X(Y)
	),
	DACOSOL AS (	
			SELECT	X.Y.value('(CODDEJDES)[1]',		'VARCHAR(4)')		CONTEXTODESTINO,
					X.Y.value('(CARPETA)[1]',		'VARCHAR(14)')		CARPETA,
					X.Y.value('(IDACO)[1]',			'INT')				IDACOSOL
			FROM	@L_XML.nodes('(/*/DACOSOL)')	AS X(Y)
	)
	INSERT INTO @Result
	(
				Codigo,
				NumeroExpediente,			FechaInicio,			CodigoContexto,
				ContextoCreacion,			Descripcion,			Prioridad,
				Carpeta,					Idacosol,				Contexto,				
				FechaEntrada,				Asunto,					ClaseAsunto,			
				ContextoProcedencia,		GrupoTrabajo,			Habilitado,				
				MateriaContexto,			TipoOficina,			Proceso		
	)
	SELECT		NEWID(),
				A.NUE,						GETDATE(),				B.CONTEXTODESTINO,
				A.CONTEXTOCREACION,			A.DESCRIPCION,			C.TN_CodPrioridad,
				A.CARPETA,					B.IDACOSOL,				B.CONTEXTODESTINO,		
				A.FECHAENTRADA,
				ISNULL(D.TN_CodAsunto,Itineracion.FN_ConsultarValorDefectoConfiguracion('C_AsuntoTipoSolicitud',B.CONTEXTODESTINO)),				
				ISNULL(E.TN_CodClaseAsunto,@L_CLASEASUNTO),			A.CONTEXTOCREACION,
				A.GRUPOTRABAJO,				1,						F.TC_CodMateria,			
				G.TN_CodTipoOficina,
				CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_ProcesoPorDefecto',@L_ContextoDestino))
	FROM		DCAR					A
	INNER JOIN	DACOSOL					B
	ON			A.CARPETA				=	B.CARPETA
	LEFT JOIN	Catalogo.Prioridad		C	WITH(NOLOCK) 
	ON			C.TN_CodPrioridad		=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_CONTEXTODESTINO,'Prioridad', A.PRIORIDAD,0,0))
	LEFT JOIN	Catalogo.Asunto			D	WITH(NOLOCK)
	ON			D.TN_CodAsunto			=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_CONTEXTODESTINO,'Asunto', A.ASUNTO,0,0))
	LEFT JOIN	Catalogo.ClaseAsunto	E	WITH(NOLOCK)
	ON			E.TN_CodClaseAsunto		=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_CONTEXTODESTINO,'ClaseAsunto', A.CLASEASUNTO,0,0))
	LEFT JOIN	Catalogo.ClaseAsuntoAsuntoTipoOficinaMateria CA WITH(NOLOCK)
	ON			CA.TN_CodAsunto		 = ISNULL(D.TN_CodAsunto,Itineracion.FN_ConsultarValorDefectoConfiguracion('C_AsuntoTipoSolicitud',@L_CONTEXTODESTINO)) AND
				CA.TN_CodClaseAsunto = E.TN_CodClaseAsunto AND
				CA.TN_CodTipoOficina = (SELECT TN_CodTipoOficina FROM Catalogo.Oficina WITH(NOLOCK) WHERE TC_CodOficina=@L_CONTEXTODESTINO) AND
				CA.TC_CodMateria	 = (SELECT TC_CodMateria FROM Catalogo.Contexto WITH(NOLOCK) WHERE TC_CodContexto=@L_CONTEXTODESTINO)
	LEFT JOIN	Catalogo.Contexto		F	WITH(NOLOCK)
	ON			F.TC_CodContexto		=	B.CONTEXTODESTINO
	LEFT JOIN	Catalogo.Oficina		G	WITH(NOLOCK)
	ON			G.TC_CodOficina			=	F.TC_CodOficina

	SELECT		Codigo					AS Codigo,
				Idacosol				as CodigoSolicitudGestion,
				'SplitOtros'			as SplitOtros,
				NumeroExpediente		as NumeroExpediente,			
				FechaInicio				as FechaInicio,			
				CodigoContexto			as CodigoContexto,
				ContextoCreacion		as ContextoCreacion,			
				Descripcion				as Descripcion,			
				Prioridad				as Prioridad,
				Carpeta					as Carpeta,	
				Contexto				as Contexto,					
				FechaEntrada			as FechaEntrada,	
				Asunto					as Asunto,						
				ClaseAsunto				as ClaseAsunto,			
				ContextoProcedencia		as ContextoProcedencia,	
				GrupoTrabajo			as GrupoTrabajo,				
				Habilitado				as Habilitado,
				MateriaContexto			as MateriaContexto,
				TipoOficina				as TipoOficina, 
				Proceso					as Proceso
	FROM		@Result
END
GO
