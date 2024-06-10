SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:					<Olger Gamboa Castillo>
-- Fecha Creación:			<06/08/2015>
-- Descripcion:				<Permite agregar un nuevo registro de despacho>
-- =================================================================================================================================================
-- Modificado:				<18/12/2015><Alejandro Villalta Ruiz><Modificar el tipo de dato del codigo de tipo de oficina>
-- Modificado:				<5/05/2017><Stefany Quesada><Se agrega el campo TC_CodOficinaDefensa al agregar
-- Modificado:				<13/07/2017><Stefany Quesada><Se agrega el parámetro @CodMateria  al agregar.>
-- Modificación:			<15/02/2018> <Andrés Díaz> <Se modifica el tamaño del teléfono y fax a 50.>
-- Modificación:			<13/03/2018> <Jonathan Aguilar Navarro> <Se modifica para quitar la materia, el fax, el teléfono, E-Mail, ahora van ligados al contexto>
-- Modificación				<23/05/2018> <Jonathan Aguilar Navarro> <Se elimina el campo CodOficinaOCJ ya que pasa a tabla Contexto como CodContextoCOJ> 
-- =============================================

CREATE PROCEDURE [Catalogo].[PA_AgregarOficina] 
	@CodOficina varchar(4), 
	@CodCategoriaOficina char(1)=null, 
	@Nombre varchar(255),
	@CodCircuito varchar(2),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2=null,
	@CodTipoOficina smallint,
	@Descripcion_Abreviada varchar(50)=null,
	@Domicilio varchar(255) =null,
	@CodOficinaDefensa varchar(4) =null
AS
BEGIN
	INSERT INTO	Catalogo.Oficina
	(	TC_CodOficina, TC_CodCategoriaOficina,	TC_Nombre,	TN_CodCircuito,	TF_Inicio_Vigencia,	
		TF_Fin_Vigencia,TN_CodTipoOficina, TC_DescripcionAbreviada,
		TC_Domicilio,TC_CodOficinaDefensa
	)
	VALUES
	(	@CodOficina, @CodCategoriaOficina,	@Nombre,	@CodCircuito,	@FechaActivacion,
		@FechaVencimiento,	@CodTipoOficina,	@Descripcion_Abreviada,
		@Domicilio,@CodOficinaDefensa
	)
END
GO
