SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles R>
-- Fecha de creación:	<12/10/2020>
-- Descripción:			<Permite consultar un registro en la tabla: AudienciaSolicitudDesacumulacion.>
-- ==================================================================================================================================================================================
-- <Aida Elena Siles Rojas> <14/10/2020> <Ajuste en la consulta al nombre del Alias del campo TU_CodSolicitud>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_ConsultarAudienciaSolicitudDesacumulacion]
	@CodSolicitud				UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodSolicitud			UNIQUEIDENTIFIER		= @CodSolicitud
	--Lógica
	SELECT		A.TU_CodSolicitud		    AS	SolicitudDesAcumulacion,
				'split'						AS  split,
				A.TN_CodAudiencia			AS  Codigo,				
		 	    B.TC_Descripcion			AS  Descripcion,
			    B.TC_NombreArchivo			AS  NombreArchivo,
			    B.TC_Duracion				AS  DuracionTotal,
			    B.TF_FechaCrea				AS  FechaCrea,
				B.TN_EstadoPublicacion		AS	EstadoPublicacion,
				B.TN_CantidadArchivos		AS	CantidadArchivos,
				B.TN_Consecutivo			AS	ConsecutivoHistorialProcesal,
				'split'						AS  split,
				B.TC_NumeroExpediente		AS  NumeroExpediente,
				A.TC_ModoSeleccion			AS  ModoSeleccion,
				B.TC_Estado					AS	EstadoAudiencia,
				C.TN_CodTipoAudiencia		AS  CodigoTipoAudiencia,
				C.TC_Descripcion			AS  DescripcionTipoAudiencia,
				B.TC_CodContextoCrea		AS  CodigoContextoCreacion,
				B.TC_UsuarioRedCrea			AS  UsuarioCreacion,
				B.TN_CantidadArchivos		AS	CantidadArchivos

	FROM		Historico.AudienciaSolicitudDesacumulacion		A WITH (NOLOCK)
	INNER JOIN  Expediente.Audiencia							B WITH (NOLOCK)
	ON			A.TN_CodAudiencia								= B.TN_CodAudiencia
	INNER JOIN  Catalogo.TipoAudiencia							C WITH (NOLOCK)
	ON			B.TN_CodTipoAudiencia							= C.TN_CodTipoAudiencia
	WHERE		A.TU_CodSolicitud								= @L_TU_CodSolicitud
END
GO
