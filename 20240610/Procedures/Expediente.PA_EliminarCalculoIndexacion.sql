SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<08/01/2019>
-- Descripción :			<Permite eliminar un cálculo de indexación y sus tramos> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarCalculoIndexacion]
	@Codigo						uniqueidentifier
As
Begin
	Declare	@Msg_Error			VarChar(Max);

	Begin Try 
		Begin Tran

			Delete Expediente.CalculoIndexacionTramo Where TU_CodigoCalculoIndexacion = @Codigo;
	
			Delete Expediente.CalculoIndexacion Where TU_CodigoCalculoIndexacion = @Codigo;

		Commit Tran
	End try
	Begin catch
		Set @Msg_Error = ERROR_MESSAGE()
		RollBack Tran
		RaisError(@Msg_Error, 16, 1)
	End catch
End
GO
