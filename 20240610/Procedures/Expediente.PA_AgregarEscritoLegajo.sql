SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:						<1.0>
-- Creado por:					<Isaac Dobles Mata>
-- Fecha de creación:			<26/03/2021>
-- Descripción :				<Vincula un escrito a un legajo> 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_AgregarEscritoLegajo]
	@CodigoEscrito			uniqueidentifier,
	@CodigoLegajo			uniqueidentifier
AS
BEGIN
			
	DECLARE @L_CodigoEscrito		uniqueidentifier	=	@CodigoEscrito,		
			@L_CodigoLegajo			uniqueidentifier	=	@CodigoLegajo
	
	INSERT INTO [Expediente].[EscritoLegajo]
	           ([TU_CodEscrito]
	           ,[TU_CodLegajo])
	     VALUES
	           (@L_CodigoEscrito		
	           ,@L_CodigoLegajo)	
END
GO
