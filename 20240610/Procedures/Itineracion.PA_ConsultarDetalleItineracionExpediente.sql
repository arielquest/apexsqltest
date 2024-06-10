SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro, Isaac Dobles Mata>
-- Fecha de creación:		<15/12/2020>
-- Descripción :			<Permite consultar el detalle de una itineración de tipo expediente proveniente de Gestión>
-- =============================================================================================================================================================================
-- Modificación:			<04/01/2021> <Jonathan Aguilar Navarro> <Se cambian los campos codpro y codclas para las tablas correspondientes (Proceso y Clase)>
-- Modificación:			<05/02/2021> <Jonathan Aguialr Navarro> <Se agrega a la consulta la materia y el tipo de oficina del contexto.>
-- Modificación:			<11/02/2021> <Isaac Dobles Mata> <Se modifica mapeo de catálogos y se agrega carpeta proveniente de Gestión.>
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<22/03/2021><Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:			<08/04/2021> <Karol Jiménez S.> <Se agrega consulta del tipo de oficina y materia asociada al contexto creación del expediente>
-- Modificación:			<12/05/2021> <Jonathan Aguilar Navarro> <Se asigna valor a la variable @L_ContextoDestino ya que no se estaba haciendo>
-- Modificación:			<01/06/2021> <Richard Zúñiga Segura> <Se agregan los valores relacionados con los datos adicionales y que se guardan en el Expediente.Expediente>
-- Modificación:			<11/06/2021> <Karol Jiménez S.> <Se ajusta consulta de la cuantia, dado que el campo en Gestión está en minúscula, y se consulta en mayúscula al XML,
--							pero es case sensitive>
-- Modificación:			<21/06/2021> <Karol Jiménez S.> <Se ajusta para evitar productos cartesianos al buscar equivalencias>
-- Modificación:			<25/06/2021> <Karol Jiménez S.> <Se cambia campos proceso y clase para que se mapeen de los campos DCAR.CODPRO y DCAR.CODCLAS, respectivamente;
--							dado que en algún momento se volvieron a cambiar en migra dichos catálogos a como están en Gestión. Ajuste valor por defecto de clase y proceso. >
-- Modificación:			<01/07/2021> <Ronny Ramírez R.> <Se agranda el campo Clase de 5 a 9 de la Tabla temporal @Result, pues no cabía el CODCLAS de tamaño 9>
-- Modificación:			<23/07/2021> <Ronny Ramírez R.> <Se aplica corrección en mapeo de campo FECHECHO>
-- Modificación:			<23/07/2021> <Ronny Ramírez R.> <Se cambia mapeo de Proceso para que se asigne tomando el cuenta el catálogo ClaseProcesoTipoOficinaMateria en lugar
--							de ClaseProceso>
-- Modificación:			<18/08/2021> <Ronny Ramírez R.> <Se reincorporan los cambios de Richard del 01/06/2021, relacionados a datos adicionales>
-- Modificación:			<29/10/2021> <Luis Alonso Leiva Tames> <Se aplica la funcion para los montos de aguinaldo y monto salario escolar>
-- Modificación:			<24/02/2023> <Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Prioridad, TipoCuantia, Moneda,
--							Provincia, Delito, Clase, Fase y Proceso)>
-- Modificación:			<10/10/2023> <Karol Jiménez S.> <PBI 347803 Se agrega a la consulta el campo EmbargosFisicos el cual se obtiene de DCAR.EMBARGOF>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarDetalleItineracionExpediente]
	@CodItineracion Uniqueidentifier = null
AS 

