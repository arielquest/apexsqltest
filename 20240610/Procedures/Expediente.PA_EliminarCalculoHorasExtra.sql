SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<28/01/2019>
-- Descripción :			<Permite eliminar cálculo de horas extra> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarCalculoHorasExtra]
	@Codigo						uniqueidentifier
As
Begin
	
		Update	Expediente.CalculoHorasExtra
		Set		TB_CalculoHorasExtraEliminado	=	1
		Where	TU_CodigoCalculoHorasExtra		=	@Codigo

End
GO
