SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<03/05/2019>
-- Descripción :			<Permite agregar un registro a la tabla Contraparte> 
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_AgregarContraparte]
	@CodContraparte				uniqueidentifier,
	@NRD						varchar(14),	
	@CodPersona					uniqueidentifier	
As
Begin
	Insert Into DefensaPublica.Contraparte
	(
		TU_CodContraparte,
		TC_NRD,
		TU_CodPersona,
		TF_Creacion
	)
	Values
	(
		@CodContraparte,
		@NRD,
		@CodPersona,		
		GETDATE()
	)
End
GO
