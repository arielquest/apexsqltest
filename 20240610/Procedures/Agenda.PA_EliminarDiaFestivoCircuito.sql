SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<18/11/2016>
-- Descripción :			<Permite eliminar un registro a AgEnda.DiaFestivoCircuito.>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_EliminarDiaFestivoCircuito]
	@FechaFestivo		Datetime2,
	@CodCircuito		SmallInt
As
Begin
	Delete 
	From		AgEnda.DiaFestivoCircuito
	Where		TF_FechaFestivo		= @FechaFestivo
	And			TN_CodCircuito		= @CodCircuito;
End

GO
