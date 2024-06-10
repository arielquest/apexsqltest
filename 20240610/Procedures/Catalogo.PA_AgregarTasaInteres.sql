SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<16/11/2018>
-- Descripción :			<Permite agregar una tasa de interes> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTasaInteres]
	@CodigoTasaInteres	uniqueidentifier,
	@CodigoBanco		char(4),
	@CodMoneda			smallint,
	@Valor				decimal(8,5),
	@FechaActivacion	datetime2,
	@FechaVencimiento	datetime2
 AS 
    BEGIN
          
			 INSERT INTO Catalogo.TasaInteres
			 (
				TN_CodigoTasaInteres,	TC_CodigoBanco,	TN_CodMoneda,	TF_Inicio_Vigencia,	TF_Fin_Vigencia,	TN_Valor
			 )
			 VALUES
			 (
				@CodigoTasaInteres,		@CodigoBanco,	@CodMoneda,		@FechaActivacion,	@FechaVencimiento,	@Valor
			 )          
    END

GO
