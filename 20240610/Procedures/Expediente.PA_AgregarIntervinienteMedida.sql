SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================
-- Autor:			<Rafa Badilla Alvarado>
-- Fecha Creación:  <19/010/2022> 
-- Descripcion:		<Permite agregar una nueva medida a un interviniente>
-- =================================================================================================================================================
CREATE      PROCEDURE [Expediente].[PA_AgregarIntervinienteMedida] 
@CodMedida			uniqueidentifier, 
@Contexto			varchar(4),
@CodInterviniente	uniqueidentifier,
@CodTipoMedida		smallint,
@CodEstado			smallint,
@FechaEstado		datetime2(3),
@Observaciones		varchar(255) = NULL
AS
BEGIN

Declare @L_TU_CodMedida		    uniqueidentifier		= @CodMedida,
@L_TC_Contexto		    varchar(4)				= @Contexto,
@L_TU_CodInterviniente  uniqueidentifier		= @CodInterviniente,
@L_TN_CodTipoMedida	    smallint				= @CodTipoMedida,
@L_TN_CodEstado			smallint				= @CodEstado,
@L_TF_FechaEstado		datetime2(3)			= @FechaEstado,
@L_TC_Observaciones		varchar(255)			= @Observaciones

INSERT INTO [Expediente].[IntervinienteMedida]
           ([TU_CodMedida]
           ,[TC_CodContexto]
           ,[TU_CodInterviniente]
           ,[TN_CodTipoMedida]
           ,[TN_CodEstado]
           ,[TF_FechaEstado]
           ,[TC_Observaciones])
     VALUES
           (@L_TU_CodMedida
           ,@L_TC_Contexto
           ,@L_TU_CodInterviniente
           ,@L_TN_CodTipoMedida
           ,@L_TN_CodEstado
           ,@L_TF_FechaEstado
           ,@L_TC_Observaciones)
END
GO
