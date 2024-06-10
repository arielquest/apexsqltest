SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<24/06/2019>
-- Descripción :			<Asociar discapacidad de una persona a una representación> 
-- =================================================================================================================================================


CREATE PROCEDURE [DefensaPublica].[PA_AgregarRepresentacionDiscapacidad]   
	@CodRepresentacion	uniqueidentifier,
    @CodDiscapacidad	smallint
AS
BEGIN
	INSERT INTO DefensaPublica.RepresentacionDiscapacidad
	(
		TU_CodRepresentacion,	TN_CodDiscapacidad,		TF_Actualizacion		
	) 
	VALUES
	(
		@CodRepresentacion,		@CodDiscapacidad,		GETDATE()			
	)
END

GO
