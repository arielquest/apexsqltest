SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<05/12/2018>
-- Descripción :			<Permite agregar una clase> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarClase]
   @Descripcion			varchar(200),
   @FechaActivacion		datetime2,
   @FechaVencimiento	datetime2
 AS 
    BEGIN
          
			 INSERT INTO Catalogo.Clase
			 (
				TC_Descripcion,	
				TF_Inicio_Vigencia,
				TF_Fin_Vigencia
			 )
			 VALUES
			 (
				@Descripcion,	
				@FechaActivacion,	
				@FechaVencimiento
			 )          
    END

GO
