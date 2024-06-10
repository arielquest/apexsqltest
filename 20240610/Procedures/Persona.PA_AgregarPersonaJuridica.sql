SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<10/09/2015>
-- Descripción :			<Permite Agregar una nueva persona Juridica> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<06/10/2015>
-- Descripción :			<Se combina los procedimiento Agregar persona con este.> 
-- Modificado por:			<Johan Acosta CodTipoEntidad Smallint>
-- Modificado por:			<Olger Gamboa castillo>
-- Fecha de creación:		<16/12/2015>
-- Descripción :			<se modifica para que el código tipo persona sea entero> 
-- Modificado :				<Alejandro Villalta><06/01/2016><Cambiar tipo de dato del codigo del catalogo tipo identificación> 
-- Fecha de modificación:	<17/03/2016>
-- Descripción :			<se modifica para que el código tipo persona sea char> 
-- Modificado :				<Johan Manuel Acosta Ibañez> 
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================

CREATE PROCEDURE [Persona].[PA_AgregarPersonaJuridica] 	
	@CodPersona				uniqueidentifier,
	@CodTipoPersona			char(1), 
	@CodTipoIdentificacion	smallint, 
	@Identificacion			varchar(21),
	@Nombre					varchar(100),
	@NombreComercial		varchar(200),
	@CodTipoEntidad			smallint,
	@Origen					char(1)
	
AS
BEGIN
	Begin Try
		Begin Transaction;
		INSERT INTO Persona.Persona
		(
			TU_CodPersona,	TC_CodTipoPersona,  TN_CodTipoIdentificacion, TC_Identificacion,
			TF_Actualizacion, TC_Origen
		)
		VALUES
		(
			@CodPersona,	@CodTipoPersona,	 @CodTipoIdentificacion, @Identificacion,
			Getdate(),		@Origen 			
		)
		INSERT INTO Persona.PersonaJuridica
		(
			TU_CodPersona,		TC_Nombre,			TC_NombreComercial,		TN_CodTipoEntidad,
			TF_Actualizacion
		)
		VALUES
		(
			@CodPersona,		@Nombre,			@NombreComercial,		@CodTipoEntidad,
			Getdate()
		)
		COMMIT TRANSACTION;
	End Try
	Begin Catch
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;

	End Catch
END



GO
