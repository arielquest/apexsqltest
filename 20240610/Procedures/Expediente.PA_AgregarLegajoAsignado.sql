SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<07/03/2019>
-- Descripcion:			<Agregar un funcionario asignado a un legajo.>
-- =================================================================================================================================================
-- Autor:				<Xinia Soto V>
-- Fecha Creación:		<04/05/2021>
-- Descripcion:			<Se agrega parámetro de asignado por reparto>
-- =================================================================================================================================================
-- Modificado por:		<19/10/2021> <Jose Gabriel Cordero Soto > <Se agrega parametro indicador de que el funcionario asignado es el responsable del expediente>
-- =================================================================================================================================================
CREATE   PROCEDURE [Expediente].[PA_AgregarLegajoAsignado] 
	@CodigoLegajo				UNIQUEIDENTIFIER,		
	@Contexto					VARCHAR(4),
	@PuestoTrabajo				VARCHAR(14),
	@FechaInicioVigencia		DATETIME2(7),
	@FechaFinVigencia			DATETIME2(7),
	@AsignadoPorReparto			BIT			= 0,
	@EsResponsable				BIT			= 0
AS
BEGIN

	DECLARE		@L_CodigoLegajo				UNIQUEIDENTIFIER	= @CodigoLegajo,
				@L_Contexto					VARCHAR(14)			= @Contexto,
				@L_CodPuestoTrabajo			VARCHAR(14)			= @PuestoTrabajo,
				@L_FechaInicioVigencia		DATETIME2			= @FechaInicioVigencia,
				@L_FechaFinVigencia			DATETIME2			= @FechaFinVigencia,
				@L_AsignadoPorReparto		BIT					= @AsignadoPorReparto,
				@L_EsResponsable			BIT					= @EsResponsable


	INSERT INTO Historico.LegajoAsignado
	(
		TU_CodLegajo,
		TC_CodContexto,
		TC_CodPuestoTrabajo,
		TF_Inicio_Vigencia,
		TF_Fin_Vigencia,
		TB_AsignadoPorReparto,
		TB_EsResponsable
	)
	VALUES
	(
		@CodigoLegajo,  
		@Contexto,
		@PuestoTrabajo,
		@FechaInicioVigencia,
		@FechaFinVigencia,
		@AsignadoPorReparto,
		@L_EsResponsable
	)
END
GO
