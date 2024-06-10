SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<29/01/2019>
-- Descripción :			<Permite asociar tipos de casos y materias>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoCasoMateria]
   @CodTipoCaso			smallint,
   @CodMateria			varchar(5),
   @InicioVigencia		datetime2(7)
AS 
BEGIN          
	INSERT INTO Catalogo.TipoCasoMateria
		(TN_CodTipoCaso, 
		TC_CodMateria, 
		TF_Inicio_Vigencia)
	VALUES
		(@CodTipoCaso,
		@CodMateria,
		@InicioVigencia);
END

GO
