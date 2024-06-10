SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<20/11/2018>
-- Descripción :			<Permite modificar una tasa de interes> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarTasaInteres]
	@CodigoTasaInteres	uniqueidentifier,
	@CodigoBanco		char(4),
	@CodMoneda			smallint,
	@Valor				decimal(8,5),
	@FechaActivacion	datetime2,
	@FechaVencimiento	datetime2
 AS 
    BEGIN
          
			 UPDATE	Catalogo.TasaInteres
			 SET	TC_CodigoBanco			=	@CodigoBanco,	
					TN_CodMoneda			=	@CodMoneda,	
					TF_Inicio_Vigencia		=	@FechaActivacion,
					TF_Fin_Vigencia			=	@FechaVencimiento,	
					TN_Valor				=	@Valor
			 WHERE	TN_CodigoTasaInteres	=	@CodigoTasaInteres
    END

GO
