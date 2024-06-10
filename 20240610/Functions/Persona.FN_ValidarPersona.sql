SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<2017/12/12>
-- Descripción :			<Valida que la persona exista en la tabla Persona.PersonaFisica o Persona.PersonaJuridica según corresponda.> 
-- =================================================================================================================================================
CREATE FUNCTION [Persona].[FN_ValidarPersona]
(
	@CodPersona		uniqueidentifier,
	@CodTipoPersona	char(1)
)
RETURNS Bit
AS
BEGIN
	Declare	@Resultado As Bit = 0;

	If (@CodTipoPersona = 'F')
	Begin
		Select		@Resultado				= Case When Count(*) = 0 Then 1 Else 0 End
		From		Persona.PersonaJuridica	A With(NoLock)
		Where		A.TU_CodPersona			= @CodPersona
	End
	Else If (@CodTipoPersona = 'J')
	Begin
		Select		@Resultado				= Case When Count(*) = 0 Then 1 Else 0 End
		From		Persona.PersonaFisica	A With(NoLock)
		Where		A.TU_CodPersona			= @CodPersona
	End

	Return @Resultado;
END
GO
