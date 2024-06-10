SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<20/08/2015>
-- Descripción :			<Permite Agregar una Situacion de libertad> 
-- Modificado:			    <Pablo Alvarez Espinoza>
-- Fecha Modifica:          <04/01/2016>
-- Descripcion:	            <Se cambia la llave a smallint squence>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarSituacionLibertad]
  
   @Descripcion varchar(255),
   @FechaActivacion datetime2(3),
   @FechaVencimiento datetime2(3)
 
AS 
    BEGIN
          
			 INSERT INTO Catalogo.SituacionLibertad
				   (TC_Descripcion
				   ,TF_Inicio_Vigencia      ,TF_Fin_Vigencia)
			 VALUES
				   (@Descripcion
				   ,@FechaActivacion        ,@FechaVencimiento)
            select 1
			return
    END
 

GO
