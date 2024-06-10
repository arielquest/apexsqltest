SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


--=========================================================================================================================================================
-- Autor:		   <Isaac Dobles Mata>
-- Fecha Creación: <24/04/2019>
-- Descripcion:	   <Consulta de archivos por legajo>
--=========================================================================================================================================================
-- Modificación:   <Aida Elena Siles R> <26/10/2020> <Se agrega a la consulta la tabla de funcionario para obtener nombre completo que creó el documento.
-- Modificación:   <Aida Elena Siles R> <18/11/2020> <Se agrega validación para los documentos en estado privado, borrador y borrador público donde el
--					contexto de creación sea igual al contexto donde se encuentra actualmente el legajo- HU recibir legajo itineración>
-- Modificación:   <Aida E Siles R> <26/02/2021> <Se agrega en el where para que filtre el numero expediente del legajo en Expediente.ArchivoExpediente>
-- Modificación:   <Jose Gabriel Cordero> <22/03/2021> <Se agrega indicador de generar voto automatico en consulta de documentos>
-- Modificación:   <Ronny Ramírez R.> <26/03/2021> <Se agrega el número de expediente asociado al archivo, pues es requerido al tratar de eliminarlo
--													específicamente en el SP PA_AgregarExclusionHistorialProcesal>
-- Modificación:	<25/05/2022> <Aida Elena Siles R> <Se agrega a la consulta el dato TB_Multimedia. PBI 252289>
-- Modificación:	<14/06/2022> <Aida Elena Siles R> <Se agrega a la consulta la descripción del formato del archivo. PBI 252715>
-- Modificación:	<12/07/2022> <Luis Alonso Leiva Tames> <Mostrara la cantida de firmas que tenga el documento>
-- Modificación:	<20/10/2022> <Aaron Rios Retana> <HU 272357 - Se agrega a la consulta obtener el código de resolución asociado al documento>
-- Modificación:	<13/06/2023> <Ronny Ramírez R.> <PBI 323074 - Se agrega filtro para consultar por Código de Archivo exacto>
-- Modificación		<Ronny Ramírez R.> <14/07/2023> <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar problema de no 
--													uso de índices por el mal uso de COALESCE en el WHERE>
----=======================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ConsultarLegajoArchivoExpedienteTodo]
	@Legajo						UNIQUEIDENTIFIER,	 
	@UsuarioCrea				VARCHAR(30),
	@CodigoPuestoTrabajo		VARCHAR(14),
	@CodEstadoBorradorPublico	TINYINT,
	@CodEstadoTerminado			TINYINT,
	@CodEstadoPrivado			TINYINT,
	@CodEstadoBorrador			TINYINT,
	@EstadoConsulta				TINYINT,
	@FechaInicio				DATETIME,
	@FechaFinal					DATETIME,
	@CodArchivo					UNIQUEIDENTIFIER = NULL
AS

