SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===============================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Stefany Quesada Cascante>
-- Fecha de creación:		<17/05/2016>
-- Descripción:				<Permite agregar un registro a [Comunicacion].[Comunicacion].>
-- ===============================================================================================================================================
-- Modificado:              <23/08/2017><se agrega el el parámetro valor el cual contiene la dirección>
-- Modificación				<28/02/2018><Jonathan Aguilar Navarro> <Se cambia el parámetro CodOficina por CodContexto>
-- Modificado:              <12/11/2018><Se modifica para ajustar a la mejora de intervenciones>
--							<21/04/2020><Cristian Cerdas Camacho><Se cambia el parámetro de entrada CodigoLegajo por NumeroExpediente>
--Modificación				<14/01/2021><Karol Jiménez Sánchez><Se agregan parámetros UsuarioRegistroGestion y UsuarioEnvioGestion>
--Modificación				<24/03/2021><Aida Elena Siles R><Se agrega parámetro codlegajo para registrar comunicación a un interviniente de un legajo>
--Modificación				<07/07/2021><Karol Jiménez Sánchez><Se agrega parámetro Resultado, FechaDevolucion, FechaEnvio e IDACO, para registrarlos
--							en las comunicaciones que se reciben en Itineraciones de Gestión>
--Modificación				<20/07/2021><Ronny Ramírez R.><Se agrega parámetro FechaResultado, pues no se está registrando desde itineraciones>
--Modificación				<09-05-2023><Glopezr><Se asigna el sector a partir de los datos de barrio distrito canton y provincia>
-- ===============================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_AgregarComunicacion]
	@CodComunicacion				UNIQUEIDENTIFIER,
	@ConsecutivoComunicacion		VARCHAR(35),
	@NumeroExpediente				CHAR(14),
    @CodContexto					VARCHAR(4),
    @CodContextoOCJ					VARCHAR(4),
    @CodTipoComunicacion			CHAR,
    @CodMedio						SMALLINT,
	@TienePrioridad					BIT,
	@PrioridadMedio					SMALLINT,
	@Estado							CHAR(1),
	@RequiereCopias					BIT,
	@Observaciones					VARCHAR(255),
	@Actualizacion					DATETIME2(7),
	@CodPuestoFuncionarioRegistro	UNIQUEIDENTIFIER	= NULL,
	@FechaRegistro					DATETIME2(7),
	@Cancelar						BIT,
	@FechaResolucion				DATETIME2(7),
	@Valor							VARCHAR(350),
	@CodProvincia					INT					= NULL,
	@CodCanton						INT					= NULL,
	@CodDistrito					INT					= NULL,
	@CodBarrio						INT					= NULL,
	@CodHorarioMedio				SMALLINT			= NULL,	
	@Latitud						FLOAT				= Null,
	@Longitud						FLOAT				= NULL,
	@Rotulado						VARCHAR (255)		= NULL,
	@UsuarioRegistroGestion			VARCHAR (25)		= NULL,
	@UsuarioEnvioGestion			VARCHAR (25)		= NULL,
	@CodLegajo						UNIQUEIDENTIFIER    = NULL,
	@Resultado						CHAR				= NULL,
	@FechaDevolucion				DATETIME2			= NULL,
	@FechaEnvio						DATETIME2			= NULL,
	@IDACO							INT					= NULL,
	@FechaResultado					DATETIME2			= NULL,
	@CodSector                      SMALLINT			= NULL
