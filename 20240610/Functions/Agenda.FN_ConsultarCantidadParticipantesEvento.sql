SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:			<1.0>
-- Creado pOr:			<Gustavo Bravo Sánchez>
-- Fecha de creación:		<14/02/2017>
-- Descripción:			<Permite mostrar la cantidad de participantes de un evento>
-- ===========================================================================================
Create FUNCTION [Agenda].[FN_ConsultarCantidadParticipantesEvento] (@CodEvento uniqueidentifier)
returns numeric(5)
as
begin

declare
@TotParticipantes numeric(5) = 0,
@TotIintervinientes numeric(5) = 0,
@SumaTotal numeric(5)




set @TotParticipantes = (select count (*) from [Agenda].[ParticipanteEvento] where TU_CodEvento = @CodEvento)

set @TotIintervinientes = (select count(*) from Agenda.IntervinienteEvento where TU_CodEvento = @CodEvento)

set @SumaTotal = @TotParticipantes +  @TotIintervinientes

RETURN @SumaTotal

end




GO
