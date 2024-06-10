SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<31/08/2015>
-- Descripción :			<Permite Agregar un idioma> 
-- =================================================================================================================================================
--  Modificacion: 09/12/2015  Gerardo Lopez <Generar llave por sequence> 

CREATE PROCEDURE [Catalogo].[PA_AgregarIdioma]
   @Descripcion varchar(150),
   @FechaActivacion	 datetime2(7),
   @FechaVencimiento datetime2(7)
 
AS 
    BEGIN
          
			 INSERT INTO Catalogo.Idioma
				   (  TC_Descripcion ,TF_Inicio_Vigencia      ,TF_Fin_Vigencia)
			 VALUES
				   (@Descripcion,  @FechaActivacion        ,@FechaVencimiento )
         
			 
    END
 

GO
