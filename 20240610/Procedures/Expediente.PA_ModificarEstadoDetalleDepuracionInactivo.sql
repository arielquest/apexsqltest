SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jefferson Parker Cortes
-- Create date: 29/05/2023
-- Description:	Procedimiento  para modificar el estado de un expediente o legajo 
-- =============================================
CREATE       PROCEDURE [Expediente].[PA_ModificarEstadoDetalleDepuracionInactivo]
	@CodDetalleDepuracion	bigint,
	@Estado					int,
	@DescripcionEstado		varchar(150)
AS
BEGIN

--Variables
DECLARE @TN_CodDetalleDepuracion bigint		   =   @CodDetalleDepuracion
DECLARE @TN_CodEstado				 int	   =   @Estado
DECLARE @TC_DescripcionEstado	 varchar(150)  =   @DescripcionEstado

UPDATE   Expediente.DetalleDepuracionInactivo

SET TN_CodEstado								  = @TN_CodEstado,
    TC_DescripcionEstado						  = @TC_DescripcionEstado
WHERE TN_CodDetalleDepuracion			          = @TN_CodDetalleDepuracion

END

GO
