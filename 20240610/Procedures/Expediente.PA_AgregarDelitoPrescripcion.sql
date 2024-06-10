SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Johan Acosta Ibañez>
-- Fecha creación:	<16/09/2015>
-- Descripción :	<Permite Agregar una nueva prescripción del delito.> 
--
-- Modificado por:	<Sigifredo Leitón Luna>
-- Fecha:			<08/01/2016>
-- Descripción :	<Se modifica para la autogeneración del código de suspensión prescripción - item 5606>
--
-- Modificado por:	<Donald Vargas Zúñiga>
-- Fecha:			<02/12/2016>
-- Descripción :	<Se corrige el nombre de los campos TC_CodDelito, TC_CodInterrupcion y TC_CodSuspensionPrescripcion a TN_CodDelito, TN_CodInterrupcion y TN_CodSuspensionPrescripcion de acuerdo al tipo de dato.>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarDelitoPrescripcion] 
	@CodDelitoPrescripcion		uniqueidentifier,
	@CodInterviniente			uniqueidentifier,
	@CodDelito					int,
	@Prescribe					datetime2,
	@CodInterrupcion			smallint		= null,
	@CodSuspensionPrescripcion	smallint		= null,
	@FechaActo					datetime2,
	@UsuarioRed					varchar(30)
AS
BEGIN
	INSERT INTO Expediente.DelitoPrescripcion
	(
		TU_CodDelitoPrescripcion,	TU_CodInterviniente,			TN_CodDelito,		TF_Prescribe,	
		TN_CodInterrupcion,			TN_CodSuspensionPrescripcion,	TF_FechaActo,		TC_UsuarioRed
	)
	VALUES
	(
		@CodDelitoPrescripcion,	@CodInterviniente,			@CodDelito,		@Prescribe,
		@CodInterrupcion,		@CodSuspensionPrescripcion,	@FechaActo,		@UsuarioRed		
	)
END


GO
