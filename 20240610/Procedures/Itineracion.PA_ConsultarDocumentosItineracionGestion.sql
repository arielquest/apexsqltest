SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<15/12/2020>
-- Descripción :			<Permite consultar los documentos asociados a un registro de Itineración de Gestión con cat logos del SIAGPJ>
-- =============================================================================================================================================================================
-- Modificación:			<12/01/2021> <Ronny Ramírez R.> <Se agrega campo IDACO como CodigoGestion para mapear con entidad de SIAGPJ>
-- Modificación:			<13/01/2021> <Ronny Ramírez R.> <Se agrega configuración por defecto para el grupo de trabajo en caso de no haber equivalencia de Gestión>
-- Modificación:			<14/01/2021> <Ronny Ramírez R.> <Se agrega campo de notificaciones desde Gestión>
-- Modificación:			<22/02/2021> <Ronny Ramírez R.> <Se agrega validación para incluir prefijo "ApremioSol/" si CODTRAM de DACO indica "APREMIOSOL">
-- Modificación:			<01/03/2021> <Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, seg£n acuerdo con BT>
-- Modificación:			<11/03/2021> <Karol Jiménez S.> <Se excluyen multimedia>
-- Modificación:			<22/03/2021> <Ronny Ramírez R.> <Se agrega el formato jur¡dico asociado a la itineración y se ajusta la conversión de la fecha de XML a Datetime2>
-- Modificación:			<23/06/2021> <Ronny Ramírez R.> <Se agrega el estado del documento DACO.CODESTACO, pues Sigifredo indicó que ahora debemos aceptar itineraciones 
--							con documentos en cualquier estado, en caso que no venga un estado v lido, se pone por defecto en Borrador, al igual que en la migración>
-- Modificación:			<05/08/2021> <Ronny Ramírez R.> <Para bug 195793 se aplica cambio en mapeo del campo asignado a la FechaCrea de FECSYS a FECDOC o FECHA cuando el 
--							anterior sea NULL>
-- Modificación:			<20/10/2021> <Ronny Ramírez R.> <Se aplica corrección para convertir todos los CTE's a tablas en memoria @ para optimizar el rendimiento>
-- Modificación:			<03/12/2021> <Isaac Santiago Méndez Castillo> <Se aplica filtro para que en el LEFT JOIN con el Catalogo.GrupoTrabajo evalue también el contexto de
--																		   de origen, estaba generando productos cartesiano. Incidente: 227001>
-- Modificación:			<01/03/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos GrupoTrabajo y FormatoJuridico)>
-- =============================================================================================================================================================================
 CREATE PROCEDURE [Itineracion].[PA_ConsultarDocumentosItineracionGestion]
	@CodItineracion Uniqueidentifier,
	@UsuarioCreaXDefecto	VARCHAR(30),
	@ContextoCreaXDefecto	VARCHAR(4)
AS 

