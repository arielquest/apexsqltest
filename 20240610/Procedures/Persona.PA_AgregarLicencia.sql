SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<30/09/2015>
-- Descripción :			<Permite Agregar una licencia a una nueva persona> 
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Persona].[PA_AgregarLicencia] 
	@CodPersona				uniqueidentifier,		
	@CodTipoLicencia		smallint, 
	@FechaCaducidad			datetime2,
	@FechaExpedicion		datetime2, 
	@FechaTramite			datetime2
AS
BEGIN
	INSERT INTO Persona.Licencia
	(
		TU_CodPersona,  TN_CodTipoLicencia,	TF_Caducidad,		TF_Expedicion,		TF_Tramite,   TF_Actualizacion 
	)
	VALUES
	(
		@CodPersona,	@CodTipoLicencia,	@FechaCaducidad,	@FechaExpedicion,	@FechaTramite,   GETDATE()
	)
END
GO
