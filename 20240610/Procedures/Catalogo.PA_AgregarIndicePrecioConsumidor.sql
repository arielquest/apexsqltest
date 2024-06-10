SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<21/11/2018>
-- Descripción :			<Permite agregar un indice de precio de consumidor> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarIndicePrecioConsumidor]
	@Valor				decimal(18,15),
	@Mes				smallint,
	@Anno				smallint
 AS 
    BEGIN
          
			 INSERT INTO Catalogo.IndicePrecioConsumidor
			 (
				TN_Valor,	TN_Mes,	TN_Anno
			 )
			 VALUES
			 (
				@Valor,		@Mes,	@Anno	
			 )          
    END

GO
