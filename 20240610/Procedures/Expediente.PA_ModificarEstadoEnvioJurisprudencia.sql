SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================================================================
-- Autor:		<Gerardo Lopez>
-- Fecha Creación: <30/08/2018>
-- Descripcion:	<Actualizar estada de envio de una registro resolucion de expediente.>
--===========================================================================================================================================
CREATE   PROCEDURE [Expediente].[PA_ModificarEstadoEnvioJurisprudencia] 
	@CodResolucion          uniqueidentifier,
	@EstadoEnvio            char(1),
	@Observaciones          varchar(255)=null,	
	@FechaEnvio            datetime2=null,
	@UsuarioRed            varchar(30)=null
AS
BEGIN

 --//En caso de cancelar envio se pone por defecto valores de envio. => @EstadoEnvio = 'N'
 if @EstadoEnvio = 'N'  
 UPDATE [Expediente].[Resolucion]
      SET   [TC_EstadoEnvioSAS] = @EstadoEnvio  
		   ,[TC_ObservacionSAS] = null
		   ,[TF_FechaEnvioSAS] =  null
		   ,[TC_UsuarioRedSAS] =  null
		   ,[TC_DescripcionSensible] = null
		   ,[TB_DatoSensible]        = 0
		   ,[TB_Relevante]           = 0
      WHERE
          [TU_CodResolucion] = @CodResolucion  
 else
UPDATE [Expediente].[Resolucion]
      SET   [TC_EstadoEnvioSAS] = @EstadoEnvio  
		   ,[TC_ObservacionSAS] = case when @Observaciones is null then TC_ObservacionSAS else @Observaciones end
		   ,[TF_FechaEnvioSAS] =  case when @FechaEnvio    is null then TF_FechaEnvioSAS  else @FechaEnvio    end
		   ,[TC_UsuarioRedSAS] =  case when @UsuarioRed    is null then TC_UsuarioRedSAS  else @UsuarioRed    end
      WHERE
          [TU_CodResolucion] = @CodResolucion 
 
 
END

 





GO
