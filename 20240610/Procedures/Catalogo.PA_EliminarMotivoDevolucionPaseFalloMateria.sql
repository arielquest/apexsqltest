SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Miguel Avendaño Rosales>
-- Fecha de creación:	<27/07/2021>
-- Descripción :		<Permite Desasociar Motivos de devolucion con materia> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarMotivoDevolucionPaseFalloMateria]
	@CodMotivoDevolucion	smallint,
	@CodMateria				varchar(5)
AS
BEGIN 
	DECLARE		@L_CodMotivoDevolucion	SMALLINT		= @CodMotivoDevolucion,
				@L_CodMateria			VARCHAR(5)		= @CodMateria

	DELETE FROM Catalogo.MotivoDevolucionPaseFalloMateria
	WHERE	TN_CodMotivoDevolucion	=	@L_CodMotivoDevolucion
	AND		TC_CodMateria			=	@L_CodMateria
END
GO
