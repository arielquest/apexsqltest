SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<22/09/2016>
-- Descripción :			<Permite asociar tipo de eventos y materias>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoEventoMateria]
   @CodTipoEvento		smallint,
   @CodMateria			varchar(5),
   @Inicio_Vigencia		datetime2(7)
AS 
BEGIN          
	INSERT INTO Catalogo.TipoEventoMateria
		(TN_CodTipoEvento, 
		TC_CodMateria, 
		TF_Inicio_Vigencia)
	VALUES
		(@CodTipoEvento,
		@CodMateria,
		@Inicio_Vigencia);
END
GO
