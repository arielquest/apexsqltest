SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Johan Acosta Ibañez>
-- Fecha creación:	<16/09/2015>
-- Descripción :	<Permite Agregar una nueva prescripción del delito.> 
--
-- Modificado por:	<Olger Gamboa Castillo>
-- Fecha creación:	<22/10/2015>
-- Descripción :	<Se agrega el campo TF_Actualizacion para SIGMA> 
--
-- Modificado por:	<Sigifredo Leitón Luna>
-- Fecha:			<08/01/2016>
-- Descripción :	<Se modifica para la autogeneración del código de suspensión prescripción - item 5606>
--
-- Modificado por:	<Donald Vargas Zúñiga>
-- Fecha:			<02/12/2016>
-- Descripción :	<Se corrige el nombre de los campos TC_CodInterrupcion y TC_CodSuspensionPrescripcion a TN_CodInterrupcion y TN_CodSuspensionPrescripcion de acuerdo al tipo de dato.>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarDelitoPrescripcion] 
	@CodDelitoPrescripcion		uniqueidentifier,
	@Prescribe					datetime2,
	@CodInterrupcion			smallint		= null,
	@CodSuspensionPrescripcion	smallint		= null,
	@FechaActo					datetime2
AS
BEGIN
	UPDATE	Expediente.DelitoPrescripcion
	SET		TF_Prescribe					=	@Prescribe,
			TN_CodInterrupcion				=	@CodInterrupcion,
			TN_CodSuspensionPrescripcion	=	@CodSuspensionPrescripcion,
			TF_FechaActo					=	@FechaActo,
			TF_Actualizacion				=	GETDATE()		
	WHERE	TU_CodDelitoPrescripcion		=	@CodDelitoPrescripcion
END


GO
