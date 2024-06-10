SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<11/01/2021>
-- Descripción :			<Permite consultar el detalle de una itineración de tipo recurso proveniente de Gestión>
-- =============================================================================================================================================================================
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<03/03/2021><Jonathan Aguilar Navarro><Se modifica el tipo de dato de clase de asunto, se corrije join con Prioridad> 
-- Modificación:			<05/03/2021><Ronny Ramírez R.><Se agrega el campo IDACO de DACOREC, para ser guardado como IDACOREC en SIAGPJ y utilizado en Resultado para DCARTD6> 
-- Modificación:			<12/03/2021><Karol Jiménez S.> <Se agrega a la consulta la materia y el tipo de oficina del contexto.>
-- Modificación:			<22/03/2021><Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:			<13/05/2021><Roger Lara> <Se agrega join con tabla intermedia ClaseAsuntoAsuntoTipoOficinaMateria>
-- Modificación:			<21/06/2021><Karol Jiménez S.> <Se ajusta para evitar productos cartesianos al buscar equivalencias>
-- Modificación:			<08/07/2021><Luis Alonso Leiva Tames> <Se agrega la columna CODRES en el resultado final de la consulta>
-- Modificación:			<27/02/2023> <Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo Prioridad, Asunto
--							y ClaseAsunto)>
-- Modificación:			<10/03/2023> <Josué Quirós Batista> <Se agrega la instrucción WITH(NOLOCK) en las subConsultas faltantes.>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarDetalleItineracionRecurso]
	@CodItineracion Uniqueidentifier = null
