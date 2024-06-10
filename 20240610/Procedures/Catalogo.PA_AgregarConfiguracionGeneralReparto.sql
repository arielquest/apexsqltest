SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<14/06/2021>
-- Descripción :			<Permite agregar la configuración general del reparto> 
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Modificado por:			<Johan Manuel Acosta ibañez>
-- Fecha de creación:		<08/09/2021>
-- Descripción :			<Se agregaron los campos para el manejo de los campos de asignaciones de responsables> 
-- Modificación:			<10/02/2023> <Josué Quirós Batista> <Actualización del tipo de dato del campo CodUbicacion.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarConfiguracionGeneralReparto]
	@CodConfiguracion		UNIQUEIDENTIFIER,
	@CodContexto			VARCHAR(4),
	@Habilitado				BIT,
	@RecordarAsignaciones	BIT,
	@LimiteTiempoHabilitado	BIT,
	@DiasHabilies			SMALLINT,
	@CriterioReparto		CHAR(1),
	@CodUbicacionError		INT,
	@CodPuestoTrabajoError	VARCHAR(14),
	@CodTareaError			SMALLINT,
	@CodTareaNuevos			SMALLINT,
	@AsignacionReparto		BIT,
	@AsignacionManual		BIT,
	@AsignacionHerencia		BIT
AS 
BEGIN   
	Declare	   @L_CodConfiguracion			UNIQUEIDENTIFIER	= @CodConfiguracion,
			   @L_CodContexto				VARCHAR(4)			= @CodContexto,
			   @L_Habilitado				BIT					= @Habilitado,
			   @L_RecordarAsignacions		BIT					= @RecordarAsignaciones,
			   @L_LimiteTiempoHabilitado	BIT					= @LimiteTiempoHabilitado,
			   @L_DiasHabilies				SMALLINT			= @DiasHabilies,
			   @L_CriterioReparto			CHAR(1)				= @CriterioReparto,
			   @L_CodUbicacionError			INT					= @CodUbicacionError,
			   @L_CodPuestoTrabajoError		VARCHAR(14)			= @CodPuestoTrabajoError,
			   @L_CodTareaError				SMALLINT			= @CodTareaError,
			   @L_CodTareaNuevos			SMALLINT			= @CodTareaNuevos,
			   @L_AsignacionReparto			BIT					= @AsignacionReparto,
			   @L_AsignacionManual			BIT					= @AsignacionManual,
			   @L_AsignacionHerencia		BIT					= @AsignacionHerencia

          
			 INSERT INTO Catalogo.ConfiguracionGeneralReparto
				   (TU_CodConfiguracionReparto, TC_CodContexto,			TB_Habilitado,					TB_RecordarAsignaciones,
				   TB_LimiteTiempoHabilitado,	TN_DiasHabiles,			TC_CriterioReparto,				TN_CodUbicacionError,
				   TC_CodPuestoTrabajoError,	TN_CodTareaError,		TN_CodTareaExpedientesNuevos,	TF_Particion,
				   TF_FechaCreacion,			TB_AsignacionReparto,	TB_AsignacionManual,			TB_AsignacionHerencia)
			 VALUES
				   (@L_CodConfiguracion,		@L_CodContexto,			@L_Habilitado,					@L_RecordarAsignacions,
				   @L_LimiteTiempoHabilitado,	@L_DiasHabilies,		@L_CriterioReparto,				@L_CodUbicacionError,
				   @L_CodPuestoTrabajoError,	@L_CodTareaError,		@L_CodTareaNuevos,				GETDATE(),

				   GETDATE(),					@L_AsignacionReparto,	@L_AsignacionManual,			@L_AsignacionHerencia)

        
END
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
