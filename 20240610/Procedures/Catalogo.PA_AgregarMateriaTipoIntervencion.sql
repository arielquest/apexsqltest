SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<03/09/2015>
-- Descripción :			<Permite asociar un tipo de internvecion a una materia>
-- Moficado:                <02-12-2016><Pablo Alvarez><Se modifica TN_CodTipoIntervencion por estandar>

-- Modificado por:			<Ailyn López>
-- Fecha de modificación:	<09/10/2017>
-- Descripción :			<Se agrega parámetro   @PuedeSolicitarDefensor >

-- Modificado por:			<Juan Ramírez>
-- Fecha de modificación:	<09/07/2018>
-- Descripción :			<Se agrega parámetro   @VinculoAgresor >
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarMateriaTipoIntervencion]
   @CodMateria varchar(5),
   @CodTipoIntervencion varchar(3),
   @Inicio_Vigencia datetime2(7),
   @PuedeSolicitarDefensor Bit,
   @VinculoAgresor Bit
AS 
BEGIN

	INSERT INTO Catalogo.MateriaTipoIntervencion
	(
		TC_CodMateria,	TN_CodTipoIntervencion, TF_Inicio_Vigencia, TB_PuedeSolicitarDefensor, TB_VinculoAgresor
	)
	VALUES
	(
		@CodMateria,	@CodTipoIntervencion,	@Inicio_Vigencia,   @PuedeSolicitarDefensor,	@VinculoAgresor
	)
END
GO
