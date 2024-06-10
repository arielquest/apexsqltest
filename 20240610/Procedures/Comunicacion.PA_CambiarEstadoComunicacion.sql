SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Gómez G Babel>
-- Fecha de creación:		<13/03/2017>
-- Descripción :			<Permite hacer cambio de estado de un comunicado y guarda la accion en la tabla histórica>
----------------------------------------------------------------------------------------------------------------------------------------------------
-- Modificado por:          <Diego Navarrete>	<31/10/2017> <Se agrega el campo [TF_Actualizacion] para actualizarlo>
-- Modificado por:          <Isaac Dobles Mata> <05/08/2021> <Se elimina manejo de transacciones>
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_CambiarEstadoComunicacion]
	@CodComunicacion				uniqueidentifier,
	@UsuarioRed						varchar(30),
	@Observaciones					varchar(500),
	@Estado							char(1)

As
Begin
	Update	[Comunicacion].Comunicacion 
	Set		[TC_Estado]					= @Estado,
			[TF_Actualizacion]			= GETDATE()
	Where TU_CodComunicacion			= @CodComunicacion;

	Insert into [Comunicacion].CambioEstadoComunicacion
	(
		TU_CodCambioEstado,		TU_CodComunicacion,		TF_Fecha,		TC_UsuarioRed,
		TC_Observaciones,		TC_Estado
	)
	Values 
	(
		NEWID(),				@CodComunicacion,		GETDATE(),		@UsuarioRed,
		@Observaciones, 		@Estado
	);
End
GO
