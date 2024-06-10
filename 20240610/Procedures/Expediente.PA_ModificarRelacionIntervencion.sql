SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<11/12/2018>
-- Descripción:				<Modificar o actualiza el codigo de intervencion que esta relacionada a otra intervención>
-- ===========================================================================================
CREATE procedure [Expediente].[PA_ModificarRelacionIntervencion]
	@CodInterviniente uniqueidentifier,
	@CodIntervenienteRelacionado uniqueidentifier
As
begin
	update	Expediente.Intervencion
	set		TU_RelacionIntervencion		=	@CodInterviniente
	where	TU_CodInterviniente			=	@CodIntervenienteRelacionado 
end
GO