BEGIN
	--Variables 
	DECLARE	@L_CodItineracion			Uniqueidentifier		= @CodItineracion,
			@L_ContextoDestino			varchar(4);
	SELECT	@L_ContextoDestino			= RECIPIENTADDRESS FROM ItineracionesSIAGPJ.dbo.MESSAGES WITH(NOLOCK) WHERE ID = @L_CodItineracion;

	--Tabla temporal para registros
	DECLARE @Result TABLE	(
			--Expediente
			NumeroExpediente		char(14),
			EmbargosFisicos			bit,
			FechaInicio				datetime2(7),
			CodigoDelito			varchar(255),
			Confidencial			bit,
			CodigoContexto			varchar(4),
			TipoOficina				smallint,
			MateriaContexto			varchar(2),
			ContextoCreacion		varchar(4),
			TipoOficinaCreacion		smallint,
			MateriaContextoCreacion	varchar(2),
			Descripcion				varchar(255),
			CasoRelevante			bit,
			Prioridad				varchar(9),
			TipoCuantia				varchar(2),
			TipoMoneda				varchar(3),
			Cuantia					decimal(12,2),
			TipoViabilidad			varchar(255),
			Provincia				varchar(255),
			Canton					varchar(255),
			Distrito				varchar(255),
			Barrio					varchar(255),
			Señas					varchar(255),
			FechaHechos				varchar(255),
			MontoAguinaldo			varchar(255),
			DescripcionHechos		varchar(255),
			MontoSalarioEscolar		varchar(255),
			--ExpedienteDetalle
			FechaEntrada			datetime2(7),
			Clase					varchar(9),
			Proceso					varchar(9),
			Fase					varchar(6),
			ContextoProcedencia		varchar(4),
			GrupoTrabajo			varchar(11),
			Habilitado				bit,
			DocumentosFisicos		varchar(1),
			TestimonioPiezas		char(14),
			Carpeta					varchar(14)
	)

	INSERT INTO @Result
	(
		--Expediente
		NumeroExpediente,
		EmbargosFisicos,
		FechaInicio,
		CodigoDelito,
		Confidencial,
		CodigoContexto,
		ContextoCreacion,
		TipoOficinaCreacion,
		MateriaContextoCreacion,
		Descripcion,
		CasoRelevante,
		Prioridad,
		TipoCuantia,
		TipoMoneda,
		Cuantia,					
		TipoViabilidad,		
		Provincia,				
		Canton,					
		Distrito,				
		Barrio,					
		Señas,					
		FechaHechos,
		MontoAguinaldo,
		DescripcionHechos,
		MontoSalarioEscolar,
		--ExpedienteDetalle
		FechaEntrada,			
		Clase,					
		Proceso,					
		Fase,					
		ContextoProcedencia,	
		GrupoTrabajo,			
		Habilitado,				
		DocumentosFisicos,		
		TestimonioPiezas,
		Carpeta
	)
		-- Detalle primera itineración de Gestión (puede que salgan repeticiones por el catálogo de Clase)
	SELECT		TOP 1
				X.VALUE.value('(/*/DCAR/NUE)[1]','CHAR(14)'),
				X.VALUE.value('(/*/DCAR/EMBARGOF)[1]','BIT'),
				TRY_CONVERT(DATETIME2(3),X.VALUE.value('(/*/DNUE/FEININUE)[1]','VARCHAR(35)')),
				(	SELECT		TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
					FROM		ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
					CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)')			AS	X(Y)
					WHERE		T.ID									=	A.ID
					AND			X.Y.value('(CODMASD)[1]', 'varchar(9)') =	'CODDELEST'),	
				CASE 
					WHEN EXISTS(
						SELECT		T.*
						FROM		ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)')			AS X(Y)
						WHERE		T.ID									= A.ID
						AND			X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'CONFIDENC'
						AND			X.Y.value('(VALOR)[1]','VARCHAR(255)')	IN ( -- Se busca valores verdaderos para campo confidencial en tabla de migraciones
																				SELECT	TC_ValoresActuales 
																				FROM	Migracion.ValoresDefecto	WITH(NOLOCK)
																				WHERE	TC_NombreCampo				=	'TB_Confidencial'
																				AND		TC_ValorPorDefecto			=	1
																			) 
					)
					THEN	1
					ELSE	0
				END,
				A.RECIPIENTADDRESS	COLLATE DATABASE_DEFAULT,
				A.SENDERADDRESS		COLLATE DATABASE_DEFAULT,
				OC.TN_CodTipoOficina,
				CC.TC_CodMateria,
				X.VALUE.value('(/*/DCAR/DESCRIP)[1]','VARCHAR(255)'),
				CASE
					WHEN
						(X.VALUE.value('(/*/DCAR/CASORELEVANTE)[1]','VARCHAR(1)') = 'S')
					THEN 1
					ELSE 0
				END,
				X.VALUE.value('(/*/DCAR/CODPRI)[1]','VARCHAR(9)'),
				X.VALUE.value('(/*/DCAR/CODCUANTIA)[1]','VARCHAR(2)'),
				X.VALUE.value('(/*/DCAR/CODMON)[1]','VARCHAR(3)'),
				X.VALUE.value('(/*/DCAR/cuantia)[1]','NUMERIC(12,2)'),
				NULL,
				(	SELECT TOP	1 X.Y.value('(VALOR)[1]', 'varchar(255)')
					FROM		ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
					CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)')			AS	X(Y)
					WHERE		T.ID									=	A.ID
					AND			X.Y.value('(CODMASD)[1]', 'varchar(9)') =	'PROVH'),
				(	SELECT TOP	1 X.Y.value('(VALOR)[1]', 'varchar(255)')
					FROM		ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
					CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)')			AS	X(Y)
					WHERE		T.ID									=	A.ID
					AND			X.Y.value('(CODMASD)[1]', 'varchar(9)')	=	'CANTH'),
				(	SELECT TOP	1 X.Y.value('(VALOR)[1]', 'varchar(255)')
					FROM		ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
					CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)')			AS	X(Y)
					WHERE		T.ID									=	A.ID
					AND			X.Y.value('(CODMASD)[1]', 'varchar(9)') =	'DISTH'),
				(	SELECT TOP	1 X.Y.value('(VALOR)[1]', 'varchar(255)')
					FROM		ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
					CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)')			AS	X(Y)
					WHERE		T.ID									=	A.ID
					AND			X.Y.value('(CODMASD)[1]', 'varchar(9)') =	'BARRH'),
				(	SELECT TOP	1 X.Y.value('(VALOR)[1]', 'varchar(255)')
					FROM		ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
					CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)')			AS	X(Y)
					WHERE		T.ID									=	A.ID
					AND			X.Y.value('(CODMASD)[1]', 'varchar(9)') =	'CODLUGAR'),
				(	SELECT TOP	1 TRY_CONVERT(DATETIME2(3), REPLACE(X.Y.value('(VALOR)[1]', 'varchar(255)'),'.',''), 103)
					FROM		ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
					CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)')			AS	X(Y)
					WHERE		T.ID									=	A.ID
					AND			X.Y.value('(CODMASD)[1]', 'varchar(9)') =	'FECHECHO'),
				(	SELECT TOP	1 X.Y.value('(VALOR)[1]', 'varchar(255)')
					FROM		ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
					CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)')			AS	X(Y)
					WHERE		T.ID									=	A.ID
					AND			X.Y.value('(CODMASD)[1]', 'varchar(9)') =	'AGUINAL'),
				(	SELECT TOP	1 X.Y.value('(VALOR)[1]', 'varchar(255)')
					FROM		ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
					CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)')			AS	X(Y)
					WHERE		T.ID									=	A.ID
					AND			X.Y.value('(CODMASD)[1]', 'varchar(9)') =	'DESCHEC'),
				(	SELECT TOP	1 X.Y.value('(VALOR)[1]', 'varchar(255)')
					FROM		ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
					CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)')			AS	X(Y)
					WHERE		T.ID									=	A.ID
					AND			X.Y.value('(CODMASD)[1]', 'varchar(9)') =	'SALESCO'),
				GETDATE(),
				X.VALUE.value('(/*/DCAR/CODCLAS)[1]','VARCHAR(9)'),
				X.VALUE.value('(/*/DCAR/CODPRO)[1]','VARCHAR(5)'),
				X.VALUE.value('(/*/DCAR/CODFAS)[1]','VARCHAR(6)'),
				A.SENDERADDRESS		COLLATE DATABASE_DEFAULT,
				X.VALUE.value('(/*/DCAR/CODGT)[1]','VARCHAR(11)'),
				1,--CONSULTAR CON NEGOCIO
				X.VALUE.value('(/*/DCAR/ESELECTRONICO)[1]','BIT'),
				NULL,
				X.VALUE.value('(/*/DCAR/CARPETA)[1]','VARCHAR(14)')
	FROM		ItineracionesSIAGPJ.dbo.MESSAGES		A 	WITH(NOLOCK)	
	INNER JOIN	ItineracionesSIAGPJ.dbo.ATTACHMENTS 	X	WITH(NOLOCK)
	ON			X.ID									=	A.ID
	LEFT JOIN	Catalogo.Contexto						CC	WITH(NOLOCK) --CONTEXTO CREACION
	ON			CC.TC_CodContexto						=	A.SENDERADDRESS COLLATE DATABASE_DEFAULT
	LEFT JOIN	Catalogo.Oficina						OC	WITH(NOLOCK) 
	ON			OC.TC_CodOficina						=	CC.TC_CodOficina
	WHERE		A.ID									=	@L_CodItineracion

	--Actualiza la prioridad
	DECLARE @Prioridad varchar(9) =  (SELECT Prioridad FROM @Result);
	IF (@Prioridad IS NOT NULL )
	BEGIN
		UPDATE	A
		SET		A.Prioridad =	(SELECT	TOP 1	P.TN_CodPrioridad 
								FROM			Catalogo.Prioridad			P	WITH(NOLOCK)
								INNER JOIN		Catalogo.ContextoPrioridad	CP	WITH(NOLOCK)
								ON				P.TN_CodPrioridad			=	CP.TN_CodPrioridad
								AND				CP.TC_CodContexto			=	@L_ContextoDestino
								WHERE			P.TN_CodPrioridad			=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Prioridad', @Prioridad,0,0))
								ORDER BY 		ISNULL(P.TF_Fin_Vigencia, GETDATE()) DESC)
		FROM @Result A
	END;

	--Actualiza el tipo de cuantia
	DECLARE @TipoCuantia varchar(2) =  (SELECT TipoCuantia FROM @Result);
	IF (@TipoCuantia IS NOT NULL )
	BEGIN
		UPDATE A
		SET A.TipoCuantia = (	SELECT 		C.TN_CodTipoCuantia 
								FROM		Catalogo.TipoCuantia	C	WITH(NOLOCK)	
								WHERE		C.TN_CodTipoCuantia		=	CONVERT(TINYINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'TipoCuantia',@TipoCuantia,0,0))
							)
		FROM @Result A
	END;

	--Actualiza el tipo de moneda
	DECLARE @TipoMoneda varchar(2) =  (SELECT TipoMoneda FROM @Result);
	IF (@TipoMoneda IS NOT NULL )
	BEGIN				
		UPDATE A
		SET A.TipoMoneda = (SELECT			M.TN_CodMoneda 
							FROM			Catalogo.Moneda			M WITH(NOLOCK)
							WHERE			M.TN_CodMoneda		=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Moneda',@TipoMoneda,0,0))
							)
		FROM @Result A
	END;

	--Actualiza el tipo de viabilidad
	BEGIN			
		UPDATE A
		SET A.TipoViabilidad = (SELECT	TOP 1	TV.TN_CodTipoViabilidad
								FROM			Catalogo.TipoViabilidad				TV		WITH(NOLOCK)	
								INNER JOIN		Catalogo.TipoOficinaTipoViabilidad	TOTV	WITH(NOLOCK)	
								ON				TV.TN_CodTipoViabilidad				= TOTV.TN_CodTipoViabilidad
								AND				TOTV.TN_CodTipoOficina				= (	SELECT		TOF.TN_CodTipoOficina
																						FROM		Catalogo.TipoOficina	TOF WITH(NOLOCK)	
																						INNER JOIN	Catalogo.Oficina		OFI WITH(NOLOCK)	
																						ON			OFI.TN_CodTipoOficina	= TOF.TN_CodTipoOficina
																						INNER JOIN	Catalogo.Contexto		C WITH(NOLOCK)	
																						ON			OFI.TC_CodOficina		= C.TC_CodOficina
																						AND			C.TC_CodContexto		= @L_ContextoDestino)
								WHERE			TV.TCT_TIPO_EXPEDIENTE				= A.TipoViabilidad)
		FROM @Result A
	END;

	--Actualiza el lugar de los hechos
	DECLARE 
	@Provincia				varchar(255)	=  (SELECT Provincia FROM @Result),
	@Canton					varchar(255)	=  (SELECT Canton FROM @Result),
	@Distrito				varchar(255)	=  (SELECT Distrito FROM @Result),
	@Barrio					varchar(255)	=  (SELECT Barrio FROM @Result)

	--Provincia
	IF (@Provincia IS NOT NULL )
	BEGIN			
		UPDATE A
		SET A.Provincia = (	SELECT 			TN_CodProvincia
							FROM			Catalogo.Provincia	WITH(NOLOCK)	
							WHERE			TN_CodProvincia		=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Provincia',@Provincia,0,0))
						  )
		FROM @Result A
	END;

	--Canton
	IF (@Provincia IS NOT NULL AND @Canton IS NOT NULL)
	BEGIN
		UPDATE A
		SET A.Canton = (SELECT	TOP 1	TN_CodCanton 
						FROM			Catalogo.Canton WITH(NOLOCK)
						WHERE			CODPROV			=	@Provincia 
						AND				CODCANTON		=	@Canton
						ORDER BY 		ISNULL(TF_Fin_Vigencia, GETDATE()) DESC)
		FROM @Result A
	END;

	--Distrito
	IF (@Provincia IS NOT NULL AND @Canton IS NOT NULL AND @Distrito IS NOT NULL)
	BEGIN
		UPDATE A
		SET A.Distrito = (	SELECT TOP 1	TN_CodDistrito 
							FROM			Catalogo.Distrito	WITH(NOLOCK)
							WHERE			CODPROV				= @Provincia 
							AND				CODCANTON			= @Canton 
							AND				CODDISTRITO			= @Distrito
							ORDER BY 		ISNULL(TF_Fin_Vigencia, GETDATE()) DESC)
		FROM @Result A
	END;

	--Barrio
	IF (@Provincia IS NOT NULL AND @Canton IS NOT NULL AND @Distrito IS NOT NULL AND @Barrio IS NOT NULL)
	BEGIN
		UPDATE A
		SET A.Barrio = (SELECT		TOP 1	TN_CodBarrio 
						FROM				Catalogo.Barrio			WITH(NOLOCK)
						WHERE				CODPROV					= @Provincia 
						AND					CODCANTON				= @Canton 
						AND					CODDISTRITO				= @Distrito
						AND					CODBARRIO				= @Barrio
						ORDER BY 			ISNULL(TF_Fin_Vigencia, GETDATE()) DESC)
		FROM @Result A
	END;

	--Actualiza el delito estadístico	
	DECLARE @Delito varchar(255) =  (SELECT CodigoDelito FROM @Result);
	IF (@Delito IS NOT NULL )
	BEGIN			
		UPDATE A
		SET A.CodigoDelito = (	SELECT			TN_CodDelito 
								FROM			Catalogo.Delito WITH(NOLOCK)
								WHERE			TN_CodDelito	=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Delito', @Delito,0,0))
							  )
		FROM @Result A
	END;

	--Actualiza la clase
	DECLARE @Clase varchar(9) = (SELECT Clase FROM @Result);
	IF (@Clase IS NOT NULL )
	BEGIN
		UPDATE A
		SET A.Clase =					(	
											SELECT	TOP 1	C.TN_CodClase
											FROM			Catalogo.Clase				C	WITH(NOLOCK)
											INNER JOIN		Catalogo.ClaseTipoOficina	CT	WITH(NOLOCK)
											ON				C.TN_CodClase				=	CT.TN_CodClase
											AND				CT.TN_CodTipoOficina		=	(	SELECT		TOF.TN_CodTipoOficina
																								FROM		Catalogo.TipoOficina	TOF	WITH(NOLOCK)
																								INNER JOIN	Catalogo.Oficina		OFI	WITH(NOLOCK)
																								ON			OFI.TN_CodTipoOficina	=	TOF.TN_CodTipoOficina
																								INNER JOIN	Catalogo.Contexto		C	WITH(NOLOCK)
																								ON			OFI.TC_CodOficina		=	C.TC_CodOficina
																								AND			C.TC_CodContexto		=	@L_ContextoDestino)
											AND				CT.TC_CodMateria			=	(	SELECT		M.TC_CodMateria
																								FROM		Catalogo.Materia		M	WITH(NOLOCK)
																								INNER JOIN	Catalogo.Contexto		C	WITH(NOLOCK)
																								ON			C.TC_CodMateria			=	M.TC_CodMateria
																								AND			C.TC_CodContexto		=	@L_ContextoDestino)
											WHERE			C.TN_CodClase				=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Clase', @Clase,0,0))																
											ORDER BY 		ISNULL(C.TF_Fin_Vigencia, GETDATE()) DESC
										)
		FROM @Result A
	END;

	UPDATE	A
	SET		A.Clase = Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_ClasePorDefecto',@L_ContextoDestino)
	FROM	@Result A
	WHERE	A.Clase IS NULL
	

	--Actualiza la fase
	DECLARE @Fase varchar(6) = (SELECT Fase FROM @Result);
	IF (@Fase IS NOT NULL )
	BEGIN

		UPDATE A
		SET A.Fase = (	SELECT		TOP 1 (F.TN_CodFase)
						FROM		Catalogo.Fase					F	WITH(NOLOCK)
						INNER JOIN	Catalogo.MateriaFase			MF	WITH(NOLOCK)
						ON			F.TN_CodFase					=	MF.TN_CodFase
						AND			MF.TN_CodTipoOficina			=	(	SELECT		TOF.TN_CodTipoOficina
																			FROM		Catalogo.TipoOficina	TOF		WITH(NOLOCK)
																			INNER JOIN	Catalogo.Oficina		OFI		WITH(NOLOCK)
																			ON			OFI.TN_CodTipoOficina	=		TOF.TN_CodTipoOficina
																			INNER JOIN	Catalogo.Contexto		C		WITH(NOLOCK)
																			ON			OFI.TC_CodOficina		=		C.TC_CodOficina
																			AND			C.TC_CodContexto		=		A.CodigoContexto)
						AND			MF.TC_CodMateria				=	(	SELECT		M.TC_CodMateria
																			FROM		Catalogo.Materia	M	WITH(NOLOCK)
																			INNER JOIN Catalogo.Contexto	C	WITH(NOLOCK)
																			ON			C.TC_CodMateria		=	M.TC_CodMateria
																			AND			C.TC_CodContexto	=	A.CodigoContexto)
						WHERE		F.TN_CodFase					=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Fase', @Fase,0,0))																
						ORDER BY	ISNULL(F.TF_Fin_Vigencia, GETDATE()) DESC
						)
		FROM @Result A
	END;

	--Actualiza el tipo de la Oficina del Contexto
	UPDATE		A
	SET			A.TipoOficina			=	C.TN_CodTipoOficina
	FROM		@Result					A
	INNER JOIN	Catalogo.Contexto		CO	WITH(NOLOCK)
	ON			Co.TC_CodContexto		=	A.CodigoContexto
	INNER JOIN	Catalogo.Oficina		C	WITH(NOLOCK)
	ON			C.TC_CodOficina			=	CO.TC_CodOficina

	--Actualiza el tipo la Materia del Contexto
	UPDATE		A
	SET			A.MateriaContexto		=	C.TC_CodMateria
	FROM		@Result					A
	INNER JOIN	Catalogo.Contexto		C	WITH(NOLOCK)
	ON			C.TC_CodContexto		=	A.CodigoContexto

	--Actualiza el proceso
	DECLARE @Proceso		VARCHAR(9)	= NULL,
			@TipoOficina	SMALLINT	= NULL,
			@CodClase		INT			= NULL,
			@Materia		VARCHAR(5)	= NULL;

	(SELECT @Proceso = Proceso,
			@TipoOficina = TipoOficina,
			@CodClase = Clase,
			@Materia = MateriaContexto
	FROM @Result);


	IF (@Proceso IS NOT NULL AND @Clase IS NOT NULL )
	BEGIN
		UPDATE A
		SET A.Proceso = (	SELECT			TOP 1 (P.TN_CodProceso)
							FROM			Catalogo.ClaseProcesoTipoOficinaMateria CPTOM WITH(NOLOCK)
							INNER JOIN		Catalogo.Proceso						P	WITH(NOLOCK)
							ON				P.TN_CodProceso							=	CPTOM.TN_CodProceso
							WHERE			P.TN_CodProceso							=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Proceso', @Proceso,0,0))
							AND				CPTOM.TN_CodTipoOficina					=	@TipoOficina
							AND				CPTOM.TN_CodClase						=	@CodClase
							AND				CPTOM.TC_CodMateria						=	@Materia
							ORDER BY 		ISNULL(P.TF_Fin_Vigencia, GETDATE()) DESC
						)
		FROM @Result A
	END;

	UPDATE A
	SET A.Proceso = Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_ProcesoPorDefecto',@L_ContextoDestino)
	FROM @Result A
	WHERE A.Proceso IS NULL

	Select 	
		NumeroExpediente											As			Numero,
		EmbargosFisicos												As			EmbargosFisicos,
		'SplitOtros'												As			SplitOtros,
		FechaInicio													As			FechaInicio,
		CodigoDelito												As			CodigoDelito,
		Confidencial												As			Confidencial,
		CodigoContexto												As			CodigoContexto,
		MateriaContexto												As			MateriaContexto,
		TipoOficina													As			TipoOficina,
		ContextoCreacion											As			ContextoCreacion,	
		TipoOficinaCreacion											As			TipoOficinaCreacion,
		MateriaContextoCreacion										As			MateriaContextoCreacion,
		Descripcion													As			Descripcion,
		CasoRelevante												As			CasoRelevante,
		Prioridad													As			Prioridad,
		TipoCuantia													As			TipoCuantia,
		TipoMoneda													As			TipoMoneda,
		Cuantia														As			Cuantia,					
		TipoViabilidad												As			TipoViabilidad,		
		Provincia													As			Provincia,				
		Canton														As			Canton,					
		Distrito													As			Distrito,				
		Barrio														As			Barrio,					
		Señas														As			Sennas,					
		FechaHechos													As			FechaHechos,				
		FechaEntrada												As			FechaEntrada,			
		Clase														As			Clase,					
		Proceso														As			Proceso,					
		Fase														As			Fase,					
		ContextoProcedencia											As			ContextoProcedencia,	
		GrupoTrabajo												As			GrupoTrabajo,			
		Habilitado													As			Habilitado,				
		DocumentosFisicos											As			DocumentosFisicos,
		Carpeta														As			CarpetaGestion,
		Itineracion.FN_DevuelveNumeroDecimal(MontoAguinaldo)		As			MontoAguinaldo,
		DescripcionHechos											As			DescripcionHechos,
		Itineracion.FN_DevuelveNumeroDecimal(MontoSalarioEscolar)	As			MontoSalarioEscolar
	From
		@Result

END
GO
