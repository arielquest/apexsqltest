SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto V.>
-- Fecha de creación:		<06/02/2020>
-- Descripción:				<Permite agregar un registro de la relación de audiciencias por legajo>
-- ===========================================================================================

CREATE PROCEDURE [Expediente].[PA_AgregarAudienciaLegajo]
	@CodAudiencia bigint,
	@CodLegajo uniqueidentifier
AS  
BEGIN  

--Variables.
Declare @L_TN_CodAudiencia bigint           = @CodAudiencia,
		@L_TU_CodLegajo	   uniqueidentifier = @CodLegajo
--Lógica.
INSERT INTO [Expediente].[AudienciaLegajo]
           ([TN_CodAudiencia],
			[TU_CodLegajo] )
     VALUES
           (@L_TN_CodAudiencia
           ,@L_TU_CodLegajo)

END		 
GO
