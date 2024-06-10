SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Autor:		<Gerardo Lopez>
-- Fecha Creación: <27/05/2016>
-- Descripcion:	<Crear un registro resolucion de expediente.>
 -- =================================================================================================================================================
-- Modificación : 		<05/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN> 
-- Modificación:		<06/07/2018> <Jonathan Aguilar Navarro> <Se eliminan los campos [TU_CodLegajo], [TC_CodOficina],[TN_CodEstadoResolucion]>
--						[TN_CodEnvioJurisprudencia], [TB_TribunalColegiado], [TC_NumeroResolucion], [TB_Recurrente]
-- Modificación:		<30/07/2018> <Gerardo Lopez> <Agregar campos para envio jurisprudencia> 
-- Modificación			<05/09/2018> <Jonathan Aguilar Navarro> <Se agrega la categoría> 
-- Modificacion:		<14/05/2019> <Jonathan Aguilar Navarro> <Se agregan los parametros CodContexto NumeroExpediente>
-- Modificacion:		<22/02/2020> <Isaac Dobles Mata> <Se agrega el redactor responsable en una itineracion (USUREDAC) y el IDACO>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_AgregarResolucion] 
	@CodResolucion          uniqueidentifier,
	@CodContexto			varchar(4),
	@RedactorResponsable	uniqueidentifier,
	@CodTipoResolucion      smallint,
	@CodResultadoResolucion smallint,
	@CodCategoriaResolucion smallint,
	@FechaCreacion          datetime2,
	@FechaResolucion        datetime2=null,
	@PorTanto               varchar(max) =null,
	@Resumen                varchar(max) =null,
	@CodArchivo             uniqueidentifier,
	@Relevante              bit=0,
	@DatoSensible           bit=0,
	@DescripcionSensible    varchar(100)=null,
	@EstadoEnvioSAS         char(1)='N',
	@FechaEnvioSAS          datetime2=null,
	@UsuarioRedSAS          varchar(30)=null,
	@NumeroExpediente		varchar(14),
	@USUREDAC				varchar(25),
	@IDACO					int

AS
BEGIN

 
INSERT INTO [Expediente].[Resolucion]
           ([TU_CodResolucion]
		   ,[TC_CodContexto]
           ,[TU_RedactorResponsable]
           ,[TN_CodTipoResolucion]
           ,[TN_CodResultadoResolucion]
		   ,[TN_CodCategoriaResolucion]
           ,[TF_FechaCreacion]
           ,[TF_FechaResolucion]
           ,[TC_PorTanto]
           ,[TC_Resumen]
           ,[TU_CodArchivo]
           ,[TF_Actualizacion]
		   ,[TB_Relevante]
		   ,[TB_DatoSensible]
		   ,[TC_DescripcionSensible]
		   ,[TC_EstadoEnvioSAS]
		   ,[TF_FechaEnvioSAS]
		   ,[TC_UsuarioRedSAS]
		   ,[TC_NumeroExpediente]
		   ,[USUREDAC]
		   ,[IDACO])
     VALUES
           (@CodResolucion
		   ,@CodContexto
           ,@RedactorResponsable 
           ,@CodTipoResolucion 
           ,@CodResultadoResolucion 
		   ,@CodCategoriaResolucion
           ,@FechaCreacion 
           ,@FechaResolucion 
           ,@PorTanto 
           ,@Resumen 
           ,@CodArchivo 
           ,GETDATE()
		   ,@Relevante
		   ,@DatoSensible
		   ,@DescripcionSensible
		   ,@EstadoEnvioSAS
		   ,@FechaEnvioSAS
		   ,@UsuarioRedSAS
		   ,@NumeroExpediente
		   ,@USUREDAC
		   ,@IDACO)
END
GO
