SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Diego Chavarria>
-- Fecha de creación:		<21/03/2017>
-- Descripción :			<Se agrega la comunicacionEntradaSalida>
-- Modificación:            <Se agrega el update para el primer registro de la comunicacion, se pone en NULL el destino y la fecha envio>
-- =================================================================================================================================================
-- Modificación				<Jonathan Aguilar Navarro> <29/05/2018> <Se cambian los parametros CodOficinaOCJOrigen CodOficinaOCJDestino
--							por CodContextoOCJOrigen y CodContextoOCJDestino>
CREATE PROCEDURE [Comunicacion].[PA_AgregarComunicacionEntradaSalida]
    @CodComunicacion	    Uniqueidentifier,
	@CodContextoOCJOrigen	varchar(4),
	@CodContextoOCJDestino	varchar(4),
	@Entreda        		datetime2,
	@Usuario				Varchar(30)
As
Begin

	UPDATE [Comunicacion].[ComunicacionEntradaSalida]
	SET													[TC_CodContextoOCJDestino]  = @CodContextoOCJDestino,
														[TF_Envio]					= @Entreda
	WHERE												[TU_CodComunicacion]		= @CodComunicacion 
	AND													[TC_CodContextoOCJDestino]	is NULL 
	AND													[TF_Envio]					is NULL


	Declare @Insertado table (Codigo int);

	Insert Into [Comunicacion].[ComunicacionEntradaSalida]
			   ([TU_CodComunicacionEntradaSalida]
			   ,[TU_CodComunicacion]
			   ,[TC_CodContextoOCJOrigen]
			   ,[TC_CodContextoOCJDestino]
			   ,[TF_Entrada]
			   ,[TF_Envio]
			   ,[TC_UsuarioCrea]
			   )
		 Values
			   (NEWID()
			   ,@CodComunicacion
			   ,@CodContextoOCJDestino
			   ,NULL
			   ,@Entreda
			   ,NULL
			   ,@Usuario)

End
GO
