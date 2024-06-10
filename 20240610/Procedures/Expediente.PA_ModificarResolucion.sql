SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:		<Gerardo Lopez>
-- Fecha Creación: <07/06/2016>
-- Descripcion:	<Modificar un registro resolucion de expediente.>
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
-- Modificación				<Jonathan Aguilar Navarro> <06/07/2018> <Se elimina de la consulta los campos [TU_CodLegajo], 
--							[TC_CodOficina],[TN_CodEstadoResolucion] [TN_CodEnvioJurisprudencia], [TB_TribunalColegiado], 
--							[TC_NumeroResolucion], [TB_Recurrente]
--							y los join correspondiente>
-- Modificación:		<30/07/2018> <Gerardo Lopez> <Agregar campos para envio jurisprudencia> 
-- Modificación			<Jonathan Aguilar Navarro> <05/09/2018> <Se agrega la categoría> 
-- MOdificacion:		<Jonathan Aguilar Navarro> <14/05/2019> < Seagregan los parametros CodContexto NumeroExpediente> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarResolucion] 
	@CodResolucion			uniqueidentifier,
	@CodContexto			varchar(4),
	@RedactorResponsable	uniqueidentifier,
	@CodTipoResolucion		smallint,
	@CodResultadoResolucion smallint,
	@CodCategoriaResolucion smallint,
	@FechaResolucion		datetime2=null,
	@PorTanto				varchar(max) =null,
	@Resumen				varchar(max) =null,
	@CodArchivo				uniqueidentifier,
	@Relevante              bit=0,
	@DatoSensible           bit=0,
	@DescripcionSensible    varchar(100)=null,
	@EstadoEnvioSAS         char(1)='N',
	@FechaEnvioSAS          datetime2=null,
	@UsuarioRedSAS          varchar(30)=null,
	@NumeroExpediente		varchar(14)
AS
BEGIN

 
UPDATE [Expediente].[Resolucion]
      SET        
            [TU_RedactorResponsable] =@RedactorResponsable
		   ,[TC_CodContexto] = @CodContexto
           ,[TN_CodTipoResolucion] =@CodTipoResolucion
           ,[TN_CodResultadoResolucion] =@CodResultadoResolucion    
		   ,[TN_CodCategoriaResolucion] =@CodCategoriaResolucion     
           ,[TF_FechaResolucion]=@FechaResolucion
           ,[TC_PorTanto] =@PorTanto
           ,[TC_Resumen] =@Resumen
           ,[TU_CodArchivo] =@CodArchivo
		   ,[TB_Relevante] =@Relevante
		   ,[TB_DatoSensible] =@DatoSensible
		   ,[TC_DescripcionSensible] =@DescripcionSensible
		   ,[TC_EstadoEnvioSAS] =@EstadoEnvioSAS
		   ,[TF_FechaEnvioSAS] =@FechaEnvioSAS
		   ,[TC_UsuarioRedSAS] =@UsuarioRedSAS
		   ,TC_NumeroExpediente =@NumeroExpediente
      WHERE
          [TU_CodResolucion] = @CodResolucion 
 
 
END





GO
