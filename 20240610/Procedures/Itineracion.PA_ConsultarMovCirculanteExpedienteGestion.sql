SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<03/02/2021>
-- Descripción :			<Permite consultar los movimientos de circulante de un expediente asociado a un registro de Itineración de Gestión con catálogos del SIAGPJ>
-- =============================================================================================================================================================================
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<22/03/2021><Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:			<04/05/2021><Karol Jiménez S.> <Se ajusta para obtener mapeo contra Catalogo.Estado para agregar el CODTIDEJ como parte de la búsqueda>
-- Modificación:			<21/06/2021> <Karol Jiménez S.> <Se ajusta para evitar productos cartesianos al buscar equivalencias>
-- Modificación:			<29/09/2021> <Karol Jiménez Sánchez> <Se aplica cambio para obtención de equivalencias catálogo Estados desde módulo de equivalencias>
-- Modificación:			<04/01/2022> <Luis Alonso Leiva Tames> <Se cambia el tipo de dato en el campo IDFEP (int --> bigint) >
-- Modificación:			<24/02/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo Fase)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarMovCirculanteExpedienteGestion]
	@CodItineracion Uniqueidentifier
AS 

BEGIN
	--Variables 
	DECLARE	@L_CodItineracion			Uniqueidentifier	=	@CodItineracion,
			@L_XML						XML,
			@L_NumeroExpediente			VARCHAR(14),
			@L_CodContexto				VARCHAR(14)

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SET @L_XML = (
					SELECT	VALUE 
					FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS WITH(NOLOCK) 
					WHERE	ID = @L_CodItineracion
				);

	-- Se obtiene el # de expediente del XML
	SET @L_NumeroExpediente = @L_XML.value('(/*/DCAR/NUE)[1]','VARCHAR(14)');

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DHISFEP (NUMEROEXPEDIENTE, IDACO, FECHA, CONTEXTO, CODESTASU, FECESTASU, FINEST, CODFAS, FECFASE, CODTIDEJ, IDFEP) AS (
		SELECT	@L_NumeroExpediente,
				X.Y.value('(IDACO)[1]', 'INT'),
				TRY_CONVERT(DATETIME2(3),X.Y.value('(FECHA)[1]', 'VARCHAR(35)')),
				X.Y.value('(CODDEJ)[1]', 'VARCHAR(4)'),
				X.Y.value('(CODESTASU)[1]', 'VARCHAR(9)'),
				TRY_CONVERT(DATETIME2(3),X.Y.value('(FECESTASU)[1]', 'VARCHAR(35)')),
				X.Y.value('(FINEST)[1]', 'VARCHAR(1)'),
				X.Y.value('(CODFAS)[1]', 'VARCHAR(6)'),
				TRY_CONVERT(DATETIME2(3),X.Y.value('(FECFASE)[1]', 'VARCHAR(35)')),
				X.Y.value('(CODTIDEJ)[1]', 'VARCHAR(2)'),
				X.Y.value('(IDFEP)[1]', 'BIGINT')
		FROM @L_XML.nodes('(/*/DHISFEP)') AS X(Y)
	),

	DACO (IDACO, TEXTO, IDUSU) AS (
		SELECT	A.B.value('(IDACO)[1]', 'INT'),
				A.B.value('(TEXTO)[1]', 'VARCHAR(255)'),
				A.B.value('(IDUSU)[1]', 'VARCHAR(25)')
		FROM @L_XML.nodes('(/*/DACO)') AS A(B)
	)

	-- Consulta de movimientos de circulante y fases con equivalencias de catálogos de SIAGPJ
	SELECT	
			A.IDFEP										IDFEP,
			A.FECHA										Fecha,
			D.TEXTO										Motivo,
			'SplitExpediente'							SplitExpediente,
			@L_NumeroExpediente							Numero,
			'SplitContexto'								SplitContexto,
			CC.TC_CodContexto							Codigo,
			CC.TC_Descripcion							Descripcion,
			'SplitEstado'								SplitEstado,
			F.TN_CodEstado									Codigo,
			F.TC_Descripcion								Descripcion,
			'SplitFase'									SplitFase,
			G.Codigo									Codigo,
			G.Descripcion								Descripcion,
			'SplitOtros'								SplitOtros,
			CASE WHEN A.FINEST IN ('C', 'c')
				THEN 'E'
				ELSE A.FINEST
			END											Movimiento,
			F.TC_Circulante								Circulante
	FROM		DHISFEP									A											
	LEFT JOIN	DACO									D
	ON			D.IDACO							=		A.IDACO
	INNER JOIN	Catalogo.Contexto				CC		WITH(NOLOCK)
	ON			CC.TC_CodContexto				=		A.CONTEXTO
	INNER JOIN	Catalogo.Materia				M		WITH(NOLOCK)
	ON			CC.TC_CodMateria				=		M.TC_CodMateria
	INNER JOIN	Catalogo.Oficina				O		WITH(NOLOCK)
	ON			CC.TC_CodOficina				=		O.TC_CodOficina
	LEFT JOIN	Catalogo.Estado					F WITH(NOLOCK)
	ON			F.TN_CodEstado					= Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(A.CONTEXTO,'Estado', A.CODESTASU,0,0)
	OUTER APPLY
	(
		SELECT	TOP 1	X.TN_CodFase			Codigo, 
						X.TC_Descripcion		Descripcion 
		FROM			Catalogo.Fase			X WITH(NOLOCK)
		INNER JOIN		Catalogo.MateriaFase	Z WITH(NOLOCK)
		ON				Z.TN_CodFase			= X.TN_CodFase
		AND				Z.TN_CodTipoOficina		= O.TN_CodTipoOficina
		AND				Z.TC_CodMateria			= M.TC_CodMateria
		WHERE			X.TN_CodFase			= CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(A.CONTEXTO,'Fase', A.CODFAS,0,0))
		ORDER BY 		ISNULL(X.TF_Fin_Vigencia, GETDATE()) DESC
	)G
	ORDER BY A.IDFEP ASC
END
GO
