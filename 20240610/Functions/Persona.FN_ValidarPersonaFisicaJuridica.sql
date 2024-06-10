SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<2017/12/11>
-- Descripción :			<Valida que la persona física o jurídica exista en la tabla persona .> 
-- =================================================================================================================================================
CREATE FUNCTION [Persona].[FN_ValidarPersonaFisicaJuridica]
(
	@CodPersona		uniqueidentifier,
	@CodTipoPersona	char(1)
)
RETURNS Bit
AS
BEGIN
	Declare	@Resultado As Bit = 0;

	Select		@Resultado				= CASE WHEN COUNT(*) = 1 THEN 1 ELSE 0 END
	From		Persona.Persona			A With(NoLock)
	Where		A.TU_CodPersona			= @CodPersona
	And			A.TC_CodTipoPersona		= @CodTipoPersona;

	Return @Resultado;
END
GO
