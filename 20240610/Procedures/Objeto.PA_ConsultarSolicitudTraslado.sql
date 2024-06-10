SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<16/03/2020>
-- Descripción:			<Permite consultar un registro en la tabla: SolicitudTraslado.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ConsultarSolicitudTraslado]

	@Codigo						UNIQUEIDENTIFIER = NULL,
	@CodigoObjeto				UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodSolicitudTraslado		UNIQUEIDENTIFIER		= @Codigo,
			@L_TU_CodigoObjeto				UNIQUEIDENTIFIER		= @CodigoObjeto
	--Lógica
	SELECT		A.TU_CodSolicitudTraslado						AS	Codigo,
				A.TC_UsuarioRedRealizaSolicitud					AS	UsuarioRedRealizaSolicitud,
				A.TC_NombreCompletoRealizaTraslado				AS	NombreCompletoRealizaTraslado,
				A.TF_Fecha										AS	Fecha,
				A.TC_Observaciones								AS	Observaciones,
				A.TC_UsuarioRedAutorizaSolicitud				AS	UsuarioRedAutorizaSolicitud,
				A.TC_ObservacionesAutorizacion					AS	ObservacionesAutorizacion,
				A.TF_FechaAutorizacion							AS	FechaAutorizacion,

				'SplitObjeto'									AS	SplitObjeto,		
				B.TU_CodObjeto									AS	Codigo,
				B.TC_NumeroObjeto								AS 	NumeroObjeto,
				B.TC_Descripcion								AS 	Descripcion,
				B.TB_Contenedor									AS	Contenedor,				
				
				'SplitExpediente'		 						AS	SplitExpediente,
				B.TC_NumeroExpediente							AS	Numero,			
				
				'SplitOficinaGeneraSolicitud'					AS	SplitOficinaGeneraSolicitud,	
				A.TC_CodOficina_Genera_Solicitud				AS	Codigo,
				C.TC_Nombre										AS 	Descripcion,

				'SplitCircuitoGeneraSolicitud'					AS	SplitCircuitoGeneraSolicitud,	
				C.TN_CodCircuito								AS	Codigo,
				E.TC_Descripcion								AS 	Descripcion,

				'SplitOficinaDestino'							AS	SplitOficinaDestino,	
				A.TC_CodOficina_Destino							AS	Codigo,
				D.TC_Nombre										AS 	Descripcion,

				'SplitCircuitoDestino'							AS	SplitCircuitoDestino,	
				D.TN_CodCircuito								AS	Codigo,
				F.TC_Descripcion								AS 	Descripcion,

				'SplitObjetoPadre'								AS	SplitObjetoPadre,		
				B.TU_CodigoObjetoPadre							AS	Codigo,	
				
				'SplitDatos'									SplitDatos,
				A.TC_Estado										AS	Estado,
				B.TC_TipoObjeto									AS	TipoObjeto
	FROM		Objeto.SolicitudTraslado						AS	A WITH(NOLOCK)
	INNER JOIN	Objeto.Objeto									AS	B WITH(NOLOCK)
	ON			A.TU_CodObjeto									=	B.TU_CodObjeto
	INNER JOIN	Catalogo.Oficina								AS	C WITH(NOLOCK)
	ON			A.TC_CodOficina_Genera_Solicitud				=	C.TC_CodOficina	
	INNER JOIN	Catalogo.Oficina								AS	D WITH(NOLOCK)
	ON			A.TC_CodOficina_Destino							=	D.TC_CodOficina
	INNER JOIN	Catalogo.Circuito								AS	E WITH(NOLOCK)
	ON			C.TN_CodCircuito								=	E.TN_CodCircuito
	INNER JOIN	Catalogo.Circuito								AS	F WITH(NOLOCK)
	ON			D.TN_CodCircuito								=	F.TN_CodCircuito
	WHERE		A.TU_CodObjeto									= @L_TU_CodigoObjeto
	AND			A.TU_CodSolicitudTraslado						= Coalesce(@L_TU_CodSolicitudTraslado, A.TU_CodSolicitudTraslado)
END
GO
