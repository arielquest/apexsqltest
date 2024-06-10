SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<21/01/2021>
-- Descripción :			<Permite eliminar una asociación entre motivo de estado de evento, estado evento, tipo oficina y materia.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarMotivoEstadoEventoTipoOficina]
   @CodMotivoEstadoEvento		SMALLINT,
   @CodEstadoEvento     		SMALLINT,
   @CodTipoOficina	        	SMALLINT,
   @CodMateria			        VARCHAR(5)
AS 
BEGIN
--VARIABLES
DECLARE		@L_CodMotivoEstadoEvento		SMALLINT	= @CodMotivoEstadoEvento,
			@L_CodEstadoEvento		        SMALLINT	= @CodEstadoEvento,
			@L_CodTipoOficina	         	SMALLINT	= @CodTipoOficina,
			@L_CodMateria		         	VARCHAR(5)	= @CodMateria
--LÓGICA
	DELETE FROM		Catalogo.MotivoEstadoEventoTipoOficina WITH(ROWLOCK)
	WHERE			TN_CodMotivoEstado        	= @L_CodMotivoEstadoEvento
	AND				TN_CodTipoOficina	        = @L_CodTipoOficina
	AND				TN_CodEstadoEvento			= @L_CodEstadoEvento
	AND				TC_CodMateria		        = @L_CodMateria;
END

GO
