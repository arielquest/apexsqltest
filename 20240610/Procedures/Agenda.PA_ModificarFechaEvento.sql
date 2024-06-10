SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Modifica las observaciones para la fecha de evento indicada.>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_ModificarFechaEvento]
	@CodEvento		Uniqueidentifier,
	@FechaInicio	Datetime2(7),
	@FechaFin		Datetime2(7),
	@Observaciones	Varchar(150),
	@Lista          Bit
As
Begin

		Update [Agenda].[FechaEvento] 
		Set		[TC_Observaciones]	= @Observaciones,
		        [TB_Lista]			= @Lista
		Where	[TF_FechaInicio]	= @FechaInicio
		AND		[TF_FechaFin]		= @FechaFin
		AND 	[TU_CodEvento]		= @CodEvento
End
GO
