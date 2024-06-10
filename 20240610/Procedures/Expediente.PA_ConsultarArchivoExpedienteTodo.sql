SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--=============================================================================================================================================
-- Autor:		   <Diego Navarrete>
-- Fecha Creación: <11/09/2017>
-- Descripcion:	   <Consulta de archivos por expediente, y los diferentes que se deben cumplir para las condiciones>
-- Devuelve lista de archivos por expediente
--=============================================================================================================================================
-- Modificación:	<27/11/2017> <Andr‚s D¡az> <Se agrega la descripción del grupo de trabajo.>
-- Modificación:	<12/01/2017> <Ailyn López><Se cambia el alias de las tablas "Catalogo.Funcionario" y "Catalogo.GrupoTrabajo".>
-- Modificacion:	<3/27/2018>  <Diego Navarrete Alvarez> <Se modifico la consulta se elimino el inner Join con funcionario y elimino el cast>
-- Modificacion:	<21/09/2018> <Isaac Dobles> <Se cambia nombre a PA_ConsultarArchivoExpedienteTodo> y se ajusta para consultar a ArchivoExpediente
-- Modificación:	<29/10/2018> <Jonathan Aguilar Navarro> <Se agrega parametro @EstadoConsulta, @FechaIncio, @FechaFinal para indicar el estado por el cual se va a consultar y las fechas de filtro> 
-- Modificación:	<14/01/2019> <Jonathan Aguilar Navarro> <Se agrega el expediente a la consulta>
-- Modificación:	<24/04/2019> <Isaac Dobles Mata> <Se elimina par metro de Legajo y se hace LEFT JOIN con tabla LegajoArchivo>
-- Modificación:	<03/06/2019> <Isaac Dobles Mata> <Se corrige consulta para que obtenga archivos que NO est‚n en los legajos del expediente>
-- Modificación:	<29/05/2020> <Isaac Dobles Mata> <Se modifica para ingresar variables internas>
-- Modificación:	<26/11/2020> <Jonathan Aguilar Navarro> <Se agrega paraetro para saber si la consulta es de acumulacion para que consulte los documentos diferentes al estado Terminado>
-- Modificación:	<22/03/2021> <Jose Gabriel Cordero Soto> <Se agrega cambio indicador de generar voto automatico a consulta>
-- Modificación:	<17/12/2021> <Luis Alonso Leiva Tames> <Se agrega el codigo si el documento esta enviado a firmar>
-- Modificación:	<12/07/2022> <Luis Alonso Leiva Tames> <Mostrara la cantidad de firmas que tenga el documento>
-- Modificación:	<14/10/2022> <Luis Alonso Leiva Tames> <Se corrige la duplidad de documentos>
-- Modificación:	<06/03/2022> <Aaron Rios Retana> <Se corrige la comparacion con el parametro @L_TN_CodEstadoConsulta cuando es una consulta de acumulacion>
-- Modificación		<Ronny Ram¡rez R.> <26/07/2023>  <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar  
--															problema de no uso de ¡ndices por el mal uso de COALESCE/ISNULL en el WHERE>
--=============================================================================================================================================
CREATE   PROCEDURE	[Expediente].[PA_ConsultarArchivoExpedienteTodo] 
	@UsuarioCrea				varchar(30),
	@CodigoPuestoTrabajo		Varchar(14),
	@CodEstadoBorradorPublico	tinyint,
	@CodEstadoTerminado			tinyint,
	@CodEstadoPrivado			tinyint,
	@CodEstadoBorrador			tinyint,
	@EstadoConsulta				tinyint,
	@FechaInicio				datetime,
	@FechaFinal					datetime,
	@NumeroExpediente			varchar(14),
	@EsAcumulacion				bit
	
AS

