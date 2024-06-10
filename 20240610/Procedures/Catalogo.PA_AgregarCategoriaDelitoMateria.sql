SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<05/02/2019>
-- Descripción :		<Permite asociar CategoriaDelito con Materia> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarCategoriaDelitoMateria]

	@CodigoCategoriaDelito		int,
	@CodMateria					varchar(4),
	@FechaAsociacion			datetime2

AS 
BEGIN
	INSERT INTO Catalogo.CategoriaDelitoMateria
	(
		TN_CodCategoriaDelito,
		TC_CodMateria,
		TF_Inicio_Vigencia
	)
	VALUES
	(
		@CodigoCategoriaDelito,
		@CodMateria,
		@FechaAsociacion
	)
END
GO
