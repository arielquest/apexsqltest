SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================================================================================================
-- Versión:			    <1.0>
-- Autor:				<Aarón Ríos Retana>
-- Fecha Creación:		<18/01/2023>
-- Descripcion:			<Consulta para determinar expediente inventariados y no inventariados DE UN CONTEXTO.>
-- Modificación:		<Gabriel Leandro Arnáez Hodgson><31/7/2023><Se agrega validación para obtener el movimiento circulante más reciente omitiendo los nulos>
-- Modificación:		<Gabriel Leandro Arnáez Hodgson><31/7/2023><Se hace una reestructuración de la consulta para que el SP dure menos tiempo ejecutandose>
-- Modificación:		<Gabriel Leandro Arnáez Hodgson><07/11/2023><Se cambia el tipo de dato de CodigoUbicacion de la tabla temporal @InventariadoContexto a INT>
-- Modificación:		<Ronny Ramírez R.><08/05/2024><Se cambia el tipo de dato de TotalRegistros de la tabla temporal @InventariadoContexto a INT, para que no haya problemas
--						de conversión de datos al pasarse a la entidad que maneja el API que es INT, pues en cada paginación producía un total distinto>
-- ============================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarInventariadoContexto]
	@CodigoInventariado			UNIQUEIDENTIFIER,
	@SinInventariar				BIT,
	@NumeroPagina				INT,
	@CantidadRegistros			INT,
	@Contexto					VARCHAR(4),
	@ClasesExpedientes			Expediente.ListaClaseExpedienteType	READONLY,
	@AsuntosLegajos				Expediente.ListaAsuntoLegajoType	READONLY
AS

