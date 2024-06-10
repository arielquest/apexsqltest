SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<19/08/2015>
-- Descripción :			<Permite Agregar una Categoria Delito> 
-- Modificado :				<Alejandro Villalta, 08/12/2015> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarDelito]
   @CodCategoriaDelito int,
   @Descripcion varchar(255),
   @FechaActivacion datetime2(3),
   @FechaVencimiento datetime2(3)
 
AS 
    BEGIN
          
			 INSERT INTO Catalogo.Delito
			 (
				TN_CodCategoriaDelito, TC_Descripcion,	TF_Inicio_Vigencia, TF_Fin_Vigencia
			 )
			 VALUES
			 (
				@CodCategoriaDelito,   @Descripcion,	@FechaActivacion,	@FechaVencimiento
			 )          
    END
 

GO
