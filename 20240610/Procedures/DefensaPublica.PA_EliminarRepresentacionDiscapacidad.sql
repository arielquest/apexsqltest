SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<28/08/2019>
-- Descripción :			<Permite eliminar las discapacidades de una representación>
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_EliminarRepresentacionDiscapacidad]
	@CodRepresentacion		uniqueidentifier,
    @CodDiscapacidad		smallint
As
Begin
	Delete
	From	DefensaPublica.RepresentacionDiscapacidad
	Where	TU_CodRepresentacion = @CodRepresentacion	
	And		TN_CodDiscapacidad   = @CodDiscapacidad
End
GO
