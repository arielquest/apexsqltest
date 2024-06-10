SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<18/08/2015>
-- Descripción :			<Permite Agregar un Funcionario a una Ubicacion> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarFuncionarioUbicacion]
  
   @CodOficina varchar(4),
   @CodUbicacion varchar(11),
   @UsuarioRed varchar(30),
   @Inicio_Vigencia datetime2(7),
   @Principal bit

AS 
    BEGIN
          
			 INSERT INTO Catalogo.FuncionarioUbicacion
				   (TC_CodOficina, TC_CodUbicacion, TC_UsuarioRed, TF_Inicio_Vigencia, TB_Principal )
			 VALUES
				   (@CodOficina, @CodUbicacion, @UsuarioRed ,@Inicio_Vigencia, @Principal )
          
    END
 

GO
