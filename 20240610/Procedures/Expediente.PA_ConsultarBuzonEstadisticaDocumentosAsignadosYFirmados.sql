SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:		   <Jose Gabriel Cordero Soto>
-- Fecha Creación: <01/09/2021>
-- Descripcion:	   <Permite consultar y listar los documentos asignados y firmados o solo los que cuentan con firma aplicada para el tema estadístico según los filtros establecidos. >
-- =================================================================================================================================================
-- Modificado por: <Jose Gabriel Cordero Soto> <06/09/2021> <Se realiza ajuste con respecto a los calculos estadisticos sobre documentos urgentes, devueltos, etc>
-- Modificado por: <Jose Gabriel Cordero Soto> <08/09/2021> <Se realiza ajuste en parametros de entrada para incluir dos tipos de jornada que se pueden seleccionar>
-- Modificado por: <Wagner Vargas S> <09/09/2021> <se crea consulta de firmados(CodTipoTrabajo 2) y se agrega cantidadExpedientesFirmados>
-- Modificado por: <Jose Gabriel Cordero Soto> <10/09/2021> <Se realiza ajustes en nombre de campos en select final y actualizacion con el filtrado de tipo de jornada>
-- Modificado por: <Jose Gabriel Cordero Soto> <14/09/2021> <Se agrega ordenamiento por fecha de asignacion descendente en select final>
-- Modificado por: <Fabian Sequeira> <14/09/2021> <Se agrega consulta para los tipos de trabajo proveido y sus actualizacion de datos>
-- Modificado por: <Jose Gabriel Cordero Soto> <15/09/2021> <Se realiza ajustes con respecto al tipo de jornada y filtrado de los resultados repetidos>
-- Modificado por: <Jose Gabriel Cordero Soto> <16/09/2021> <Se realiza ajuste en calculos de la parte estadística de la consulta>
-- Modificado por: <Fabian Sequeira Gamboa> <30/09/2021> <Se realiza ajuste para cuando se hace la consulta a proveidos, cuando se envia el asignador >
-- Modificado por: <Jose Gabriel Cordero Soto> <28/10/2021> <Se realiza la inclusion de nuevos filtros para la consulta >
-- Modificado por: <Jose Gabriel Cordero Soto> <02/11/2021> <Se realiza ajuste con el UsuarioTrabajo para que sea un LEFT JOIN por temas de rendimiento y tiempo >
-- Modificado por: <Jose Gabriel Cordero Soto> <05/11/2021> <Se realiza ajuste con respecto a campo TB_GenerarVotoAutomatico para que muestre resultados si esta en NULL >
-- Modificado por: <Karol Jiménez Sánchez> <13/01/2022> <BUG 231163- Se realiza ajuste con respecto filtro para mostrar todos documentos o solo resoluciones >
-- Modificado por: <Josué Quirós Batista> <14/01/2022> <BUG 231152- Ajuste para que obtenga resultados al ejecutar tipoTrabajo =2 , con puesto de trabajo vacío>
-- Modificado por: <Aarón Ríos Retana> <17-01-2022> <Bug 231158 - Ajuste para que retorne si es firmado digitalmente>
-- Modificado por: <Jonathan Aguilar Navarro> <25/01/2022> <Bug 235146 - Se agrega el parametro @CodPuestotrabajoFuncionarioAsignador para utilizarlo como filtro si se marcó "Asignador">
-- Modificado por: <Jose Gabriel Cordero Soto> <02/02/2022> <Bug 236450- Se ajusta asociacion con catalogos de formato juridico con notificacion automatica y formato juridico con tipo de trabajo>
-- Modificado por: <Jose Gabriel Cordero Soto> <08/02/2022> <Bug 231157 - Se ajusta nombre del firmante en consulta, dado que mostraba vacío>
-- Modificado por: <Aida Elena Siles R> <22/02/2022> <Se modifica consulta para evitar registros duplicados cuando las asignaciones de firma tienen más de un firmante.
--					Se realiza la consulta de acuerdo a las fechas y en caso que se envie el usuario, los codigos de puesto trabajo funcionario del usuario los obtenemos en el SP.
--					Se corrige la forma para obtener la cantidad de documentos pendientes. Se elimina parámetro @CodPuestotrabajoFuncionarioAsignador ya no se requiere.>
-- Modificado por: <Aida Elena Siles R> <01/03/2022> <Ajuste en los contadores de: DocumentosAsignados, expedientes firmados, firmas aplicadas, documentos pendientes y documentos devueltos.>
-- Modificado por: <Jonathan Aguilar Navarro><11/07/2023><Se realiza modificación de la consulta, modificando "OUTTER APPLY"  que retornaba el ultimo "usuario red" asignado al puesto de trabajo>
--				   < lo que provocaba que no devolviera resultados cuando el usuario seleccionado no esta en el puesto de trabajo actualmente>	
-- =================================================================================================================================================
CREATE  PROCEDURE [Expediente].[PA_ConsultarBuzonEstadisticaDocumentosAsignadosYFirmados]
(
	@NumeroPagina									INT,
	@CantidadRegistros								INT,
	@CodTipoTrabajo									CHAR(1),	
	@FechaAsignaDesde								DATETIME2(3),
	@FechaAsignaHasta								DATETIME2(3),
	@CodJornadaLaboralDiurna						BIT				= NULL,
	@CodJornadaLaboralExtraordinaria				BIT				= NULL,
	@TipoFirmaElectronica							BIT				= NULL,	
	@TipoFirmaDigital								BIT				= NULL,
	@CodPuestoTrabajo								VARCHAR(14),
	@UsuarioTrabajo									VARCHAR(30),
	@CodPuestotrabajoAsignador						VARCHAR(14),
	@UsuarioTrabajoAsignador						VARCHAR(30),	
	@CodContexto									VARCHAR(4),
	@CodDocResoluciones								BIT
)
AS
BEGIN

	--*************************************************************************************************************************************************
	--Declaracion de variables
	--*************************************************************************************************************************************************

	DECLARE @L_NumeroPagina								INT							= @NumeroPagina,
			@L_CantidadRegistros						INT							= @CantidadRegistros,			
			@L_CodTipoTrabajo							CHAR(1)						= @CodTipoTrabajo,	
			@L_FechaAsignaDesde							DATETIME2(3)				= @FechaAsignaDesde,
			@L_FechaAsignaHasta							DATETIME2(3)				= @FechaAsignaHasta,
			@L_CodJornadaLaboralDiurna					SMALLINT					= @CodJornadaLaboralDiurna,
			@L_CodJornadaLaboralExtra					SMALLINT					= @CodJornadaLaboralExtraordinaria,
			@L_TipoFirmaElectronica						BIT							= @TipoFirmaElectronica,	
			@L_TipoFirmaDigital							BIT							= @TipoFirmaDigital,
			@L_CodPuestoTrabajo							VARCHAR(14)					= @CodPuestoTrabajo,
			@L_UsuarioTrabajo							VARCHAR(30)					= @UsuarioTrabajo,
			@L_CodPuestotrabajoAsignador				VARCHAR(14)					= @CodPuestotrabajoAsignador,
			@L_UsuarioTrabajoAsignador					VARCHAR(30)					= @UsuarioTrabajoAsignador,			
			@L_CodContexto								VARCHAR(4)					= @CodContexto,			
			@L_CantidadExpedientesAsignados				INT							= 0,	
			@L_CantidadDocumentosAsignados				INT							= 0,
			@L_CantidadExpedientesFirmados				INT							= 0,
			@L_CantidadDocumentosSinExpediente			INT							= 0,
			@L_CantidadFirmasAplicadas					INT							= 0,
			@L_CantidadDocumentosPendientes				INT							= 0,
			@L_CantidadDocumentosDevueltos				INT							= 0,
			@L_CantidadDocumentosUrgentes				INT							= 0,
			@L_CantidadDocumentosCorregidos				INT							= 0,
			@L_EsFirmaDigital							TINYINT						= 0,
			@L_Jornada									SMALLINT					= 0,
			@L_TotalRegistros							BIGINT						= 0,
			@L_CodDocResoluciones						BIT							= @CodDocResoluciones,
			@L_TodosDoc									BIT							= NULL			

	--OBTIENE EL TIPO de FILTRO PARA TIPO de FIRMADO
	IF(@L_TipoFirmaElectronica = 1 and @L_TipoFirmaDigital=1)
		BEGIN
			set @L_EsFirmaDigital = 2
		END
	ELSE
		BEGIN
			IF(@L_TipoFirmaElectronica = 0 and @L_TipoFirmaDigital=1)
				set @L_EsFirmaDigital = 1
			ELSE
				set @L_EsFirmaDigital = 0
		END			

	IF(@L_CodDocResoluciones = 1)
		SET @L_TodosDoc = 0
	ELSE 
		SET @L_TodosDoc = 1 
	
	--*************************************************************************************************************************************************
	-- Creación de tabla temporal
	--*************************************************************************************************************************************************		
	DECLARE @BUZONFIRMADO AS TABLE 
	(		
		[TU_CodArchivo]							[UNIQUEIDENTIFIER]  NOT NULL, 
		[TC_Descripcion]						[VARCHAR](255)		NOT NULL, 
		[TF_FechaCrea]							[DATETIME2](7)		NOT NULL,
		[TC_NumeroExpediente]					[VARCHAR](14)		NULL,  
		[TU_CodLegajo]							[UNIQUEIDENTIFIER]	NULL,
		[TF_FechaAsigna]						[DATETIME2](7)		NOT NULL, 
		[TU_AsignadoPor]						[UNIQUEIDENTIFIER]  NOT NULL, 
		[TF_FechaAplicado]						[DATETIME2](7)		NULL,
		[TB_EsFirmaDigital]						[Bit]			    NULL,
		[TC_UsuarioRed]							[VARCHAR](30)		NULL,
		[TC_Nombre]								[VARCHAR](50)		NULL, 
		[TC_PrimerApellido]						[VARCHAR](50)		NULL, 		
		[TC_SegundoApellido]					[VARCHAR](50)		NULL, 		
		[TC_UsuarioRedAsignador]				[VARCHAR](30)		NULL,
		[TC_NombreAsignado]						[VARCHAR](50)		NULL, 
		[TC_PrimerApellidoAsignado]				[VARCHAR](50)		NULL, 		
		[TC_SegundoApellidoAsignado]			[VARCHAR](50)		NULL,
		[TN_CantidadExpedientesAsignados]		[INT]				NULL, 
		[TN_CantidadDocumentosAsignados]		[INT]				NULL, 
		[TN_CantidadExpedientesFirmados]		[INT]				NULL, 
		[TN_CantidadDocumentosSinExpediente]	[INT]				NULL, 
		[TN_CantidadFirmasAplicadas]			[INT]				NULL, 
		[TN_CantidadDocumentosPedientes]		[INT]				NULL, 
		[TN_CantidadDocumentosDevueltos]		[INT]				NULL, 
		[TN_CantidadDocumentosUrgentes]			[INT]				NULL,
		[TN_CantidadDocumentosCorregidos]		[INT]				NULL,
		[TU_CodAsignacionFirmado]				[UNIQUEIDENTIFIER]  NULL,
		[TU_FirmadoPor]							[UNIQUEIDENTIFIER]  NULL,
		[TC_CodPuestoTrabajoAsignadoA]			[VARCHAR](14)		NULL,
		[TF_FechaDevolucion]					[DATETIME2](7)		NULL
	);
	DECLARE @BUZONFIRMADOTEMP AS TABLE --Se utiliza para almacenar temporalmente los datos y eliminar duplicados de documentos.
	(		
		[TU_CodArchivo]							[UNIQUEIDENTIFIER]  NOT NULL, 
		[TC_Descripcion]						[VARCHAR](255)		NOT NULL, 
		[TF_FechaCrea]							[DATETIME2](7)		NOT NULL,
		[TC_NumeroExpediente]					[VARCHAR](14)		NULL,  
		[TU_CodLegajo]							[UNIQUEIDENTIFIER]	NULL,
		[TF_FechaAsigna]						[DATETIME2](7)		NOT NULL, 
		[TU_AsignadoPor]						[UNIQUEIDENTIFIER]  NOT NULL, 
		[TF_FechaAplicado]						[DATETIME2](7)		NULL,
		[TB_EsFirmaDigital]						[Bit]			    NULL,
		[TC_UsuarioRed]							[VARCHAR](30)		NULL,
		[TC_Nombre]								[VARCHAR](50)		NULL, 
		[TC_PrimerApellido]						[VARCHAR](50)		NULL, 		
		[TC_SegundoApellido]					[VARCHAR](50)		NULL, 		
		[TC_UsuarioRedAsignador]				[VARCHAR](30)		NULL,
		[TC_NombreAsignado]						[VARCHAR](50)		NULL, 
		[TC_PrimerApellidoAsignado]				[VARCHAR](50)		NULL, 		
		[TC_SegundoApellidoAsignado]			[VARCHAR](50)		NULL,
		[TN_CantidadExpedientesAsignados]		[INT]				NULL, 
		[TN_CantidadDocumentosAsignados]		[INT]				NULL, 
		[TN_CantidadExpedientesFirmados]		[INT]				NULL, 
		[TN_CantidadDocumentosSinExpediente]	[INT]				NULL, 
		[TN_CantidadFirmasAplicadas]			[INT]				NULL, 
		[TN_CantidadDocumentosPedientes]		[INT]				NULL, 
		[TN_CantidadDocumentosDevueltos]		[INT]				NULL, 
		[TN_CantidadDocumentosUrgentes]			[INT]				NULL,
		[TN_CantidadDocumentosCorregidos]		[INT]				NULL,
		[TU_CodAsignacionFirmado]				[UNIQUEIDENTIFIER]  NULL,
		[TU_FirmadoPor]							[UNIQUEIDENTIFIER]  NULL,
		[TC_CodPuestoTrabajoAsignadoA]			[VARCHAR](14)		NULL,
		[TF_FechaDevolucion]					[DATETIME2](7)		NULL
	);	

	--*************************************************************************************************************************************************
	--Creación de tablas para almacenar temporalmente los codigos Guid's de los puestos de trabajo del usuario firmador y del usuario asignador.
	--*************************************************************************************************************************************************
	DECLARE @PUESTOSTRABAJOFUNCIONARIOTABLA AS TABLE
	(
		TU_CodPuestoTrabajoFuncionario UNIQUEIDENTIFIER
	);
	DECLARE @PUESTOSTRABAJOFUNCIONARIOASIGNADORTABLA AS TABLE
	(
		TU_CodPuestoTrabajoFuncionario UNIQUEIDENTIFIER
	);

	IF (@L_UsuarioTrabajo IS NOT NULL AND @L_UsuarioTrabajo <> '')
	BEGIN
		--Almacenamos todos los codigos de puesto trabajo funcionario del usuario para el puesto
		INSERT INTO @PUESTOSTRABAJOFUNCIONARIOTABLA
		SELECT	TU_CodPuestoFuncionario
		FROM	Catalogo.PuestoTrabajoFuncionario WITH(NOLOCK)
		WHERE	TC_CodPuestoTrabajo = @L_CodPuestoTrabajo
		AND		TC_UsuarioRed		= @L_UsuarioTrabajo		
	END

	IF (@L_UsuarioTrabajoAsignador IS NOT NULL AND @L_UsuarioTrabajoAsignador <> '')
	BEGIN
		--Almacenamos todos los codigos de puesto trabajo funcionario del usuario asignador
		INSERT INTO @PUESTOSTRABAJOFUNCIONARIOASIGNADORTABLA
		SELECT	TU_CodPuestoFuncionario
		FROM	Catalogo.PuestoTrabajoFuncionario WITH(NOLOCK)
		WHERE	TC_CodPuestoTrabajo = @L_CodPuestotrabajoAsignador
		AND		TC_UsuarioRed		= @L_UsuarioTrabajoAsignador
	END

	--*************************************************************************************************************************************************
	--Ejecución de Condición para aplicar consulta
	--*************************************************************************************************************************************************

	IF (@L_CodTipoTrabajo = '1')
	BEGIN			
		--EN CASO DE AMBAS JORNADAS
		IF(@L_CodJornadaLaboralDiurna = 1 AND @L_CodJornadaLaboralExtra = 1)
		BEGIN
			--OBTIENE LOS REGISTROS ASIGNADOS AL PUESTO DE TRABAJO CORRESPONDIENTE
			INSERT INTO @BUZONFIRMADO
			SELECT		B.TU_CodArchivo						Codigo,
						B.TC_Descripcion					Descripcion, 
						B.TF_FechaCrea						FechaCrea,	
						F.TC_NumeroExpediente				NumeroExpediente,					
						G.TU_CodLegajo						Codigo,					
						A.TF_FechaAsigna					FechaAsigna,
						A.TU_AsignadoPor					AsignadoPor,					
						C.TF_FechaAplicado					FechaAplicado,
						C.TB_EsFirmaDigital					EsFirmaDigital,
						UsuarioAsignado.TC_UsuarioRed		UsuarioRed, 
						UsuarioAsignado.TC_Nombre			NombreFuncionario,
						UsuarioAsignado.TC_PrimerApellido	PrimerApellidoFuncionario,
						UsuarioAsignado.TC_SegundoApellido	SegundoApellidoFuncionario,
						UsuarioAsignador.TC_UsuarioRed		UsuarioRedAsignador,
						UsuarioAsignador.TC_Nombre			NombreFuncionarioAsignador,
						UsuarioAsignador.TC_PrimerApellido	PrimerApellidoFuncionarioAsignador,
						UsuarioAsignador.TC_SegundoApellido	SegundoApellidoFuncionarioAsignador,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL, 
						NULL,
						A.TU_CodAsignacionFirmado,
						C.TU_FirmadoPor,
						C.TC_CodPuestoTrabajo,
						A.TF_FechaDevolucion
			FROM		Archivo.AsignacionFirmado			A WITH(NOLOCK)
			INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
			ON			B.TU_CodArchivo						= A.TU_CodArchivo
			INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
			ON			C.TU_CodAsignacionFirmado			= A.TU_CodAsignacionFirmado		
			AND	   	    C.TC_CodPuestoTrabajo				= COALESCE(@L_CodPuestoTrabajo, C.TC_CodPuestoTrabajo)
			--Se extrae el ultimo usuario para asignarlo a la consulta de los pendientes de firma, ya que la tabla Archivo.AsignacionFirmante solo tiene el puesto de trabajo, y se requiere puesto trabajo funcionario
			OUTER APPLY (
				SELECT		TOP 1 F.TC_UsuarioRed, F.TU_CodPuestoFuncionario
				FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
				WHERE		F.TC_CodPuestoTrabajo					= @CodPuestoTrabajo
				AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
				AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
				AND			@CodPuestoTrabajo						IS NOT NULL
				ORDER BY	F.TF_Inicio_Vigencia DESC
			) PTF
			LEFT JOIN   Expediente.ArchivoExpediente		F WITH(NOLOCK) 
			ON			F.TU_CodArchivo						= A.TU_CodArchivo
			AND			F.TB_Eliminado						= 0
			LEFT JOIN   Expediente.LegajoArchivo			G WITH(NOLOCK) 
			ON			G.TU_CodArchivo						= A.TU_CodArchivo		
			OUTER APPLY (
				SELECT		TOP 1 
							H.TC_UsuarioRed,		
							H.TC_Nombre,			
							H.TC_PrimerApellido,	
							H.TC_SegundoApellido
				FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
				LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
				ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
				WHERE		F.TC_CodPuestoTrabajo					= C.TC_CodPuestoTrabajo
				AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
				AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
				ORDER BY	F.TF_Inicio_Vigencia DESC
			) UsuarioAsignado
			OUTER APPLY (
				SELECT		TOP 1 
							H.TC_UsuarioRed,		
							H.TC_Nombre,			
							H.TC_PrimerApellido,	
							H.TC_SegundoApellido
				FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
				LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
				ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
				WHERE		F.TU_CodPuestoFuncionario				= A.TU_AsignadoPor	
				AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
				AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
				ORDER BY	F.TF_Inicio_Vigencia DESC
			) UsuarioAsignador
			OUTER APPLY	(/*Documentos asociados a resoluciones y que el formato jurídico asociado al documento en el contexto genera notificación automática*/						
						SELECT		TOP 1 Z.TU_CodArchivo
						FROM		Catalogo.FormatoJuridicoTipoOficina			K WITH(NOLOCK)
						INNER JOIN	Catalogo.FormatoJuriComunicacionContexto	L WITH(NOLOCK)	
						ON			L.TC_CodContexto							= @L_CodContexto
						AND			L.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
						INNER JOIN	Archivo.Archivo								Z WITH(NOLOCK)
						ON			Z.TC_CodFormatoJuridico						= K.TC_CodFormatoJuridico
						AND			Z.TC_CodFormatoJuridico						= L.TC_CodFormatoJuridico
						AND			Z.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
						WHERE		Z.TU_CodArchivo								= B.TU_CodArchivo
						AND			K.TB_EsResolucion							= 1
						) OA
			WHERE		(A.TF_FechaAsigna					>= @L_FechaAsignaDesde
			AND			 A.TF_FechaAsigna					<= @L_FechaAsignaHasta) 			
			AND			 B.TC_CodContextoCrea				= @L_CodContexto		
			AND			(@L_TodosDoc						= 1
							OR	
							(
								@L_TodosDoc					= 0
								AND
								B.TU_CodArchivo				= OA.TU_CodArchivo
							)
						)
			AND			(@CodPuestoTrabajo					IS NULL
							OR PTF.TC_UsuarioRed			= ISNULL(@L_UsuarioTrabajo, PTF.TC_UsuarioRed)
			)
			ORDER BY	A.TF_FechaAsigna DESC	
		END
		ELSE
		BEGIN 
			-- EN CASO DE DIRUNO
			IF (@L_CodJornadaLaboralDiurna = 1)
			BEGIN				 
				INSERT INTO @BUZONFIRMADO
				SELECT		B.TU_CodArchivo						Codigo,
							B.TC_Descripcion					Descripcion, 
							B.TF_FechaCrea						FechaCrea,	
							F.TC_NumeroExpediente				NumeroExpediente,					
							G.TU_CodLegajo						Codigo,					
							A.TF_FechaAsigna					FechaAsigna,
							A.TU_AsignadoPor					AsignadoPor,					
							C.TF_FechaAplicado					FechaAplicado,	
							C.TB_EsFirmaDigital					EsFirmaDigital,
							UsuarioAsignado.TC_UsuarioRed		UsuarioRed, 
							UsuarioAsignado.TC_Nombre			NombreFuncionario,
							UsuarioAsignado.TC_PrimerApellido	PrimerApellidoFuncionario,
							UsuarioAsignado.TC_SegundoApellido	SegundoApellidoFuncionario,
							UsuarioAsignador.TC_UsuarioRed		UsuarioRedAsignador,
							UsuarioAsignador.TC_Nombre			NombreFuncionarioAsignador,
							UsuarioAsignador.TC_PrimerApellido	PrimerApellidoFuncionarioAsignador,
							UsuarioAsignador.TC_SegundoApellido	SegundoApellidoFuncionarioAsignador,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL, 
							NULL,
							A.TU_CodAsignacionFirmado,
							C.TU_FirmadoPor,
							C.TC_CodPuestoTrabajo,
							A.TF_FechaDevolucion
				FROM		Archivo.AsignacionFirmado			A WITH(NOLOCK)
				INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
				ON			B.TU_CodArchivo						= A.TU_CodArchivo				
				INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
				ON			C.TU_CodAsignacionFirmado			= A.TU_CodAsignacionFirmado		
				AND	   	    C.TC_CodPuestoTrabajo				= COALESCE(@L_CodPuestoTrabajo, C.TC_CodPuestoTrabajo)		
				--Se extrae el ultimo usuario para asignarlo a la consulta de los pendientes de firma, ya que la tabla Archivo.AsignacionFirmante solo tiene el puesto de trabajo, y se requiere puesto trabajo funcionario
				OUTER APPLY (
							SELECT		TOP 1 F.TC_UsuarioRed, F.TU_CodPuestoFuncionario
							FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
							WHERE		F.TC_CodPuestoTrabajo					= @CodPuestoTrabajo
							AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
							AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
							AND			@CodPuestoTrabajo						IS NOT NULL
							ORDER BY	F.TF_Inicio_Vigencia DESC
				) PTF
				LEFT JOIN   Expediente.ArchivoExpediente		F WITH(NOLOCK) 
				ON			F.TU_CodArchivo						= A.TU_CodArchivo
				AND			F.TB_Eliminado						= 0
				LEFT JOIN   Expediente.LegajoArchivo			G WITH(NOLOCK) 
				ON			G.TU_CodArchivo						= A.TU_CodArchivo
							OUTER APPLY (
				SELECT		TOP 1 
							H.TC_UsuarioRed,		
							H.TC_Nombre,			
							H.TC_PrimerApellido,	
							H.TC_SegundoApellido
				FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
				LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
				ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
				WHERE		F.TC_CodPuestoTrabajo					= C.TC_CodPuestoTrabajo
				AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
				AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
				ORDER BY	F.TF_Inicio_Vigencia DESC
				) UsuarioAsignado	
				OUTER APPLY (
				SELECT		TOP 1 
							H.TC_UsuarioRed,		
							H.TC_Nombre,			
							H.TC_PrimerApellido,	
							H.TC_SegundoApellido
				FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
				LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
				ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
				WHERE		F.TU_CodPuestoFuncionario				= A.TU_AsignadoPor	
				AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
				AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
				ORDER BY	F.TF_Inicio_Vigencia DESC
			) UsuarioAsignador
				OUTER APPLY	(/*Documentos asociados a resoluciones y que el formato jurídico asociado al documento en el contexto genera notificación automática*/							
							  SELECT		TOP 1 Z.TU_CodArchivo
							  FROM		Catalogo.FormatoJuridicoTipoOficina			K WITH(NOLOCK)
							  INNER JOIN	Catalogo.FormatoJuriComunicacionContexto	L WITH(NOLOCK)	
							  ON			L.TC_CodContexto							= @L_CodContexto
							  AND			L.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
							  INNER JOIN	Archivo.Archivo								Z WITH(NOLOCK)
							  ON			Z.TC_CodFormatoJuridico						= K.TC_CodFormatoJuridico
							  AND			Z.TC_CodFormatoJuridico						= L.TC_CodFormatoJuridico
							  AND			Z.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
							  WHERE		Z.TU_CodArchivo								= B.TU_CodArchivo
							) OA
				WHERE		(A.TF_FechaAsigna					>= @L_FechaAsignaDesde
				AND			 A.TF_FechaAsigna					<= @L_FechaAsignaHasta) 			
				AND			(CONVERT(varchar(8), A.TF_FechaAsigna, 108) >= CONVERT(varchar(8), '07:30:00',108)
				AND	  		 CONVERT(varchar(8), A.TF_FechaAsigna, 108) <= CONVERT(varchar(8), '16:30:00',108))
				AND			 B.TC_CodContextoCrea				 = @L_CodContexto	
				AND			(@L_TodosDoc						= 1
								OR	
								(
									@L_TodosDoc					= 0
									AND
									B.TU_CodArchivo				= OA.TU_CodArchivo
								)
							)
			AND			(@CodPuestoTrabajo					IS NULL
							OR PTF.TC_UsuarioRed			= ISNULL(@L_UsuarioTrabajo, PTF.TC_UsuarioRed)
			)
				ORDER BY	A.TF_FechaAsigna DESC	
			END
			ELSE --EN CASO DE SER EXTRAORDINARIO
			BEGIN
				INSERT INTO @BUZONFIRMADO
				SELECT		B.TU_CodArchivo						Codigo,
							B.TC_Descripcion					Descripcion, 
							B.TF_FechaCrea						FechaCrea,	
							F.TC_NumeroExpediente				NumeroExpediente,					
							G.TU_CodLegajo						Codigo,					
							A.TF_FechaAsigna					FechaAsigna,
							A.TU_AsignadoPor					AsignadoPor,					
							C.TF_FechaAplicado					FechaAplicado,	
							C.TB_EsFirmaDigital					EsFirmaDigital,
							UsuarioAsignado.TC_UsuarioRed		UsuarioRed, 
							UsuarioAsignado.TC_Nombre			NombreFuncionario,
							UsuarioAsignado.TC_PrimerApellido	PrimerApellidoFuncionario,
							UsuarioAsignado.TC_SegundoApellido	SegundoApellidoFuncionario,
							UsuarioAsignador.TC_UsuarioRed		UsuarioRedAsignador,
							UsuarioAsignador.TC_Nombre			NombreFuncionarioAsignador,
							UsuarioAsignador.TC_PrimerApellido	PrimerApellidoFuncionarioAsignador,
							UsuarioAsignador.TC_SegundoApellido	SegundoApellidoFuncionarioAsignador,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL, 
							NULL,
							A.TU_CodAsignacionFirmado,
							C.TU_FirmadoPor,
							C.TC_CodPuestoTrabajo,
							A.TF_FechaDevolucion
				FROM		Archivo.AsignacionFirmado			A WITH(NOLOCK)
				INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
				ON			B.TU_CodArchivo						= A.TU_CodArchivo		
			  --AND			A.TU_AsignadoPor					= ISNULL(@L_CodPuestotrabajoFuncionarioAsignador, A.TU_AsignadoPor)
				INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
				ON			C.TU_CodAsignacionFirmado			= A.TU_CodAsignacionFirmado		
				AND	   	    C.TC_CodPuestoTrabajo				= COALESCE(@L_CodPuestoTrabajo, C.TC_CodPuestoTrabajo)			
				--Se extrae el ultimo usuario para asignarlo a la consulta de los pendientes de firma, ya que la tabla Archivo.AsignacionFirmante solo tiene el puesto de trabajo, y se requiere puesto trabajo funcionario
				OUTER APPLY (
							SELECT		TOP 1 F.TC_UsuarioRed, F.TU_CodPuestoFuncionario
							FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
							WHERE		F.TC_CodPuestoTrabajo					= @CodPuestoTrabajo
							AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
							AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
							AND			@CodPuestoTrabajo						IS NOT NULL
							ORDER BY	F.TF_Inicio_Vigencia DESC
				) PTF
				LEFT JOIN   Expediente.ArchivoExpediente		F WITH(NOLOCK) 
				ON			F.TU_CodArchivo						= A.TU_CodArchivo
				AND			F.TB_Eliminado						= 0
				LEFT JOIN   Expediente.LegajoArchivo			G WITH(NOLOCK) 
				ON			G.TU_CodArchivo						= A.TU_CodArchivo
							OUTER APPLY (
				SELECT		TOP 1 
							H.TC_UsuarioRed,		
							H.TC_Nombre,			
							H.TC_PrimerApellido,	
							H.TC_SegundoApellido
				FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
				LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
				ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
				WHERE		F.TC_CodPuestoTrabajo					= C.TC_CodPuestoTrabajo
				AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
				AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
				ORDER BY	F.TF_Inicio_Vigencia DESC
				) UsuarioAsignado	
				OUTER APPLY (
				SELECT		TOP 1 
							H.TC_UsuarioRed,		
							H.TC_Nombre,			
							H.TC_PrimerApellido,	
							H.TC_SegundoApellido
				FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
				LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
				ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
				WHERE		F.TU_CodPuestoFuncionario				= A.TU_AsignadoPor	
				AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
				AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
				ORDER BY	F.TF_Inicio_Vigencia DESC
			) UsuarioAsignador
				OUTER APPLY	(/*Documentos asociados a resoluciones y que el formato jurídico asociado al documento en el contexto genera notificación automática*/							
							  SELECT		TOP 1 Z.TU_CodArchivo
							  FROM		Catalogo.FormatoJuridicoTipoOficina			K WITH(NOLOCK)
							  INNER JOIN	Catalogo.FormatoJuriComunicacionContexto	L WITH(NOLOCK)	
							  ON			L.TC_CodContexto							= @L_CodContexto
							  AND			L.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
							  INNER JOIN	Archivo.Archivo								Z WITH(NOLOCK)
							  ON			Z.TC_CodFormatoJuridico						= K.TC_CodFormatoJuridico
							  AND			Z.TC_CodFormatoJuridico						= L.TC_CodFormatoJuridico
							  AND			Z.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
							  WHERE		Z.TU_CodArchivo								= B.TU_CodArchivo
							) OA
				WHERE		(A.TF_FechaAsigna					>= @L_FechaAsignaDesde
				AND			 A.TF_FechaAsigna					<= @L_FechaAsignaHasta) 			
				AND			(CONVERT(varchar(8), A.TF_FechaAsigna, 108) < CONVERT(varchar(8), '07:30:00',108)
				OR	  		 CONVERT(varchar(8), A.TF_FechaAsigna, 108) > CONVERT(varchar(8), '16:30:00',108)) 
				AND			(@L_TodosDoc						= 1
								OR	
								(
									@L_TodosDoc					= 0
									AND
									B.TU_CodArchivo				= OA.TU_CodArchivo
								)
							)

				AND			B.TC_CodContextoCrea				 = @L_CodContexto		
				AND			(@CodPuestoTrabajo					IS NULL
								OR PTF.TC_UsuarioRed			= ISNULL(@L_UsuarioTrabajo, PTF.TC_UsuarioRed)
							)	
				ORDER BY	A.TF_FechaAsigna DESC	
			END
		END

		--BORRAMOS LOS REGISTROS QUE NO CORRESPONDEN AL USUARIO
		IF (@L_UsuarioTrabajo IS NOT NULL AND @L_UsuarioTrabajo <> '')
		BEGIN
			DELETE FROM @BUZONFIRMADO
			WHERE TU_FirmadoPor NOT IN (SELECT * FROM @PUESTOSTRABAJOFUNCIONARIOTABLA)
		END
		--BORRAMOS LOS REGISTROS QUE NO CORRESPONDEN AL USUARIO ASIGNADOR
		IF (@L_UsuarioTrabajoAsignador IS NOT NULL AND @L_UsuarioTrabajoAsignador <> '')
		BEGIN
			DELETE FROM @BUZONFIRMADO
			WHERE TU_AsignadoPor NOT IN (SELECT * FROM @PUESTOSTRABAJOFUNCIONARIOASIGNADORTABLA)
		END

		--Obtener cantidad registros de la consulta
		SELECT  @L_TotalRegistros = COUNT(*) FROM @BUZONFIRMADO;

		--***********************************************************************************************************************************************
		--ACTUALIZACION DE CAMPOS DE CANTIDAD SEGUN CRITERIO
		--***********************************************************************************************************************************************

		UPDATE		@BUZONFIRMADO
		SET			TN_CantidadDocumentosCorregidos = 0

		--EXPEDIENTES ASIGNADOS AL PUESTO DE TRABAJO		
		SELECT		@L_CantidadExpedientesAsignados = ISNULL(COUNT(DISTINCT(A.TC_NumeroExpediente)), 0)
		FROM		@BUZONFIRMADO				 A
		INNER JOIN	Archivo.AsignacionFirmado	 B WITH(NOLOCK)	
		ON			B.TU_CodAsignacionFirmado	 = A.TU_CodAsignacionFirmado		
		LEFT JOIN	Expediente.ArchivoExpediente C WITH(NOLOCK)	
		ON			C.TU_CodArchivo				 = B.TU_CodArchivo
		LEFT JOIN	Expediente.LegajoArchivo	 D WITH(NOLOCK)	
		ON			D.TU_CodArchivo				 = B.TU_CodArchivo		
		
		UPDATE		@BUZONFIRMADO
		SET			TN_CantidadExpedientesAsignados = @L_CantidadExpedientesAsignados

		--DOCUMENTOS ASIGNADOS AL PUESTO DE TRABAJO
		SELECT		@L_CantidadDocumentosAsignados = ISNULL(COUNT(DISTINCT(A.TU_CodArchivo)), 0)
		FROM		@BUZONFIRMADO				 A

		UPDATE		@BUZONFIRMADO
		SET			TN_CantidadDocumentosAsignados = @L_CantidadDocumentosAsignados

		--EXPEDIENTES FIRMADOS
		SELECT		@L_CantidadExpedientesFirmados = ISNULL(COUNT(DISTINCT(A.TC_NumeroExpediente)), 0)
		FROM		@BUZONFIRMADO				A
		WHERE		A.TF_FechaAplicado			IS NOT NULL		

		UPDATE		@BUZONFIRMADO
		SET			TN_CantidadExpedientesFirmados = @L_CantidadExpedientesFirmados

		--DOCUMENTO SIN EXPEDIENTE
		SELECT		@L_CantidadDocumentosSinExpediente = ISNULL(COUNT(A.TU_CodArchivo), 0)
		FROM		@BUZONFIRMADO								A
		INNER JOIN	ArchivoSinExpediente.ArchivoSinExpediente   B WITH(NOLOCK) 
		ON			B.TU_CodArchivo								= A.TU_CodArchivo

		UPDATE		@BUZONFIRMADO
		SET			TN_CantidadDocumentosSinExpediente = @L_CantidadDocumentosSinExpediente

		--FIRMAS APLICADAS
		SELECT		@L_CantidadFirmasAplicadas = ISNULL(COUNT(A.TU_CodAsignacionFirmado), 0)
		FROM		@BUZONFIRMADO				A
		WHERE		A.TF_FechaAplicado			IS NOT NULL		

		UPDATE		@BUZONFIRMADO
		SET			TN_CantidadFirmasAplicadas = @L_CantidadFirmasAplicadas

		--DOCUMENTOS PENDIENTES
		SELECT		@L_CantidadDocumentosPendientes = ISNULL(COUNT(DISTINCT(A.TU_CodArchivo)), 0)
		FROM		@BUZONFIRMADO				A
		WHERE		A.TF_FechaAplicado			IS NULL	
		AND			A.TF_FechaDevolucion		IS NULL			

		UPDATE		@BUZONFIRMADO
		SET			TN_CantidadDocumentosPedientes = @L_CantidadDocumentosPendientes

		--DOCUMENTOS DEVUELTOS
		SELECT		@L_CantidadDocumentosDevueltos = ISNULL(COUNT(DISTINCT(A.TU_CodArchivo)), 0)
		FROM		@BUZONFIRMADO				A
		WHERE		A.TF_FechaDevolucion		IS NOT NULL		

		UPDATE		@BUZONFIRMADO
		SET			TN_CantidadDocumentosDevueltos = @L_CantidadDocumentosDevueltos

		--DOCUMENTOS URGENTES
		SELECT		@L_CantidadDocumentosUrgentes = ISNULL(COUNT(A.TU_CodArchivo), 0)		
		FROM		@BUZONFIRMADO				A
		INNER JOIN  Archivo.AsignacionFirmado   B WITH(NOLOCK)
		ON			B.TU_CodAsignacionFirmado	= A.TU_CodAsignacionFirmado
		WHERE		B.TB_Urgente				= 1
		GROUP BY	A.TU_CodArchivo

		UPDATE		@BUZONFIRMADO
		SET			TN_CantidadDocumentosUrgentes = @L_CantidadDocumentosUrgentes		
	END
	ELSE
	BEGIN
		IF (@L_CodTipoTrabajo = '2')
		BEGIN
			--EN CASO DE AMBAS JORNADAS
			IF(@L_CodJornadaLaboralDiurna = 1 AND @L_CodJornadaLaboralExtra = 1)
			BEGIN		
				--OBTIENE LOS REGISTROS ASIGNADOS AL PUESTO DE TRABAJO CORRESPONDIENTE
				INSERT INTO @BUZONFIRMADO
				SELECT		B.TU_CodArchivo						Codigo,
							B.TC_Descripcion					Descripcion, 
							B.TF_FechaCrea						FechaCrea,	
							F.TC_NumeroExpediente				NumeroExpediente,					
							G.TU_CodLegajo						Codigo,					
							A.TF_FechaAsigna					FechaAsigna,
							A.TU_AsignadoPor					AsignadoPor,					
							C.TF_FechaAplicado					FechaAplicado,	
							C.TB_EsFirmaDigital					EsFirmaDigital,
							UsuarioAsignado.TC_UsuarioRed		UsuarioRed, 
							UsuarioAsignado.TC_Nombre			NombreFuncionario,
							UsuarioAsignado.TC_PrimerApellido	PrimerApellidoFuncionario,
							UsuarioAsignado.TC_SegundoApellido	SegundoApellidoFuncionario,
							UsuarioAsignador.TC_UsuarioRed		UsuarioRedAsignador,
							UsuarioAsignador.TC_Nombre			NombreFuncionarioAsignador,
							UsuarioAsignador.TC_PrimerApellido	PrimerApellidoFuncionarioAsignador,
							UsuarioAsignador.TC_SegundoApellido	SegundoApellidoFuncionarioAsignador,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL, 
							NULL,
							A.TU_CodAsignacionFirmado,
							C.TU_FirmadoPor,
							C.TC_CodPuestoTrabajo,
							A.TF_FechaDevolucion
				FROM		Archivo.AsignacionFirmado			A WITH(NOLOCK)
				INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
				ON			B.TU_CodArchivo						= A.TU_CodArchivo						
				INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
				ON			C.TU_CodAsignacionFirmado			= A.TU_CodAsignacionFirmado		
				AND	   	    C.TC_CodPuestoTrabajo				= COALESCE(@L_CodPuestoTrabajo, C.TC_CodPuestoTrabajo)						
				LEFT JOIN   Expediente.ArchivoExpediente		F WITH(NOLOCK) 
				ON			F.TU_CodArchivo						= A.TU_CodArchivo
				AND			F.TB_Eliminado						= 0
				LEFT JOIN   Expediente.LegajoArchivo			G WITH(NOLOCK) 
				ON			G.TU_CodArchivo						= A.TU_CodArchivo
				OUTER APPLY (
				SELECT		TOP 1 
							H.TC_UsuarioRed,		
							H.TC_Nombre,			
							H.TC_PrimerApellido,	
							H.TC_SegundoApellido
				FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
				LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
				ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
				WHERE		F.TC_CodPuestoTrabajo					= C.TC_CodPuestoTrabajo
				AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
				AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
				ORDER BY	F.TF_Inicio_Vigencia DESC
				) UsuarioAsignado
				OUTER APPLY (
				SELECT		TOP 1 
							H.TC_UsuarioRed,		
							H.TC_Nombre,			
							H.TC_PrimerApellido,	
							H.TC_SegundoApellido
				FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
				LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
				ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
				WHERE		F.TU_CodPuestoFuncionario				= A.TU_AsignadoPor	
				AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
				AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
				ORDER BY	F.TF_Inicio_Vigencia DESC
			) UsuarioAsignador
				OUTER APPLY	(/*Documentos asociados a resoluciones y que el formato jurídico asociado al documento en el contexto genera notificación automática*/							
							  SELECT		TOP 1 Z.TU_CodArchivo
							  FROM		Catalogo.FormatoJuridicoTipoOficina			K WITH(NOLOCK)
							  INNER JOIN	Catalogo.FormatoJuriComunicacionContexto	L WITH(NOLOCK)	
							  ON			L.TC_CodContexto							= @L_CodContexto
							  AND			L.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
							  INNER JOIN	Archivo.Archivo								Z WITH(NOLOCK)
							  ON			Z.TC_CodFormatoJuridico						= K.TC_CodFormatoJuridico
							  AND			Z.TC_CodFormatoJuridico						= L.TC_CodFormatoJuridico
							  AND			Z.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
							  WHERE		Z.TU_CodArchivo								= B.TU_CodArchivo
							) OA
				WHERE		(C.TF_FechaAplicado					 >= @L_FechaAsignaDesde
				AND			 C.TF_FechaAplicado					 <= @L_FechaAsignaHasta) 			
				AND			 B.TC_CodContextoCrea				 = @L_CodContexto
				AND			(C.TB_EsFirmaDigital				 = case @L_EsFirmaDigital when 2 then C.TB_EsFirmaDigital else @L_EsFirmaDigital end)				
				AND	   	     C.TC_CodPuestoTrabajo				 = COALESCE(@L_CodPuestoTrabajo, C.TC_CodPuestoTrabajo)
				AND			(@L_TodosDoc						= 1
								OR	
								(
									@L_TodosDoc					= 0
									AND
									B.TU_CodArchivo				= OA.TU_CodArchivo
								)
							)

				ORDER BY	A.TF_FechaAsigna DESC	
			END
			ELSE
			BEGIN
				-- EN CASO DE DIRUNO
				IF (@L_CodJornadaLaboralDiurna = 1)
				BEGIN
					INSERT INTO @BUZONFIRMADO
					SELECT		B.TU_CodArchivo						Codigo,
								B.TC_Descripcion					Descripcion, 
								B.TF_FechaCrea						FechaCrea,	
								F.TC_NumeroExpediente				NumeroExpediente,					
								G.TU_CodLegajo						Codigo,					
								A.TF_FechaAsigna					FechaAsigna,
								A.TU_AsignadoPor					AsignadoPor,					
								C.TF_FechaAplicado					FechaAplicado,
								C.TB_EsFirmaDigital					EsFirmaDigital,
								UsuarioAsignado.TC_UsuarioRed		UsuarioRed, 
								UsuarioAsignado.TC_Nombre			NombreFuncionario,
								UsuarioAsignado.TC_PrimerApellido	PrimerApellidoFuncionario,
								UsuarioAsignado.TC_SegundoApellido	SegundoApellidoFuncionario,
								UsuarioAsignador.TC_UsuarioRed		UsuarioRedAsignador,
								UsuarioAsignador.TC_Nombre			NombreFuncionarioAsignador,
								UsuarioAsignador.TC_PrimerApellido	PrimerApellidoFuncionarioAsignador,
								UsuarioAsignador.TC_SegundoApellido	SegundoApellidoFuncionarioAsignador,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL, 
								NULL,
								A.TU_CodAsignacionFirmado,
								C.TU_FirmadoPor,
								C.TC_CodPuestoTrabajo,
								A.TF_FechaDevolucion
					FROM		Archivo.AsignacionFirmado			A WITH(NOLOCK)
					INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
					ON			B.TU_CodArchivo						= A.TU_CodArchivo							
					INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
					ON			C.TU_CodAsignacionFirmado			= A.TU_CodAsignacionFirmado		
					AND	   	    C.TC_CodPuestoTrabajo				= COALESCE(@L_CodPuestoTrabajo, C.TC_CodPuestoTrabajo)								
					LEFT JOIN   Expediente.ArchivoExpediente		F WITH(NOLOCK) 
					ON			F.TU_CodArchivo						= A.TU_CodArchivo
					AND			F.TB_Eliminado						= 0
					LEFT JOIN   Expediente.LegajoArchivo			G WITH(NOLOCK) 
					ON			G.TU_CodArchivo						= A.TU_CodArchivo
					OUTER APPLY (
						SELECT		TOP 1 
									H.TC_UsuarioRed,		
									H.TC_Nombre,			
									H.TC_PrimerApellido,	
									H.TC_SegundoApellido
						FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
						LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
						ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
						WHERE		F.TC_CodPuestoTrabajo					= C.TC_CodPuestoTrabajo
						AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
						AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
						ORDER BY	F.TF_Inicio_Vigencia DESC
					) UsuarioAsignado	
					OUTER APPLY (
					SELECT		TOP 1 
								H.TC_UsuarioRed,		
								H.TC_Nombre,			
								H.TC_PrimerApellido,	
								H.TC_SegundoApellido
					FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
					LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
					ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
					WHERE		F.TU_CodPuestoFuncionario				= A.TU_AsignadoPor	
					AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
					AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
					ORDER BY	F.TF_Inicio_Vigencia DESC
				) UsuarioAsignador	
					OUTER APPLY	(/*Documentos asociados a resoluciones y que el formato jurídico asociado al documento en el contexto genera notificación automática*/								
								  SELECT		TOP 1 Z.TU_CodArchivo
								  FROM		Catalogo.FormatoJuridicoTipoOficina			K WITH(NOLOCK)
								  INNER JOIN	Catalogo.FormatoJuriComunicacionContexto	L WITH(NOLOCK)	
								  ON			L.TC_CodContexto							= @L_CodContexto
								  AND			L.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
								  INNER JOIN	Archivo.Archivo								Z WITH(NOLOCK)
								  ON			Z.TC_CodFormatoJuridico						= K.TC_CodFormatoJuridico
								  AND			Z.TC_CodFormatoJuridico						= L.TC_CodFormatoJuridico
								  AND			Z.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
								  WHERE		Z.TU_CodArchivo								= B.TU_CodArchivo
								) OA
					WHERE		(C.TF_FechaAplicado					 >= @L_FechaAsignaDesde
					AND			 C.TF_FechaAplicado					 <= @L_FechaAsignaHasta) 			
					AND			 B.TC_CodContextoCrea				 = @L_CodContexto
					AND			(C.TB_EsFirmaDigital				 = case @L_EsFirmaDigital when 2 then C.TB_EsFirmaDigital else @L_EsFirmaDigital end)				
					AND	   	     C.TC_CodPuestoTrabajo				 = COALESCE(@L_CodPuestoTrabajo, C.TC_CodPuestoTrabajo)
					AND			(CONVERT(varchar(8), A.TF_FechaAsigna, 108) >= CONVERT(varchar(8), '07:30:00',108)				
					AND	  		 CONVERT(varchar(8), A.TF_FechaAsigna, 108) <= CONVERT(varchar(8), '16:30:00',108))
					AND			(@L_TodosDoc						= 1
									OR	
									(
										@L_TodosDoc					= 0
										AND
										B.TU_CodArchivo				= OA.TU_CodArchivo
									)
								)
					
					ORDER BY	 A.TF_FechaAsigna DESC	
				END
				ELSE
				BEGIN
					INSERT INTO @BUZONFIRMADO
					SELECT		B.TU_CodArchivo						Codigo,
								B.TC_Descripcion					Descripcion, 
								B.TF_FechaCrea						FechaCrea,	
								F.TC_NumeroExpediente				NumeroExpediente,					
								G.TU_CodLegajo						Codigo,					
								A.TF_FechaAsigna					FechaAsigna,
								A.TU_AsignadoPor					AsignadoPor,					
								C.TF_FechaAplicado					FechaAplicado,
								C.TB_EsFirmaDigital					EsFirmaDigital,
								UsuarioAsignado.TC_UsuarioRed		UsuarioRed, 
								UsuarioAsignado.TC_Nombre			NombreFuncionario,
								UsuarioAsignado.TC_PrimerApellido	PrimerApellidoFuncionario,
								UsuarioAsignado.TC_SegundoApellido	SegundoApellidoFuncionario,
								UsuarioAsignador.TC_UsuarioRed		UsuarioRedAsignador,
								UsuarioAsignador.TC_Nombre			NombreFuncionarioAsignador,
								UsuarioAsignador.TC_PrimerApellido	PrimerApellidoFuncionarioAsignador,
								UsuarioAsignador.TC_SegundoApellido	SegundoApellidoFuncionarioAsignador,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL, 
								NULL,
								A.TU_CodAsignacionFirmado,
								C.TU_FirmadoPor,
								C.TC_CodPuestoTrabajo,
								A.TF_FechaDevolucion
					FROM		Archivo.AsignacionFirmado			A WITH(NOLOCK)
					INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
					ON			B.TU_CodArchivo						= A.TU_CodArchivo							
					INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
					ON			C.TU_CodAsignacionFirmado			= A.TU_CodAsignacionFirmado		
					AND	   	    C.TC_CodPuestoTrabajo				= COALESCE(@L_CodPuestoTrabajo, C.TC_CodPuestoTrabajo)								
					LEFT JOIN   Expediente.ArchivoExpediente		F WITH(NOLOCK) 
					ON			F.TU_CodArchivo						= A.TU_CodArchivo
					AND			F.TB_Eliminado						= 0
					LEFT JOIN   Expediente.LegajoArchivo			G WITH(NOLOCK) 
					ON			G.TU_CodArchivo						= A.TU_CodArchivo
					OUTER APPLY (
					SELECT		TOP 1 
								H.TC_UsuarioRed,		
								H.TC_Nombre,			
								H.TC_PrimerApellido,	
								H.TC_SegundoApellido
					FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
					LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
					ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
					WHERE		F.TC_CodPuestoTrabajo					= C.TC_CodPuestoTrabajo
					AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
					AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
					ORDER BY	F.TF_Inicio_Vigencia DESC
					) UsuarioAsignado	
					OUTER APPLY (
						SELECT		TOP 1 
									H.TC_UsuarioRed,		
									H.TC_Nombre,			
									H.TC_PrimerApellido,	
									H.TC_SegundoApellido
						FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
						LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
						ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
						WHERE		F.TU_CodPuestoFuncionario				= A.TU_AsignadoPor	
						AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
						AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
						ORDER BY	F.TF_Inicio_Vigencia DESC
					) UsuarioAsignador
					OUTER APPLY	(/*Documentos asociados a resoluciones y que el formato jurídico asociado al documento en el contexto genera notificación automática*/								
								  SELECT		TOP 1 Z.TU_CodArchivo
								  FROM		Catalogo.FormatoJuridicoTipoOficina			K WITH(NOLOCK)
								  INNER JOIN	Catalogo.FormatoJuriComunicacionContexto	L WITH(NOLOCK)	
								  ON			L.TC_CodContexto							= @L_CodContexto
								  AND			L.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
								  INNER JOIN	Archivo.Archivo								Z WITH(NOLOCK)
								  ON			Z.TC_CodFormatoJuridico						= K.TC_CodFormatoJuridico
								  AND			Z.TC_CodFormatoJuridico						= L.TC_CodFormatoJuridico
								  AND			Z.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
								  WHERE		Z.TU_CodArchivo								= B.TU_CodArchivo
								) OA
					WHERE		(C.TF_FechaAplicado					 >= @L_FechaAsignaDesde
					AND			 C.TF_FechaAplicado					 <= @L_FechaAsignaHasta) 			
					AND		 	 B.TC_CodContextoCrea				 = @L_CodContexto
					AND			(C.TB_EsFirmaDigital				 = case @L_EsFirmaDigital when 2 then C.TB_EsFirmaDigital else @L_EsFirmaDigital end)				
					AND	   	     C.TC_CodPuestoTrabajo				 = COALESCE(@L_CodPuestoTrabajo, C.TC_CodPuestoTrabajo)
					AND			(CONVERT(varchar(8), A.TF_FechaAsigna, 108) < CONVERT(varchar(8), '07:30:00',108)
					OR	  		 CONVERT(varchar(8), A.TF_FechaAsigna, 108) > CONVERT(varchar(8), '16:30:00',108)) 
					AND			(@L_TodosDoc						= 1
									OR	
									(
										@L_TodosDoc					= 0
										AND
										B.TU_CodArchivo				= OA.TU_CodArchivo
									)
								)

					ORDER BY	A.TF_FechaAsigna DESC	
				END
			END

			--BORRAMOS LOS REGISTROS QUE NO CORRESPONDEN AL USUARIO
			IF (@L_UsuarioTrabajo IS NOT NULL AND @L_UsuarioTrabajo <> '')
			BEGIN
				DELETE FROM @BUZONFIRMADO
				WHERE TU_FirmadoPor NOT IN (SELECT * FROM @PUESTOSTRABAJOFUNCIONARIOTABLA)
			END

			--BORRAMOS LOS REGISTROS QUE NO CORRESPONDEN AL USUARIO ASIGNADOR
			IF (@L_UsuarioTrabajoAsignador IS NOT NULL AND @L_UsuarioTrabajoAsignador <> '')
			BEGIN
				DELETE FROM @BUZONFIRMADO
				WHERE TU_AsignadoPor NOT IN (SELECT * FROM @PUESTOSTRABAJOFUNCIONARIOASIGNADORTABLA)
			END
		
			--Obtener cantidad registros de la consulta
			SELECT  @L_TotalRegistros = COUNT(*) FROM @BUZONFIRMADO;
				
			--***********************************************************************************************************************************************
			--ACTUALIZACION DE CAMPOS DE CANTIDAD SEGUN CRITERIO
			--***********************************************************************************************************************************************

			UPDATE		@BUZONFIRMADO
			SET			TN_CantidadDocumentosCorregidos = 0

			--EXPEDIENTES ASIGNADOS AL PUESTO DE TRABAJO		
			SELECT		@L_CantidadExpedientesAsignados = ISNULL(COUNT(DISTINCT(A.TC_NumeroExpediente)), 0)
			FROM		@BUZONFIRMADO				 A
			INNER JOIN	Archivo.AsignacionFirmado	 B WITH(NOLOCK)	
			ON			B.TU_CodAsignacionFirmado	 = A.TU_CodAsignacionFirmado		
			LEFT JOIN	Expediente.ArchivoExpediente C WITH(NOLOCK)	
			ON			C.TU_CodArchivo				 = B.TU_CodArchivo
			LEFT JOIN	Expediente.LegajoArchivo	 D WITH(NOLOCK)	
			ON			D.TU_CodArchivo				 = B.TU_CodArchivo		
			

			UPDATE		@BUZONFIRMADO
			SET			TN_CantidadExpedientesAsignados = @L_CantidadExpedientesAsignados

			--DOCUMENTOS ASIGNADOS AL PUESTO DE TRABAJO
			SELECT		@L_CantidadDocumentosAsignados = ISNULL(COUNT(DISTINCT(A.TU_CodArchivo)), 0)
			FROM		@BUZONFIRMADO				 A

			UPDATE		@BUZONFIRMADO
			SET			TN_CantidadDocumentosAsignados = @L_CantidadDocumentosAsignados

			--EXPEDIENTES FIRMADOS
			SELECT		@L_CantidadExpedientesFirmados = ISNULL(COUNT(DISTINCT(A.TC_NumeroExpediente)), 0)
			FROM		@BUZONFIRMADO				A
			WHERE		A.TF_FechaAplicado			IS NOT NULL		

			UPDATE		@BUZONFIRMADO
			SET			TN_CantidadExpedientesFirmados = @L_CantidadExpedientesFirmados

			--DOCUMENTO SIN EXPEDIENTE
			SELECT		@L_CantidadDocumentosSinExpediente = ISNULL(COUNT(A.TU_CodArchivo), 0)
			FROM		@BUZONFIRMADO								A
			INNER JOIN	ArchivoSinExpediente.ArchivoSinExpediente   B WITH(NOLOCK) 
			ON			B.TU_CodArchivo								= A.TU_CodArchivo

			UPDATE		@BUZONFIRMADO
			SET			TN_CantidadDocumentosSinExpediente = @L_CantidadDocumentosSinExpediente

			--FIRMAS APLICADAS
			SELECT		@L_CantidadFirmasAplicadas = ISNULL(COUNT(A.TU_CodAsignacionFirmado), 0)
			FROM		@BUZONFIRMADO				A
			WHERE		A.TF_FechaAplicado			IS NOT NULL		

			UPDATE		@BUZONFIRMADO
			SET			TN_CantidadFirmasAplicadas = @L_CantidadFirmasAplicadas

			--DOCUMENTOS PENDIENTES
			SELECT		@L_CantidadDocumentosPendientes = ISNULL(COUNT(DISTINCT(A.TU_CodArchivo)), 0)
			FROM		@BUZONFIRMADO				A
			WHERE		A.TF_FechaAplicado			IS NULL	
			AND			A.TF_FechaDevolucion		IS NULL			

			UPDATE		@BUZONFIRMADO
			SET			TN_CantidadDocumentosPedientes = @L_CantidadDocumentosPendientes

			--DOCUMENTOS DEVUELTOS
			SELECT		@L_CantidadDocumentosDevueltos = ISNULL(COUNT(DISTINCT(A.TU_CodArchivo)), 0)
			FROM		@BUZONFIRMADO				A
			WHERE		A.TF_FechaDevolucion		IS NOT NULL			

			UPDATE		@BUZONFIRMADO
			SET			TN_CantidadDocumentosDevueltos = @L_CantidadDocumentosDevueltos

			--DOCUMENTOS URGENTES
			SELECT		@L_CantidadDocumentosUrgentes = ISNULL(COUNT(A.TU_CodArchivo), 0)		
			FROM		@BUZONFIRMADO				A
			INNER JOIN  Archivo.AsignacionFirmado   B WITH(NOLOCK)
			ON			B.TU_CodAsignacionFirmado	= A.TU_CodAsignacionFirmado
			WHERE		B.TB_Urgente				= 1
			GROUP BY	A.TU_CodArchivo

			UPDATE		@BUZONFIRMADO
			SET			TN_CantidadDocumentosUrgentes = @L_CantidadDocumentosUrgentes
		END
		ELSE
		BEGIN
			IF (@L_CodTipoTrabajo = '3')
				BEGIN	
					IF (ISNULL(@L_CodPuestotrabajoAsignador,'') <> @L_CodPuestoTrabajo)
					BEGIN	
						--EN CASO DE AMBAS JORNADAS
						IF(@L_CodJornadaLaboralDiurna = 1 AND @L_CodJornadaLaboralExtra = 1)
						BEGIN							
							--OBTIENE LOS REGISTROS ASIGNADOS AL PUESTO DE TRABAJO CORRESPONDIENTE
							INSERT INTO @BUZONFIRMADO
							SELECT		B.TU_CodArchivo						Codigo,
										B.TC_Descripcion					Descripcion, 
										B.TF_FechaCrea						FechaCrea,	
										F.TC_NumeroExpediente				NumeroExpediente,					
										G.TU_CodLegajo						Codigo,					
										A.TF_FechaAsigna					FechaAsigna,
										A.TU_AsignadoPor					AsignadoPor,					
										C.TF_FechaAplicado					FechaAplicado,
										C.TB_EsFirmaDigital					EsFirmaDigital,
										UsuarioAsignado.TC_UsuarioRed		UsuarioRed, 
										UsuarioAsignado.TC_Nombre			NombreFuncionario,
										UsuarioAsignado.TC_PrimerApellido	PrimerApellidoFuncionario,
										UsuarioAsignado.TC_SegundoApellido	SegundoApellidoFuncionario,
										UsuarioAsignador.TC_UsuarioRed		UsuarioRedAsignador,
										UsuarioAsignador.TC_Nombre			NombreFuncionarioAsignador,
										UsuarioAsignador.TC_PrimerApellido	PrimerApellidoFuncionarioAsignador,
										UsuarioAsignador.TC_SegundoApellido	SegundoApellidoFuncionarioAsignador,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL, 
										NULL,
										A.TU_CodAsignacionFirmado,
										C.TU_FirmadoPor,
										C.TC_CodPuestoTrabajo,
										A.TF_FechaDevolucion
							FROM		Archivo.AsignacionFirmado			A WITH(NOLOCK)
							INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
							ON			B.TU_CodArchivo						= A.TU_CodArchivo														
							INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
							ON			C.TU_CodAsignacionFirmado			= A.TU_CodAsignacionFirmado		
							AND	   	    C.TC_CodPuestoTrabajo				= COALESCE(@L_CodPuestoTrabajoAsignador, C.TC_CodPuestoTrabajo)		
							--Se extrae el ultimo usuario para asignarlo a la consulta de los pendientes de firma, ya que la tabla Archivo.AsignacionFirmante solo tiene el puesto de trabajo, y se requiere puesto trabajo funcionario
							OUTER APPLY (
								SELECT		TOP 1 F.TC_UsuarioRed, F.TU_CodPuestoFuncionario
								FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
								WHERE		F.TC_CodPuestoTrabajo					= @CodPuestoTrabajo
								AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
								AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
								AND			@CodPuestoTrabajo						IS NOT NULL
								ORDER BY	F.TF_Inicio_Vigencia DESC
							) PTF
							LEFT JOIN   Expediente.ArchivoExpediente		F WITH(NOLOCK) 
							ON			F.TU_CodArchivo						= A.TU_CodArchivo
							AND			F.TB_Eliminado						= 0
							LEFT JOIN   Expediente.LegajoArchivo			G WITH(NOLOCK) 
							ON			G.TU_CodArchivo						= A.TU_CodArchivo
							OUTER APPLY (
							SELECT		TOP 1 
										H.TC_UsuarioRed,		
										H.TC_Nombre,			
										H.TC_PrimerApellido,	
										H.TC_SegundoApellido
							FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
							LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
							ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
							WHERE		F.TC_CodPuestoTrabajo					= C.TC_CodPuestoTrabajo
							AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
							AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
							ORDER BY	F.TF_Inicio_Vigencia DESC
							) UsuarioAsignado	
							OUTER APPLY (
								SELECT		TOP 1 
											H.TC_UsuarioRed,		
											H.TC_Nombre,			
											H.TC_PrimerApellido,	
											H.TC_SegundoApellido
								FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
								LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
								ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
								WHERE		F.TU_CodPuestoFuncionario				= A.TU_AsignadoPor	
								AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
								AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
								ORDER BY	F.TF_Inicio_Vigencia DESC
							) UsuarioAsignador							
							OUTER APPLY	(/*Documentos asociados a resoluciones y que el formato jurídico asociado al documento en el contexto genera notificación automática*/										
										  SELECT		TOP 1 Z.TU_CodArchivo
										  FROM			Catalogo.FormatoJuridicoTipoOficina			K WITH(NOLOCK)
										  INNER JOIN	Catalogo.FormatoJuriComunicacionContexto	L WITH(NOLOCK)	
										  ON			L.TC_CodContexto							= @L_CodContexto
										  AND			L.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
										  INNER JOIN	Archivo.Archivo								Z WITH(NOLOCK)
										  ON			Z.TC_CodFormatoJuridico						= K.TC_CodFormatoJuridico
										  AND			Z.TC_CodFormatoJuridico						= L.TC_CodFormatoJuridico
										  AND			Z.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
										  WHERE		Z.TU_CodArchivo								= B.TU_CodArchivo
										) OA
							WHERE		(A.TF_FechaAsigna					>= @L_FechaAsignaDesde
							AND			 A.TF_FechaAsigna					<= @L_FechaAsignaHasta) 			
							AND			 B.TC_CodContextoCrea				 = @L_CodContexto							
							--AND	   	     C.TC_CodPuestoTrabajo				 = @L_CodPuestoTrabajo
							AND			(@L_TodosDoc						= 1
											OR	
											(
												@L_TodosDoc					= 0
												AND
												B.TU_CodArchivo				= OA.TU_CodArchivo
											)
										)
						AND			(@CodPuestoTrabajo					IS NULL
										OR PTF.TC_UsuarioRed			= ISNULL(@L_UsuarioTrabajo, PTF.TC_UsuarioRed)
									)	
							ORDER BY	A.TF_FechaAsigna DESC	
						END
						ELSE
						BEGIN
							-- EN CASO DE DIRUNO
							IF (@L_CodJornadaLaboralDiurna = 1)
							BEGIN
								INSERT INTO @BUZONFIRMADO
								SELECT		B.TU_CodArchivo						Codigo,
											B.TC_Descripcion					Descripcion, 
											B.TF_FechaCrea						FechaCrea,	
											F.TC_NumeroExpediente				NumeroExpediente,					
											G.TU_CodLegajo						Codigo,					
											A.TF_FechaAsigna					FechaAsigna,
											A.TU_AsignadoPor					AsignadoPor,					
											C.TF_FechaAplicado					FechaAplicado,
											C.TB_EsFirmaDigital					EsFirmaDigital,
											UsuarioAsignado.TC_UsuarioRed		UsuarioRed, 
											UsuarioAsignado.TC_Nombre			NombreFuncionario,
											UsuarioAsignado.TC_PrimerApellido	PrimerApellidoFuncionario,
											UsuarioAsignado.TC_SegundoApellido	SegundoApellidoFuncionario,
											UsuarioAsignador.TC_UsuarioRed		UsuarioRedAsignador,
											UsuarioAsignador.TC_Nombre			NombreFuncionarioAsignador,
											UsuarioAsignador.TC_PrimerApellido	PrimerApellidoFuncionarioAsignador,
											UsuarioAsignador.TC_SegundoApellido	SegundoApellidoFuncionarioAsignador,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL, 
											NULL,
											A.TU_CodAsignacionFirmado,
											C.TU_FirmadoPor,
											C.TC_CodPuestoTrabajo,
											A.TF_FechaDevolucion
								FROM		Archivo.AsignacionFirmado			A WITH(NOLOCK)
								INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
								ON			B.TU_CodArchivo						= A.TU_CodArchivo										
								INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
								ON			C.TU_CodAsignacionFirmado			= A.TU_CodAsignacionFirmado		
								AND	   	    C.TC_CodPuestoTrabajo				= COALESCE(@L_CodPuestoTrabajo, C.TC_CodPuestoTrabajo)								
								--Se extrae el ultimo usuario para asignarlo a la consulta de los pendientes de firma, ya que la tabla Archivo.AsignacionFirmante solo tiene el puesto de trabajo, y se requiere puesto trabajo funcionario
								OUTER APPLY (
									SELECT		TOP 1 F.TC_UsuarioRed, F.TU_CodPuestoFuncionario
									FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
									WHERE		F.TC_CodPuestoTrabajo					= @CodPuestoTrabajo
									AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
									AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
									AND			@CodPuestoTrabajo						IS NOT NULL
									ORDER BY	F.TF_Inicio_Vigencia DESC
								) PTF
								LEFT JOIN   Expediente.ArchivoExpediente		F WITH(NOLOCK) 
								ON			F.TU_CodArchivo						= A.TU_CodArchivo
								AND			F.TB_Eliminado						= 0
								LEFT JOIN   Expediente.LegajoArchivo			G WITH(NOLOCK) 
								ON			G.TU_CodArchivo						= A.TU_CodArchivo
								OUTER APPLY (
								SELECT		TOP 1 
											H.TC_UsuarioRed,		
											H.TC_Nombre,			
											H.TC_PrimerApellido,	
											H.TC_SegundoApellido
								FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
								LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
								ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
								WHERE		F.TC_CodPuestoTrabajo					= C.TC_CodPuestoTrabajo
								AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
								AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
								ORDER BY	F.TF_Inicio_Vigencia DESC
							) UsuarioAsignado
							OUTER APPLY (
								SELECT		TOP 1 
											H.TC_UsuarioRed,		
											H.TC_Nombre,			
											H.TC_PrimerApellido,	
											H.TC_SegundoApellido
								FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
								LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
								ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
								WHERE		F.TU_CodPuestoFuncionario				= A.TU_AsignadoPor	
								AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
								AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
								ORDER BY	F.TF_Inicio_Vigencia DESC
							) UsuarioAsignador	
								OUTER APPLY	(/*Documentos asociados a resoluciones y que el formato jurídico asociado al documento en el contexto genera notificación automática*/											
											  SELECT		TOP 1 Z.TU_CodArchivo
											  FROM		Catalogo.FormatoJuridicoTipoOficina			K WITH(NOLOCK)
											  INNER JOIN	Catalogo.FormatoJuriComunicacionContexto	L WITH(NOLOCK)	
											  ON			L.TC_CodContexto							= @L_CodContexto
											  AND			L.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
											  INNER JOIN	Archivo.Archivo								Z WITH(NOLOCK)
											  ON			Z.TC_CodFormatoJuridico						= K.TC_CodFormatoJuridico
											  AND			Z.TC_CodFormatoJuridico						= L.TC_CodFormatoJuridico
											  AND			Z.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
											  WHERE		Z.TU_CodArchivo								= B.TU_CodArchivo
											) OA
								WHERE		(A.TF_FechaAsigna					>= @L_FechaAsignaDesde
								AND			 A.TF_FechaAsigna					<= @L_FechaAsignaHasta) 			
								AND			 B.TC_CodContextoCrea				 = @L_CodContexto							
								AND	   	     C.TC_CodPuestoTrabajo				 = @L_CodPuestoTrabajo
								AND			(CONVERT(varchar(8), A.TF_FechaAsigna, 108) >= CONVERT(varchar(8), '07:30:00',108)
								AND	  		 CONVERT(varchar(8), A.TF_FechaAsigna, 108) <= CONVERT(varchar(8), '16:30:00',108))
								AND			(@L_TodosDoc						= 1
												OR	
												(
													@L_TodosDoc					= 0
													AND
													B.TU_CodArchivo				= OA.TU_CodArchivo
												)
											)
								AND			(@CodPuestoTrabajo					IS NULL
												OR PTF.TC_UsuarioRed			= ISNULL(@L_UsuarioTrabajo, PTF.TC_UsuarioRed)
											)
								ORDER BY	A.TF_FechaAsigna DESC
							END
							ELSE --EN CASO DE SER EXTRAORDINARIO
							BEGIN
								INSERT INTO @BUZONFIRMADO
								SELECT		B.TU_CodArchivo						Codigo,
											B.TC_Descripcion					Descripcion, 
											B.TF_FechaCrea						FechaCrea,	
											F.TC_NumeroExpediente				NumeroExpediente,					
											G.TU_CodLegajo						Codigo,					
											A.TF_FechaAsigna					FechaAsigna,
											A.TU_AsignadoPor					AsignadoPor,					
											C.TF_FechaAplicado					FechaAplicado,
											C.TB_EsFirmaDigital					EsFirmaDigital,
											UsuarioAsignado.TC_UsuarioRed		UsuarioRed, 
											UsuarioAsignado.TC_Nombre			NombreFuncionario,
											UsuarioAsignado.TC_PrimerApellido	PrimerApellidoFuncionario,
											UsuarioAsignado.TC_SegundoApellido	SegundoApellidoFuncionario,
											UsuarioAsignador.TC_UsuarioRed		UsuarioRedAsignador,
											UsuarioAsignador.TC_Nombre			NombreFuncionarioAsignador,
											UsuarioAsignador.TC_PrimerApellido	PrimerApellidoFuncionarioAsignador,
											UsuarioAsignador.TC_SegundoApellido	SegundoApellidoFuncionarioAsignador,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL, 
											NULL,
											A.TU_CodAsignacionFirmado,
											C.TU_FirmadoPor,
											C.TC_CodPuestoTrabajo,
											A.TF_FechaDevolucion
								FROM		Archivo.AsignacionFirmado			A WITH(NOLOCK)
								INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
								ON			B.TU_CodArchivo						= A.TU_CodArchivo										
								INNER JOIN	Archivo.AsignacionFirmante			C WITH(NOLOCK)
								ON			C.TU_CodAsignacionFirmado			= A.TU_CodAsignacionFirmado		
								AND	   	    C.TC_CodPuestoTrabajo				= COALESCE(@L_CodPuestoTrabajo, C.TC_CodPuestoTrabajo)		
								--Se extrae el ultimo usuario para asignarlo a la consulta de los pendientes de firma, ya que la tabla Archivo.AsignacionFirmante solo tiene el puesto de trabajo, y se requiere puesto trabajo funcionario
								OUTER APPLY (
									SELECT		TOP 1 F.TC_UsuarioRed, F.TU_CodPuestoFuncionario
									FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
									WHERE		F.TC_CodPuestoTrabajo					= @CodPuestoTrabajo
									AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
									AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
									AND			@CodPuestoTrabajo						IS NOT NULL
									ORDER BY	F.TF_Inicio_Vigencia DESC
								) PTF
								LEFT JOIN   Expediente.ArchivoExpediente		F WITH(NOLOCK) 
								ON			F.TU_CodArchivo						= A.TU_CodArchivo
								AND			F.TB_Eliminado						= 0
								LEFT JOIN   Expediente.LegajoArchivo			G WITH(NOLOCK) 
								ON			G.TU_CodArchivo						= A.TU_CodArchivo
								OUTER APPLY (
								SELECT		TOP 1 
											H.TC_UsuarioRed,		
											H.TC_Nombre,			
											H.TC_PrimerApellido,	
											H.TC_SegundoApellido
								FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
								LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
								ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
								WHERE		F.TC_CodPuestoTrabajo					= C.TC_CodPuestoTrabajo
								AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
								AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
								ORDER BY	F.TF_Inicio_Vigencia DESC
							) UsuarioAsignado
							OUTER APPLY (
								SELECT		TOP 1 
											H.TC_UsuarioRed,		
											H.TC_Nombre,			
											H.TC_PrimerApellido,	
											H.TC_SegundoApellido
								FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
								LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
								ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
								WHERE		F.TU_CodPuestoFuncionario				= A.TU_AsignadoPor	
								AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
								AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
								ORDER BY	F.TF_Inicio_Vigencia DESC
							) UsuarioAsignador	
								OUTER APPLY	(/*Documentos asociados a resoluciones y que el formato jurídico asociado al documento en el contexto genera notificación automática*/											
											  SELECT		TOP 1 Z.TU_CodArchivo
											  FROM		Catalogo.FormatoJuridicoTipoOficina			K WITH(NOLOCK)
											  INNER JOIN	Catalogo.FormatoJuriComunicacionContexto	L WITH(NOLOCK)	
											  ON			L.TC_CodContexto							= @L_CodContexto
											  AND			L.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
											  INNER JOIN	Archivo.Archivo								Z WITH(NOLOCK)
											  ON			Z.TC_CodFormatoJuridico						= K.TC_CodFormatoJuridico
											  AND			Z.TC_CodFormatoJuridico						= L.TC_CodFormatoJuridico
											  AND			Z.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
											  WHERE		Z.TU_CodArchivo								= B.TU_CodArchivo
											) OA
								WHERE		(A.TF_FechaAsigna					>= @L_FechaAsignaDesde
								AND			 A.TF_FechaAsigna					<= @L_FechaAsignaHasta) 			
								AND			 B.TC_CodContextoCrea				 = @L_CodContexto							
								AND	   	     C.TC_CodPuestoTrabajo				 = @L_CodPuestoTrabajo
								AND			(CONVERT(varchar(8), A.TF_FechaAsigna, 108) < CONVERT(varchar(8), '07:30:00',108)
								OR	  		 CONVERT(varchar(8), A.TF_FechaAsigna, 108) > CONVERT(varchar(8), '16:30:00',108)) 
								AND			(@L_TodosDoc						= 1
												OR	
												(
													@L_TodosDoc					= 0
													AND
													B.TU_CodArchivo				= OA.TU_CodArchivo
												)
											)
								AND			(@CodPuestoTrabajo					IS NULL
												OR PTF.TC_UsuarioRed			= ISNULL(@L_UsuarioTrabajo, PTF.TC_UsuarioRed)
											)
								ORDER BY	A.TF_FechaAsigna DESC
							END
						END
					END
					ELSE
					BEGIN
						IF(@L_CodJornadaLaboralDiurna = 1 AND @L_CodJornadaLaboralExtra = 1)
						BEGIN
							--OBTIENE LOS REGISTROS ASIGNADOS AL PUESTO DE TRABAJO CORRESPONDIENTE
							INSERT INTO @BUZONFIRMADO
							SELECT		B.TU_CodArchivo						Codigo,
										B.TC_Descripcion					Descripcion, 
										B.TF_FechaCrea						FechaCrea,	
										F.TC_NumeroExpediente				NumeroExpediente,					
										G.TU_CodLegajo						Codigo,					
										A.TF_FechaAsigna					FechaAsigna,
										A.TU_AsignadoPor					AsignadoPor,					
										null								FechaAplicado,
										null								EsFirmaDigital,
										' '									UsuarioRed, 
										' '									NombreFuncionario,
										' '									PrimerApellidoFuncionario,
										' '									SegundoApellidoFuncionario,
										UsuarioAsignador.TC_UsuarioRed		UsuarioRedAsignador,
										UsuarioAsignador.TC_Nombre			NombreFuncionarioAsignador,
										UsuarioAsignador.TC_PrimerApellido	PrimerApellidoFuncionarioAsignador,
										UsuarioAsignador.TC_SegundoApellido	SegundoApellidoFuncionarioAsignador,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL, 
										NULL,
										A.TU_CodAsignacionFirmado,
										NULL,
										NULL,
										A.TF_FechaDevolucion
							FROM		Archivo.AsignacionFirmado			A WITH(NOLOCK)
							INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
							ON			B.TU_CodArchivo						= A.TU_CodArchivo									
							LEFT JOIN   Expediente.ArchivoExpediente		F WITH(NOLOCK) 
							ON			F.TU_CodArchivo						= A.TU_CodArchivo
							AND			F.TB_Eliminado						= 0
							LEFT JOIN   Expediente.LegajoArchivo			G WITH(NOLOCK) 
							ON			G.TU_CodArchivo						= A.TU_CodArchivo
							OUTER APPLY (
								SELECT		TOP 1 
											H.TC_UsuarioRed,		
											H.TC_Nombre,			
											H.TC_PrimerApellido,	
											H.TC_SegundoApellido
								FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
								LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
								ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
								WHERE		F.TU_CodPuestoFuncionario				= A.TU_AsignadoPor	
								AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
								AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
								ORDER BY	F.TF_Inicio_Vigencia DESC
							) UsuarioAsignador	
							OUTER APPLY	(/*Documentos asociados a resoluciones y que el formato jurídico asociado al documento en el contexto genera notificación automática*/										
										  SELECT		TOP 1 Z.TU_CodArchivo
										  FROM		Catalogo.FormatoJuridicoTipoOficina			K WITH(NOLOCK)
										  INNER JOIN	Catalogo.FormatoJuriComunicacionContexto	L WITH(NOLOCK)	
										  ON			L.TC_CodContexto							= @L_CodContexto
										  AND			L.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
										  INNER JOIN	Archivo.Archivo								Z WITH(NOLOCK)
										  ON			Z.TC_CodFormatoJuridico						= K.TC_CodFormatoJuridico
										  AND			Z.TC_CodFormatoJuridico						= L.TC_CodFormatoJuridico
										  AND			Z.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
										  WHERE		Z.TU_CodArchivo								= B.TU_CodArchivo
										) OA
							WHERE		(A.TF_FechaAsigna					>= @L_FechaAsignaDesde
							AND			 A.TF_FechaAsigna					<= @L_FechaAsignaHasta) 			
							AND			 B.TC_CodContextoCrea				 = @L_CodContexto		
							AND			(@L_TodosDoc						= 1
											OR	
											(
												@L_TodosDoc					= 0
												AND
												B.TU_CodArchivo				= OA.TU_CodArchivo
											)
										)

							ORDER BY	A.TF_FechaAsigna DESC	
						END
						ELSE
						BEGIN
							-- EN CASO DE DIRUNO
							IF (@L_CodJornadaLaboralDiurna = 1)
							BEGIN
								INSERT INTO @BUZONFIRMADO
								SELECT		B.TU_CodArchivo						Codigo,
											B.TC_Descripcion					Descripcion, 
											B.TF_FechaCrea						FechaCrea,	
											F.TC_NumeroExpediente				NumeroExpediente,					
											G.TU_CodLegajo						Codigo,					
											A.TF_FechaAsigna					FechaAsigna,
											A.TU_AsignadoPor					AsignadoPor,					
											null								FechaAplicado,
											null								EsFirmaDigital,
											' '									UsuarioRed, 
											' '									NombreFuncionario,
											' '									PrimerApellidoFuncionario,
											' '									SegundoApellidoFuncionario,
											UsuarioAsignador.TC_UsuarioRed		UsuarioRedAsignador,
											UsuarioAsignador.TC_Nombre			NombreFuncionarioAsignador,
											UsuarioAsignador.TC_PrimerApellido	PrimerApellidoFuncionarioAsignador,
											UsuarioAsignador.TC_SegundoApellido	SegundoApellidoFuncionarioAsignador,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL, 
											NULL,
											A.TU_CodAsignacionFirmado,
											NULL,
											NULL,
											A.TF_FechaDevolucion
								FROM		Archivo.AsignacionFirmado			A WITH(NOLOCK)
								INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
								ON			B.TU_CodArchivo						= A.TU_CodArchivo										
								LEFT JOIN   Expediente.ArchivoExpediente		F WITH(NOLOCK) 
								ON			F.TU_CodArchivo						= A.TU_CodArchivo
								AND			F.TB_Eliminado						= 0
								LEFT JOIN   Expediente.LegajoArchivo			G WITH(NOLOCK) 
								ON			G.TU_CodArchivo						= A.TU_CodArchivo
								OUTER APPLY (
									SELECT		TOP 1 
												H.TC_UsuarioRed,		
												H.TC_Nombre,			
												H.TC_PrimerApellido,	
												H.TC_SegundoApellido
									FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
									LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
									ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
									WHERE		F.TU_CodPuestoFuncionario				= A.TU_AsignadoPor	
									AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
									AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
									ORDER BY	F.TF_Inicio_Vigencia DESC
								) UsuarioAsignador	
								OUTER APPLY	(/*Documentos asociados a resoluciones y que el formato jurídico asociado al documento en el contexto genera notificación automática*/											
											  SELECT		TOP 1 Z.TU_CodArchivo
											  FROM		Catalogo.FormatoJuridicoTipoOficina			K WITH(NOLOCK)
											  INNER JOIN	Catalogo.FormatoJuriComunicacionContexto	L WITH(NOLOCK)	
											  ON			L.TC_CodContexto							= @L_CodContexto
											  AND			L.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
											  INNER JOIN	Archivo.Archivo								Z WITH(NOLOCK)
											  ON			Z.TC_CodFormatoJuridico						= K.TC_CodFormatoJuridico
											  AND			Z.TC_CodFormatoJuridico						= L.TC_CodFormatoJuridico
											  AND			Z.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
											  WHERE		Z.TU_CodArchivo								= B.TU_CodArchivo
											) OA
								WHERE		(A.TF_FechaAsigna					>= @L_FechaAsignaDesde
								AND			 A.TF_FechaAsigna					<= @L_FechaAsignaHasta) 			
								AND			 B.TC_CodContextoCrea				 = @L_CodContexto							
								AND			(CONVERT(varchar(8), A.TF_FechaAsigna, 108) >= CONVERT(varchar(8), '07:30:00',108)
								AND	  		 CONVERT(varchar(8), A.TF_FechaAsigna, 108) <= CONVERT(varchar(8), '16:30:00',108))
								AND			(@L_TodosDoc						= 1
												OR	
												(
													@L_TodosDoc					= 0
													AND
													B.TU_CodArchivo				= OA.TU_CodArchivo
												)
											)

								ORDER BY	A.TF_FechaAsigna DESC
							END
							ELSE --EN CASO DE SER EXTRAORDINARIO
							BEGIN
								INSERT INTO @BUZONFIRMADO
								SELECT		B.TU_CodArchivo						Codigo,
											B.TC_Descripcion					Descripcion, 
											B.TF_FechaCrea						FechaCrea,	
											F.TC_NumeroExpediente				NumeroExpediente,					
											G.TU_CodLegajo						Codigo,					
											A.TF_FechaAsigna					FechaAsigna,
											A.TU_AsignadoPor					AsignadoPor,					
											null								FechaAplicado,		
											null								EsFirmaDigital,
											' '									UsuarioRed, 
											' '									NombreFuncionario,
											' '									PrimerApellidoFuncionario,
											' '									SegundoApellidoFuncionario,
											UsuarioAsignador.TC_UsuarioRed		UsuarioRedAsignador,
											UsuarioAsignador.TC_Nombre			NombreFuncionarioAsignador,
											UsuarioAsignador.TC_PrimerApellido	PrimerApellidoFuncionarioAsignador,
											UsuarioAsignador.TC_SegundoApellido	SegundoApellidoFuncionarioAsignador,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL,
											NULL, 
											NULL,
											A.TU_CodAsignacionFirmado,
											NULL,
											NULL,
											A.TF_FechaDevolucion
								FROM		Archivo.AsignacionFirmado			A WITH(NOLOCK)
								INNER JOIN	Archivo.Archivo						B WITH(NOLOCK)
								ON			B.TU_CodArchivo						= A.TU_CodArchivo										
								LEFT JOIN   Expediente.ArchivoExpediente		F WITH(NOLOCK) 
								ON			F.TU_CodArchivo						= A.TU_CodArchivo
								AND			F.TB_Eliminado						= 0
								LEFT JOIN   Expediente.LegajoArchivo			G WITH(NOLOCK) 
								ON			G.TU_CodArchivo						= A.TU_CodArchivo
								OUTER APPLY (
									SELECT		TOP 1 
												H.TC_UsuarioRed,		
												H.TC_Nombre,			
												H.TC_PrimerApellido,	
												H.TC_SegundoApellido
									FROM		Catalogo.PuestoTrabajoFuncionario		F WITH(NOLOCK)
									LEFT JOIN	Catalogo.Funcionario					H WITH(NOLOCK) 		
									ON			H.TC_UsuarioRed							= F.TC_UsuarioRed
									WHERE		F.TU_CodPuestoFuncionario				= A.TU_AsignadoPor	
									AND			F.TF_Inicio_Vigencia					<= A.TF_FechaAsigna
									AND			ISNULL(F.TF_Fin_Vigencia, GETDATE())	>= A.TF_FechaAsigna
									ORDER BY	F.TF_Inicio_Vigencia DESC
								) UsuarioAsignador	
								OUTER APPLY	(/*Documentos asociados a resoluciones y que el formato jurídico asociado al documento en el contexto genera notificación automática*/											
											  SELECT		TOP 1 Z.TU_CodArchivo
											  FROM		Catalogo.FormatoJuridicoTipoOficina			K WITH(NOLOCK)
											  INNER JOIN	Catalogo.FormatoJuriComunicacionContexto	L WITH(NOLOCK)	
											  ON			L.TC_CodContexto							= @L_CodContexto
											  AND			L.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
											  INNER JOIN	Archivo.Archivo								Z WITH(NOLOCK)
											  ON			Z.TC_CodFormatoJuridico						= K.TC_CodFormatoJuridico
											  AND			Z.TC_CodFormatoJuridico						= L.TC_CodFormatoJuridico
											  AND			Z.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico
											  WHERE		Z.TU_CodArchivo								= B.TU_CodArchivo
											) OA
								WHERE		(A.TF_FechaAsigna					>= @L_FechaAsignaDesde
								AND			 A.TF_FechaAsigna					<= @L_FechaAsignaHasta) 			
								AND			 B.TC_CodContextoCrea				 = @L_CodContexto							
								AND			(CONVERT(varchar(8), A.TF_FechaAsigna, 108) < CONVERT(varchar(8), '07:30:00',108)
								OR	  		 CONVERT(varchar(8), A.TF_FechaAsigna, 108) > CONVERT(varchar(8), '16:30:00',108)) 
								AND			(@L_TodosDoc						= 1
												OR	
												(
													@L_TodosDoc					= 0
													AND
													B.TU_CodArchivo				= OA.TU_CodArchivo
												)
											)

								ORDER BY	A.TF_FechaAsigna DESC
							END
						END
					END

					--BORRAMOS LOS REGISTROS QUE NO CORRESPONDEN AL USUARIO
					IF (@L_UsuarioTrabajo IS NOT NULL AND @L_UsuarioTrabajo <> '')
					BEGIN
						DELETE FROM @BUZONFIRMADO
						WHERE TU_AsignadoPor NOT IN (SELECT * FROM @PUESTOSTRABAJOFUNCIONARIOTABLA)
					END

					--BORRAMOS LOS REGISTROS QUE NO CORRESPONDEN AL USUARIO ASIGNADOR
					IF (@L_UsuarioTrabajoAsignador IS NOT NULL AND @L_UsuarioTrabajoAsignador <> '')
					BEGIN
						DELETE FROM @BUZONFIRMADO
						WHERE TU_FirmadoPor NOT IN (SELECT * FROM @PUESTOSTRABAJOFUNCIONARIOASIGNADORTABLA)
					END
					ELSE
					BEGIN
						--Como usuario asignador viene NULL, pueden venir registros repetidos cuando una asignación de firmado, es para dos usuarios y tienen mismo codigo de archivo
						--En estos casos eliminamos los duplicados.
						DECLARE @CodigoArchivoActual UNIQUEIDENTIFIER;
						INSERT INTO @BUZONFIRMADOTEMP
						SELECT * FROM @BUZONFIRMADO
						DELETE FROM @BUZONFIRMADO

						WHILE EXISTS ( SELECT	*
									   FROM	@BUZONFIRMADOTEMP )
						BEGIN	
							SELECT TOP 1	@CodigoArchivoActual = A.TU_CodArchivo
							FROM			@BUZONFIRMADOTEMP A

							IF  NOT EXISTS ( SELECT TU_CodArchivo
											 FROM	@BUZONFIRMADO 
											 WHERE  TU_CodArchivo  = @CodigoArchivoActual) 
							BEGIN
								INSERT INTO @BUZONFIRMADO
								SELECT TOP 1 * FROM @BUZONFIRMADOTEMP WHERE TU_CodArchivo = @CodigoArchivoActual --solo tomamos 1 cualquiera
							END
							ELSE
							BEGIN
								DELETE FROM @BUZONFIRMADOTEMP WHERE TU_CodArchivo = @CodigoArchivoActual
							END
						END
					END



					--Obtener cantidad registros de la consulta
					SELECT  @L_TotalRegistros = COUNT(*) FROM @BUZONFIRMADO;

					--***********************************************************************************************************************************************
					--ACTUALIZACION DE CAMPOS DE CANTIDAD SEGUN CRITERIO
					--***********************************************************************************************************************************************

					UPDATE		@BUZONFIRMADO
					SET			TN_CantidadDocumentosCorregidos = 0

					--EXPEDIENTES ASIGNADOS AL PUESTO DE TRABAJO		
					SELECT		@L_CantidadExpedientesAsignados = ISNULL(COUNT(DISTINCT(A.TC_NumeroExpediente)), 0)
					FROM		@BUZONFIRMADO				 A
					INNER JOIN	Archivo.AsignacionFirmado	 B WITH(NOLOCK)	
					ON			B.TU_CodAsignacionFirmado	 = A.TU_CodAsignacionFirmado		
					LEFT JOIN	Expediente.ArchivoExpediente C WITH(NOLOCK)	
					ON			C.TU_CodArchivo				 = B.TU_CodArchivo
					LEFT JOIN	Expediente.LegajoArchivo	 D WITH(NOLOCK)	
					ON			D.TU_CodArchivo				 = B.TU_CodArchivo	
					
					UPDATE		@BUZONFIRMADO
					SET			TN_CantidadExpedientesAsignados = @L_CantidadExpedientesAsignados

					--DOCUMENTOS ASIGNADOS AL PUESTO DE TRABAJO
					SELECT		@L_CantidadDocumentosAsignados = ISNULL(COUNT(DISTINCT(A.TU_CodArchivo)), 0)
					FROM		@BUZONFIRMADO				 A	

					UPDATE		@BUZONFIRMADO
					SET			TN_CantidadDocumentosAsignados = @L_CantidadDocumentosAsignados

					--EXPEDIENTES FIRMADOS
					SELECT		@L_CantidadExpedientesFirmados = ISNULL(COUNT(DISTINCT(A.TC_NumeroExpediente)), 0)
					FROM		@BUZONFIRMADO				A
					WHERE		A.TF_FechaAplicado			IS NOT NULL		

					UPDATE		@BUZONFIRMADO
					SET			TN_CantidadExpedientesFirmados = @L_CantidadExpedientesFirmados

					--DOCUMENTO SIN EXPEDIENTE
					SELECT		@L_CantidadDocumentosSinExpediente = ISNULL(COUNT(A.TU_CodArchivo), 0)
					FROM		@BUZONFIRMADO								A
					INNER JOIN	ArchivoSinExpediente.ArchivoSinExpediente   B WITH(NOLOCK) 
					ON			B.TU_CodArchivo								= A.TU_CodArchivo

					UPDATE		@BUZONFIRMADO
					SET			TN_CantidadDocumentosSinExpediente = @L_CantidadDocumentosSinExpediente

					--FIRMAS APLICADAS
					SELECT		@L_CantidadFirmasAplicadas = ISNULL(COUNT(A.TU_CodAsignacionFirmado), 0)
					FROM		@BUZONFIRMADO				A
					WHERE		A.TF_FechaAplicado			IS NOT NULL		

					UPDATE		@BUZONFIRMADO
					SET			TN_CantidadFirmasAplicadas = @L_CantidadFirmasAplicadas

					--DOCUMENTOS PENDIENTES
					SELECT		@L_CantidadDocumentosPendientes = ISNULL(COUNT(DISTINCT(A.TU_CodArchivo)), 0)
					FROM		@BUZONFIRMADO				A				
					WHERE		A.TF_FechaAplicado			IS NULL	
					AND			A.TF_FechaDevolucion		IS NULL

					UPDATE		@BUZONFIRMADO
					SET			TN_CantidadDocumentosPedientes = @L_CantidadDocumentosPendientes

					--DOCUMENTOS DEVUELTOS
					SELECT		@L_CantidadDocumentosDevueltos = ISNULL(COUNT(DISTINCT(A.TU_CodArchivo)), 0)
					FROM		@BUZONFIRMADO				A
					WHERE		A.TF_FechaDevolucion		IS NOT NULL					

					UPDATE		@BUZONFIRMADO
					SET			TN_CantidadDocumentosDevueltos = @L_CantidadDocumentosDevueltos

					--DOCUMENTOS URGENTES
					SELECT		@L_CantidadDocumentosUrgentes = ISNULL(COUNT(A.TU_CodArchivo), 0)		
					FROM		@BUZONFIRMADO				A
					INNER JOIN  Archivo.AsignacionFirmado   B WITH(NOLOCK)
					ON			B.TU_CodAsignacionFirmado	= A.TU_CodAsignacionFirmado
					WHERE		B.TB_Urgente				= 1
					GROUP BY	A.TU_CodArchivo

					UPDATE		@BUZONFIRMADO
					SET			TN_CantidadDocumentosUrgentes = @L_CantidadDocumentosUrgentes

					--DOCUMENTOS CORREGIDOS 
					SELECT		@L_CantidadDocumentosCorregidos = ISNULL(COUNT(A.TU_CodArchivo), 0)		
					FROM		@BUZONFIRMADO				A
					INNER JOIN  Archivo.AsignacionFirmado   B WITH(NOLOCK)
					ON			B.TU_CodAsignacionFirmado	= A.TU_CodAsignacionFirmado
					WHERE		B.TU_CorregidoPor			IS NOT NULL
					GROUP BY	A.TU_CodArchivo

					UPDATE		@BUZONFIRMADO
					SET			TN_CantidadDocumentosCorregidos = @L_CantidadDocumentosCorregidos

				END		
		END
	END

	--*************************************************************************************************************************************************
	--Consulta final
	--*************************************************************************************************************************************************		

	--retornar consultar
		SELECT x.TU_CodArchivo							Codigo				
			  ,x.TC_Descripcion							Descripcion
			  ,x.TF_FechaCrea							FechaCrea
			  ,@L_TotalRegistros						TotalRegistros		
			  ,'splitExpediente'						splitExpediente	
			  ,x.TC_NumeroExpediente					Numero
			  ,'splitLegajo'							splitLegajo
			  ,x.TU_CodLegajo							Codigo
			  ,'splitAsignacionFirmado'					splitAsignacionFirmado
			  ,x.TF_FechaAsigna							FechaAsignacion
			  ,'splitAsignacionFirmante'				splitAsignacionFirmante
			  ,x.TF_FechaAplicado						FechaAplicado	
			  ,x.TB_EsFirmaDigital						EsFirmaDigital
			  ,'splitOtros'								splitOtros
			  ,x.TC_UsuarioRed							UsuarioRed 
			  ,x.TC_Nombre								NombreFuncionario
			  ,x.TC_PrimerApellido						PrimerApellidoFuncionario
			  ,x.TC_SegundoApellido						SegundoApellidoFuncionario														
			  ,x.TC_UsuarioRedAsignador					UsuarioRedAsignador
			  ,x.TC_NombreAsignado						NombreFuncionarioAsignador
			  ,x.TC_PrimerApellidoAsignado				PrimerApellidoFuncionarioAsignador
			  ,x.TC_SegundoApellidoAsignado				SegundoApellidoFuncionarioAsignador
			  ,TN_CantidadExpedientesAsignados			CantidadExpedientesAsignados
			  ,TN_CantidadDocumentosAsignados			CantidadDocumentosAsignados
			  ,TN_CantidadExpedientesFirmados			CantidadExpedientesFirmados
			  ,TN_CantidadDocumentosSinExpediente		CantidadDocumentosSinExpediente
			  ,TN_CantidadFirmasAplicadas				CantidadFirmasAplicadas
			  ,TN_CantidadDocumentosPedientes			CantidadDocumentosPendientes
			  ,TN_CantidadDocumentosDevueltos			CantidadDocumentosDevueltos
			  ,TN_CantidadDocumentosUrgentes			CantidadDocumentosUrgentes
			  ,TN_CantidadDocumentosCorregidos			CantidadDocumentosCorregidos
			  ,x.TU_AsignadoPor							AsignadoPor
			  ,x.TU_FirmadoPor							FirmadoPor
			  ,x.TC_CodPuestoTrabajoAsignadoA			PuestoAsignadoA
			  ,x.TF_FechaDevolucion						FechaDevolucion

		FROM (
			SELECT TU_CodArchivo						
				  ,TC_Descripcion						
				  ,TF_FechaCrea							
				  ,TC_NumeroExpediente					
				  ,TU_CodLegajo			
				  ,TF_FechaAsigna					
				  ,TU_AsignadoPor
				  ,TF_FechaAplicado
				  ,TB_EsFirmaDigital
				  ,TC_UsuarioRed
				  ,TC_Nombre				
				  ,TC_PrimerApellido
				  ,TC_SegundoApellido
				  ,TC_UsuarioRedAsignador
				  ,TC_NombreAsignado
				  ,TC_PrimerApellidoAsignado
				  ,TC_SegundoApellidoAsignado
				  ,TN_CantidadExpedientesAsignados
				  ,TN_CantidadDocumentosAsignados
				  ,TN_CantidadExpedientesFirmados
				  ,TN_CantidadDocumentosSinExpediente
				  ,TN_CantidadFirmasAplicadas
				  ,TN_CantidadDocumentosPedientes
				  ,TN_CantidadDocumentosDevueltos
				  ,TN_CantidadDocumentosUrgentes
				  ,TN_CantidadDocumentosCorregidos
				  ,TU_FirmadoPor
				  ,TC_CodPuestoTrabajoAsignadoA
				  ,TF_FechaDevolucion
			FROM		@BUZONFIRMADO
			ORDER BY	TF_FechaAsigna	   	  Asc
			OFFSET		(@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS 
			FETCH NEXT	@L_CantidadRegistros ROWS ONLY
		)	As x
		ORDER BY	x.TF_FechaAsigna		  DESC 
END

GO
