SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<14/06/2021>
-- Descripción :			<Permite modificar la configuración general del reparto> 
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<11/08/2021>
-- Descripción :			<Se corrige porque no se actualizaba la tarea en caso de error> 
-- =================================================================================================================================================
-- Versión:					<3.0>
-- Modificado por:			<Johan Manuel Acosta ibañez>
-- Fecha de creación:		<08/09/2021>
-- Descripción :			<Se agregaron los campos para el manejo de los campos de asignaciones de responsables> 
-- Modificación:			<10/02/2023> <Josué Quirós Batista> <Actualización del tipo de dato del campo CodUbicacion.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarConfiguracionGeneralReparto]
	@CodConfiguracion		UNIQUEIDENTIFIER,
	@Habilitado				BIT,
	@RecordarAsignaciones	BIT,
	@LimiteTiempoHabilitado BIT,
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


          
				Update	Catalogo.ConfiguracionGeneralReparto
				Set		TB_Habilitado							= @L_Habilitado,
						TB_RecordarAsignaciones					= @L_RecordarAsignacions,
						TB_LimiteTiempoHabilitado				= @L_LimiteTiempoHabilitado,
						TN_DiasHabiles							= @L_DiasHabilies,
						TC_CriterioReparto						= @L_CriterioReparto,
						TN_CodUbicacionError					= @L_CodUbicacionError,
						TC_CodPuestoTrabajoError				= @L_CodPuestoTrabajoError, 
						TN_CodTareaExpedientesNuevos			= @L_CodTareaNuevos,
						TB_AsignacionReparto					= @L_AsignacionReparto,
						TB_AsignacionManual						= @L_AsignacionManual,
						TB_AsignacionHerencia					= @L_AsignacionHerencia

				Where	TU_CodConfiguracionReparto				= @L_CodConfiguracion
END 
GO
