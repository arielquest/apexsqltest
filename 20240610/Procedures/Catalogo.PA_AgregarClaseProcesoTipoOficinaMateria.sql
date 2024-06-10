SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Miguel Avendaño Rosales>
-- Fecha de creación:		<19/04/2021>
-- Descripción :			<Permite asociar un proceso a una clase, tipo oficina, materia> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarClaseProcesoTipoOficinaMateria]

	@CodigoProceso			smallint,
	@CodTipoOficina			smallint,
	@CodClase				int,
	@CodMateria				varchar(5),
	@CodFase				int,
	@FechaInicioVigencia	datetime2
AS 
BEGIN
	INSERT INTO Catalogo.ClaseProcesoTipoOficinaMateria
	(
		TN_CodProceso,	TN_CodTipoOficina,	TN_CodClase,	TC_CodMateria,	TN_CodFase,	TF_Inicio_Vigencia	
	)
	VALUES
	(
		@CodigoProceso,	@CodTipoOficina, @CodClase, @CodMateria, @CodFase, @FechaInicioVigencia
	)
END
GO
