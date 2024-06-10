SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<16 de noviembre de 2016>
-- Descripción:				<Permite agregar un registro a Agenda.DiaFestivo.>
-- ===========================================================================================
-- SE AGREGA ESTA MODIFICACIÓN PARA VALIDAR CAMBIOS EN REPOSITORIO DE BD DE AZURE
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_AgregarDiaFestivo]
	@FechaFestivo			datetime2,
	@Descripcion			varchar(250)
As  
Begin  
	Insert Into [Agenda].[DiaFestivo]
			   ([TF_FechaFestivo]
			   ,[TC_Descripcion])
		 Values
			   (@FechaFestivo
			   ,@Descripcion);
End
GO
