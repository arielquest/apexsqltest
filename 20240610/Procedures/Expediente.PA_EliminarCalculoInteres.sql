SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<25/03/2019>
-- Descripción :			<Permite eliminar los datos de un Cálculo de Interés> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarCalculoInteres]
	@Codigo							uniqueidentifier
As
Begin
	
	Declare	@Msg_Error			VarChar(Max);

	Begin Try 
		Begin Tran

			Delete	Expediente.CalculoInteresTramo 	Where TU_CodigoCalculoInteres = @Codigo	

			Delete	Expediente.CalculoInteres Where	TU_CodigoCalculoInteres = @Codigo	

			Commit Tran
	End try
	Begin catch
		Set @Msg_Error = ERROR_MESSAGE()
		RollBack Tran
		RaisError(@Msg_Error, 16, 1)
	End catch
End
GO
