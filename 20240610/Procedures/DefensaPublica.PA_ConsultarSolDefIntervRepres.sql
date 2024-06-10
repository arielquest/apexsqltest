SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<19/02/2020>
-- Descripción :			<Permite consultar las solicitudes de defensor en la defensa>
-- Modificación:			<27/02/2020> <Aida E Siles> <Se agrega el estado de la solicitud interviniente y se ajusta para mostrar cuando expediente no existe>
-- Modificación:			<20/03/2020> <Aida E Siles> <Se agregan las variables locales.Observación revisión par.>
-- =============================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_ConsultarSolDefIntervRepres]
	@CodSolicitudDefensor	UNIQUEIDENTIFIER,
	@NumeroExpediente		VARCHAR(14)
AS
BEGIN
	DECLARE @L_TU_CodSolicitudDefensor	UNIQUEIDENTIFIER	=	@CodSolicitudDefensor,
			@L_TC_NumeroExpediente		VARCHAR(14)			=	@NumeroExpediente

	DECLARE @ExpedienteRepresentacion AS TABLE
	(
		CodigoRepresentacion				UNIQUEIDENTIFIER,
		CodigoInterviniente					UNIQUEIDENTIFIER,
		CodigoPersona						UNIQUEIDENTIFIER,
		NRD									VARCHAR(14),
		NumeroExpediente					VARCHAR(14),
		Contexto							VARCHAR(4),
		CodigoEstadoRepresentacion			SMALLINT,
		EstadoRepresentacionDescrip			VARCHAR(150),
		TF_Movimiento						DATETIME2,
		Circulante							CHAR(1)
	)

     INSERT INTO @ExpedienteRepresentacion
	 (
		CodigoRepresentacion,
		CodigoInterviniente,
		CodigoPersona,
		NRD,
		NumeroExpediente,
		Contexto,
		CodigoEstadoRepresentacion,
		EstadoRepresentacionDescrip,
		TF_Movimiento,
		Circulante
	 )
	 
	SELECT		R.TU_CodRepresentacion,			R.TU_CodInterviniente,
				R.TU_CodPersona,				R.TC_NRD,
				C.TC_NumeroExpediente, 			C.TC_CodContexto,
				M.TN_CodEstadoRepresentacion,	E.TC_Descripcion,
				M.TF_Movimiento,				E.TC_Circulante
	FROM		DefensaPublica.Representacion								R With(NoLock) 
	INNER JOIN	DefensaPublica.Carpeta										C With(NoLock)
	ON			R.TC_NRD													= C.TC_NRD
	INNER JOIN	DefensaPublica.RepresentacionMovimientoCirculante			M With(NoLock)
	ON			R.TU_CodRepresentacion										= M.TU_CodRepresentacion
	INNER JOIN	Catalogo.EstadoRepresentacion								E With(NoLock)
	ON			M.TN_CodEstadoRepresentacion								= E.TN_CodEstadoRepresentacion
	WHERE		C.TC_NumeroExpediente = @L_TC_NumeroExpediente
	AND 		M.TF_Movimiento = (	SELECT MAX(MC.TF_Movimiento)
									FROM DefensaPublica.RepresentacionMovimientoCirculante MC
									WHERE MC.TU_CodRepresentacion = R.TU_CodRepresentacion )
    
	--Resultado de la consulta
	SELECT	B.TU_CodSolicitudDefensor			AS CodSolicitudDefensor,
	        'Split'								AS Split,
			B.TU_CodInterviniente				AS CodigoInterviniente,
			'Split'								AS Split,
			H.TN_CodTipoIntervencion			AS Codigo,
			H.TC_Descripcion					AS Descripcion,
			'Split'								AS Split,
			I.TN_CodTipoIdentificacion			AS Codigo,
			I.TC_Descripcion					AS Descripcion,		
			I.TC_Formato						AS Formato,
			'Split'								AS Split,
			D.TU_CodPersona						AS CodigoPersona,
			E.TC_Identificacion					AS Identificacion,
			F.TC_Nombre							AS Nombre,
			F.TC_PrimerApellido					AS PrimerApellido,
			F.TC_SegundoApellido				AS SegundoApellido,
			'Split'								AS Split,		
			B.TC_EstadoSolicitudInterviniente   AS EstadoSolicitudInterviniente,
			D.TC_NumeroExpediente				AS NumeroExpediente,
			T.CodigoRepresentacion				AS CodigoRepresentacion,
			T.Contexto							AS ContextoDefensa,
			T.NRD								AS NRD,																	
			T.CodigoEstadoRepresentacion		AS CodEstadoRepresentacion,
			T.EstadoRepresentacionDescrip		AS EstadoRepresentacionDescrip,	
			T.TF_Movimiento						AS FechaMovimiento,		
			T.Circulante						AS Circulante	

	FROM	Expediente.SolicitudDefensor								A With(NoLock)	
			INNER JOIN Expediente.SolicitudDefensorInterviniente		B With(NoLock)
			ON A.TU_CodSolicitudDefensor								= B.TU_CodSolicitudDefensor
			INNER JOIN Expediente.Interviniente							C With(NoLock)
			ON B.TU_CodInterviniente									= C.TU_CodInterviniente
			INNER JOIN Expediente.Intervencion							D With(NoLock)
			ON B.TU_CodInterviniente									= D.TU_CodInterviniente
			INNER JOIN Persona.Persona									E With(NoLock)
			ON D.TU_CodPersona											= E.TU_CodPersona			
			INNER JOIN Persona.PersonaFisica							F With(NoLock)
			ON D.TU_CodPersona											= F.TU_CodPersona
			INNER JOIN Catalogo.TipoIntervencion						H With(NoLock)
			ON C.TN_CodTipoIntervencion									= H.TN_CodTipoIntervencion
			INNER JOIN Catalogo.TipoIdentificacion						I  With(NoLock)
			ON E.TN_CodTipoIdentificacion								= I.TN_CodTipoIdentificacion
			LEFT JOIN @ExpedienteRepresentacion							T
			ON 	T.CodigoInterviniente									= D.TU_CodInterviniente
	WHERE   B.TU_CodSolicitudDefensor = @L_TU_CodSolicitudDefensor
END
GO
