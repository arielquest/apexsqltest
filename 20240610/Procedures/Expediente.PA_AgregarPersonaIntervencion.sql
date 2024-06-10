SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Autor:			<Juan Ramirez V>
-- Fecha Creación:	<20/16/2018>
-- Descripcion:		<Agregar los datos de una intervencion en el expediente>
-- =============================================================================================================================================================================
-- Modificación:	<09/02/2021><Karol Jiménez Sánchez><Se agrega parámetro IDINT>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarPersonaIntervencion] 
	   @CodigoInterviniente 			uniqueidentifier,
       @CodigoTipoParticipacion 		char(1),
       @CodigoPersona 					uniqueidentifier,
       @CodigoNumeroLegajo 				Char (14),
       @FechaInicioVigencia 			datetime2(7),
       @FechaFinVigencia 				datetime2(7),
	   @IDINT							bigint
AS

BEGIN

	INSERT INTO [Expediente].[Intervencion]
           ([TU_CodInterviniente]
           ,[TC_TipoParticipacion]
           ,[TU_CodPersona]
           ,[TC_NumeroExpediente]
           ,[TF_Inicio_Vigencia]
           ,[TF_Fin_Vigencia]
		   ,[TF_Actualizacion]
		   ,[IDINT])
     VALUES
           (	
		   @CodigoInterviniente,
		   @CodigoTipoParticipacion,
		   @CodigoPersona,
		   @CodigoNumeroLegajo,
		   @FechaInicioVigencia,
		   @FechaFinVigencia,
		   GETDATE(),
		   @IDINT)
END

GO
