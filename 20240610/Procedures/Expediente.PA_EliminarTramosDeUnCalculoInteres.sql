SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<29/03/2019>
-- Descripción :			<Permite eliminar todos los tramos de un Cálculo de Interés> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarTramosDeUnCalculoInteres]
	@Codigo							uniqueidentifier
As
Begin
	
	Declare	@Msg_Error			VarChar(Max);

	Begin Try 
		Begin Tran

			Delete	Expediente.CalculoInteresTramo 	Where TU_CodigoCalculoInteres = @Codigo	

		Commit Tran
	End try
	Begin catch
		Set @Msg_Error = ERROR_MESSAGE()
		RollBack Tran
		RaisError(@Msg_Error, 16, 1)
	End catch
End
GO
