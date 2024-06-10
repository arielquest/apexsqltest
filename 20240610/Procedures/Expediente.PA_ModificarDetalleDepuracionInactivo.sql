SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Olger Gamboa Castillo
-- Create date: 20/04/2021
-- Description:	Procedimiento para para actualizar un expediente o legajo de acuerdo a la verificación en el SREM o depósito judicial
-- =============================================
CREATE PROCEDURE [Expediente].[PA_ModificarDetalleDepuracionInactivo]
	@CodDetalleDepuracion bigint,
	@CodSolicitud bigint,
	@TieneDepositos bit=NULL,
	@TieneMandamientos bit=NULL,
	@Estado char(1)=NULL,
	@Resultado varchar(100)=null
AS
BEGIN
	--Variables
DECLARE @TN_CodSolicitud bigint			=   @CodSolicitud,
		@TN_CodDetalleDepuracion bigint =	@CodDetalleDepuracion,
		@TB_TieneMandamientos bit		=	@TieneMandamientos,
		@TB_TieneDepositos bit			=	@TieneDepositos,
		@TC_Estado	char(1)				=	@Estado,
		@TC_Resultado varchar(100)		=	@Resultado

UPDATE Expediente.DetalleDepuracionInactivo
SET TB_TieneMandamientos=COALESCE(@TB_TieneMandamientos,TB_TieneMandamientos),	TB_TieneDepositos=COALESCE(@TB_TieneDepositos,TB_TieneDepositos),
	TC_Estado=COALESCE(@TC_Estado,TC_Estado),					  				TC_Resultado=COALESCE(@TC_Resultado,TC_Resultado)
WHERE TN_CodDetalleDepuracion=@TN_CodDetalleDepuracion AND TN_CodSolicitud=@TN_CodSolicitud

END

GO
