SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<17/04/2020>
-- Descripción:				<Permite agregar una exlusión de documento al historial procesal.>
-- ===================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<27/05/2020>
-- Modificación				<Se cambia el tamaño de la columna TC_Observaciones de la tabla 
--							ExclusionHistorialProcesal pues tenía un tamaño incorrecto de 250>
-- ===================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<29/05/2020>
-- Modificación				<Se modifica para aplicar el uso de variables temporales además
--							de hacer no requerido los campos de @CodigoArchivo y @DescripcionArchivo
--							y se agregan columnas adicionales para relacionar Escritos y Audiencias>
-- ===================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarExclusionHistorialProcesal]
	@CodigoIndice				uniqueidentifier,
	@NumeroExpediente			char(14),
	@CodigoLegajo				uniqueidentifier	= null,
	@CodigoArchivo				uniqueidentifier	= null,
	@DescripcionArchivo			varchar(255)		= null,
	@TipoArchivo				char(1),
	@Consecutivo				int,
	@Observaciones				varchar(255)		= null,
	@PuestoTrabajoFuncionario	uniqueidentifier,
	@CodigoEscrito				uniqueidentifier	= null,
	@CodigoAudiencia			bigint				= null
As  
Begin  
	--Variables
	DECLARE	@L_TU_CodIndice							uniqueidentifier		= @CodigoIndice,
			@L_TC_NumeroExpediente					char(14)				= @NumeroExpediente,
			@L_TU_CodLegajo							uniqueidentifier		= @CodigoLegajo,
			@L_TU_CodArchivo						uniqueidentifier		= @CodigoArchivo,
			@L_TC_Descrpcion						varchar(255)			= @DescripcionArchivo,
			@L_TC_TipoArchivo						char(1)					= @TipoArchivo,
			@L_TN_Consecutivo						int						= @Consecutivo,
			@L_TC_Observaciones						varchar(255)			= @Observaciones,
			@L_TU_CodPuestoTrabajoFuncionario		uniqueidentifier		= @PuestoTrabajoFuncionario,
			@L_TU_CodEscrito						uniqueidentifier		= @CodigoEscrito,
			@L_TN_CodAudiencia						bigint					= @CodigoAudiencia

	Insert Into [Expediente].[ExclusionHistorialProcesal]
			   (
					[TU_CodIndice],
					[TC_NumeroExpediente],
					[TU_CodLegajo],
					[TU_CodArchivo],
					[TC_Descrpcion],
					[TC_TipoArchivo],
					[TN_Consecutivo],
					[TC_Observaciones],
					[TU_CodPuestoTrabajoFuncionario],
					[TU_CodEscrito],
					[TN_CodAudiencia]
			   )
	Values
			   (
					@L_TU_CodIndice,
					@L_TC_NumeroExpediente,
					@L_TU_CodLegajo,
					@L_TU_CodArchivo,
					@L_TC_Descrpcion,
					@L_TC_TipoArchivo,
					@L_TN_Consecutivo,
					@L_TC_Observaciones,
					@L_TU_CodPuestoTrabajoFuncionario,
					@L_TU_CodEscrito,
					@L_TN_CodAudiencia
			   );
End
GO
