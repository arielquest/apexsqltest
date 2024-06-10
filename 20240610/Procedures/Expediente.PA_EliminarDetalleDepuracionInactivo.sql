SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rafa Badilla Alvarado
-- Create date: 26/05/2023
-- Description:	Procedimiento para para eliminar un expediente o legajo de la lista de registros ligados a una solicitud de Expediente Inactivo
-- =============================================
CREATE   PROCEDURE [Expediente].[PA_EliminarDetalleDepuracionInactivo]
	@CodDetalleDepuracion bigint
AS
BEGIN

--Variables
DECLARE @TN_CodDetalleDepuracion bigint =	@CodDetalleDepuracion

DELETE 
FROM Expediente.DetalleDepuracionInactivo
WHERE TN_CodDetalleDepuracion			=	@TN_CodDetalleDepuracion

END

GO
