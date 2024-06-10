SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<27/10/2022>
-- Descripción:			<Permite actualizar un registro en la tabla: IntervinienteMedida.>
-- ==================================================================================================================================================================================
CREATE   PROCEDURE	[Expediente].[PA_ModificarIntervinienteMedida]
	@CodMedida					UNIQUEIDENTIFIER,
	@Contexto					VARCHAR(4),
	@CodInterviniente			UNIQUEIDENTIFIER,
	@CodTipoMedida				SMALLINT,
	@CodEstado					SMALLINT,
	@FechaEstado				DATETIME2(3),
	@Observaciones				VARCHAR(255)	= NULL
	
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodMedida					UNIQUEIDENTIFIER		= @CodMedida,
			@L_TC_CodContexto				VARCHAR(4)				= @Contexto,
			@L_TU_CodInterviniente			UNIQUEIDENTIFIER		= @CodInterviniente,
			@L_TN_CodTipoMedida				SMALLINT				= @CodTipoMedida,
			@L_TN_CodEstado					SMALLINT				= @CodEstado,
			@L_TF_FechaEstado				DATETIME2(3)			= @FechaEstado,
			@L_TC_Observaciones				VARCHAR(255)			= @Observaciones			
	
	--Lógica
	UPDATE	Expediente.IntervinienteMedida	WITH (ROWLOCK)
	SET		TC_CodContexto					= @L_TC_CodContexto,
			TU_CodInterviniente				= @L_TU_CodInterviniente,
			TN_CodTipoMedida				= @L_TN_CodTipoMedida,
			TN_CodEstado					= @L_TN_CodEstado,
			TF_FechaEstado					= @L_TF_FechaEstado,
			TC_Observaciones				= @L_TC_Observaciones,	
			TF_Actualizacion			    = GETDATE()
	WHERE	TU_CodMedida					= @L_TU_CodMedida
END
GO
