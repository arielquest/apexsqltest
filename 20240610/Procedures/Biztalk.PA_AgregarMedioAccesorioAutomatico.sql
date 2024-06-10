SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Cristian Cerdas Camacho>
-- Fecha de creación:		<17/04/2020>
-- Descripción:				<Registra la notificación de un medio accesorio, cuando el contexto tiene activo el envío automático
--                           al medio accesorio.> 
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_AgregarMedioAccesorioAutomatico]
(
	@CodigoComunicacionPrincipal	    VARCHAR(100),
	@Estado							    CHAR(1),
	@NumeroExpediente					CHAR(14),
	@CodigoComunicacionMedioAccesorio   VARCHAR(100),
	@CodigoInterviniente				VARCHAR(100),
	@TipoConsecutivo					CHAR(1),
	@CodigoMedioComunicacion			SMALLINT,	
	@Valor								VARCHAR(350),
	@Provincia							SMALLINT,
	@Canton								SMALLINT,
	@Distrito							SMALLINT,
	@Barrio								SMALLINT,
	@Rotulado							VARCHAR(255),
	@PrioridadMedio						SMALLINT,
	@CodigoHorarioMedio					SMALLINT
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TempCodigoComunicacionPrincipal			VARCHAR(100)
	DECLARE	@TempEstado									CHAR(1)
	DECLARE @TempNumeroExpediente						CHAR(14)
	DECLARE @TempCodigoComunicacionMedioAccesorio		VARCHAR(100)
    DECLARE @TempCodigoInterviniente					VARCHAR(100)
	DECLARE @TempTipoConsecutivo						CHAR(1)
	DECLARE @TempCodigoMedioComunicacion				SMALLINT			
	DECLARE @TempValor									VARCHAR(350)
	DECLARE @TempProvincia								SMALLINT
	DECLARE @TempCanton									SMALLINT
	DECLARE @TempDistrito								SMALLINT
	DECLARE @TempBarrio									SMALLINT
	DECLARE @TempRotulado								VARCHAR(255)
	DECLARE @TempPrioridadMedio							SMALLINT
	DECLARE @TempCodigoHorarioMedio						SMALLINT
	
	--Datos de la tabla Comunicacion.Comunicacion
	DECLARE @ConsecutivoComunicacion					VARCHAR(35)
	DECLARE @CodigoContexto								CHAR(4)
	DECLARE @CodigoContextoOCJ							CHAR(4)
	DECLARE @TienePrioridad								BIT
	DECLARE @FechaResolucion							DATETIME2(7)
	DECLARE @RequiereCopias								BIT
	DECLARE @Observaciones								VARCHAR(255)
	DECLARE @CodigoPuestoTrabajoFuncionarioRegistro		UNIQUEIDENTIFIER
	DECLARE @CodigoPuestoFuncionarioEnvio				UNIQUEIDENTIFIER
	DECLARE @TipoComunicacion							CHAR(1)
	DECLARE @Sector										SMALLINT
	DECLARE @IntervencionPrincipal						BIT

	--Datos de la tabla Expediente.IntervencionMedioComunicacion se obtiene el punto de ubicación para el interviniente.
	DECLARE @TUbicacionPunto							GEOGRAPHY = NULL
	DECLARE @Latitud									FLOAT = NULL
	DECLARE @Longitud									FLOAT = NULL

	DECLARE @TempTablaConsecutivo TABLE (TC_ConsecutivoComunicacion VARCHAR(35))
	DECLARE @TempTablaCodigoSector TABLE (TN_CodSector SMALLINT)
	
	SELECT @TempCodigoComunicacionPrincipal			=  @CodigoComunicacionPrincipal	    
    SELECT @TempEstado								=  @Estado							        
	SELECT @TempNumeroExpediente					=  @NumeroExpediente						
	SELECT @TempCodigoComunicacionMedioAccesorio	=  @CodigoComunicacionMedioAccesorio   
	SELECT @TempCodigoInterviniente					=  @CodigoInterviniente	
	SELECT @TempTipoConsecutivo					    =  @TipoConsecutivo
	SELECT @TempCodigoMedioComunicacion				=  @CodigoMedioComunicacion
	SELECT @TempValor								=  @Valor					
	SELECT @TempProvincia							=  @Provincia				
	SELECT @TempCanton								=  @Canton					
	SELECT @TempDistrito							=  @Distrito				
	SELECT @TempBarrio								=  @Barrio					
	SELECT @TempRotulado					        =  @Rotulado				
	SELECT @TempPrioridadMedio						=  @PrioridadMedio			
	SELECT @TempCodigoHorarioMedio					=  @CodigoHorarioMedio		


	--Se obtiene los valores de la tabla comunicación.comunicacion
	SELECT @CodigoContexto							=	A.TC_CodContexto,				
		   @CodigoContextoOCJ						=	A.TC_CodContextoOCJ,
		   @TienePrioridad							=	A.TB_TienePrioridad,				
		   @FechaResolucion						    =	A.TF_FechaResolucion,	
		   @RequiereCopias							=	A.TB_RequiereCopias,				
		   @Observaciones							=	A.TC_Observaciones,				
		   @CodigoPuestoTrabajoFuncionarioRegistro	=   A.TU_CodPuestoFuncionarioRegistro,
		   @CodigoPuestoFuncionarioEnvio			=   A.TU_CodPuestoFuncionarioEnvio,
		   @TipoComunicacion						=   A.TC_TipoComunicacion,
		   @IntervencionPrincipal                   =	B.TB_Principal
	FROM Comunicacion.Comunicacion A
	INNER JOIN [Comunicacion].[ComunicacionIntervencion] B
	ON A.TU_CodComunicacion = B.TU_CodComunicacion
	WHERE A.TU_CodComunicacion = @TempCodigoComunicacionPrincipal
	AND b.TU_CodInterviniente = @TempCodigoInterviniente

	--Se obtiene el punto de ubicación.
	SELECT @TUbicacionPunto = TG_UbicacionPunto,
		   @Latitud = TG_UbicacionPunto.Lat,
	       @Longitud = TG_UbicacionPunto.Long	
	FROM Expediente.IntervencionMedioComunicacion
	WHERE TU_CodInterviniente = @TempCodigoInterviniente

	--Se obtiene el Consecutivo de la comunicación
	INSERT @TempTablaConsecutivo EXEC Configuracion.PA_GeneraNumeroConsecutivo @CodigoContexto,@TempTipoConsecutivo
	SET @ConsecutivoComunicacion = (SELECT TC_ConsecutivoComunicacion FROM @TempTablaConsecutivo)

	--Se registra la comunicación en la base datos
	Insert Into [Comunicacion].[Comunicacion]
	(
		TU_CodComunicacion ,				TC_ConsecutivoComunicacion ,	  TC_NumeroExpediente ,	               TC_CodContextoOCJ	,			
	    TC_CodContexto ,					TC_TipoComunicacion ,     	      TC_CodMedio ,				   		   TC_Valor,							
		TB_TienePrioridad  , 				TN_PrioridadMedio ,        		  TC_Estado ,	            		   TB_RequiereCopias , 
		TC_Observaciones ,        		    TF_Actualizacion ,                TU_CodPuestoFuncionarioRegistro ,    TF_FechaRegistro ,	
		TB_Cancelar,                        TF_FechaResolucion,               TN_CodProvincia,                     TN_CodCanton,
        TN_CodDistrito,                     TN_CodBarrio,                     TG_UbicacionPunto,                   TN_CodSector, 
		TN_CodHorarioMedio,					TC_Rotulado)
	Values
	(
		@TempCodigoComunicacionMedioAccesorio ,					@ConsecutivoComunicacion ,	    @TempNumeroExpediente ,						@CodigoContextoOCJ,
	    @CodigoContexto,										@TipoComunicacion ,             @TempCodigoMedioComunicacion ,     			@TempValor,
		@TienePrioridad, 										@TempPrioridadMedio ,			@TempEstado,								@RequiereCopias,
		@Observaciones,        									GETDATE(),         	            @CodigoPuestoTrabajoFuncionarioRegistro,	GETDATE(), 
		0,														@FechaResolucion,	            @TempProvincia,								@TempCanton,
		@TempDistrito,											@TempBarrio,                     Iif(@Latitud Is Not Null And @Longitud Is Not Null, geography::Point(@Latitud,@Longitud,4326), Null),
		Comunicacion.FN_ConsultarSectorComunicacion(  Iif(@Latitud Is Not Null And @Longitud Is Not Null, geography::Point(@Latitud,@Longitud,4326), Null),@CodigoContexto),
		@TempCodigoHorarioMedio,					@TempRotulado)

	--Se registra la información del interviniente 
	INSERT INTO [Comunicacion].[ComunicacionIntervencion]
           ([TU_CodComunicacion]           ,[TU_CodInterviniente]            ,[TB_Principal])
     VALUES
           (@TempCodigoComunicacionMedioAccesorio           ,@TempCodigoInterviniente           ,@IntervencionPrincipal)

	--Registrar los archivos asociados a la comunicación.
	INSERT INTO [Comunicacion].[ArchivoComunicacion]
           ([TU_CodArchivoComunicacion]           ,[TU_CodComunicacion]           ,[TB_EsActa]
           ,[TF_FechaAsociacion]                  ,[TU_CodArchivo]                ,[TB_EsPrincipal])
    SELECT NEWID(), @TempCodigoComunicacionMedioAccesorio, 0, GETDATE(), TU_CodArchivo, TB_EsPrincipal 
	FROM [Comunicacion].[ArchivoComunicacion]
	WHERE [TU_CodComunicacion] = @TempCodigoComunicacionPrincipal

END


GO
