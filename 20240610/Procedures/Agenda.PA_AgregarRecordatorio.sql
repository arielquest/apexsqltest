SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				Tatiana Flores
-- Fecha de creación:		<24/01/2017>
-- Descripción:				<Permite agregar un registro a [Agenda].[Recordatorio].>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_AgregarRecordatorio]
	 @CodigoRecordatorio Uniqueidentifier,
	 @CodigoEvento Uniqueidentifier,
	 @CodigoInterviniente Uniqueidentifier,
	 @NumeroMovil Varchar(11),
	 @FechaInicio Datetime2(7),
	 @Mensaje Varchar(200)
	
	
As
Begin

	Insert Into [Agenda].[Recordatorio]
	(
		[TU_CodRecordatorio],
        [TU_CodEvento],
        [TU_CodInterviniente],
        [TC_NumeroMovil],
		[TF_FechaInicioEvento],
		[TC_Mensaje]
	)
	Values
	(
		 @CodigoRecordatorio,
		 @CodigoEvento,
		 @CodigoInterviniente,
		 @NumeroMovil,
		 @FechaInicio,
		 @Mensaje
	)

End


GO
