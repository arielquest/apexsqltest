SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<14/09/2015>
-- Descripción :			<Permite modificar una persona fisica> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<06/10/2015>
-- Descripción :			<Se combina el sp ModificarPersona con este para hacer uno solo.> 
-- Modificado por:			<Gerardo Lopez>
-- Fecha de creación:		<26/10/2015>
-- Descripción :			<Se incluye fecha de actualizacion del registro.> 
-- Modificado por:			<Gerardo><15/12/2015><se modifica para que el codetnia sea smallint> 
-- Modificado por:			<Alejandro Villalta><06/01/2016><Cambiar tipo de dato del codigo del catalogo tipo identificación> 
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
-- Modificación:	    <24/01/2018> <Jonathan Aguilar> <Se agrega la coolumna TB_EsIgnorado.>
-- Modificado por:		<Juan Ramírez><14/01/2019><Se modifica para adaptar a la nueva estructura de intervenciones>
-- Modificado por:		<Isaac Dobles><14/01/2019><Se modifica para actualizar campo TC_Origen en tabla Persona.Persona> 
-- Modificado por:		<Karol Jiménez S.><24/03/2021><Se modifica para quitar transacción de BD, se pasa al backend. Se valida nulo TC_Origen>
-- =================================================================================================================================================
CREATE PROCEDURE [Persona].[PA_ModificarPersonaFisica] 
	@CodPersona				uniqueidentifier,
	@CodTipoIdentificacion	smallint, 
	@Identificacion			varchar(21),
	@Nombre					varchar(50),
	@PrimerApellido			varchar(50),
	@SegundoApellido		varchar(50),
	@FechaNacimiento		datetime2(7),
	@LugarNacimiento		varchar(50),
	@FechaDefuncion			datetime2(7),
	@LugarDefuncion			varchar(50),
	@NombreMadre			varchar(80),
	@NombrePadre			varchar(80),
	@CodEtnia				smallint,
	@Carne					varchar(25)		=null,
	@EsIgnorado				bit,
	@CodigoEstadoCivil		smallint		=null,
	@CodigoSexo				char(1)			=null,
	@Origen					char(1),
	@Salario				decimal(18,2)	=null
AS
BEGIN		

		Update	Persona.Persona
		Set		TN_CodTipoIdentificacion	=	@CodTipoIdentificacion, 
				TC_Identificacion			=	@Identificacion,
				TF_Actualizacion			=	GETDATE(),
				TC_Origen					=	ISNULL(@Origen, TC_Origen)
		Where	TU_CodPersona				=	@CodPersona;

		Update	Persona.PersonaFisica
		Set		TC_Nombre				=	@Nombre,
				TC_PrimerApellido		=	@PrimerApellido,
				TC_SegundoApellido		=	@SegundoApellido,
				TF_FechaNacimiento		=	@FechaNacimiento,
				TC_LugarNacimiento		=	@LugarNacimiento,
				TF_FechaDefuncion		=	@FechaDefuncion,
				TC_LugarDefuncion		=	@LugarDefuncion,
				TC_NombreMadre			=	@NombreMadre,
				TC_NombrePadre			=	@NombrePadre,
				TN_CodEtnia				=	@CodEtnia,
				TF_Actualizacion		=	GETDATE(),
				TC_Carne				=	@Carne,
				TB_EsIgnorado			=	@EsIgnorado,
				TN_CodEstadoCivil		=	@CodigoEstadoCivil,
				TC_CodSexo				=	@CodigoSexo,
				TN_Salario				=	@Salario
		Where	TU_CodPersona			=	@CodPersona;
END





GO
