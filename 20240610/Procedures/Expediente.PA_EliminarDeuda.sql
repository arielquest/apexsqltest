SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<25/03/2019>
-- Descripción :			<Permite eliminar los datos de una deuda> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarDeuda]
	@Codigo							uniqueidentifier
As
Begin
	Declare	@Msg_Error			VarChar(Max);

	Begin Try 
		Begin Tran

			Delete	Expediente.Deuda 	Where TU_CodigoDeuda = @Codigo	

			Commit Tran
	End try
	Begin catch
		Set @Msg_Error = ERROR_MESSAGE()
		RollBack Tran
		RaisError(@Msg_Error, 16, 1)
	End catch
End
GO
