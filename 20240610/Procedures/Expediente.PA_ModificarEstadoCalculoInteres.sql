SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<29/03/2019>
-- Descripción :			<Permite modificar el estado de Cálculo de Interés> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarEstadoCalculoInteres]
	@Codigo							uniqueidentifier,
	@CodigoDeuda					uniqueidentifier,
	@EstadoCalculo					char(1)
As
Begin
	
	Update	Expediente.CalculoInteres 
	Set		TC_EstadoCalculo				=	@EstadoCalculo
	Where	TU_CodigoCalculoInteres			=	@Codigo	
	And		TU_CodigoDeuda					=	@CodigoDeuda

End
GO
