SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<28/01/2019>
-- Descripción :			<Permite consultar la intervencion relacionada a otra> 
-- =================================================================================================================================================

CREATE Procedure [Expediente].[PA_ConsultarIntervencionRelacionada]
	@CodInterviniente			Uniqueidentifier
As
Begin				
	Select TU_RelacionIntervencion 
	from Expediente.Intervencion 
	where TU_CodInterviniente = @CodInterviniente	
End
GO
