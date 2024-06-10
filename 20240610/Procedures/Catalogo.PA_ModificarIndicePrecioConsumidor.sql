SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<22/11/2018>
-- Descripción :			<Permite modificar un indice de precio de consumidor> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarIndicePrecioConsumidor]
	@Codigo				int,
	@Valor				decimal(18,15),
	@Mes				smallint,
	@Anno				smallint
 AS 
    BEGIN
          
			 UPDATE	Catalogo.IndicePrecioConsumidor
			 SET	TN_Valor			=	@Valor,	
					TN_Mes				=	@Mes,	
					TN_Anno				=	@Anno
			 WHERE	TN_Codigo			=	@Codigo
    END

GO
