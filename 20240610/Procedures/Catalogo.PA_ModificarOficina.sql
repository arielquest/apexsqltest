SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:					<Roger Lara>
-- Fecha Creación:			<06/08/2015>
-- Descripcion:				<Modificar Oficina>
-- =================================================================================================================================================
-- Modificado:				<18/12/2015><Alejandro Villalta Ruiz><Modificar el tipo de dato del codigo de tipo de oficina>
-- Nodificado:				<25/05/2016><Andrés Díaz><Se agrega el campo TF_Fin_Vigencia al update.>
-- Modificación:			<29/09/2016><Johan Acosta> <Se agrega el campo de categoria oficina.>
-- Modificación:			<02/12/2016><Pablo Alvarez> <Se corrige TN_CodCircuito y TN_CodTipoOficina por estandar.>
-- Modificado:				<19/01/2017> <Roger Lara><Se agrega el campo de Codidgo Oficina OCJ >
-- Modificado:				<23/01/2017> <Roger Lara><Se modifico el campo categoria oficina para que sea de tipo char(1) >
-- Modificado:				<05/05/2017> <Stefany Quesada><Se agrego el campo CodOficinaDefensa >
-- Modificado:				<13/07/2017> <Stefany Quesada><Se agrego el parámetro @CodMateria >
-- Modificación:			<15/02/2018> <Andrés Díaz> <Se modifica el tamaño del teléfono y fax a 50.>
-- Modificación:			<13/03/2018> <Jonathan Aguilar Navarro> <Se modifica para quitar la materia, el fax, el teléfono, E-Mail, ahora van ligados al contexto>
-- Modificación				<23/05/2018> <Jonathan Aguilar Navarro> <Se elimina el campo CodOficinaOCJ ya que pasa a tabla Contexto como CodContextoCOJ> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarOficina] 
	@CodOficina varchar(4), 
	@CodCategoriaOficina char(1)=null, 
	@Nombre varchar(255),
	@CodCircuito varchar(2),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2,
	@CodTipoOficina smallint,
	@Descripcion_Abreviada varchar(50),
	@Domicilio varchar(255),
	@CodOficinaDefensa varchar(4) =null

AS
BEGIN

UPDATE Catalogo.Oficina set		TC_Nombre=@Nombre,
								TC_CodCategoriaOficina = @CodCategoriaOficina,
								TN_CodCircuito=@CodCircuito,
								TF_Inicio_Vigencia=@FechaActivacion,
								TF_Fin_Vigencia=@FechaVencimiento,
								TN_CodTipoOficina=@CodTipoOficina,
								TC_DescripcionAbreviada=@Descripcion_Abreviada,
								TC_Domicilio=@Domicilio,
                                TC_CodOficinaDefensa=@CodOficinaDefensa
where TC_CodOficina=@CodOficina

END


GO
