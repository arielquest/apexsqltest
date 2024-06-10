SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<29/09/2015>
-- Descripción :			<Permite eliminar una persona fisica> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<06/10/2015>
-- Descripción :			<Se combina el sp EliminarPersona con este para hacer uno solo.>
-- =================================================================================================================================================
CREATE PROCEDURE [Persona].[PA_EliminarPersonaFisica] 
	@CodPersona	uniqueidentifier
AS
BEGIN
	Begin Try
		Begin Transaction;
		DELETE
		FROM  Persona.PersonaFisica
		WHERE TU_CodPersona=@CodPersona
		DELETE
		FROM  Persona.Persona
		WHERE TU_CodPersona=@CodPersona
	End Try
	Begin Catch
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	End Catch
		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;
END


GO
