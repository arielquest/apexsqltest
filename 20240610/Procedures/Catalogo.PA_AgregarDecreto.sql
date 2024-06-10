SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<06/11/2018>
-- Descripción :			<Permite Agregar un Decreto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarDecreto]
   @CodDecreto			varchar(15),
   @Descripcion			varchar(255),
   @FechaActivacion		datetime2,
   @FechaVencimiento	datetime2,
   @FechaPublicacion	datetime2
 AS 
    BEGIN
          
			 INSERT INTO Catalogo.Decreto
			 (
				TC_CodigoDecreto,	TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia,	TF_FechaPublicacion
			 )
			 VALUES
			 (
				@CodDecreto,	@Descripcion,	@FechaActivacion,	@FechaVencimiento,	@FechaPublicacion
			 )          
    END

GO
