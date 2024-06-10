SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<19/11/2015>
-- Descripción :			<Permite Agregar una unbicacion a una ofcina> 
-- Modificado:				<Pablo Alvarez Espinoza>
-- Fecha Modifica:			<17/12/2015>
-- Descripcion:				<Se cambia la llave perfilpuesto a smallint squence>
-- Modificación:			<10/02/2023> <Josué Quirós Batista> <Actualización del tipo de dato del campo CodUbicacion.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarOficinaUbicacion]
   @CodOficina varchar(4),
   @CodUbicacion int,
   @FecAsociacion datetime2
AS 
    BEGIN
          
	  Update Catalogo.OficinaUbicacion
		   set  TF_Inicio_Vigencia  =@FecAsociacion
	   Where TC_CodOficina = @CodOficina and 	TN_CodUbicacion=@CodUbicacion
		 
    END
 

GO