AS 
BEGIN
	--Variables 
	DECLARE	@L_CodItineracion			Uniqueidentifier		= @CodItineracion
	DECLARE @L_XML						XML
	DECLARE @L_ASUNTO					SMALLINT
	DECLARE @L_DESPACHODESTINO			VARCHAR(4)

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
			Prioridad				smallint,
			Carpeta					varchar(14),
			Idacorec				int,
			--Legajo detalle
			Contexto				varchar(4),
			FechaEntrada			datetime2(7),
			Asunto					int,
			ClaseAsunto				int,
			ContextoProcedencia		varchar(4),		
			GrupoTrabajo			varchar(11),
			Habilitado				bit, 
			CODRES					varchar(4)
	)

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SELECT	@L_XML								= VALUE 
	FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS	WITH(NOLOCK) 
	WHERE	ID									= @L_CodItineracion;
	
	--Obtengo el contexto destino deL XML para la consulta de las configuraciones
	SELECT @L_DESPACHODESTINO= RECIPIENTADDRESS FROM ItineracionesSIAGPJ.dbo.MESSAGES WITH(NOLOCK) WHERE ID = @L_CodItineracion;

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DCAR AS (
		SELECT	X.Y.value('(NUE)[1]',				'VARCHAR(14)')						NUE,
				X.Y.value('(CODDEJ)[1]',			'VARCHAR(4)')						CONTEXTOCREACION,
				X.Y.value('(DESCRIP)[1]',			'VARCHAR(255)')						DESCRIPCION,
				X.Y.value('(CODPRI)[1]',			'VARCHAR(9)')						PRIORIDAD,
				X.Y.value('(CARPETA)[1]',			'VARCHAR(14)')						CARPETA,
				TRY_CONVERT(DATETIME2(3), X.Y.value('(FECENT)[1]', 'VARCHAR(35)'))		FECHAENTRADA,
				X.Y.value('(CODASU)[1]',			'VARCHAR(9)')						ASUNTO,
				X.Y.value('(CODCLAS)[1]',			'VARCHAR(9)')						CLASEASUNTO,
				X.Y.value('(CODGT)[1]',				'VARCHAR(11)')						GRUPOTRABAJO				
		FROM	@L_XML.nodes('(/*/DCAR)')			AS X(Y)
	),
	DACOREC AS (	
			SELECT	X.Y.value('(CODDEJDES)[1]',		'VARCHAR(4)')		CONTEXTODESTINO,
					X.Y.value('(CARPETA)[1]',		'VARCHAR(14)')		CARPETA,
					X.Y.value('(IDACO)[1]',			'INT')				IDACOREC, 
					X.Y.value('(CODRES)[1]',			'VARCHAR(4)')	CODRES		
			FROM	@L_XML.nodes('(/*/DACOREC)')	AS X(Y)
	)
	INSERT INTO @Result
	(
				Codigo,
				NumeroExpediente,			FechaInicio,			CodigoContexto,
				ContextoCreacion,			Descripcion,			Prioridad,
				Carpeta,					Contexto,				FechaEntrada,	
				Asunto,						ClaseAsunto,			ContextoProcedencia,	
				GrupoTrabajo,				Habilitado,				Idacorec,
				MateriaContexto,			TipoOficina,			CODRES
	)
	SELECT		NEWID(),
				A.NUE,						GETDATE(),				B.CONTEXTODESTINO,
				A.CONTEXTOCREACION,			A.DESCRIPCION,			C.TN_CodPrioridad,
				A.CARPETA,					B.CONTEXTODESTINO,		A.FECHAENTRADA,
				ISNULL(D.TN_CodAsunto,Itineracion.FN_ConsultarValorDefectoConfiguracion('C_AsuntoTipoRecurso',@L_DESPACHODESTINO)),				
				E.TN_CodClaseAsunto,		A.CONTEXTOCREACION,
				A.GRUPOTRABAJO,				1,						B.IDACOREC,
				F.TC_CodMateria,			G.TN_CodTipoOficina,	B.CODRES
	FROM		DCAR					A
	INNER JOIN	DACOREC					B
	ON			A.CARPETA				=	B.CARPETA
	LEFT JOIN	Catalogo.Prioridad		C	WITH(NOLOCK) 
	ON			C.TN_CodPrioridad		=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_DESPACHODESTINO,'Prioridad', A.PRIORIDAD,0,0))
	LEFT JOIN	Catalogo.Asunto			D	WITH(NOLOCK) 
	ON			D.TN_CodAsunto			=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_DESPACHODESTINO,'Asunto', A.ASUNTO,0,0))
	LEFT JOIN	Catalogo.ClaseAsunto	E	WITH(NOLOCK)
	ON			E.TN_CodClaseAsunto		=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_DESPACHODESTINO,'ClaseAsunto', A.CLASEASUNTO,0,0))
	LEFT JOIN	Catalogo.Contexto		F	WITH(NOLOCK)
	ON			F.TC_CodContexto		=	B.CONTEXTODESTINO
	LEFT JOIN	Catalogo.Oficina		G	WITH(NOLOCK)
	ON			G.TC_CodOficina			=	F.TC_CodOficina
	LEFT JOIN  Catalogo.ClaseAsuntoAsuntoTipoOficinaMateria CA WITH(NOLOCK)
	ON			CA.TN_CodAsunto		 = ISNULL(D.TN_CodAsunto,Itineracion.FN_ConsultarValorDefectoConfiguracion('C_AsuntoTipoRecurso',@L_DESPACHODESTINO)) AND
				CA.TN_CodClaseAsunto = E.TN_CodClaseAsunto AND
				CA.TN_CodTipoOficina = (SELECT TN_CodTipoOficina FROM Catalogo.Oficina WITH(NOLOCK) WHERE TC_CodOficina=F.TC_CodOficina) AND
				CA.TC_CodMateria	 = (SELECT TC_CodMateria FROM Catalogo.Contexto WITH(NOLOCK) WHERE TC_CodContexto=F.TC_CodContexto)


	SELECT		Codigo					AS Codigo,
				Idacorec				AS CodigoRecursoGestion,
				'SplitOtros'			as SplitOtros,
				NumeroExpediente		as NumeroExpediente,			
				FechaInicio				as FechaInicio,			
				@L_DESPACHODESTINO		as CodigoContexto,
				ContextoCreacion		as ContextoCreacion,			
				Descripcion				as Descripcion,			
				Prioridad				as Prioridad,
				Carpeta					as Carpeta,	
				@L_DESPACHODESTINO		as Contexto,					
				FechaEntrada			as FechaEntrada,	
				Asunto					as Asunto,						
				ClaseAsunto				as ClaseAsunto,			
				ContextoProcedencia		as ContextoProcedencia,	
				GrupoTrabajo			as GrupoTrabajo,				
				Habilitado				as Habilitado,
				MateriaContexto			as MateriaContexto,
				TipoOficina				as TipoOficina, 
				CODRES					as CODRES
	FROM		@Result
END
GO
