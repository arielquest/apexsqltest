SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<19/08/2015>
-- Descripción :			<Permite Agregar una Categoria Delito> 
-- Modificaco:				<Roger Lara>
-- Fecha:					<08/12/2015>
-- Descripción :			<Se cambio el codigo a entero> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarCategoriaDelito]
   @Descripcion varchar(255),
   @FechaActivacion datetime2(3),
   @FechaVencimiento datetime2(3)
 
AS 
    BEGIN
          
			 INSERT INTO Catalogo.CategoriaDelito
				   (TC_Descripcion ,TF_Inicio_Vigencia      ,TF_Fin_Vigencia)
			 VALUES
				   (@Descripcion   ,@FechaActivacion       ,@FechaVencimiento )
        
    END
 

GO
