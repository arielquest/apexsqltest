SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<16/11/2016>
-- Descripción :			<Permite eliminar un registro a Agenda.DiaFestivo.>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_EliminarDiaFestivo]
	@FechaFestivo		datetime2
As
Begin
	Delete From		Agenda.DiaFestivo
	Where			TF_FechaFestivo		= @FechaFestivo;
End


GO
