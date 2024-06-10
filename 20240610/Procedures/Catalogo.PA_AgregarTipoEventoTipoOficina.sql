SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<22/09/2016>
-- Descripción :			<Permite asociar tipo de eventos y materias>
-- =================================================================================================================================================
-- Modificación:			<Aida Elena Siles R> <30/12/2020> <Para insertar en la nueva tabla TipoEventoTipoOficina>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoEventoTipoOficina]
   @CodTipoEvento		SMALLINT,
   @CodTipoOficina		SMALLINT,
   @CodMateria			VARCHAR(5),
   @Inicio_Vigencia		DATETIME2(7)
AS 
BEGIN          
-- VARIABLES
DECLARE		@L_CodTipoEvento		SMALLINT		= @CodTipoEvento,
			@L_CodTipoOficina		SMALLINT		= @CodTipoOficina,
			@L_CodMateria			VARCHAR(5)		= @CodMateria,
			@L_Inicio_Vigencia		DATETIME2(7)	= @Inicio_Vigencia
--LÓGICA
	INSERT INTO Catalogo.TipoEventoTipoOficina WITH(ROWLOCK)
	(	
		TN_CodTipoEvento,		TN_CodTipoOficina,		TC_CodMateria,		TF_Inicio_Vigencia
	)
	VALUES
	(	
		@L_CodTipoEvento,		@L_CodTipoOficina,		@L_CodMateria,		@L_Inicio_Vigencia
	);
END
GO
