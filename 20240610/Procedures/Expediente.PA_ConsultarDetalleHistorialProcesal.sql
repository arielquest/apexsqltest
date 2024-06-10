SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versi¢n:					<1.0>
-- Creado por:				<Ronny Ram¡rez R.>
-- Fecha de creaci¢n:		<18/06/2020>
-- Descripci¢n :			<Permite consultar el detalle de un registro del historial procesal de un expediente>
-- =================================================================================================================================================
-- Modificaci¢n:	<Andrew Allen> <21/08/2020> <Se agrega el campo expediente como campo de retorno en la consulta>
-- =================================================================================================================================================
-- =================================================================================================================================================
-- Modificaci¢n:	<Donald Vargas Z£ñiga> <07/06/2021> <Se modifica consulta con la tabla Catalogo.Funcionario para documentos y actas como LEFT JOIN; ya que las actas de comunicaci¢n no son generadas por una persona funcionaria judicial>
-- Modificaci¢n:	<Fabian Sequeira> <30/06/2021> <Se modifica para que se obtenga el Id del archivo del escrito y no el id del escrito>
-- =================================================================================================================================================
 CREATE PROCEDURE [Expediente].[PA_ConsultarDetalleHistorialProcesal]
	@Identificador			varchar(50),
	@Clasificacion			char(1),
	@CodigoInterviniente	uniqueidentifier	= NULL
AS 

BEGIN

-- Variables 
		DECLARE	@L_Identificador			varchar(50)				= @Identificador,
				@L_Clasificacion			char(1)					= @Clasificacion,
				@L_CodigoInterviniente		uniqueidentifier		= @CodigoInterviniente

