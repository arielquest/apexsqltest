SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez R.>
-- Fecha de creación:		<11/03/2020>
-- Descripción :			<Permite Consultar información relacionada con las solicitudes de traslado para el buzón de traslado de objetos>
-- =================================================================================================================================================
-- Modificación:			<Ronny Ramírez R.> <27/03/2020> <Se agrega validación para evitar listar registros de solicitud de traslado y 
--															transferencia en sus respectivos buzones, si estos están contenidos en otro objeto.> 
-- =================================================================================================================================================
-- Modificación:			<Ronny Ramírez R.> <02/04/2020> <Se aplica corrección por problema detectado durante las pruebas pares, pues se estaba 
--															mostrando la oficina pertenece y oficina custodia de forma invertida.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Objeto].[PA_ConsultarBuzonTrasladoObjetos]   
 	@NumeroPagina					INT,
	@CantidadRegistros				INT,
	@CodOficina_Genera_Solicitud	VARCHAR(4)			= NULL,
	@EstadoSolicitudTraslado		CHAR(1)				= NULL,
	@FechaDesde						DATETIME2			= NULL,
	@FechaHasta						DATETIME2			= NULL,
	@NumeroExpediente				VARCHAR(14)			= NULL,
	@NumeroObjeto					VARCHAR(20)			= NULL,
	@UsuarioRed						VARCHAR(30)			= NULL
AS
BEGIN
	
	--Variables
	DECLARE	@L_TN_NumeroPagina						INT						= @NumeroPagina,
			@L_TN_CantidadRegistros					INT						= @CantidadRegistros,
			@L_TC_CodOficina_Genera_Solicitud		VARCHAR(4)				= @CodOficina_Genera_Solicitud,
			@L_TC_Estado							VARCHAR(1)				= @EstadoSolicitudTraslado,
			@L_TF_FechaDesde						DATETIME2				= @FechaDesde,
			@L_TF_FechaHasta						DATETIME2				= @FechaHasta,
			@L_TC_NumeroExpediente					VARCHAR(14)				= @NumeroExpediente,
			@L_TC_NumeroObjeto						VARCHAR(20)				= @NumeroObjeto,
			@L_TC_UsuarioRedRealizaSolicitud		VARCHAR(30)				= @UsuarioRed
			
			
	DECLARE @BuzonTraslado AS TABLE
	(
		CodigoSolicitud				UNIQUEIDENTIFIER,
		CodigoObjeto				UNIQUEIDENTIFIER,
		NumeroObjeto				VARCHAR(20),
		Descripcion					VARCHAR(255),
		FechaRegistro				DATETIME2,
		EstadoDisposicion			CHAR(1),
		EstadoSolicitudTraslado		CHAR(1),
		NumeroExpediente			CHAR(14),
		OficinaCustodiaDescrip		VARCHAR(255),
		CodOficinaCustodia			VARCHAR(4),
		OficinaPerteneceDescrip		VARCHAR(255),
		OficinaPertenece			VARCHAR(4),
		EsContenedor				BIT,
		EsContenido					BIT,
		FechaSolicitudTraslado		DATETIME2
	)

  if( @L_TN_NumeroPagina is null) set @L_TN_NumeroPagina=1;

     INSERT INTO @BuzonTraslado(
	 CodigoSolicitud,
	 CodigoObjeto,		
	 NumeroObjeto,	 
	 Descripcion,
	 FechaRegistro,				
	 EstadoDisposicion,
	 EstadoSolicitudTraslado,
	 NumeroExpediente,			
	 OficinaCustodiaDescrip,
	 CodOficinaCustodia,
	 OficinaPerteneceDescrip,
	 OficinaPertenece,
	 EsContenedor,
	 EsContenido,
	 FechaSolicitudTraslado
	) 
		SELECT		T.TU_CodSolicitudTraslado						AS	CodigoSolicitud,
					A.TU_CodObjeto									AS	CodigoObjeto,
					A.TC_NumeroObjeto								AS 	NumeroObjeto,
					A.TC_Descripcion								AS 	Descripcion,
					A.TF_FechaRegistro								AS	FechaRegistro,
					D.TC_Disposicion								AS	EstadoDisposicion,
					T.TC_Estado										AS	EstadoSolicitudTraslado,
					A.TC_NumeroExpediente							AS	NumeroExpediente,
					R.TC_Nombre										AS	OficinaCustodiaDescrip,
					E.TC_CodOficina_Recibe							AS	CodOficinaCustodia,
					C.TC_Nombre										AS	OficinaPerteneceDescrip,
					C.TC_CodOficina									AS	OficinaPertenece,
					A.TB_Contenedor									AS	EsContenedor,
					CASE WHEN A.TU_CodigoObjetoPadre IS NOT NULL 
						THEN 1 ELSE 0 END							AS	EsContenido,
					T.TF_Fecha										AS	FechaSolicitudTraslado
		FROM		Objeto.Objeto									AS	A WITH(NOLOCK)
		INNER JOIN	Catalogo.Oficina								AS	C WITH(NOLOCK)
		ON			A.TC_CodOficina									=	C.TC_CodOficina
		LEFT JOIN	Objeto.Eslabon									AS	E WITH(NOLOCK)
		ON			E.TU_CodObjeto									=	A.TU_CodObjeto
		AND			E.TF_Fecha										= (
																		select max(TF_Fecha) from Objeto.Eslabon where TU_CodObjeto =	E.TU_CodObjeto
																	)
		LEFT JOIN	Catalogo.Oficina								AS	R WITH(NOLOCK)
		ON			R.TC_CodOficina									=	E.TC_CodOficina_Recibe
		LEFT JOIN	Objeto.DestinoEvidencia							AS	D WITH(NOLOCK)
		ON			D.TU_CodObjeto									=	A.TU_CodObjeto
		INNER JOIN	Objeto.SolicitudTraslado						AS	T WITH(NOLOCK)
		ON			T.TU_CodObjeto									=	A.TU_CodObjeto
		WHERE		T.TC_CodOficina_Genera_Solicitud 				= 	@L_TC_CodOficina_Genera_Solicitud
		AND			(@L_TC_Estado IS NULL							OR 	T.TC_Estado	= @L_TC_Estado)
		AND			A.TU_CodigoObjetoPadre 							IS NULL
		AND			T.TC_UsuarioRedRealizaSolicitud					=	ISNULL(@L_TC_UsuarioRedRealizaSolicitud, T.TC_UsuarioRedRealizaSolicitud)
		AND			A.TC_NumeroObjeto								=	ISNULL(@L_TC_NumeroObjeto, A.TC_NumeroObjeto)
		AND			A.TC_NumeroExpediente							=	ISNULL(@L_TC_NumeroExpediente, A.TC_NumeroExpediente)
		AND			(@L_TF_FechaDesde IS NULL						OR DATEDIFF(day, T.TF_Fecha,@L_TF_FechaDesde) <= 0)
		AND			(@L_TF_FechaHasta IS NULL						OR DATEDIFF(day, T.TF_Fecha,@L_TF_FechaHasta) >= 0)
		ORDER BY	A.TF_FechaRegistro ASC

