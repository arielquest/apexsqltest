SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<11/12/2018>
-- ===========================================================================================
CREATE procedure [Comunicacion].[PA_ConsultarComunicacionesIntervencion]
	@CodInterviniente uniqueidentifier
As
begin
	select		CO.TU_CodComunicacion					As CodigoComunicacion
	from		Comunicacion.Comunicacion				As CO
	inner join	Comunicacion.ComunicacionIntervencion	As CI
	on			CI.TU_CodComunicacion					= CO.TU_CodComunicacion
	where		CI.TU_CodInterviniente					= @CodInterviniente 
	and			CI.TB_Principal							= 1
end
GO
