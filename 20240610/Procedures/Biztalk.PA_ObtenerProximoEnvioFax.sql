SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Cristian Cerdas Camacho>
-- Fecha de creación:		08/01/2020>
-- Descripción:				<Procedimiento que se encarga de retornar la fecha del proximo envío. > 
-- Modificación				01/07/2020 Cristian Cerdas <Se cambia la última sentencia de Select a Set>
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ObtenerProximoEnvioFax]
(
   	@FechaIntentoEnvio		DATETIME2(7),
	@Contexto	            VARCHAR(4),
	@HoraEnvio              VARCHAR(5),
	@CantidadIntentos       INT,
	@TiempoEsperaEnvio		INT
)
AS
BEGIN
SET NOCOUNT ON;

	   DECLARE @Dia							INT  
 	   DECLARE @DiaHabil					BIT
	   DECLARE @FechaProxEnvio				DATETIME2
	   DECLARE @FechaProxEnvioTemp              DATETIME2
	   DECLARE @CodCircuito					SMALLINT
	   DECLARE @TempHoraEnvio				TIME
	   DECLARE @TempFechaIntentoEnvio		DATETIME2(7)
	   DECLARE @TempContexto				VARCHAR(4)
	   DECLARE @EnvioInmediato              BIT	
	   DECLARE @TempCantidadIntentos		INT
	   DECLARE @TempTiempoEsperaEnvio		INT
	   
	   SET @TempFechaIntentoEnvio = @FechaIntentoEnvio
	   SET @TempContexto = @Contexto
	   SET @TempHoraEnvio = CAST(@HoraEnvio AS TIME)
	   SET @TempCantidadIntentos = @CantidadIntentos
	   SET @TempTiempoEsperaEnvio = @TiempoEsperaEnvio

	   SELECT  @FechaProxEnvioTemp =     DATEADD(day, 1, @FechaIntentoEnvio) 
	   SET @DiaHabil	= 0
	   SET @EnvioInmediato = 1


	   IF (@TempCantidadIntentos = 5)
	   BEGIN
			SET @EnvioInmediato = 0
			SET @FechaProxEnvioTemp = @FechaIntentoEnvio
	   END
	   ELSE
	   BEGIN
			IF (@TempCantidadIntentos <3) OR (@TempCantidadIntentos	= 4) OR (@TempContexto = '0007')
			BEGIN
				SELECT @FechaProxEnvioTemp = DATEADD(MINUTE, @TempTiempoEsperaEnvio, @FechaIntentoEnvio)
				SET @EnvioInmediato = 1			   
			END
			ELSE
			BEGIN
				WHILE @DiaHabil	= 0
					BEGIN
						SELECT @dia= DATEPART(dw,@FechaProxEnvioTemp)
						--7 Día sabado
						--1 Día domingo
						IF (@dia <> 7 AND @Dia <> 1)
						BEGIN
			    			--Verificamos si existe el día feriado en la tabla Agenda.DiaFestivo
								IF (Select	COUNT(*)
									From	Agenda.DiaFestivo					A	WITH(NOLOCK)
									JOIN	Agenda.DiaFestivoCircuito			B	WITH(NOLOCK)
									On		A.TF_FechaFestivo			=		B.TF_FechaFestivo
									JOIN	Catalogo.Oficina					C	WITH(NOLOCK)
									On		C.TN_CodCircuito			=		B.TN_CodCircuito
									Where	C.TC_CodOficina				=		@TempContexto
									AND		A.TF_FechaFestivo			=		@FechaProxEnvioTemp) = 0
								BEGIN
									SELECT @DiaHabil = 1
								END				
							ELSE
							BEGIN
								SELECT @FechaProxEnvioTemp= DATEADD(day, 1, @FechaProxEnvioTemp)
							END				
						END
						ELSE
						BEGIN
								SELECT @FechaProxEnvioTemp= DATEADD(day, 1, @FechaProxEnvioTemp)
						END
					END --WHILE
	 
					SELECT @FechaProxEnvioTemp = DATETIMEFROMPARTS(datepart(YEAR, @FechaProxEnvioTemp), datepart(MONTH, @FechaProxEnvioTemp), datepart(DAY, @FechaProxEnvioTemp), datepart(HOUR, @TempHoraEnvio), datepart(MINUTE, @TempHoraEnvio), 0, 0)
			END
	END
	SET @FechaProxEnvio = CONVERT(DATETIME2,DATEADD(ss,-1 *DATEDIFF(ss,GETUTCDATE(),GETDATE()),@FechaProxEnvioTemp))
	SELECT @FechaProxEnvio AS 'FechaProximoEnvio', @TempCantidadIntentos AS 'CantidadIntentosEnvio', @EnvioInmediato AS 'EnvioInmediato'

END
GO
