SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Rafa Badilla Alvarado>
-- Fecha de creación:		<17/11/2022>
-- Descripción :			<Permite eliminar una solicitud de carga de expedientes y legajos inactivos>
-- ===========================================================================================
CREATE     PROCEDURE [Expediente].[PA_EliminarCargaExpedienteInactivo]
	@CodSolicitud			 BigInt
AS
BEGIN
	--Variables.
	DECLARE	@L_CodSolicitud	  BigInt	=	@CodSolicitud
	BEGIN
		DELETE	
		FROM	[Expediente].[SolicitudCargaInactivo]
		WHERE	[TN_CodSolicitud]		=	@L_CodSolicitud
	END 
END
GO
