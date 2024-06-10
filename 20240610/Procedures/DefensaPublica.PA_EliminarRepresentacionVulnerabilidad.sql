SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<27/08/2019>
-- Descripción :			<Permite eliminar las vulnerabilidades de una representación>
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_EliminarRepresentacionVulnerabilidad]
	@CodRepresentacion		uniqueidentifier,
    @CodVulnerabilidad		smallint
As
Begin
	Delete
	From	DefensaPublica.RepresentacionVulnerabilidad	
	Where	TU_CodRepresentacion = @CodRepresentacion	
	And		TN_CodVulnerabilidad = @CodVulnerabilidad
End
GO
