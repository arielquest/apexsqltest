SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<18/11/2016>
-- Descripción :			<Permite agregar un registro a Agenda.DiaFestivoCircuito.>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_AgregarDiaFestivoCircuito]
	@FechaFestivo			datetime2,
	@CodCircuito			smallint,
	@FechaAsociacion		datetime2
As  
Begin  
	Insert Into [Agenda].[DiaFestivoCircuito]
			   ([TF_FechaFestivo]
			   ,[TN_CodCircuito]
			   ,[TF_Inicio_Vigencia])
		 Values
			   (@FechaFestivo
			   ,@CodCircuito
			   ,@FechaAsociacion);
End
GO
