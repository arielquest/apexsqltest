SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
--Versión:	<1.0>  Creado por: <Rafa Badilla Alvarado> Fecha de creación:<29/09/2022> Descripción :	<Permite agregar las materias asociadas a un tipo de medida. 
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_AgregarTipoMedidaMateria]

	@CodigoTipoMedida     		int,
	@CodMateria					varchar(4),
	@FechaAsociacion			datetime2

AS 
BEGIN
	INSERT INTO Catalogo.TipoMedidaMateria
	(
		TN_CodTipoMedida,
		TC_CodMateria,
		TF_Fecha_Asociacion
	)
	VALUES
	(
		@CodigoTipoMedida,
		@CodMateria,
		@FechaAsociacion
	)
END
GO
