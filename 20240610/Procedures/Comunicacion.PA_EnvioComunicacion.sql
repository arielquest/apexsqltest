SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Stefany Quesada>
-- Fecha de creación:		<22/05/2017>
-- Descripción:				<Realiza el envio de comunicaciones y cambia su estado  Para Tramitar.>
-- modificado:              <Se agrego un selecte para obtener el codigo del funcionario>
-- modificado:              <se elimino el un select y se cambio el nombre un parametro>
-- ===========================================================================================
CREATE Procedure [Comunicacion].[PA_EnvioComunicacion]
	@CodigoComunicacion      Uniqueidentifier,
	@Estado                  Varchar(1),
	@CodPuestoFuncionario         Uniqueidentifier
As
Begin	
			
	 UPDATE [Comunicacion].[Comunicacion]
	 SET    TC_Estado                      = @Estado, 
			TF_FechaEnvio				   = GETDATE(),
            TU_CodPuestoFuncionarioEnvio   = @CodPuestoFuncionario
	 WHERE  TU_CodComunicacion             = @CodigoComunicacion			
		
End
GO
