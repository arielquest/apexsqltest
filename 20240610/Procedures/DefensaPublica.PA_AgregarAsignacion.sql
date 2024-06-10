SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<28/05/2019>
-- Descripción :			<Permite agregar un registro a la tabla Asignacion> 
-- <Modificación>           <23/03/2020> <Aida E Siles> <Se agregan las variables locales.>
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_AgregarAsignacion]
	@CodAsignacion				UNIQUEIDENTIFIER,
	@CodRepresentacion			UNIQUEIDENTIFIER,
	@CodMotivoFinalizacion		SMALLINT,
	@CodPuestoTrabajo			VARCHAR(14),
	@Inicio_Vigencia			DATETIME2,
	@Fin_Vigencia				DATETIME2	
AS
BEGIN
	--Variables	DECLARE	@L_TU_CodAsignacion			UNIQUEIDENTIFIER	= @CodAsignacion,			@L_TU_CodRepresentacion		UNIQUEIDENTIFIER	= @CodRepresentacion,			@L_TN_CodMotivoFinalizacion	SMALLINT			= @CodMotivoFinalizacion,			@L_TC_CodPuestoTrabajo		VARCHAR(14)			= @CodPuestoTrabajo,			@L_TF_Inicio_Vigencia		DATETIME2			= @Inicio_Vigencia,			@L_TF_Fin_Vigencia			DATETIME2			= @Fin_Vigencia

	INSERT INTO DefensaPublica.Asignacion
	(
		TU_CodAsignacion,		TU_CodRepresentacion,		TN_CodMotivoFinalizacion,		TC_CodPuestoTrabajo,
		TF_Inicio_Vigencia,		TF_Fin_Vigencia,			TF_Actualizacion	
	)
	VALUES	(		@L_TU_CodAsignacion,			@L_TU_CodRepresentacion,		@L_TN_CodMotivoFinalizacion,			@L_TC_CodPuestoTrabajo,					@L_TF_Inicio_Vigencia,			@L_TF_Fin_Vigencia,				GETDATE()			)
END
GO
