SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<18/08/2015>
-- Descripción :			<Permite Modificar una ubicacion de un usuario> 
-- =================================================================================================================================================

  
CREATE PROCEDURE [Catalogo].[PA_ModificarFuncionarioUbicacion]


 @CodOficina varchar(4),
 @CodUbicacion varchar(11),
 @UsuarioRed varchar(30),
 @Principal bit
 
 As
 Begin
 
  Update [Catalogo.FuncionarioUbicacion] Set TB_Principal =@Principal
                 Where TC_CodUbicacion =@CodUbicacion AND TC_CodOficina = @CodOficina AND TC_UsuarioRed=@UsuarioRed 

 End
GO
