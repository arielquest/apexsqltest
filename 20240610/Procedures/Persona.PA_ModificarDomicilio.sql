SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Alejansdro Villalta>
-- Fecha de creación:		<6/10/2015>
-- Descripción :			<Permite Modificar un domicilio a una persona
-- Modificado por:			<Olger Gamboa Castillo>
-- Fecha de modificación:	<22/10/2015>
-- Descripción :			<Se agrega el campo TF_Actualizacion para SIGMA> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de modificación:	<03/12/2015>
-- Descripción :			<Agregar el manejo del campo país para la dirección.>
-- =================================================================================================================================================
-- Modificación:			<15/02/2015> <Andrés Díaz> <Se elimina el campo Telefono de la tabla.>
-- Modificación:			<23/02/2015> <Andrés Díaz> <Se agrega el campo Activo al procedimiento almacenado.>
-- Modificación:			<05/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN>
-- Modificación:			<08/05/2019> <Andrés Díaz> <En 'Persona.Domicilio' se renombra 'TB_Activo' por 'TB_DomicilioHabitual'.>
-- =================================================================================================================================================
CREATE PROCEDURE [Persona].[PA_ModificarDomicilio] 
	@CodDomicilio			uniqueidentifier,		
	@CodTipoDomicilio		smallint, 
	@CodPais				varchar(3), 
	@CodProvincia			smallint,
	@CodCanton				smallint,
	@CodDistrito			smallint,
	@CodBarrio				smallint,
	@Direccion				varchar(500),
	@DomicilioHabitual		bit
AS
BEGIN

	UPDATE Persona.Domicilio
	SET 	
		TN_CodTipoDomicilio		= @CodTipoDomicilio, 
		TC_CodPais				= @CodPais,
		TN_CodProvincia			= @CodProvincia,
		TN_CodCanton			= @CodCanton, 
		TN_CodDistrito			= @CodDistrito,
		TN_CodBarrio			= @CodBarrio,			
		TC_Direccion			= @Direccion,
		TB_DomicilioHabitual	= @DomicilioHabitual,
		TF_Actualizacion		= GETDATE()
	WHERE TU_CodDomicilio		= @CodDomicilio

END
GO
