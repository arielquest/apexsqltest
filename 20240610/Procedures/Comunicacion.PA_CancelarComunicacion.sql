SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Diego GB>
-- Fecha de creación:		<25/05/2017>
-- Descripción:				<realiza la cancelacion de una comunicacion.>
-- Modificación:            <Se elimina select >
---------------------------------------------------------------------------------------------
-- Fecha:		            <31/10/2017>
-- Modificado por:			<Diego Navarrete>
-- Descripción :			<Se agrega el campo [TF_Actualizacion] para actualizarlo>
-- ===========================================================================================
CREATE Procedure [Comunicacion].[PA_CancelarComunicacion]
	@CodigoComunicacion        Uniqueidentifier,
	@CodigoPuestoTrabajoFuncionario    Uniqueidentifier
As
Begin			
		UPDATE [Comunicacion].[Comunicacion]

		SET		[TU_CodPuestoFuncionarioCancelar]	= @CodigoPuestoTrabajoFuncionario, 
				[TF_FechaCancelar]					= GETDATE(),
				[TB_Cancelar]						= 1,
				[TF_Actualizacion]					= GETDATE()

		WHERE  [TU_CodComunicacion]				 = @CodigoComunicacion 
	
End
GO
