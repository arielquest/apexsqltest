SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<10/09/2015>
-- Descripción :			<Permite Agregar una nueva persona fisica> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<06/10/2015>
-- Descripción :			<Permite Agregar una nueva persona fisica> 
-- Modificado por:			<Gerardo Lopez>
-- Fecha de creación:		<26/10/2015>
-- Descripción :			<Se incluye fecha de actualizacion del registro.> 

-- Modificado por:			<Gerardo><15/12/2015><se modifica para que el codetnia sea smallint> 
-- Modificado por:			<Olger Gamboa castillo>
-- Fecha de creación:		<16/12/2015>
-- Descripción :			<se modifica para que el código tipo persona sea entero> 

-- Modificado por:			<Alejandro Villalta><06/01/2016><Cambiar tipo de dato del codigo del catalogo tipo identificación> 
-- =================================================================================================================================================
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
-- Modificación:	    <24/01/2018> <Jonathan Aguilar> <Se agrega la columna TB_EsIgnorado.>
-- Modificación:	    <14/01/2018> <Isaac Dobles> <Se modifica para insertar datos en columna TC_Origen de la tabla Persona.Persona.>
-- Modificación:	    <28/01/2019> <Juan Ramírez> <Se modifica para insertar datos en columna TN_CodEstadoCivil,TC_CodSexo de la tabla Persona.PersonaFisica.>
-- Modificación:	    <26/03/2019> <Juan Ramírez> <Se modifica tipo dato en columna TN_Salario de la tabla Persona.PersonaFisica.>

CREATE PROCEDURE [Persona].[PA_AgregarPersonaFisica] 
	@CodPersona				uniqueidentifier,
	@CodTipoPersona			char(1), 
	@CodTipoIdentificacion	smallint, 
	@Identificacion			varchar(21)=null,
	@Nombre					varchar(50),
	@PrimerApellido			varchar(50),
	@SegundoApellido		varchar(50)= null,
	@FechaNacimiento		datetime2(7)=null,
	@LugarNacimiento		varchar(50)=null,
	@FechaDefuncion			datetime2(7)=null,
	@LugarDefuncion			varchar(50)=null,
	@NombreMadre			varchar(80)=null,
	@NombrePadre			varchar(80)=null,
	@CodEtnia				smallint=null,
	@Carne					varchar(25)=null,
	@EsIgnorado				bit,
	@Origen					char(1),	
	@CodigoEstadoCivil		smallint=null,
	@CodigoSexo				char(1)=null,
	@Salario				decimal(18,2) null
AS
BEGIN
	Begin Try
		INSERT INTO Persona.Persona
		(
			TU_CodPersona,		TC_CodTipoPersona,		TN_CodTipoIdentificacion,	TC_Identificacion, 
			TF_Actualizacion,	TC_Origen
		)
		VALUES
		(
			@CodPersona,		@CodTipoPersona,		@CodTipoIdentificacion,		@Identificacion,
			getdate(),			@Origen		
		)
		INSERT INTO Persona.PersonaFisica
		(
			TU_CodPersona,			TC_Nombre,			TC_PrimerApellido,	TC_SegundoApellido,	TF_FechaNacimiento,
			TC_LugarNacimiento,		TF_FechaDefuncion,	TC_LugarDefuncion,	TC_NombreMadre,		TC_NombrePadre,
			TN_CodEtnia , TF_Actualizacion,TC_Carne,	TB_EsIgnorado,		TN_CodEstadoCivil,	TC_CodSexo,
			TN_Salario
		)
		VALUES
		(
			@CodPersona,			@Nombre,			@PrimerApellido,	@SegundoApellido,	@FechaNacimiento,
			@LugarNacimiento,		@FechaDefuncion,	@LugarDefuncion,	@NombreMadre,		@NombrePadre,
			@CodEtnia	, getdate(),@Carne,				@EsIgnorado, 		@CodigoEstadoCivil,	@CodigoSexo,
			@Salario			
		)
	End Try
	Begin Catch
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;

	End Catch
END




GO