BEGIN
	--Variables 
	DECLARE	@L_CodItineracion			VARCHAR(36)			=	@CodItineracion,
			@L_UsuarioCrea				VARCHAR(30)			=	@UsuarioCreaXDefecto,
			@L_ContextoCreaXDefecto		VARCHAR(4)			=	@ContextoCreaXDefecto,
			@L_CodigoEstado				INT					=	2, -- Código Enum BORRADOR
			@L_XML						XML,
			@L_NumeroExpediente			VARCHAR(14),
			@L_ValorDefectoGrupoTrabajo	SMALLINT			= NULL,
			@L_DescDefectoGrupoTrabajo	VARCHAR(255)		= NULL,
			@L_ContextoDestino			VARCHAR(4); 

	-- Se obtiene valor por defecto para el grupo de trabajo desde configuración
	SELECT	@L_ValorDefectoGrupoTrabajo	= CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_GrupoTrabajoArchExped', @L_ContextoCreaXDefecto))
	SET		@L_DescDefectoGrupoTrabajo = (
				SELECT	TC_Descripcion
				FROM	Catalogo.GrupoTrabajo		WITH(NOLOCK)
				WHERE	TN_CodGrupoTrabajo		=	@L_ValorDefectoGrupoTrabajo
			);

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SELECT		@L_XML								= A.VALUE,
				@L_ContextoDestino					= M.RECIPIENTADDRESS
	FROM		ItineracionesSIAGPJ.dbo.MESSAGES	M WITH(NOLOCK) 
	INNER JOIN	ItineracionesSIAGPJ.dbo.ATTACHMENTS A WITH(NOLOCK) 
	ON			A.ID								= M.ID
	WHERE		M.ID								= @L_CodItineracion;

	-- Se obtiene el # de expediente del XML
	SET @L_NumeroExpediente = @L_XML.value('(/*/DCAR/NUE)[1]','VARCHAR(14)');

	-- Se mapean los campos a tablas en memoria para facilitar y optimizar los joins de m£ltiples nodos
	
	DECLARE @TBLArchivos TABLE (idaco INT, ruta VARCHAR(255), nombre VARCHAR(255))
	INSERT INTO @TBLArchivos
	SELECT	X.Y.value('(idaco)[1]', 'INT'),
			X.Y.value('(ruta)[1]', 'VARCHAR(255)'),
			X.Y.value('(nombre)[1]', 'VARCHAR(255)')	
	FROM @L_XML.nodes('(/*/tblArchivos)') AS X(Y)
	
	DECLARE @DACO TABLE (IDACO INT, TEXTO VARCHAR(255), CODDEJ VARCHAR(4), FECDOC VARCHAR(35), FECHA VARCHAR(35), IDUSU VARCHAR(25), CODGT VARCHAR(9), CODTRAM VARCHAR(12), CODACO VARCHAR(9), CODESTACO VARCHAR(1))
	INSERT INTO @DACO	
	SELECT	A.B.value('(IDACO)[1]', 'int'),
			A.B.value('(TEXTO)[1]', 'VARCHAR(255)'),
			A.B.value('(CODDEJ)[1]', 'VARCHAR(4)'),
			TRY_CONVERT(DATETIME2(3), A.B.value('(FECDOC)[1]', 'VARCHAR(35)')),
			TRY_CONVERT(DATETIME2(3), A.B.value('(FECHA)[1]', 'VARCHAR(35)')),
			A.B.value('(IDUSU)[1]', 'VARCHAR(25)'),
			A.B.value('(CODGT)[1]', 'VARCHAR(9)'),
			A.B.value('(CODTRAM)[1]', 'VARCHAR(12)'),
			A.B.value('(CODACO)[1]', 'VARCHAR(9)'),
			A.B.value('(CODESTACO)[1]', 'VARCHAR(1)')
	FROM @L_XML.nodes('(/*/DACO)') AS A(B)
	
	DECLARE @DACONOT TABLE (IDACODOCUNOT INT)
	INSERT	INTO @DACONOT
	SELECT	A.B.value('(IDACODOCUNOT)[1]', 'int')
	FROM	@L_XML.nodes('(/*/DACONOT)') AS A(B)

	DECLARE @SinFormatoArchivo TABLE (Codigo INT, Descripcion VARCHAR(100))
	INSERT	INTO @SinFormatoArchivo
	SELECT	TN_CodFormatoArchivo,		TC_Descripcion
	FROM	Catalogo.FormatoArchivo		WITH(NOLOCK)
	WHERE	TC_Extensiones				LIKE	'SIN EXTENSION'
	
	DECLARE @DACODOC TABLE (IDACO INT, CODMOD VARCHAR(12))
	INSERT	INTO @DACODOC
	SELECT	A.B.value('(IDACO)[1]', 'int'),
			A.B.value('(CODMOD)[1]', 'VARCHAR(12)')
	FROM	@L_XML.nodes('(/*/DACODOC)') AS A(B)

	-- Consulta de registros de documentos con equivalencias de cat logos de SIAGPJ
	SELECT		CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)		AS	Codigo,
				A.idaco										As	CodigoGestion,
				CONCAT(
					CASE	
						WHEN	D.CODTRAM = 'APREMIOSOL' 
						THEN	'ApremioSol/'
					END,
					ISNULL(D.TEXTO, 'Itinerado')
				)											AS	Descripcion,
				ISNULL(D.FECDOC,ISNULL(D.FECHA, GETDATE()))	AS	FechaCrea,
				A.ruta										AS	RutaArchivoGestion,
				H.ExisteNotificacion						AS	Notifica,
				'SplitExpediente'							AS	SplitExpediente,
				@L_NumeroExpediente							AS	Numero,
				'SplitGrupoTrabajo'							AS	SplitGrupoTrabajo,
				ISNULL(GT.TN_CodGrupoTrabajo, @L_ValorDefectoGrupoTrabajo)				AS	Codigo,
				ISNULL(GT.TC_Descripcion, @L_DescDefectoGrupoTrabajo)					AS	Descripcion,
				'SplitContextoCrea'							AS	SplitContextoCrea,
				CC.TC_CodContexto							AS	Codigo,
				CC.TC_Descripcion							AS	Descripcion,
				'SplitFormatoArchivo'						AS	SplitFormatoArchivo,
				ISNULL(	
					B.TN_CodFormatoArchivo, 
					(SELECT Codigo FROM @SinFormatoArchivo)
				)											AS	Codigo,
				ISNULL(	
					B.TC_Descripcion, 
					(SELECT Descripcion FROM @SinFormatoArchivo)
				)											AS	Descripcion,
				'SplitUsuarioCrea'							AS	SplitUsuarioCrea,
				F.TC_UsuarioRed								AS	UsuarioRed,
				F.TC_Nombre									AS	Nombre,
				F.TC_PrimerApellido							AS	PrimerApellido,
				F.TC_SegundoApellido						AS	SegundoApellido,
				'SplitEstadoArchivo'						AS	SplitEstadoArchivo,
				CASE
					WHEN D.CODESTACO = 1 THEN '1' --PRIVADO
					WHEN D.CODESTACO = 2 THEN '2' --BORRADOR
					WHEN D.CODESTACO = 3 THEN '3' --BORRADOR PéBLICO
					WHEN D.CODESTACO = 5 THEN '4' --TERMINADO
					ELSE @L_CodigoEstado		  --NO SE CUENTA CON ESTE ESTADO ASÖ QUE SE ASIGNA EL DEFECTO QUE SE DEFINA ARRIBA
				END											AS	CodigoEstadoArchivoExpediente,
				'SplitFormatoJuridico'						AS	SplitFormatoJuridico,
				J.TC_CodFormatoJuridico						AS	CodFormatoJuridico
	FROM		@TBLArchivos						A
	OUTER APPLY (
					SELECT	TOP 1
							TN_CodFormatoArchivo, 
							TC_Descripcion
					FROM	Catalogo.FormatoArchivo	WITH(NOLOCK)
					WHERE	TC_Extensiones			LIKE	'%'+reverse(left(reverse(A.nombre),charindex('.',reverse(A.nombre))-1))+'%'
	)											B	
	INNER JOIN	@DACO							D
	ON			D.IDACO							=	A.idaco
	CROSS APPLY (
					SELECT						CASE
													WHEN EXISTS(
															SELECT	TC_UsuarioRed
															FROM	Catalogo.Funcionario WITH(NOLOCK)
															WHERE	TC_UsuarioRed = D.IDUSU
													)
													THEN	1
													ELSE	0
												END	AS	ExisteUsuarioGestion
	)											C
	LEFT JOIN	Catalogo.Contexto				CC	WITH(NOLOCK)
	ON			CC.TC_CodContexto				=	(	
														CASE
															WHEN	ExisteUsuarioGestion = 1
															THEN	D.CODDEJ	COLLATE DATABASE_DEFAULT
															ELSE	@L_ContextoCreaXDefecto
														END
													)	
	LEFT JOIN	Catalogo.Funcionario			F	WITH(NOLOCK)
	ON			F.TC_UsuarioRed					=	(	
														CASE
															WHEN	ExisteUsuarioGestion = 1
															THEN	D.IDUSU
															ELSE	@L_UsuarioCrea
														END
													)
	LEFT JOIN	Catalogo.GrupoTrabajo			GT 	WITH(NOLOCK)
	ON			GT.TN_CodGrupoTrabajo			=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'GrupoTrabajo', D.CODGT,0,0))
	AND			GT.TC_CodContexto				=	@L_ContextoCreaXDefecto
	CROSS APPLY (
					SELECT						CASE
													WHEN EXISTS(
															SELECT	IDACODOCUNOT
															FROM	@DACONOT
															WHERE	IDACODOCUNOT = A.idaco
													)
													THEN	1
													ELSE	0
												END	AS	ExisteNotificacion
	)											H
	LEFT JOIN	@DACODOC						I
	ON			I.IDACO							=	A.idaco
	LEFT JOIN	Catalogo.FormatoJuridico		J	WITH(NOLOCK)
	ON			J.TC_CodFormatoJuridico			=	Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'FormatoJuridico', I.CODMOD,0,0)
	WHERE		D.CODACO						<>	'INDOMULT'
END
SET ANSI_NULLS ON
GO
