SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<10/09/2015>
-- Descripción :			<Permite Agregar un domicilio a una persona
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de modificación:	<03/12/2015>
-- Descripción :			<Agregar el manejo del campo país para la dirección.>
--
-- Modificación:			<15/02/2015> <Andrés Díaz> <Se elimina el campo Telefono de la tabla.>
-- Modificación:			<05/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN >
-- Modificación:			<08/05/2019> <Andrés Díaz> <En 'Persona.Domicilio' se renombra 'TB_Activo' por 'TB_DomicilioHabitual'.>
-- =================================================================================================================================================
CREATE PROCEDURE [Persona].[PA_AgregarDomicilio] 
	@CodDomicilio			uniqueidentifier,		
	@CodPersona				uniqueidentifier, 
	@CodTipoDomicilio		smallint,
	@CodPais				varchar(3), 
	@CodProvincia			smallint,
	@CodCanton				smallint,
	@CodDistrito			smallint,
	@Barrio					smallint,
	@Direccion				varchar(500),
	@DomicilioHabitual		bit
AS
BEGIN
	INSERT INTO Persona.Domicilio
	(		
		TU_CodDomicilio,	TU_CodPersona,  TN_CodTipoDomicilio,	TC_CodPais,
		TN_CodProvincia,	TN_CodCanton,	TN_CodDistrito,			TN_CodBarrio,			
		TC_Direccion,		TB_DomicilioHabitual
	)
	VALUES
	(
		@CodDomicilio,	@CodPersona,	@CodTipoDomicilio,		@CodPais,
		@CodProvincia,	@CodCanton,		@CodDistrito,			@Barrio,
		@Direccion,		@DomicilioHabitual
	)
END
GO
