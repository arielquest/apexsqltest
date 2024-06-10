SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Olger Gamboa Castillo
-- Create date: 20/04/2020
-- Description:	Procedimiento para para actualizar una solicitud de depuración de expediente
-- =============================================
CREATE PROCEDURE [Expediente].[PA_ModificarSolicitudDepuracionInactivo]
	@CodSolicitud bigint,
	@Estado char(1)=NULL
AS
BEGIN
	--Variables
DECLARE @TN_CodSolicitud bigint			=   @CodSolicitud,
		@TC_Estado	char(1)				=	@Estado

UPDATE Expediente.SolicitudCargaInactivo
SET	   TC_Estado=COALESCE(@TC_Estado,TC_Estado)					  				
WHERE  @TN_CodSolicitud=@TN_CodSolicitud

END
GO
