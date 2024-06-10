SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Cristian Cerdas Camacho>
-- Fecha de creación:		<30/03/2020>
-- Descripción :			<Permite actualizar el resultado de la comunicación>
-- =================================================================================================================================================
-- Modificación :			<01/06/2021> <Olger Gamboa> Toma el motivo resultado según la configuración C_BIZT_RESULTNOTI_POSITIVA
-- Modificación :			<02/02/2022> <Isaac Dobles Mata> Se elimina conversión a hora local y se agrega configuracion para que se haga
-- =================================================================================================================================================
CREATE   PROCEDURE [Biztalk].[PA_RegistrarResultadoComunicacion]
	@CodComunicacion	            VARCHAR(100),
	@ObservacionesComunicacion      VARCHAR(255),
	@ObservacionesCambioEstado	    VARCHAR(500),
	@Estado							CHAR(1),
	@Resultado                      CHAR(1),
	@FechaResultadoComunicacion     VARCHAR(27),
	@UsuarioRed						VARCHAR(30)
	
	
As
BEGIN
SET NOCOUNT ON;

	DECLARE @TempCodComunicacion	            VARCHAR(100) =	@CodComunicacion,	
	@TempObservacionesComunicacion				VARCHAR(255) =	@ObservacionesComunicacion,  
	@TempObservacionesCambioEstado				VARCHAR(500) =	@ObservacionesCambioEstado,
	@TempEstado									CHAR(1) =		@Estado,		
	@TempResultado								CHAR(1) =		@Resultado,
	@TempCodigoMotivoResultado					SMALLINT =		NULL,
	@TempFechaResultadoComunicacion				VARCHAR(27) =	@FechaResultadoComunicacion,
	@TempUsuarioRed								VARCHAR(30) =	@UsuarioRed,
	@TempFechaIntentoEnvio						DATETIME =		NULL,
	@CambioFechaLocalHabilitado					VarChar(1) =	NULL

	IF @Resultado='P'
	BEGIN
		SELECT TOP 1 @TempCodigoMotivoResultado= TC_Valor
		FROM Configuracion.ConfiguracionValor WITH(NOLOCK)
		WHERE TC_CodConfiguracion='C_BIZT_RESULTNOTI_POSITIVA'
	END
	
	SELECT TOP 1 @CambioFechaLocalHabilitado = TC_Valor
	FROM Configuracion.ConfiguracionValor WITH(NOLOCK)
	WHERE TC_CodConfiguracion='U_BIZT_CONVERTIRFHRESULTADO'

	IF @CambioFechaLocalHabilitado = '1'
	BEGIN
		SET @TempFechaIntentoEnvio = @TempFechaResultadoComunicacion
	END
	ELSE
	BEGIN
		SET @TempFechaIntentoEnvio = (SELECT DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), @TempFechaResultadoComunicacion))
	END
	
	/*Actualiza la comunicación*/
	UPDATE [Comunicacion].[Comunicacion]
	SET [TC_Estado]					= @TempEstado,
	[TC_Observaciones]				= @TempObservacionesComunicacion,
	[TC_Resultado]					= @TempResultado,
	[TN_CodMotivoResultado]			= @TempCodigoMotivoResultado,
	[TF_Actualizacion]				= GETDATE(),
	[TF_FechaResultado]				= @TempFechaIntentoEnvio,
	[TF_FechaDevolucion]			= GETDATE()
	WHERE TU_CodComunicacion		= @TempCodComunicacion;
	
	INSERT INTO [Comunicacion].CambioEstadoComunicacion
	(
		TU_CodCambioEstado,		TU_CodComunicacion,		TF_Fecha,		TC_UsuarioRed,
		TC_Observaciones,		TC_Estado
	)
	VALUES 
	(
		NEWID(),				@TempCodComunicacion,		GETDATE(),		@TempUsuarioRed,
		@TempObservacionesCambioEstado, 		@TempEstado
	);
END
GO
