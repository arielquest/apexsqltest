SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================================================================================================
-- Autor:		   <Jonathan Aguilar Navarro>
-- Fecha Creación: <16/11/2018>
-- Descripcion:	   <Permite consultar los archivos de una solicitd de desacumulación>
-- =======================================================================================================================================
-- Modificación:	<Jonathan Aguilar Navarro> <19/02/2019> <Se agrega el parametro numeroexpediente a la consulta.>
-- Modificación:	<Jonathan Aguilar Navarro> <12/08/2019> <Se excluyen los archivo de los legajos en la consulta>
-- Modificación:	<Aida Elena Siles Rojas> <07/10/2020> <Se agrega a la consulta el consecutivo del documento>
-- =======================================================================================================================================

CREATE PROCEDURE [Historico].[PA_ConsultarArchivosSolicitudDesacumulacion]
	@CodSolicitud		UNIQUEIDENTIFIER,
	@NumeroExpediente	VARCHAR(14)
AS
BEGIN
--Variables  
	 DECLARE 
	 @L_CodSolicitud				 UNIQUEIDENTIFIER		= @CodSolicitud,    
	 @L_NumeroExpediente			 VARCHAR(14)			= @NumeroExpediente
--Lógica
	SELECT	C.TU_CodSolicitud		AS	CodigoSolicitud,
			'Split'					AS	Split,
			A.TU_CodArchivo			AS	Codigo,							
			A.TC_Descripcion		AS	Descripcion,			
			A.TF_FechaCrea			AS	FechaCrea,		
			AE.TN_Consecutivo		AS  ConsecutivoHistorialProcesal,
			'Split'					AS	Split,
			C.TC_ModoSeleccion		AS	Modo,
			AE.TC_NumeroExpediente	AS	NumeroExpediente,
			AE.TN_CodGrupoTrabajo	AS  GrupoTrabajo,
			AE.TB_Notifica			AS  Notifica,
			AE.TB_Eliminado			AS	Eliminado
										
	FROM		Historico.ArchivoSolicitudDesacumulacion	C
	INNER JOIN	Historico.SolicitudDesacumulacion			D
	ON			D.TU_CodSolicitud						=	C.TU_CodSolicitud	
	INNER JOIN	Archivo.Archivo								A WITH(NOLOCK)
	ON			A.TU_CodArchivo							=	C.TU_CodArchivo
	INNER JOIN	Expediente.ArchivoExpediente				AE WITH(NOLOCK)
	ON			A.TU_CodArchivo							=	AE.TU_CodArchivo
	INNER JOIN	
					(
						SELECT		AE.TU_CodArchivo
						FROM		Expediente.ArchivoExpediente AE
						WHERE		AE.TC_NumeroExpediente = @L_NumeroExpediente
						EXCEPT
						SELECT		LA.TU_CodArchivo
						FROM		Expediente.LegajoArchivo LA
						WHERE		LA.TC_NumeroExpediente = @L_NumeroExpediente
					) AS X
					ON				X.TU_CodArchivo		= A.TU_CodArchivo 
	WHERE		C.TU_CodSolicitud						=	@L_CodSolicitud
	AND			AE.TC_Numeroexpediente					=	@L_NumeroExpediente

END
GO