BEGIN
	--Variables
	DECLARE	@L_CodLegajo					UNIQUEIDENTIFIER		=  @Legajo,
			@L_UsuarioCrea					VARCHAR(30)				=  @UsuarioCrea,
			@L_CodigoPuestoTrabajo			VARCHAR(14)				=  @CodigoPuestoTrabajo,
			@L_CodEstadoBorradorPublico		TINYINT					=  @CodEstadoBorradorPublico,
			@L_CodEstadoTerminado			TINYINT					=  @CodEstadoTerminado,
			@L_CodEstadoPrivado				TINYINT					=  @CodEstadoPrivado,
			@L_CodEstadoBorrador			TINYINT					=  @CodEstadoBorrador,
			@L_EstadoConsulta				TINYINT					=  @EstadoConsulta,
			@L_FechaInicio					DATETIME				=  @FechaInicio,
			@L_FechaFinal					DATETIME				=  @FechaFinal,
			@L_TU_CodArchivo				UNIQUEIDENTIFIER		=  @CodArchivo


	-- Se obtiene los Grupos de trabajo asociados al Puesto 
	DECLARE @CodigosGrupoTrabajo AS TABLE
	(
	     CodigoGrupo Smallint
	);

	INSERT INTO @CodigosGrupoTrabajo
	(
		CodigoGrupo
	)

	SELECT	[TN_CodGrupoTrabajo]		
    FROM	[Catalogo].[GrupoTrabajoPuesto]	
	WHERE	TC_CodPuestoTrabajo		= @L_CodigoPuestoTrabajo
	
	IF (@L_EstadoConsulta IS NULL)
	BEGIN
		IF (@L_FechaInicio IS NULL AND @L_FechaFinal IS NULL)
			BEGIN
					SELECT		
					A.TU_CodArchivo								AS	Codigo,							
					A.TC_Descripcion							AS	Descripcion,			
					A.TF_FechaCrea								AS	FechaCrea,
					AE.TB_Notifica								AS	Notifica,
					AE.TB_Eliminado								AS	Eliminado,
					A.TB_Multimedia								AS	EsMultimedia,
					COUNT(AFt.TU_FirmadoPor)					AS	CantidadFirmas,
					'Split'										AS	Split,
					AE.TN_CodGrupoTrabajo						AS	Codigo,
					'Split'										AS	Split,
					A.TC_UsuarioCrea							AS	UsuarioRed,								
					'Split'										AS	Split,
					A.TN_CodEstado								AS	Estado,
					A.TB_GenerarVotoAutomatico					AS  GenerarVotoAutomatico,
					AE.TC_NumeroExpediente						AS	NumeroExpediente,
					FA.TN_CodFormatoArchivo						AS	CodigoFormatoArchivo,
					FA.TC_Descripcion							AS	FormatoArchivoDescrip,
					R.TU_CodResolucion							AS	CodigoResolucion
						
					FROM		Archivo.Archivo					A	WITH(NOLOCK)
					INNER JOIN	Expediente.ArchivoExpediente	AE	WITH(NOLOCK)
					ON			A.TU_CodArchivo					=	AE.TU_CodArchivo					
					INNER JOIN	Expediente.LegajoArchivo		LA	WITH(NOLOCK)
					ON			AE.TU_CodArchivo				=	LA.TU_CodArchivo
					INNER JOIN	Expediente.Legajo				EL	WITH(NOLOCK)
					ON			LA.TU_CodLegajo					=	EL.TU_CodLegajo
					INNER JOIN	Catalogo.FormatoArchivo			FA	WITH(NOLOCK)
					ON			A.TN_CodFormatoArchivo			=	FA.TN_CodFormatoArchivo
					LEFT JOIN	Expediente.Resolucion			R	WITH(NOLOCK)
					ON			R.TU_CodArchivo					=	A.TU_CodArchivo
					LEFT JOIN Archivo.AsignacionFirmado			AgF WITH(NOLOCK)
					ON			AE.TU_CodArchivo				= AgF.TU_CodArchivo
					LEFT JOIN Archivo.AsignacionFirmante		AFt WITH(NOLOCK)
					ON			AgF.TU_CodAsignacionFirmado		= AFt.TU_CodAsignacionFirmado 
					WHERE		AE.TB_Eliminado					=	0						
					AND			AE.TC_NumeroExpediente			=	EL.TC_NumeroExpediente
					AND			
					(
						A.TN_CodEstado	=	@L_CodEstadoTerminado			
						OR
						(
							A.TN_CodEstado	=	@L_CodEstadoBorradorPublico 
							AND 
							A.TC_CodContextoCrea = EL.TC_CodContexto
						)
						OR 
						(
							A.TN_CodEstado	=	@L_CodEstadoBorrador		
							AND 
							EXISTS 
							(
								SELECT		CodigoGrupo 
								FROM		@CodigosGrupoTrabajo 
								WHERE		CodigoGrupo= AE.TN_CodGrupoTrabajo
							)
							AND 
							A.TC_CodContextoCrea = EL.TC_CodContexto
						)
						OR
						(
							A.TN_CodEstado		 =	@L_CodEstadoPrivado			
							AND 
							A.TC_UsuarioCrea	 =	@L_UsuarioCrea 
							AND 
							A.TC_CodContextoCrea = EL.TC_CodContexto
						)
					)
					AND			EL.TU_CodLegajo			= COALESCE(@L_CodLegajo, EL.TU_CodLegajo)
					AND			A.TU_CodArchivo			= COALESCE(@L_TU_CodArchivo, A.TU_CodArchivo)
					GROUP BY 
					A.TU_CodArchivo,A.TC_Descripcion,A.TF_FechaCrea,AE.TB_Notifica, AE.TB_Eliminado,AE.TN_CodGrupoTrabajo,
					A.TC_UsuarioCrea,A.TN_CodEstado,A.TB_GenerarVotoAutomatico,AE.TC_NumeroExpediente,A.TB_Multimedia,
					FA.TN_CodFormatoArchivo	, FA.TC_Descripcion , R.TU_CodResolucion
					OPTION(RECOMPILE)
			END
		ELSE
			BEGIN
					SELECT		
					A.TU_CodArchivo				AS		Codigo,							
					A.TC_Descripcion			AS		Descripcion,			
					A.TF_FechaCrea				AS		FechaCrea,
					AE.TB_Notifica				AS		Notifica,
					AE.TB_Eliminado				AS		Eliminado,
					A.TB_Multimedia				AS		EsMultimedia,
					COUNT(AFt.TU_FirmadoPor)	AS	CantidadFirmas,
					'Split'						AS		Split,
					AE.TN_CodGrupoTrabajo		AS		Codigo,
					'Split'						AS		Split,
					A.TC_UsuarioCrea			AS		UsuarioRed,								
					'Split'						AS		Split,
					A.TN_CodEstado				AS		Estado,
					A.TB_GenerarVotoAutomatico	AS		GenerarVotoAutomatico,
					AE.TC_NumeroExpediente		AS		NumeroExpediente,
					FA.TN_CodFormatoArchivo		AS		CodigoFormatoArchivo,
					FA.TC_Descripcion			AS		FormatoArchivoDescrip,
					R.TU_CodResolucion			AS		CodigoResolucion
						
					FROM		Archivo.Archivo					A	WITH(NOLOCK)	
					INNER JOIN	Expediente.ArchivoExpediente	AE	WITH(NOLOCK)
					ON			A.TU_CodArchivo					=	AE.TU_CodArchivo
					INNER JOIN	Expediente.LegajoArchivo		LA	WITH(NOLOCK)
					ON			AE.TU_CodArchivo				=	LA.TU_CodArchivo
					INNER JOIN	Expediente.Legajo				EL	WITH(NOLOCK)
					ON			LA.TU_CodLegajo					=	EL.TU_CodLegajo
					INNER JOIN	Catalogo.FormatoArchivo			FA	WITH(NOLOCK)
					ON			A.TN_CodFormatoArchivo			=	FA.TN_CodFormatoArchivo
					LEFT JOIN	Expediente.Resolucion			R	WITH(NOLOCK)
					ON			R.TU_CodArchivo					=	A.TU_CodArchivo
					LEFT JOIN Archivo.AsignacionFirmado			AgF WITH(NOLOCK)
					ON			AE.TU_CodArchivo				= AgF.TU_CodArchivo
					LEFT JOIN Archivo.AsignacionFirmante		AFt WITH(NOLOCK)
					ON			AgF.TU_CodAsignacionFirmado		= AFt.TU_CodAsignacionFirmado 
					WHERE		AE.TB_Eliminado					=	0		
					AND			AE.TC_NumeroExpediente			=	EL.TC_NumeroExpediente
					AND	   
					(		A.TN_CodEstado			=	@L_CodEstadoTerminado			
							OR
							(
								A.TN_CodEstado				=	@L_CodEstadoBorradorPublico
								AND	A.TC_CodContextoCrea	=	EL.TC_CodContexto
							)
							OR 
							(	A.TN_CodEstado		=	@L_CodEstadoBorrador		
								AND 
								EXISTS (SELECT CodigoGrupo FROM @CodigosGrupoTrabajo WHERE CodigoGrupo= AE.TN_CodGrupoTrabajo)	 
								AND
								A.TC_CodContextoCrea	=	EL.TC_CodContexto
							)
							OR
							(	A.TN_CodEstado		=	@L_CodEstadoPrivado			
								AND 
								A.TC_UsuarioCrea	=	@L_UsuarioCrea
								AND
								A.TC_CodContextoCrea	= EL.TC_CodContexto
							)
					)
					AND		A.TF_FechaCrea BETWEEN @L_FechaInicio AND @L_FechaFinal
					AND		EL.TU_CodLegajo			= COALESCE(@L_CodLegajo, EL.TU_CodLegajo)
					AND		A.TU_CodArchivo			= COALESCE(@L_TU_CodArchivo, A.TU_CodArchivo)
					GROUP BY 
					A.TU_CodArchivo,A.TC_Descripcion,A.TF_FechaCrea,AE.TB_Notifica, AE.TB_Eliminado,AE.TN_CodGrupoTrabajo,
					A.TC_UsuarioCrea,A.TN_CodEstado,A.TB_GenerarVotoAutomatico,AE.TC_NumeroExpediente,A.TB_Multimedia,
					FA.TN_CodFormatoArchivo	, FA.TC_Descripcion , R.TU_CodResolucion
					OPTION(RECOMPILE)
			END
	END
	ELSE
	BEGIN
		SELECT		A.TU_CodArchivo					AS	Codigo,							
					A.TC_Descripcion				AS	Descripcion,			
					A.TF_FechaCrea					AS	FechaCrea,
					AE.TB_Notifica					AS  Notifica,
					AE.TB_Eliminado					AS  Eliminado,
					A.TB_Multimedia					AS	EsMultimedia,
					COUNT(AFt.TU_FirmadoPor)		AS	CantidadFirmas,
					'Split'							AS	Split,
					AE.TN_CodGrupoTrabajo			AS	Codigo,
					'Split'							AS	Split,
					A.TC_UsuarioCrea				AS	UsuarioRed,		
					F.TC_Nombre						AS	Nombre,
					F.TC_PrimerApellido				AS	PrimerApellido,
					F.TC_SegundoApellido			AS	SegundoApellido,
					'Split'							AS	Split,
					A.TN_CodEstado					AS	Estado,
					A.TB_GenerarVotoAutomatico		AS  GenerarVotoAutomatico,
					AE.TC_NumeroExpediente			AS	NumeroExpediente,
					FA.TN_CodFormatoArchivo			AS	CodigoFormatoArchivo,
					FA.TC_Descripcion				AS	FormatoArchivoDescrip,
					R.TU_CodResolucion				AS	CodigoResolucion
						
		FROM		Archivo.Archivo					A WITH(NOLOCK)	
		INNER JOIN	Expediente.ArchivoExpediente	AE WITH(NOLOCK)
		ON			A.TU_CodArchivo					= AE.TU_CodArchivo
		INNER JOIN	Expediente.LegajoArchivo		LA WITH(NOLOCK)
		ON			AE.TU_CodArchivo				= LA.TU_CodArchivo
		INNER JOIN	Expediente.Legajo				EL WITH(NOLOCK)
		ON			LA.TU_CodLegajo					= EL.TU_CodLegajo
		INNER JOIN	Catalogo.Funcionario			F WITH(NOLOCK)
		ON			A.TC_UsuarioCrea				= F.TC_UsuarioRed
		INNER JOIN	Catalogo.FormatoArchivo			FA WITH(NOLOCK)
		ON			A.TN_CodFormatoArchivo			= FA.TN_CodFormatoArchivo
		LEFT JOIN	Expediente.Resolucion			R	WITH(NOLOCK)
		ON			R.TU_CodArchivo					=	A.TU_CodArchivo
		LEFT JOIN	Archivo.AsignacionFirmado			AgF WITH(NOLOCK)
		ON			AE.TU_CodArchivo				= AgF.TU_CodArchivo
		LEFT JOIN	Archivo.AsignacionFirmante		AFt WITH(NOLOCK)
		ON			AgF.TU_CodAsignacionFirmado		= AFt.TU_CodAsignacionFirmado 
		WHERE		AE.TB_Eliminado					=	0						
		AND			A.TN_CodEstado					=	@L_EstadoConsulta	
		AND			EL.TU_CodLegajo					= COALESCE(@L_CodLegajo, EL.TU_CodLegajo)
		AND			AE.TC_NumeroExpediente			= EL.TC_NumeroExpediente
		AND			A.TU_CodArchivo					= COALESCE(@L_TU_CodArchivo, A.TU_CodArchivo)
		GROUP BY 
		A.TU_CodArchivo,A.TC_Descripcion,A.TF_FechaCrea,AE.TB_Notifica, AE.TB_Eliminado,AE.TN_CodGrupoTrabajo,
		A.TC_UsuarioCrea,F.TC_Nombre,F.TC_PrimerApellido,F.TC_SegundoApellido,A.TN_CodEstado,A.TB_GenerarVotoAutomatico,AE.TC_NumeroExpediente,
		A.TB_Multimedia, FA.TN_CodFormatoArchivo	, FA.TC_Descripcion , R.TU_CodResolucion
		OPTION(RECOMPILE)
	END																	
END


GO
