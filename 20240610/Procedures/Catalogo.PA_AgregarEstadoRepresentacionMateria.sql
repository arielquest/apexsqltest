SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<05/02/2019>
-- Descripción :			<Permite asociar estados de representación y materias > 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarEstadoRepresentacionMateria]
   @CodEstadoRepresentacion		smallint,
   @CodMateria					varchar(5),   
   @InicioVigencia				datetime2(7),
   @IniciaTramitacion			bit
AS 
BEGIN          
	INSERT INTO Catalogo.EstadoRepresentacionMateria
		(TN_CodEstadoRepresentacion,		
		TC_CodMateria, 		
		TF_Inicio_Vigencia,
		TB_IniciaTramitacion)
	VALUES
		(@CodEstadoRepresentacion,
		@CodMateria,
		@InicioVigencia,
		@IniciaTramitacion);
END

GO