-- L¢gica

	IF @L_Clasificacion = 'D'
		BEGIN
			-- Consulta de documentos
			SELECT		convert(varchar(50), AE.TU_CodArchivo)		AS		Identificador,
						A.TC_Descripcion							AS		Descripcion,
						A.TF_FechaCrea								AS		FechaCreacion,
						A.TF_Actualizacion							AS		FechaModificacion,
						AE.TN_Consecutivo							AS		Consecutivo,
						'Split'										AS		'Split',
						F.TC_UsuarioRed								AS		UsuarioRed,
						F.TC_Nombre									AS		Nombre,
						F.TC_PrimerApellido							AS		PrimerApellido,
						F.TC_SegundoApellido						AS		SegundoApellido,
						'Split'										AS		'Split',
						NULL										AS		Codigo,
						'Split'										AS		'Split',
						A.TN_CodEstado								AS		Estado,
						@L_Clasificacion							AS		Clasificacion,
						'Split'										AS		'Split',
						E.TC_NumeroExpediente						AS		 Numero
						
			FROM		Archivo.Archivo								A	WITH(NOLOCK)
			INNER JOIN	Expediente.ArchivoExpediente				AE	WITH(NOLOCK)
			ON			AE.TU_CodArchivo							=	A.TU_CodArchivo
			JOIN		Expediente.Expediente						E	WITH(NOLOCK)
			ON			E.TC_NumeroExpediente						=	AE.TC_NumeroExpediente
			LEFT JOIN	Catalogo.Funcionario						F	WITH(NOLOCK)
			ON			F.TC_UsuarioRed								=	A.TC_UsuarioCrea
			WHERE		A.TU_CodArchivo								=	@L_Identificador
			AND			AE.TB_Eliminado								=	0

		END
	ELSE IF @L_Clasificacion IN ('A', 'V')
		BEGIN
			--Consulta de audiencias
			SELECT		
						Convert(varchar(50), A.TN_CodAudiencia)		AS		Identificador,
						A.TC_Descripcion							AS		Descripcion,
						A.TF_FechaCrea								AS		FechaCreacion,
						A.TF_Actualizacion							AS		FechaModificacion,
						A.TN_Consecutivo							AS		Consecutivo,
						'Split'										AS		'Split',
						F.TC_UsuarioRed								AS		UsuarioRed,
						F.TC_Nombre									AS		Nombre,
						F.TC_PrimerApellido							AS		PrimerApellido,
						F.TC_SegundoApellido						AS		SegundoApellido,
						'Split'										AS		'Split',
						NULL										AS		Codigo,
						'Split'										AS		'Split',
						NULL										AS		Estado,
						@L_Clasificacion							AS		Clasificacion,
						'Split'										AS		'Split',
						E.TC_NumeroExpediente						AS		 Numero

			FROM		Expediente.Audiencia					A	WITH(NOLOCK)
			INNER JOIN	Catalogo.Funcionario					F	WITH(NOLOCK)
			ON			F.TC_UsuarioRed							=	A.TC_UsuarioRedCrea
			JOIN		Expediente.Expediente					E	WITH(NOLOCK)
			ON			E.TC_NumeroExpediente					=	A.TC_NumeroExpediente
			WHERE		A.TN_CodAudiencia						=	@L_Identificador

		END
	ELSE IF @L_Clasificacion = 'E'
		BEGIN
			
			--Consulta de escritos 
			SELECT		convert(varchar(50), EE.TC_IDARCHIVO)		AS		Identificador,
						EE.TC_Descripcion							AS		Descripcion,
						EE.TF_FechaRegistro							AS		FechaCreacion,
						NULL										AS		FechaModificacion,
						EE.TN_Consecutivo							AS		Consecutivo,
						'Split'										AS		'Split',
						NULL										AS		UsuarioRed,
						'Split'										AS		'Split',
						TE.TN_CodTipoEscrito						AS		Codigo,
						TE.TC_Descripcion							AS		Descripcion,
						'Split'										AS		'Split',
						NULL										AS		Estado,
						@L_Clasificacion							AS		Clasificacion,
						'Split'										AS		'Split',
						EE.TC_NumeroExpediente						AS		 Numero
			FROM		Expediente.EscritoExpediente				EE	WITH(NOLOCK)
			INNER JOIN	Catalogo.TipoEscrito						TE	WITH(NOLOCK)
			ON			TE.TN_CodTipoEscrito						= EE.TN_CodTipoEscrito
			WHERE		EE.TC_IDARCHIVO							=	@L_Identificador

		END
	ELSE IF @L_Clasificacion = 'N'
		BEGIN
			--Se insertan Actas	de notificaci¢n con base en los documentos insertados y que sean de tipo resoluci¢n
			SELECT		convert(varchar(50), A.TU_CodArchivo)		AS		Identificador,
						'Acta de notificaci¢n'						AS		Descripcion,
						AC.TF_FechaAsociacion						AS		FechaCreacion,
						A.TF_Actualizacion							AS		FechaModificacion,
						NULL										AS		Consecutivo,
						'Split'										AS		'Split',
						F.TC_UsuarioRed								AS		UsuarioRed,
						F.TC_Nombre									AS		Nombre,
						F.TC_PrimerApellido							AS		PrimerApellido,
						F.TC_SegundoApellido						AS		SegundoApellido,
						'Split'										AS		'Split',
						NULL										AS		Codigo,
						'Split'										AS		'Split',
						C.TC_Estado									AS		Estado,
						C.TC_Resultado								AS		Resultado,
						@L_Clasificacion							AS		Clasificacion,
						'Split'										AS		'Split',
						E.TC_NumeroExpediente						AS		 Numero
			FROM		Comunicacion.Comunicacion				C		WITH(NOLOCK)
			INNER JOIN	Comunicacion.ArchivoComunicacion		AC		WITH(NOLOCK)
			ON			C.TU_CodComunicacion					=		AC.TU_CodComunicacion
			INNER JOIN	Comunicacion.ComunicacionIntervencion	CI		WITH(NOLOCK)
			ON			CI.TU_CodComunicacion					=		C.TU_CodComunicacion
			INNER JOIN	Archivo.Archivo							A		WITH(NOLOCK)
			ON			AC.TU_CodArchivo						=		A.TU_CodArchivo
			INNER JOIN	Expediente.Expediente					E		WITH(NOLOCK)
			ON			C.TC_NumeroExpediente					=		E.TC_NumeroExpediente
			INNER JOIN	Expediente.Resolucion					R		WITH(NOLOCK)
			ON			A.TU_CodArchivo							=		R.TU_CodArchivo
			LEFT JOIN	Catalogo.Funcionario					F		WITH(NOLOCK)
			ON			F.TC_UsuarioRed							=		A.TC_UsuarioCrea
			WHERE		A.TU_CodArchivo							=		@L_Identificador
			AND			AC.TB_EsActa							=		1
			AND			CI.TU_CodInterviniente					=		@L_CodigoInterviniente
		END


END
SET ANSI_NULLS ON
GO
