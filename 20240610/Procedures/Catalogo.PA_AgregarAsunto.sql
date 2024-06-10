SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<11/02/2019>
-- Descripción :			<Permite agregar un Asunto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarAsunto]
   @Descripcion			varchar(200),
   @FechaActivacion		datetime2,
   @FechaVencimiento	datetime2
 AS 
    BEGIN          
		INSERT INTO Catalogo.Asunto
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
