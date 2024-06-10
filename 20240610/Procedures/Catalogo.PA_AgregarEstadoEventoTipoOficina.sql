SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Miguel Avendaño Rosales>
-- Fecha de creación:		<07/01/2021>
-- Descripción :			<Permite asociar estado de eventos y materias>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarEstadoEventoTipoOficina]
   @CodEstadoEvento		SMALLINT,
   @CodTipoOficina		SMALLINT,
   @CodMateria			VARCHAR(5),
   @Inicio_Vigencia		DATETIME2(7)
AS 
BEGIN          
-- VARIABLES
DECLARE		@L_CodEstadoEvento		SMALLINT		= @CodEstadoEvento,
			@L_CodTipoOficina		SMALLINT		= @CodTipoOficina,
			@L_CodMateria			VARCHAR(5)		= @CodMateria,
			@L_Inicio_Vigencia		DATETIME2(7)	= @Inicio_Vigencia
--LÓGICA
	INSERT INTO Catalogo.EstadoEventoTipoOficina WITH(ROWLOCK)
	(	
		TN_CodEstadoEvento,		TN_CodTipoOficina,		TC_CodMateria,		TF_Inicio_Vigencia
	)
	VALUES
	(	
		@L_CodEstadoEvento,		@L_CodTipoOficina,		@L_CodMateria,		@L_Inicio_Vigencia
	);
END
GO