AS
BEGIN
--VARIABLES
 
 
DECLARE		@L_CodComunicacion					UNIQUEIDENTIFIER	= @CodComunicacion,
			@L_ConsecutivoComunicacion			VARCHAR(35)			= @ConsecutivoComunicacion,
			@L_NumeroExpediente					CHAR(14)			= @NumeroExpediente,
			@L_CodContexto						VARCHAR(4)			= @CodContexto,
			@L_CodContextoOCJ					VARCHAR(4)			= @CodContextoOCJ,
			@L_CodTipoComunicacion				CHAR				= @CodTipoComunicacion,
			@L_CodMedio							SMALLINT			= @CodMedio,
			@L_TienePrioridad					BIT					= @TienePrioridad,
			@L_PrioridadMedio					SMALLINT			= @PrioridadMedio,
			@L_Estado							CHAR(1)				= @Estado,
			@L_RequiereCopias					BIT					= @RequiereCopias,
			@L_Observaciones					VARCHAR(255)		= @Observaciones,
			@L_Actualizacion					DATETIME2(7)		= @Actualizacion,
			@L_CodPuestoFuncionarioRegistro		UNIQUEIDENTIFIER	= @CodPuestoFuncionarioRegistro,
			@L_FechaRegistro					DATETIME2(7)		= @FechaRegistro,
			@L_Cancelar							BIT					= @Cancelar,
			@L_FechaResolucion					DATETIME2(7)		= @FechaResolucion,
			@L_Valor							VARCHAR(350)		= @Valor,
			@L_CodProvincia						INT					= @CodProvincia,
			@L_CodCanton						INT					= @CodCanton,
			@L_CodDistrito						INT					= @CodDistrito,
			@L_CodBarrio						INT					= @CodBarrio,
			@L_CodHorarioMedio					SMALLINT			= @CodHorarioMedio,	
			@L_Latitud							FLOAT				= @Latitud,
			@L_Longitud							FLOAT				= @Longitud,
			@L_Rotulado							VARCHAR (255)		= @Rotulado,
			@L_UsuarioRegistroGestion			VARCHAR (25)		= @UsuarioRegistroGestion,
			@L_UsuarioEnvioGestion				VARCHAR (25)		= @UsuarioEnvioGestion,
			@L_CodLegajo						UNIQUEIDENTIFIER	= @CodLegajo,
			@L_Resultado						CHAR				= @Resultado,
			@L_FechaDevolucion					DATETIME2			= @FechaDevolucion,
			@L_FechaEnvio						DATETIME2			= @FechaEnvio,
			@L_IDACO							INT					= @IDACO,
			@L_FechaResultado					DATETIME2			= @FechaResultado,
@L_Sector							smallint			= @CodSector
 

	INSERT INTO [Comunicacion].[Comunicacion]	WITH (ROWLOCK)
	(
		TU_CodComunicacion,			TC_ConsecutivoComunicacion,		TC_NumeroExpediente,				TC_CodContextoOCJ,			
	    TC_CodContexto,				TC_TipoComunicacion,     		TC_CodMedio,						TC_Valor,							
		TB_TienePrioridad, 			TN_PrioridadMedio,        	    TC_Estado,	            			TB_RequiereCopias, 
		TC_Observaciones,        	TF_Actualizacion,               TU_CodPuestoFuncionarioRegistro,	TF_FechaRegistro,	
		TB_Cancelar,                TF_FechaResolucion,             TN_CodProvincia,					TN_CodCanton,
        TN_CodDistrito,             TN_CodBarrio,                   
		TG_UbicacionPunto,					
		TN_CodSector, 
		TN_CodHorarioMedio,			TC_Rotulado,					IDUSU_REGISTRO,						IDUSU_ENVIO,
		TU_CodLegajo,				TC_Resultado,					TF_FechaDevolucion,					TF_FechaEnvio,
		IDACO,						TF_FechaResultado
	)
	VALUES
	(
		@L_CodComunicacion,			@L_ConsecutivoComunicacion,	    @L_NumeroExpediente,				@L_CodContextoOCJ,
	    @L_CodContexto,				@L_CodTipoComunicacion,         @L_CodMedio,						@L_Valor,						
		@L_TienePrioridad, 			@L_PrioridadMedio,				@L_Estado,							@L_RequiereCopias,
		@L_Observaciones,        	@L_Actualizacion,         	    @L_CodPuestoFuncionarioRegistro,	@L_FechaRegistro, 
		@L_Cancelar ,               @L_FechaResolucion,	            @L_CodProvincia,					@L_CodCanton,
		@L_CodDistrito,             @L_CodBarrio,                     
		Iif(@L_Latitud IS NOT NULL AND @L_Longitud IS NOT NULL, GEOGRAPHY::Point(@L_Latitud,@L_Longitud,4326), NULL),  
		@L_Sector,
		@L_CodHorarioMedio,			@L_Rotulado,					@L_UsuarioRegistroGestion,			@L_UsuarioEnvioGestion,
		@L_CodLegajo,				@L_Resultado,					@L_FechaDevolucion,					@L_FechaEnvio,
		@L_IDACO,					@L_FechaResultado
    )

END

SET ANSI_NULLS ON
GO
