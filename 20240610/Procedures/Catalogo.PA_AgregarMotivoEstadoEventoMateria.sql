SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan Acosta Ibañez>
-- Fecha de creación:	<16/09/2016>
-- Descripción :		<Permite Asociar MotivoEstadoEvento con Materia> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarMotivoEstadoEventoMateria]
	@CodMotivoEstado		smallint,
	@CodMateria				varchar(5),
	@Inicio_Vigencia		datetime2(7)
AS 
BEGIN
	INSERT INTO Catalogo.MotivoEstadoEventoMateria
	(
		TN_CodMotivoEstado,	TC_CodMateria,	TF_Inicio_Vigencia 
	)
	VALUES
	(
		@CodMotivoEstado,	@CodMateria,	@Inicio_Vigencia 
	)
END
 

GO
