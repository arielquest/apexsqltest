SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versi¢n:				<1.0>
-- Creado por:			<Aida Elena Siles R>
-- Fecha de creaci¢n:	<09/07/2021>
-- Descripci¢n:			<Permite agregar un registro en la tabla: PaseFallo.>
-- ==================================================================================================================================================================================
-- Modificaci¢n:		<17/08/2021> <Aida Elena Siles R> <Se agrega l¢gica para pasar nuevamente a fallo cuando se ha suspendido el plazo del ultimo pase a fallo.>
-- Modificaci¢n:		<23/09/2021> <Jose Miguel Avendaño R> <Se modifica para que asigne correctamente la fecha de vencimiento en los casos en que el expediente ha tenido 
--																pasos previos por el pase a fallo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_AgregarPaseFallo]
	@CodPaseFallo				UNIQUEIDENTIFIER,
	@NumeroExpediente			CHAR(14),
	@CodLegajo					UNIQUEIDENTIFIER	= NULL,
	@CodContexto				VARCHAR(4),
	@UsuarioRedAsigna			VARCHAR(30),
	@CodTareaAsigna				UNIQUEIDENTIFIER,
	@CodTarea					SMALLINT			= NULL,
	@CodOficina					VARCHAR(4)			= NULL,
	@CodMateria					VARCHAR(5)			= NULL,
	@CodTipoOficina				SMALLINT			= NULL,
	@TipoPaseFallo				CHAR,
	@CalcularHoras				BIT					= 0
AS
BEGIN
SET NOCOUNT ON;
	--Variables
	DECLARE	@L_TU_CodPaseFallo			UNIQUEIDENTIFIER		= @CodPaseFallo,
			@L_TC_NumeroExpediente		CHAR(14)				= @NumeroExpediente,
			@L_TU_CodLegajo				UNIQUEIDENTIFIER		= @CodLegajo,
			@L_TC_CodContexto			VARCHAR(4)				= @CodContexto,
			@L_UsuarioRedAsigna			VARCHAR(30)				= @UsuarioRedAsigna,
			@L_TU_CodTareaAsigna		UNIQUEIDENTIFIER		= @CodTareaAsigna,
			@L_TN_CodTarea				SMALLINT				= @CodTarea,
			@L_TC_CodOficina			VARCHAR(4)				= @CodOficina,
			@L_TC_CodMateria			VARCHAR(5)				= @CodMateria,
			@L_TN_CodTipoOficina		SMALLINT				= @CodTipoOficina,
			@L_TipoPaseFallo			CHAR					= @TipoPaseFallo,
			@L_TF_Vence					DATETIME2(7),
			@L_HorasConsumidas			SMALLINT				= 0,
			@L_CalcularHoras			BIT						= @CalcularHoras,
			@L_Plazo					SMALLINT				= 0

	IF (@L_TipoPaseFallo = 'T')
	BEGIN		
		IF (@L_CalcularHoras = 1)
		BEGIN
			SET @L_HorasConsumidas = (SELECT [Historico].[FN_PaseFalloCalcularHorasConsumidas] (@L_TC_NumeroExpediente, @L_TU_CodLegajo, @L_TC_CodOficina, @L_TC_CodContexto))
		END

		--Se obtiene la cantidad de horas registradas de la tarea
		SELECT  @L_Plazo						= TN_CantidadHoras 
		FROM	Catalogo.TareaTipoOficinaMateria WITH(NOLOCK)
		WHERE	TC_CodMateria					= @CodMateria 
		AND		TN_CodTarea						= @CodTarea 
		AND		TN_CodTipoOficina				= @CodTipoOficina

		IF (@L_HorasConsumidas >= @L_Plazo)
		BEGIN
			If (@L_TU_CodLegajo Is Null Or @L_TU_CodLegajo = '00000000-0000-0000-0000-000000000000')
			BEGIN
				Select Top(1)	@L_TF_Vence =		TF_FechaVencimiento
				From			Historico.PaseFallo
				Where			TC_NumeroExpediente = @L_TC_NumeroExpediente
				And				TU_CodLegajo		Is Null
				Order By		TF_FechaAsignacion	Desc
			END
			ELSE
			BEGIN
				Select Top(1)	@L_TF_Vence =		TF_FechaVencimiento
				From			Historico.PaseFallo
				Where			TU_CodLegajo = @L_TU_CodLegajo
				Order By		TF_FechaAsignacion	Desc
			END
		END
		ELSE
		BEGIN
			--Calcula fecha vencimiento
			SET @L_TF_Vence = (SELECT [Expediente].[FN_PlazoDiasFechaVence] (@L_TN_CodTarea, @L_TC_CodMateria, @L_TC_CodOficina, @L_TN_CodTipoOficina, GETDATE(), @L_HorasConsumidas))
		END

		SET NOCOUNT OFF;
		INSERT INTO	Historico.PaseFallo	WITH (ROWLOCK)
		(
			TU_CodPaseFallo,				TC_NumeroExpediente,			TU_CodLegajo,					TC_CodContexto,	
			TC_UsuarioRedAsigna,			TU_CodTareaAsigna,				TF_FechaAsignacion,				TU_CodTareaDevuelve,			
			TF_FechaDevolucion,				TN_CodMotivoDevolucion,			TF_FechaVencimiento,			TU_CodArchivo					
		)
		VALUES
		(
			@L_TU_CodPaseFallo,				@L_TC_NumeroExpediente,			@L_TU_CodLegajo,				@L_TC_CodContexto,
			@L_UsuarioRedAsigna,			@L_TU_CodTareaAsigna,			GETDATE(),						NULL,
			NULL,							NULL,							@L_TF_Vence,					NULL					
		)
		IF (@@ROWCOUNT > 0)
		BEGIN
			SELECT @L_TF_Vence
		END
		ELSE
		BEGIN
			SELECT NULL
		END
	END
END/****** Object:  StoredProcedure [Itineracion].[PA_ConsultarAudienciasSIAGPJ]    Script Date: 09/08/2021 15:17:34 ******/
SET ANSI_NULLS ON
GO
