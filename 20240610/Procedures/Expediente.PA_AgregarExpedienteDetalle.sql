SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ======================================================================================================================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<03/09/2015>
-- Descripcion:		<Crear un nuevo detalle de expediente asociado a un legajo.>
-- ======================================================================================================================================
-- Modificacion:	<8/12/2015><Gerardo Lopez> <Se cambia tipo de dato a codmoneda a tinyint>
-- Modificado por:	<Sigifredo Leitón Luna.>
-- Fecha:			<13/01/2016>
-- Descripción:		<Se realiza cambio para autogenerar el consecutivo de tipo de cuantía - item 5630.> 
-- Modificado por:	<Donald Vargas Zúñiga>
-- Fecha:			<02/12/2016>
-- Descripción:		<Se corrige el nombre del campo TC_CodMoneda, TC_CodPrioridad, TC_CodTipoCuantia y TC_CodTipoViabilidad a TN_CodMoneda, TN_CodPrioridad, TN_CodTipoCuantia y TN_CodTipoViabilidad de acuerdo al tipo de dato>
-- Descripción:		<Jonathan Aguilar Navarro> <24/04/2018><Se cambia el campo TC_CodOficina por TC_CodContexto y TC_CodOficinaProcedencia por TC_CodContextoProcedencia>
-- Modificación		<Jonathan Aguilar Navarro> <28/02/2019> <Se agregan los campos conrrespondientes a la mejora de Crecion de Expediente>
-- Modificación		<Isaac Dobles Mata> <13/10/2020> <Se agregan indicador para señalar testimonio de piezas>
-- ======================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_AgregarExpedienteDetalle] 
	@NumeroExpediente					char(14),	
	@CodContexto						varchar(4),
	@FechaEntrada						datetime2,
	@CodClase							int,
	@CodProceso							int,
	@CodFase							int,
	@CodContextoProcedencia				varchar(14),
	@CodGrupoTrabajo					int,
	@Habilitado							bit,
	@DocumentosFisicos					bit,
	@ExpedienteTestimonioPiezas			char(14) = null
AS
BEGIN

	DECLARE
	@L_TC_NumeroExpediente				char(14)	= @NumeroExpediente,
	@L_TC_CodContexto					varchar(4)	= @CodContexto,
	@L_TF_Entrada						datetime2	= @FechaEntrada,
	@L_TN_CodClase						int			= @CodClase,
	@L_TN_CodProceso					int			= @CodProceso,
	@L_TN_CodFase						int			= @CodFase,
	@L_TC_CodContextoProcedencia		varchar(14) = @CodContextoProcedencia,
	@L_TN_CodGrupoTrabajo				int			= @CodGrupoTrabajo,
	@L_TB_Habilitado					bit			= @Habilitado,
	@L_TB_DocumentosFisicos				bit			= @DocumentosFisicos,
	@L_TC_TestimonioPiezas				char(14)	= @ExpedienteTestimonioPiezas

	INSERT INTO Expediente.ExpedienteDetalle 
	(
		TC_NumeroExpediente,		TC_CodContexto,				TF_Entrada,			TN_CodClase,		TN_CodProceso,
		TN_CodFase,					TC_CodContextoProcedencia,	TN_CodGrupoTrabajo,	TB_Habilitado,		TB_DocumentosFisicos,
		TC_TestimonioPiezas,		TF_Actualizacion
	)
	VALUES
	(
		@L_TC_NumeroExpediente,			@L_TC_CodContexto,				@L_TF_Entrada,			@L_TN_CodClase,			@L_TN_CodProceso,						
		@L_TN_CodFase,					@L_TC_CodContextoProcedencia,	@L_TN_CodGrupoTrabajo,	@L_TB_Habilitado,		@L_TB_DocumentosFisicos,
		@L_TC_TestimonioPiezas,			GETDATE()			
	)
END
GO