--Obtener cantidad registros de la consulta
DECLARE @TotalRegistros AS INT = @@rowcount; 

--Resultado de la consulta
SELECT		@TotalRegistros			AS	TotalRegistros,	
			
			'SplitSolicitud'		AS	SplitSolicitud,			
			CodigoSolicitud			AS 	Codigo,
			FechaSolicitudTraslado	AS 	Fecha,
			
			'SplitObjeto'			AS	SplitObjeto,										
			CodigoObjeto			AS	Codigo,
			NumeroObjeto			AS	NumeroObjeto,
			Descripcion				AS	Descripcion,
			FechaRegistro			AS	FechaRegistro,
			EsContenedor			AS	Contenedor,
			EsContenido				AS	EsContenido,
			
			'SplitExpediente'		 	SplitExpediente,
			NumeroExpediente		AS	Numero,
			
			'SplitOficinaPertenece'		SplitOficinaPertenece,
			OficinaPertenece		AS	Codigo,
			OficinaPerteneceDescrip	AS	Descripcion,			
			
			'SplitOficinaCustodia'		SplitOficinaCustodia,
			CodOficinaCustodia		AS	Codigo,
			OficinaCustodiaDescrip	AS	Descripcion,
			
			'SplitDatos'				SplitDatos,
			EstadoDisposicion		AS	EstadoDisposicion,
			EstadoSolicitudTraslado	AS	EstadoSolicitudTraslado
FROM		@BuzonTraslado
ORDER BY	FechaRegistro ASC

OFFSET		(@L_TN_NumeroPagina - 1) * @L_TN_CantidadRegistros ROWS 
FETCH NEXT	@L_TN_CantidadRegistros ROWS ONLY
		
END
GO
