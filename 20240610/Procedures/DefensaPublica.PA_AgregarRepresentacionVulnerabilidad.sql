SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<18/06/2019>
-- Descripción :			<Asociar vulnerabilidad de una persona a una representación> 
-- =================================================================================================================================================


CREATE PROCEDURE [DefensaPublica].[PA_AgregarRepresentacionVulnerabilidad]   
	@CodRepresentacion	uniqueidentifier,
    @CodVulnerabilidad	smallint
AS
BEGIN
	INSERT INTO DefensaPublica.RepresentacionVulnerabilidad
	(
		TU_CodRepresentacion,	TN_CodVulnerabilidad,	TF_Actualizacion		
	) 
	VALUES
	(
		@CodRepresentacion,		@CodVulnerabilidad,		GETDATE()			
	)
END

GO
