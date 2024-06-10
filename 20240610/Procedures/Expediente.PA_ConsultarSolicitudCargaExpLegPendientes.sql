SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<22/12/2022>
-- Descripción :			<Permite consultar las solicitudes de carga de expedientes y legajos inactivos pendientes de procesar
-- ===============================================================================================================================================================================
-- 
-- ===============================================================================================================================================================================
CREATE           PROCEDURE [Expediente].[PA_ConsultarSolicitudCargaExpLegPendientes]
AS 
BEGIN

	SELECT
	[TN_CodSolicitud]							AS	CodigoSolicitud,
	[TB_ValidarSREM]							AS	ValidarSREM,
	[TB_ValidarDocumento]						AS	ValidarDocumento,
	[TB_ValidarEscrito]							AS	ValidarEscrito,
	[TC_UsuarioRed]								AS	UsuarioRed,
	[TC_CodContexto]							AS	CodigoContexto,
	[TF_Corte]									AS	FechaCorte
	FROM [Expediente].[SolicitudCargaInactivo]	WITH(NOLOCK)
	WHERE	
	[TC_Estado]									=	'P'

END
GO
