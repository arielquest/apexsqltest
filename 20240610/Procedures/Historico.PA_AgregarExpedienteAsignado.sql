SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:				<Johan Acosta>
-- Fecha Creación:		<08/09/2015>
-- Descripcion:			<Crear un nuevo registro en el hitorico para un expediente responsable>
-- Modificado por:		<19/07/2016> <Gerardo Lopez> <Se cambian los campos de Oficinafuncionario por código de puesto.>
-- Modificado por:		<25/03/2019> <Isaac Dobles> <Se ajusta para tabla Historico.ExpedienteAsignado.>
-- Modificado por:		<04/05/2021> <Xinia Soto V.> <Se agrega paramtro de asignado por reparto.>
-- Modificado por:		<18/10/2021> <Jose Gabriel Cordero Soto > <Se agrega parametro indicador de que el funcionario asignado es el responsable del expediente>
-- =============================================
CREATE PROCEDURE [Historico].[PA_AgregarExpedienteAsignado] 
	@NumeroExpediente			CHAR(14), 
    @Contexto					VARCHAR(4),
	@CodPuestoTrabajo			VARCHAR(14), 
	@FechaActivacion			DATETIME2,
	@FechaVencimiento			DATETIME2	= null,
	@AsignadoPorReparto			BIT			= 0,
	@EsResponsable				BIT			= 0
AS
BEGIN

	DECLARE		@L_NumeroExpediente			CHAR(14)			= @NumeroExpediente,
				@L_Contexto					VARCHAR(14)			= @Contexto,
				@L_CodPuestoTrabajo			VARCHAR(14)			= @CodPuestoTrabajo,
				@L_FechaActivacion			DATETIME2			= @FechaActivacion,
				@L_FechaVencimiento			DATETIME2			= @FechaVencimiento,
				@L_AsignadoPorReparto		BIT					= @AsignadoPorReparto,
				@L_EsResponsable			BIT					= @EsResponsable

	INSERT INTO Historico.ExpedienteAsignado
	(
			TC_NumeroExpediente,	TC_CodContexto,		TC_CodPuestoTrabajo,		
			TF_Inicio_Vigencia,		TF_Fin_Vigencia,	TB_AsignadoPorReparto,
			TB_EsResponsable
	)
	VALUES
	(
			@L_NumeroExpediente,	@L_Contexto,			@L_CodPuestoTrabajo,
			@L_FechaActivacion,		@L_FechaVencimiento,	@L_AsignadoPorReparto,
			@L_EsResponsable
	)

END
GO