BEGIN

	DECLARE	@L_CodigoInventariado		UNIQUEIDENTIFIER	=	@CodigoInventariado,
			@L_SinInventariar			BIT					=	@SinInventariar,
			@L_NumeroPagina				INT					=	@NumeroPagina,
			@L_CantidadRegistros		INT					=	@CantidadRegistros,
			@L_Contexto					VARCHAR(4)			=	@Contexto,
			@L_TotalRegistros			INT				=	0

	--Declaramos la tabla temporal donde se cargaran los expedientes y los legajos 
	Declare @InventariadoContexto AS TABLE
	(
		NumeroExpediente				VARCHAR (14)			NULL	,
		CodigoLegajo					UNIQUEIDENTIFIER		NULL	,
		CodigoUltimoInventario			UNIQUEIDENTIFIER		NULL	,
		NombreUltimoInventariado		VARCHAR(20)				NULL	,
		FechaInicioUltimoInventariado	DATETIME				NULL	,
		FechaAplicacion					DATETIME				NULL	,
		UsuarioRed						VARCHAR(30)				NULL	,
		PersonaUsuariaQueAplica			VARCHAR(255)			NULL	,
		FechaEntrada					DATETIME				NULL	,
		CodigoClase						INT								,
		DescripcionClase				VARCHAR(200)			NULL	,
		CodigoAsunto					INT								,
		DescripcionAsunto				VARCHAR(100)			NULL	,
		CodigoProceso					SMALLINT				NULL	,
		DescripcionProceso				VARCHAR(100)			NULL	,
		CodigoEstado					INT								,
		DescripcionEstado				VARCHAR(150)			NULL	,
		CodigoUbicacion					INT						,
		DescripcionUbicacion			VARCHAR(150)			NULL	,
		TotalRegistros					INT							
	);

	--Declaramos la tabla temporal donde se cargaran los expedientes y legajos activos 
	DECLARE @Activos TABLE(
        NumeroExpediente       			VARCHAR(14)           	NOT NULL,
        CodigoLegajo					UNIQUEIDENTIFIER		NULL	,
		CodigoEstado					INT								,
		CodigoContexto					VARCHAR(4)				NOT NULL,
		CodigoUltimoInventario			UNIQUEIDENTIFIER		NULL	,
		CodigoClase						INT								,
		CodigoAsunto					INT								,
		FechaEntrada					DATETIME				NULL	,
		UsuarioRed						VARCHAR(30)				NULL	,
		FechaAplicacion					DATETIME				NULL	,
		CodigoProceso					SMALLINT				NULL	
    );

	DECLARE @ActivosTotales TABLE(
        NumeroExpediente       			VARCHAR(14)           	NOT NULL,
        CodigoLegajo					UNIQUEIDENTIFIER		NULL	,
		CodigoEstado					INT								,
		CodigoContexto					VARCHAR(4)				NOT NULL,
		CodigoUltimoInventario			UNIQUEIDENTIFIER		NULL	,
		CodigoClase						INT								,
		CodigoAsunto					INT								,
		FechaEntrada					DATETIME				NULL	,
		UsuarioRed						VARCHAR(30)				NULL	,
		FechaAplicacion					DATETIME				NULL	,
		CodigoProceso					SMALLINT				NULL	
    );


	--Realizamos la consulta de los expedientes activos dentro del contexto 
	IF ((SELECT COUNT(*) FROM @ClasesExpedientes)  > 0)
	BEGIN

		IF (@L_SinInventariar = 0)
		BEGIN
   			INSERT INTO @ActivosTotales
   			(
   				NumeroExpediente, CodigoEstado, CodigoContexto
   			)
			SELECT TC_NumeroExpediente,TN_CodEstado,TC_CodContexto FROM
			(
				SELECT		MC.TC_NumeroExpediente, MC.TC_Movimiento, MC.TN_CodEstado, MC.TC_CodContexto, ROW_NUMBER() OVER (PARTITION BY MC.TC_NumeroExpediente ORDER BY MC.TF_Fecha DESC) AS RN
   				FROM		Historico.ExpedienteMovimientoCirculante MC WITH	(NOLOCK)
				INNER JOIN  Expediente.ExpedienteDetalle ED WITH (NOLOCK)
				ON			MC.TC_NumeroExpediente = ED.TC_NumeroExpediente AND ED.TC_CodContexto = MC.TC_CodContexto AND ED.TN_CodClase IN	(SELECT TN_CodClase FROM @ClasesExpedientes) 
				WHERE		MC.TC_CodContexto = @L_Contexto
				AND			TC_Movimiento IS NOT NULL
				AND		EXISTS 
					( select * from
						(SELECT TOP 1 
							HINV.TU_CodPeriodo
							FROM			Historico.HistoricoInventariado				HINV	WITH	(NOLOCK)
							WHERE			HINV.TC_NumeroExpediente					=		MC.TC_NumeroExpediente
							AND				HINV.TU_CodLegajo							IS		NULL
							ORDER BY		HINV.TF_FechaAplicacion						DESC
						) codP
					where codP.TU_CodPeriodo = @L_CodigoInventariado
					)
			) AS A
   			WHERE
			A.RN = 1 
			AND
			A.TC_Movimiento <> 'F'

		END
		ELSE
		BEGIN
			INSERT INTO @ActivosTotales
   			(
   				NumeroExpediente, CodigoEstado, CodigoContexto
   			)
			SELECT TC_NumeroExpediente,TN_CodEstado,TC_CodContexto FROM
			(
				SELECT	MC.TC_NumeroExpediente, MC.TC_Movimiento, MC.TN_CodEstado, MC.TC_CodContexto, ROW_NUMBER() OVER (PARTITION BY MC.TC_NumeroExpediente ORDER BY MC.TF_Fecha DESC) AS RN
   				FROM	Historico.ExpedienteMovimientoCirculante MC WITH	(NOLOCK)
				INNER JOIN  Expediente.ExpedienteDetalle ED WITH (NOLOCK)
				ON			MC.TC_NumeroExpediente = ED.TC_NumeroExpediente AND ED.TC_CodContexto = MC.TC_CodContexto AND ED.TN_CodClase IN	(SELECT TN_CodClase FROM @ClasesExpedientes)
				WHERE	MC.TC_CodContexto = @L_Contexto
				AND		TC_Movimiento IS NOT NULL
				AND (
						EXISTS 
						( select * from
							(SELECT TOP 1 
								HINV.TU_CodPeriodo
								FROM			Historico.HistoricoInventariado				HINV	WITH	(NOLOCK)
								WHERE			HINV.TC_NumeroExpediente					=		MC.TC_NumeroExpediente
								AND				HINV.TU_CodLegajo							IS		NULL
								ORDER BY		HINV.TF_FechaAplicacion						DESC
							) codP
						where codP.TU_CodPeriodo <> @L_CodigoInventariado
						)
						OR
						NOT EXISTS
						(
							SELECT
							HINV.TU_CodPeriodo
							FROM			Historico.HistoricoInventariado				HINV	WITH	(NOLOCK)
							WHERE			HINV.TC_NumeroExpediente					=		MC.TC_NumeroExpediente
							AND				HINV.TU_CodLegajo							IS		NULL
						)
					)
			) AS A
   			WHERE
			A.RN = 1 
			AND
			A.TC_Movimiento <> 'F'
		END
	END

	--Realizamos la consulta de los legajos activos dentro del contexto 
	IF ((SELECT COUNT(*) FROM @AsuntosLegajos)  > 0)
	BEGIN
		IF (@L_SinInventariar = 0)
		BEGIN
			--Realizamos la consulta de los legajos activos dentro del contexto 
			INSERT INTO @ActivosTotales
   			(
   				NumeroExpediente, CodigoEstado, CodigoContexto
   			)
			SELECT TC_NumeroExpediente,TN_CodEstado,TC_CodContexto FROM
			(
				SELECT		MC.TC_NumeroExpediente, MC.TC_Movimiento, MC.TN_CodEstado, MC.TC_CodContexto, ROW_NUMBER() OVER (PARTITION BY MC.TC_NumeroExpediente ORDER BY MC.TF_Fecha DESC) AS RN
   				FROM		Historico.LegajoMovimientoCirculante MC WITH	(NOLOCK)
				INNER JOIN  Expediente.LegajoDetalle ED WITH (NOLOCK)
				ON			MC.TU_CodLegajo = ED.TU_CodLegajo AND ED.TC_CodContexto = MC.TC_CodContexto AND ED.TN_CodAsunto IN	(SELECT TN_CodAsunto FROM @AsuntosLegajos) 
				WHERE		MC.TC_CodContexto = @L_Contexto
				AND			TC_Movimiento IS NOT NULL
				AND		EXISTS 
					( select * from
						(SELECT TOP 1 
							HINV.TU_CodPeriodo
							FROM			Historico.HistoricoInventariado				HINV	WITH	(NOLOCK)
							WHERE			HINV.TC_NumeroExpediente					=		MC.TC_NumeroExpediente
							AND				HINV.TU_CodLegajo							=		MC.TU_CodLegajo
							ORDER BY		HINV.TF_FechaAplicacion						DESC
						) codP
					where codP.TU_CodPeriodo = @L_CodigoInventariado
					)
			) AS A
   			WHERE
			A.RN = 1 
			AND
			A.TC_Movimiento <> 'F'
		END
		ELSE
		BEGIN
			INSERT INTO @ActivosTotales
   			(
   				NumeroExpediente, CodigoEstado, CodigoContexto
   			)
			SELECT TC_NumeroExpediente,TN_CodEstado,TC_CodContexto FROM
			(
				SELECT	MC.TC_NumeroExpediente, MC.TC_Movimiento, MC.TN_CodEstado, MC.TC_CodContexto, ROW_NUMBER() OVER (PARTITION BY MC.TC_NumeroExpediente ORDER BY MC.TF_Fecha DESC) AS RN
   				FROM	Historico.LegajoMovimientoCirculante MC WITH	(NOLOCK)
				INNER JOIN  Expediente.LegajoDetalle ED WITH (NOLOCK)
				ON			MC.TU_CodLegajo = ED.TU_CodLegajo AND ED.TC_CodContexto = MC.TC_CodContexto AND ED.TN_CodAsunto IN	(SELECT TN_CodAsunto FROM @AsuntosLegajos)
				WHERE	MC.TC_CodContexto = @L_Contexto
				AND		TC_Movimiento IS NOT NULL
				AND (
						EXISTS 
						( select * from
							(SELECT TOP 1 
								HINV.TU_CodPeriodo
								FROM			Historico.HistoricoInventariado				HINV	WITH	(NOLOCK)
								WHERE			HINV.TC_NumeroExpediente					=		MC.TC_NumeroExpediente
								AND				HINV.TU_CodLegajo							=		MC.TU_CodLegajo
								ORDER BY		HINV.TF_FechaAplicacion						DESC
							) codP
						where codP.TU_CodPeriodo <> @L_CodigoInventariado
						)
						OR
						NOT EXISTS
						(
							SELECT
							HINV.TU_CodPeriodo
							FROM			Historico.HistoricoInventariado				HINV	WITH	(NOLOCK)
							WHERE			HINV.TC_NumeroExpediente					=		MC.TC_NumeroExpediente
							AND				HINV.TU_CodLegajo							=		MC.TU_CodLegajo
						)
					)
			) AS A
   			WHERE
			A.RN = 1 
			AND
			A.TC_Movimiento <> 'F'
		END
			
	END

		--Se obtiene el ultimo inventario y el usuario que lo aplico de cada uno de los legajos 
	UPDATE	A
	SET		A.CodigoUltimoInventario	=	HINV.TU_CodPeriodo,
			A.UsuarioRed				=	HINV.TC_UsuarioRed,
			A.FechaAplicacion			=	HINV.TF_FechaAplicacion	
	FROM 
	@Activos	AS A
	OUTER APPLY 
				(SELECT TOP 1 
								HINV.TU_CodPeriodo,
								HINV.TC_UsuarioRed,
								HINV.TF_FechaAplicacion	
				FROM			Historico.HistoricoInventariado				HINV	WITH	(NOLOCK)
				WHERE			HINV.TC_NumeroExpediente					=		A.NumeroExpediente
				AND				HINV.TU_CodLegajo							=		A.CodigoLegajo
				ORDER BY		HINV.TF_FechaAplicacion						DESC)	AS HINV
	WHERE	A.CodigoLegajo IS NOT NULL



	--Se obtiene el ultimo inventario y el usuario que lo aplico de cada uno de los expedientes 
	UPDATE	A
	SET		A.CodigoUltimoInventario	=	HINV.TU_CodPeriodo,
			A.UsuarioRed				=	HINV.TC_UsuarioRed,
			A.FechaAplicacion			=	HINV.TF_FechaAplicacion
	FROM 
	@ActivosTotales AS A
	OUTER APPLY 
				(SELECT TOP 1 
								HINV.TU_CodPeriodo,
								HINV.TC_UsuarioRed,
								HINV.TF_FechaAplicacion	
				FROM			Historico.HistoricoInventariado				HINV	WITH	(NOLOCK)
				WHERE			HINV.TC_NumeroExpediente					=		A.NumeroExpediente
				AND				HINV.TU_CodLegajo							IS		NULL
				ORDER BY		HINV.TF_FechaAplicacion						DESC)	AS HINV
	WHERE	A.CodigoLegajo IS NULL

	-- Se obtiene la cantidad total de registros 
	SELECT  @L_TotalRegistros = COUNT(*) FROM @ActivosTotales;

	-- Select final de la consulta 
	INSERT INTO @Activos
	SELECT 
		NumeroExpediente       	,
        CodigoLegajo			,
		CodigoEstado			,
		CodigoContexto			,
		CodigoUltimoInventario	,
		CodigoClase				,
		CodigoAsunto			,
		FechaEntrada			,
		UsuarioRed				,
		FechaAplicacion			,
		CodigoProceso			
	FROM @ActivosTotales	INVCON
	ORDER BY			INVCON.FechaAplicacion	DESC
	OFFSET				(@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS
	FETCH NEXT			@L_CantidadRegistros ROWS ONLY


	--Se obtiene la clase, fecha de entrada y proceso de los expediente activos
	UPDATE	A
	SET		A.CodigoClase	=	ED.TN_CodClase,
			A.FechaEntrada	=	ED.TF_Entrada,
			A.CodigoProceso	=	ED.TN_CodProceso			
	FROM
	@Activos									AS	A
	INNER JOIN	Expediente.ExpedienteDetalle	AS	ED WITH	(NOLOCK)
	ON			A.NumeroExpediente				=	ED.TC_NumeroExpediente
	AND			A.CodigoContexto				=	ED.TC_CodContexto
	WHERE		A.CodigoLegajo					IS	NULL

	--Se obtiene el asunto, fecha de entrada y proceso de los legajos activos 
	UPDATE	A
	SET		A.CodigoAsunto	=	LED.TN_CodAsunto,
			A.FechaEntrada	=	LED.TF_Entrada,
			A.CodigoProceso =	LED.TN_CodProceso
	FROM
	@Activos									AS	A
	INNER JOIN	Expediente.LegajoDetalle		AS	LED WITH	(NOLOCK)
	ON			A.CodigoLegajo					=	LED.TU_CodLegajo
	AND			A.CodigoContexto				=	LED.TC_CodContexto
	WHERE		A.CodigoLegajo					IS	NOT	NULL

	--Se realiza la consulta de los expedientes o legajos inventariados
	IF(@L_SinInventariar = 0)
	BEGIN
		--Se cargan los expedientes y legajos inventariados a la tabla temporal si coinciden las clases y asuntos 
		INSERT INTO @InventariadoContexto
		(NumeroExpediente,
		CodigoLegajo,
		CodigoAsunto,
		CodigoClase,
		CodigoUltimoInventario,
		CodigoEstado,
		FechaEntrada,
		UsuarioRed,
		FechaAplicacion,
		CodigoProceso)
		SELECT 
		A.NumeroExpediente,
		A.CodigoLegajo,
		A.CodigoAsunto,
		A.CodigoClase,
		A.CodigoUltimoInventario,
		A.CodigoEstado,
		A.FechaEntrada,
		A.UsuarioRed,
		A.FechaAplicacion,
		A.CodigoProceso
		FROM 
		@Activos	AS	A

	END
	ELSE
	BEGIN
		--Se cargan los expedientes y legajos inventariados a la tabla temporal si coinciden las clases y asuntos 
		INSERT INTO @InventariadoContexto
		(NumeroExpediente,
		CodigoLegajo,
		CodigoAsunto,
		CodigoClase,
		CodigoUltimoInventario,
		CodigoEstado,
		FechaEntrada,
		UsuarioRed,
		FechaAplicacion,
		CodigoProceso)
		SELECT 
		A.NumeroExpediente,
		A.CodigoLegajo,
		A.CodigoAsunto,
		A.CodigoClase,
		A.CodigoUltimoInventario,
		A.CodigoEstado,
		A.FechaEntrada,
		A.UsuarioRed,
		A.FechaAplicacion,
		A.CodigoProceso
		FROM 
		@Activos	AS	A
	END

	--Se obtienen la descripcion de las clases 
	UPDATE IV
	SET		DescripcionClase	=	cla.TC_Descripcion
		
	FROM @InventariadoContexto	AS	IV
	INNER JOIN	Catalogo.Clase	AS	CLA WITH	(NOLOCK)
	ON			CLA.TN_CodClase	=	IV.CodigoClase

	--Se obtienen la descripcion de los asuntos  
	UPDATE IV
	SET		DescripcionAsunto	=	ASU.TC_Descripcion
		
	FROM @InventariadoContexto	AS	IV
	INNER JOIN	Catalogo.Asunto	AS	ASU WITH	(NOLOCK)
	ON			ASU.TN_CodAsunto	=	IV.CodigoAsunto

	--Se obtienen la descripcion de los estados 
	UPDATE IV
	SET		DescripcionEstado	=	EST.TC_Descripcion
		
	FROM @InventariadoContexto	AS	IV
	INNER JOIN	Catalogo.Estado	AS	EST WITH	(NOLOCK)
	ON			EST.TN_CodEstado	=	IV.CodigoEstado

	--Se obtienen la descripcion de los procesos 
	UPDATE IV
	SET		DescripcionProceso	=	PRO.TC_Descripcion
		
	FROM @InventariadoContexto		AS	IV
	INNER JOIN	Catalogo.Proceso	AS	PRO WITH	(NOLOCK)
	ON			PRO.TN_CodProceso	=	IV.CodigoProceso
	
	--Se obtienen el codigo de las ubicaciones de los expedientes 
UPDATE IV
SET        CodigoUbicacion    =    UBI.TN_CodUbicacion
FROM @InventariadoContexto        AS    IV
OUTER APPLY    (
                           SELECT TOP 1    EXPUBI.TN_CodUbicacion
                           FROM            Historico.ExpedienteUbicacion                EXPUBI    WITH(NOLOCK)
                           WHERE            EXPUBI.TC_NumeroExpediente                    =        IV.NumeroExpediente
                           ORDER BY        EXPUBI.TF_FechaUbicacion                        DESC
                       )    AS    UBI
where IV.CodigoLegajo IS NULL

	--Se obtiene el codigo de las ubicaciones de los legajos 
UPDATE IV
SET        CodigoUbicacion    =    UBI.TN_CodUbicacion
FROM @InventariadoContexto        AS    IV
OUTER APPLY    (
                           SELECT TOP 1    LEGUBI.TN_CodUbicacion
                           FROM            Historico.LegajoUbicacion                    LEGUBI    WITH(NOLOCK)
                           WHERE            LEGUBI.TU_CodLegajo                    =        IV.CodigoLegajo
                           ORDER BY        LEGUBI.TF_FechaUbicacion                        DESC
                       )    AS    UBI
where IV.CodigoLegajo IS NOT NULL

	-- Se carga la descripcion de la ubicacion
	UPDATE IV
SET        DescripcionUbicacion    =FUNC.TC_Descripcion
FROM @InventariadoContexto            AS    IV
INNER JOIN    catalogo.Ubicacion    AS    FUNC    WITH    (NOLOCK)
ON    FUNC.TN_CodUbicacion=IV.CodigoUbicacion and FUNC.TC_CodOficina= @L_Contexto
	
	--Se carga el nombre del funcionario 
	UPDATE IV
	SET		PersonaUsuariaQueAplica	=	FUNC.TC_Nombre + ' ' + FUNC.TC_PrimerApellido + ' ' + FUNC.TC_SegundoApellido
	FROM @InventariadoContexto			AS	IV
	INNER JOIN	catalogo.Funcionario	AS	FUNC	WITH	(NOLOCK)
	ON			IV.UsuarioRed			=	FUNC.TC_UsuarioRed

	--Se obtienen el nombre del periodo de inventariado 
	UPDATE IV
	SET		NombreUltimoInventariado		=	PINV.TC_NombrePeriodo,
			FechaInicioUltimoInventariado	=	PINV.TF_Fechainicio
		
	FROM @InventariadoContexto		AS	IV
	INNER JOIN	expediente.PeriodoInventariado	AS	PINV WITH	(NOLOCK)
	ON			PINV.TU_CodPeriodo	=	IV.CodigoUltimoInventario

	-- Select final de la consulta 
	SELECT 
		NumeroExpediente,
		CodigoLegajo,
		NombreUltimoInventariado,
		FechaAplicacion,
		PersonaUsuariaQueAplica,
		FechaEntrada,
		DescripcionClase,
		DescripcionAsunto,
		DescripcionProceso,
		DescripcionEstado,
		DescripcionUbicacion,
		UsuarioRed								AS NombreDeUsuarioPersonaQueAplica,
		FechaInicioUltimoInventariado,
		@L_TotalRegistros AS TotalRegistros
	FROM @InventariadoContexto	INVCON
	ORDER BY			INVCON.FechaAplicacion	DESC, INVCON.DescripcionUbicacion DESC

END
GO