BEGIN
	-- Se obtiene los Grupos de trabajo asociados al Puesto 
	DECLARE @CodigosGrupoTrabajo AS TABLE
	(
	     CodigoGrupo Smallint
	 );

	Declare 
	@L_TC_UsuarioCrea					varchar(30)			= @UsuarioCrea,    
	@L_TC_CodPuestoTrabajo				Varchar(14)			= @CodigoPuestoTrabajo,
	@L_TN_CodEstadoBorradorPublico		tinyint				= @CodEstadoBorradorPublico, 
	@L_TN_CodEstadoTerminado			tinyint				= @CodEstadoTerminado,    
	@L_TN_CodEstadoPrivado				tinyint				= @CodEstadoPrivado,    
	@L_TN_CodEstadoBorrador				tinyint				= @CodEstadoBorrador,    
	@L_TN_CodEstadoConsulta				tinyint				= @EstadoConsulta,    
	@L_TF_FechaInicio					datetime			= @FechaInicio, 
	@L_TF_FechaFinal					datetime			= @FechaFinal,    
	@L_TC_NumeroExpediente				varchar(14)			= @NumeroExpediente,
	@L_TB_EsAcumulacion					bit					= @EsAcumulacion

	INSERT INTO @CodigosGrupoTrabajo
	(
		CodigoGrupo
	)
	SELECT	[TN_CodGrupoTrabajo]		
    FROM	[Catalogo].[GrupoTrabajoPuesto]	
	WHERE	TC_CodPuestoTrabajo		= @L_TC_CodPuestoTrabajo
	
	IF (@L_TN_CodEstadoConsulta is null)
	BEGIN
		IF (@L_TF_FechaInicio is null and @L_TF_FechaFinal is null)
			BEGIN
					SELECT DISTINCT	
					A.TU_CodArchivo								AS	Codigo,							
					A.TC_Descripcion							AS	Descripcion,			
					A.TF_FechaCrea								AS	FechaCrea,					
					AE.TB_Notifica								AS	Notifica,
					AE.TB_Eliminado								AS	Eliminado,
					AE.TN_Consecutivo							AS  ConsecutivoHistorialProcesal,
					COUNT(AFt.TU_FirmadoPor)					AS	CantidadFirmas,
					'Split'										AS	Split,
					AE.TN_CodGrupoTrabajo						AS	Codigo,
					'Split'										AS	Split,
					A.TC_UsuarioCrea							AS	UsuarioRed,	
					'Split'										AS	Split,
					AE.TC_NumeroExpediente						AS  Numero,												
					'Split'										AS	Split,
					A.TN_CodEstado								AS	Estado,
					A.TB_GenerarVotoAutomatico					AS  GenerarVotoAutomatico,					
					AgF.TU_CodArchivo								AS  Codigo, 
					AgF.TC_Estado									AS  EstadoFirmado

					FROM		Archivo.Archivo					A WITH(NOLOCK)
					INNER JOIN	Expediente.ArchivoExpediente	AE WITH(NOLOCK)
					ON			A.TU_CodArchivo					= AE.TU_CodArchivo
					INNER JOIN	
					(
						SELECT		AE.TU_CodArchivo
						FROM		Expediente.ArchivoExpediente AE
						WHERE		AE.TC_NumeroExpediente = @L_TC_NumeroExpediente
						EXCEPT
						SELECT		LA.TU_CodArchivo
						FROM		Expediente.LegajoArchivo LA
						WHERE		LA.TC_NumeroExpediente = @L_TC_NumeroExpediente
					) AS X
					ON			X.TU_CodArchivo = A.TU_CodArchivo 
					LEFT JOIN Archivo.AsignacionFirmado AgF WITH(NOLOCK) 
					ON A.TU_CodArchivo = AgF.TU_CodArchivoAsignado AND AgF.TU_CodAsignacionFirmado IN 
					(SELECT TU_CodAsignacionFirmado 
					 FROM Archivo.AsignacionFirmante WITH(NOLOCK) 
					 WHERE 
					 TU_FirmadoPor IS NOT NULL AND 
					 TU_CodAsignacionFirmado = AgF.TU_CodAsignacionFirmado)
					LEFT JOIN Archivo.AsignacionFirmante		AFt WITH(NOLOCK)
					ON			AgF.TU_CodAsignacionFirmado		= AFt.TU_CodAsignacionFirmado 
					WHERE		AE.TB_Eliminado					=	0	
					AND			
					(
						A.TN_CodEstado	=	@L_TN_CodEstadoTerminado			
						OR
						A.TN_CodEstado	=	@L_TN_CodEstadoBorradorPublico
						OR 
						(
							A.TN_CodEstado	=	@L_TN_CodEstadoBorrador		
							AND 
							EXISTS 
							(
								SELECT		CodigoGrupo 
								FROM		@CodigosGrupoTrabajo 
								WHERE		CodigoGrupo= AE.TN_CodGrupoTrabajo
							)	 
						)
						OR
						(
							A.TN_CodEstado		=	@L_TN_CodEstadoPrivado			
							AND 
							A.TC_UsuarioCrea	=	@L_TC_UsuarioCrea 
						)
					)
					AND		   AE.TC_NumeroExpediente			= COALESCE(@L_TC_NumeroExpediente, AE.TC_NumeroExpediente)
					GROUP BY 
					A.TU_CodArchivo, A.TC_Descripcion,A.TF_FechaCrea,AE.TB_Notifica,AE.TB_Eliminado,
					AE.TN_Consecutivo,AE.TN_CodGrupoTrabajo,A.TC_UsuarioCrea,
					AE.TC_NumeroExpediente,A.TN_CodEstado,A.TB_GenerarVotoAutomatico,A.TN_CodFormatoArchivo,AgF.TU_CodArchivo,AgF.TC_Estado,Agf.TU_CodArchivoFirmado
					OPTION(RECOMPILE);
			END
		ELSE
			BEGIN
					SELECT DISTINCT			
					A.TU_CodArchivo				AS		Codigo,							
					A.TC_Descripcion			AS		Descripcion,			
					A.TF_FechaCrea				AS		FechaCrea,
					AE.TB_Notifica				AS		Notifica,
					AE.TB_Eliminado				AS		Eliminado,
					AE.TN_Consecutivo			AS		ConsecutivoHistorialProcesal,
						COUNT(AFt.TU_FirmadoPor)	AS	CantidadFirmas,
					'Split'						AS		Split,
					AE.TN_CodGrupoTrabajo		AS		Codigo,
					'Split'						AS		Split,
					A.TC_UsuarioCrea			AS		UsuarioRed,	
					'Split'						AS		Split,
					AE.TC_NumeroExpediente		AS		Numero,												
					'Split'						AS		Split,
					A.TN_CodEstado				AS		Estado,
					A.TB_GenerarVotoAutomatico	AS		GenerarVotoAutomatico, 
					AgF.TU_CodArchivoFirmado		AS		Codigo, 
					AgF.TC_Estado					AS		EstadoFirmado
					FROM		Archivo.Archivo					A WITH(NOLOCK)	
					INNER JOIN	Expediente.ArchivoExpediente	AE WITH(NOLOCK)
					ON			A.TU_CodArchivo					= AE.TU_CodArchivo
					INNER JOIN	
					(
						SELECT		AE.TU_CodArchivo
						FROM		Expediente.ArchivoExpediente AE
						WHERE		AE.TC_NumeroExpediente = @L_TC_NumeroExpediente
						EXCEPT
						SELECT		LA.TU_CodArchivo
						FROM		Expediente.LegajoArchivo LA
						WHERE		LA.TC_NumeroExpediente = @L_TC_NumeroExpediente
					) AS X
					ON			X.TU_CodArchivo = A.TU_CodArchivo 
					LEFT JOIN Archivo.AsignacionFirmado AgF WITH(NOLOCK)
					ON A.TU_CodArchivo = AgF.TU_CodArchivoAsignado AND AgF.TU_CodAsignacionFirmado IN 
					(SELECT TU_CodAsignacionFirmado 
					 FROM Archivo.AsignacionFirmante WITH(NOLOCK) 
					 WHERE 
					 TU_FirmadoPor IS NOT NULL AND 
					 TU_CodAsignacionFirmado = AgF.TU_CodAsignacionFirmado)
					LEFT JOIN Archivo.AsignacionFirmante		AFt WITH(NOLOCK)
					ON			AgF.TU_CodAsignacionFirmado		= AFt.TU_CodAsignacionFirmado  
					WHERE		AE.TB_Eliminado					= 0		
					AND	   
					(		A.TN_CodEstado			=	@L_TN_CodEstadoTerminado			
							OR
							A.TN_CodEstado			=	@L_TN_CodEstadoBorradorPublico
							OR 
								(A.TN_CodEstado		=	@L_TN_CodEstadoBorrador		
								AND 
								 EXISTS (SELECT CodigoGrupo FROM @CodigosGrupoTrabajo WHERE CodigoGrupo= AE.TN_CodGrupoTrabajo)	 
								)
							OR
								(A.TN_CodEstado		=	@L_TN_CodEstadoPrivado			
								AND 
								A.TC_UsuarioCrea	=	@L_TC_UsuarioCrea 
								)
					)
					AND A.TF_FechaCrea BETWEEN @L_TF_FechaInicio AND @L_TF_FechaFinal
					AND	AE.TC_NumeroExpediente			= COALESCE(@L_TC_NumeroExpediente, AE.TC_NumeroExpediente)
					GROUP BY 
					A.TU_CodArchivo, A.TC_Descripcion,A.TF_FechaCrea,AE.TB_Notifica,AE.TB_Eliminado,
					AE.TN_Consecutivo,AE.TN_CodGrupoTrabajo,A.TC_UsuarioCrea,
					AE.TC_NumeroExpediente,A.TN_CodEstado,A.TB_GenerarVotoAutomatico,A.TN_CodFormatoArchivo,AgF.TU_CodArchivo,AgF.TC_Estado,Agf.TU_CodArchivoFirmado
					OPTION(RECOMPILE);
			END
	END
	ELSE
	BEGIN
	if (@L_TB_EsAcumulacion = 1)
		begin
			SELECT DISTINCT			
			A.TU_CodArchivo				AS	Codigo,							
						A.TC_Descripcion			AS	Descripcion,			
						A.TF_FechaCrea				AS	FechaCrea,
						AE.TB_Notifica				As	Notifica,
						AE.TB_Eliminado				As	Eliminado,
						AE.TN_Consecutivo			AS  ConsecutivoHistorialProcesal,
						COUNT(AFt.TU_FirmadoPor)	AS	CantidadFirmas,
						'Split'						As	Split,
						AE.TN_CodGrupoTrabajo		AS	Codigo,
						'Split'						As	Split,
						A.TC_UsuarioCrea			AS	UsuarioRed,	
						'Split'						AS	Split,
						AE.TC_NumeroExpediente		AS  Numero,							
						'Split'						AS	Split,
						A.TN_CodEstado				AS	Estado,
						A.TB_GenerarVotoAutomatico	AS  GenerarVotoAutomatico,
						AgF.TU_CodArchivoFirmado		AS	Codigo, 
						AgF.TC_Estado					AS  EstadoFirmado
						
			FROM		Archivo.Archivo					A WITH(NOLOCK)	
			INNER JOIN	Expediente.ArchivoExpediente	AE WITH(NOLOCK)
			ON			A.TU_CodArchivo					= AE.TU_CodArchivo
			INNER JOIN	
						(
							SELECT		AE.TU_CodArchivo
							FROM		Expediente.ArchivoExpediente AE
							WHERE		AE.TC_NumeroExpediente = @L_TC_NumeroExpediente
							EXCEPT
							SELECT		LA.TU_CodArchivo
							FROM		Expediente.LegajoArchivo LA
							WHERE		LA.TC_NumeroExpediente = @L_TC_NumeroExpediente
						) AS X
						ON			X.TU_CodArchivo = A.TU_CodArchivo 
						LEFT JOIN Archivo.AsignacionFirmado AgF WITH(NOLOCK)  
						ON A.TU_CodArchivo = AgF.TU_CodArchivoAsignado AND AgF.TU_CodAsignacionFirmado IN 
						(SELECT TU_CodAsignacionFirmado 
						 FROM Archivo.AsignacionFirmante WITH(NOLOCK) 
						 WHERE 
						 TU_FirmadoPor IS NOT NULL AND 
						 TU_CodAsignacionFirmado = AgF.TU_CodAsignacionFirmado)
			LEFT JOIN Archivo.AsignacionFirmante		AFt WITH(NOLOCK)
			ON			AgF.TU_CodAsignacionFirmado		= AFt.TU_CodAsignacionFirmado  
			WHERE		AE.TB_Eliminado					=	0	
			AND			A.TN_CodEstado					=	@L_TN_CodEstadoConsulta	
			AND			AE.TC_NumeroExpediente			= COALESCE(@L_TC_NumeroExpediente, AE.TC_NumeroExpediente)		
			GROUP BY 
			A.TU_CodArchivo, A.TC_Descripcion,A.TF_FechaCrea,AE.TB_Notifica,AE.TB_Eliminado,
			AE.TN_Consecutivo,AE.TN_CodGrupoTrabajo,A.TC_UsuarioCrea,
			AE.TC_NumeroExpediente,A.TN_CodEstado,A.TB_GenerarVotoAutomatico,A.TN_CodFormatoArchivo,AgF.TU_CodArchivo,AgF.TC_Estado,Agf.TU_CodArchivoFirmado
			OPTION(RECOMPILE);
		end
		else
		begin
				SELECT	DISTINCT		
							A.TU_CodArchivo					AS	Codigo,							
							A.TC_Descripcion				AS	Descripcion,			
							A.TF_FechaCrea					AS	FechaCrea,
							AE.TB_Notifica					As	Notifica,
							AE.TB_Eliminado					As	Eliminado,
							AE.TN_Consecutivo				AS  ConsecutivoHistorialProcesal,
							COUNT(AFt.TU_FirmadoPor)		AS	CantidadFirmas,
							'Split'							As	Split,
							AE.TN_CodGrupoTrabajo			AS	Codigo,
							'Split'							As	Split,
							A.TC_UsuarioCrea				AS	UsuarioRed,	
							'Split'							AS	Split,
							AE.TC_NumeroExpediente			AS  Numero,							
							'Split'							AS	Split,
							A.TN_CodEstado					AS	Estado,
							A.TB_GenerarVotoAutomatico		AS  GenerarVotoAutomatico, 
							AgF.TU_CodArchivoFirmado			AS	Codigo,
							AgF.TC_Estado						AS  EstadoFirmado
				FROM		Archivo.Archivo					A WITH(NOLOCK)	
				INNER JOIN	Expediente.ArchivoExpediente	AE WITH(NOLOCK)
				ON			A.TU_CodArchivo					= AE.TU_CodArchivo
				INNER JOIN	
							(
								SELECT		AE.TU_CodArchivo
								FROM		Expediente.ArchivoExpediente AE
								WHERE		AE.TC_NumeroExpediente = @L_TC_NumeroExpediente
								EXCEPT
								SELECT		LA.TU_CodArchivo
								FROM		Expediente.LegajoArchivo LA
								WHERE		LA.TC_NumeroExpediente = @L_TC_NumeroExpediente
							) AS X
							ON			X.TU_CodArchivo = A.TU_CodArchivo 
							LEFT JOIN Archivo.AsignacionFirmado AgF WITH(NOLOCK) 
							ON A.TU_CodArchivo = AgF.TU_CodArchivoAsignado AND AgF.TU_CodAsignacionFirmado IN 
							(SELECT TU_CodAsignacionFirmado 
							 FROM Archivo.AsignacionFirmante WITH(NOLOCK) 
							 WHERE 
							 TU_FirmadoPor IS NOT NULL AND 
							 TU_CodAsignacionFirmado = AgF.TU_CodAsignacionFirmado)
				LEFT JOIN Archivo.AsignacionFirmante		AFt WITH(NOLOCK)
				ON			AgF.TU_CodAsignacionFirmado		= AFt.TU_CodAsignacionFirmado  
				WHERE		AE.TB_Eliminado					=	0			
				AND			A.TN_CodEstado					=	@L_TN_CodEstadoConsulta	
				AND			AE.TC_NumeroExpediente			= COALESCE(@L_TC_NumeroExpediente, AE.TC_NumeroExpediente)		
				GROUP BY 
						A.TU_CodArchivo, A.TC_Descripcion,A.TF_FechaCrea,AE.TB_Notifica,AE.TB_Eliminado,
						AE.TN_Consecutivo,AE.TN_CodGrupoTrabajo,A.TC_UsuarioCrea,
						AE.TC_NumeroExpediente,A.TN_CodEstado,A.TB_GenerarVotoAutomatico,A.TN_CodFormatoArchivo,AgF.TU_CodArchivo,AgF.TC_Estado,Agf.TU_CodArchivoFirmado
				OPTION(RECOMPILE);
		end

	END																	
END		
GO
