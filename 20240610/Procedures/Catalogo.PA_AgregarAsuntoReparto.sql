SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<30/07/2021>
-- Descripción :			<Registra un asunto de reparto> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_AgregarAsuntoReparto]     
	@CodAsunto					INT,
	@CodConfiguracionReparto	UNIQUEIDENTIFIER
AS  
BEGIN  
	DECLARE 
			@L_CodAsunto				INT					= @CodAsunto,
			@L_CodConfiguracionReparto	UNIQUEIDENTIFIER	= @CodConfiguracionReparto


			
			

	INSERT INTO Catalogo.AsuntosReparto	(TN_CodAsunto,	TU_CodConfiguracionReparto) 
	VALUES								(@CodAsunto,	@CodConfiguracionReparto)
END
GO
