SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan Acosta Ibañez>
-- Fecha de creación:	<16/09/2016>
-- Descripción :		<Permite Desasociar MotivoEstadoEvento con Materia> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarMotivoEstadoEventoMateria]
	@CodMotivoEstado		smallint,
	@CodMateria				varchar(5)
AS
BEGIN          
	DELETE FROM Catalogo.MotivoEstadoEventoMateria
	WHERE	TN_CodMotivoEstado		=	@CodMotivoEstado
	AND		TC_CodMateria			=	@CodMateria
END
 

GO
