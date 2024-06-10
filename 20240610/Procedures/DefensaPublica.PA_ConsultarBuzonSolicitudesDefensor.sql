SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<AIDA ELENA SILES R>
-- Fecha de creación:		<30/01/2020>
-- Descripción :			<Permite Consultar las solicitudes de defensor para el buzon de solicitud defensor>
-- Modificación:			<11/02/2020> <AIDA E SILES> <Se agrega el lugar diligencia, fecha creación, codarchivo y observaciones de la solicitud>
-- =================================================================================================================================================
CREATE PROCEDURE [DefensaPublica].[PA_ConsultarBuzonSolicitudesDefensor]   
 	@NumeroPagina				INT,
	@CantidadRegistros			INT,
	@CodOficinaDefensa			VARCHAR(4),
	@EstadoSolicitudDefensa		CHAR(1)			= NULL,	
	@FechaDesde					DATETIME2		= NULL,
	@FechaHasta					DATETIME2		= NULL,
	@NumeroExpediente			VARCHAR(14)		= NULL,	
	@CodOficinaSolicta			VARCHAR(4)      = NULL
AS
BEGIN
	
	DECLARE @SolicitudesDefensor AS TABLE
	(
		CodigoSolicitud				UNIQUEIDENTIFIER,
		FechaEnvio					DATETIME2,
		EstadoSolicitudDefensa		CHAR(1),
		TipoSolicitud				CHAR(1),
		NumeroExpediente			CHAR(14),
		OficinaSolicitaDescrip		VARCHAR(255),
		CodOficinaSolicita			VARCHAR(4),
		OficinaDefensaDescrip		VARCHAR(255),
		CodOficinaDefensa			VARCHAR(4),
		LugarDiligencia				VARCHAR(100),
		FechaCreacion				DATETIME2,
		CodArchivo					UNIQUEIDENTIFIER,
		CodEvento					UNIQUEIDENTIFIER,
		Observaciones				VARCHAR(255)
	)

  if( @NumeroPagina is null) set @NumeroPagina=1;

     INSERT INTO @SolicitudesDefensor(
	 CodigoSolicitud,					
	 FechaEnvio,				
	 EstadoSolicitudDefensa,		
	 TipoSolicitud,				
	 NumeroExpediente,			
	 OficinaSolicitaDescrip,
	 CodOficinaSolicita,
	 OficinaDefensaDescrip,
	 CodOficinaDefensa,
	 LugarDiligencia,
	 FechaCreacion,
	 CodArchivo,
	 CodEvento,
	 Observaciones
	) 
		SELECT		A.TU_CodSolicitudDefensor						AS	CodigoSolicitud,
					A.TF_FechaEnvio									AS	FechaEnvio,
					A.TC_EstadoSolicitudDefensa						AS	EstadoSolicitudDefensa,
					A.TC_TipoSolicitudDefensor						AS	TipoSolicitud,
					A.TC_NumeroExpediente							AS	NumeroExpediente,
					C.TC_Nombre										AS	OficinaSolicitaDescrip,
					C.TC_CodOficina									AS	CodOficinaSolicita,
					D.TC_Nombre										AS	OficinaDefensaDescrip,
					D.TC_CodOficina									AS	CodOficinaDefensa,
					A.TC_LugarDiligencia							AS	LugarDiligencia,
					A.TF_FechaCreacion								AS	FechaCreacion,
					A.TU_CodArchivo									AS	CodigoArchivo,
					A.TU_Evento										AS	CodEvento,
					A.TC_Observaciones								AS	Observaciones
		FROM		Expediente.SolicitudDefensor					AS	A WITH(NOLOCK)
		INNER JOIN	Expediente.Expediente							AS	B WITH(NOLOCK)
		ON			A.TC_NumeroExpediente							=	B.TC_NumeroExpediente
		INNER JOIN	Catalogo.Oficina								AS	C WITH(NOLOCK)
		ON			A.TC_CodOficinaSolicita							=	C.TC_CodOficina
		INNER JOIN	Catalogo.Oficina								AS	D WITH(NOLOCK)
		ON			A.TC_CodOficinaDefensa							=	D.TC_CodOficina
		WHERE		A.TC_EstadoSolicitudDefensa						=	ISNULL(@EstadoSolicitudDefensa, A.TC_EstadoSolicitudDefensa)
		AND			A.TC_CodOficinaSolicita							=	ISNULL(@CodOficinaSolicta, A.TC_CodOficinaSolicita)
		AND			A.TC_NumeroExpediente							=	ISNULL(@NumeroExpediente, A.TC_NumeroExpediente)
		AND			(@FechaDesde IS NULL							OR DATEDIFF(day, A.TF_FechaEnvio,@FechaDesde) <= 0)
		AND			(@FechaHasta IS NULL							OR DATEDIFF(day, A.TF_FechaEnvio,@FechaHasta) >= 0)
		AND			A.TC_CodOficinaDefensa							=	@CodOficinaDefensa
		ORDER BY	A.TF_FechaEnvio ASC

--Obtener cantidad registros de la consulta
DECLARE @TotalRegistros AS INT = @@rowcount; 

--Resultado de la consulta
SELECT		@TotalRegistros			AS	TotalRegistros,
			'Split'					AS	Split,
			CodigoSolicitud			AS	CodigoSolicitud,
			FechaEnvio				AS	FechaEnvio,
			NumeroExpediente		AS	NumeroExpediente,
			EstadoSolicitudDefensa	AS	EstadoSolicitudDefensa,
			TipoSolicitud			AS	TipoSolicitud,
			OficinaSolicitaDescrip	AS	OficinaSolicitaDescrip,
			CodOficinaSolicita		AS	CodOficinaSolicita,
			OficinaDefensaDescrip	AS	OficinaDefensaDescrip,
			CodOficinaDefensa		AS	CodOficinaDefensa,
			LugarDiligencia			AS	LugarDiligencia,
			FechaCreacion			AS	FechaCreacion,
			CodArchivo				AS  CodigoArchivo,
			CodEvento				AS	CodEvento,
			Observaciones			AS	Observaciones
FROM		@SolicitudesDefensor
ORDER BY	FechaEnvio ASC

OFFSET		(@NumeroPagina - 1) * @CantidadRegistros ROWS 
FETCH NEXT	@CantidadRegistros ROWS ONLY
		
END
GO
