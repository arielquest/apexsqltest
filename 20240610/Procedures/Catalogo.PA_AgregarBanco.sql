SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<12/11/2018>
-- Descripción :			<Permite Agregar un Banco> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarBanco]
   @CodBanco			char(4),
   @Descripcion			varchar(255),
   @FechaActivacion		datetime2,
   @FechaVencimiento	datetime2
 AS 
    BEGIN
          
			 INSERT INTO Catalogo.Banco
			 (
				TC_CodigoBanco,	TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
			 )
			 VALUES
			 (
				@CodBanco,	@Descripcion,	@FechaActivacion,	@FechaVencimiento
			 )          
    END

GO
