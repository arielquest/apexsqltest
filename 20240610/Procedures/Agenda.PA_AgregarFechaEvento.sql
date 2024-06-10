SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Permite agregar un registro a [AgEnda].[PA_AgregarFechaEvento].>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_AgregarFechaEvento]
	@CodigoFechaEvento	Uniqueidentifier,
	@CodigoEvento		Uniqueidentifier,
	@FechaInicio		Datetime2(7),
	@FechaFin			Datetime2(7),
	@CodigoSala			Smallint,
	@Observaciones		Varchar(150),
	@Cancelada			Bit,
	@MontoRemate		Decimal(18,2),
	@Lista				Bit 
	
As
Begin

	Insert Into [AgEnda].[FechaEvento]
	(
		TU_CodFechaEvento, 
		TU_CodEvento, 
		TF_FechaInicio, 
		TF_FechaFin, 
		TN_CodSala, 
		TC_Observaciones, 
		TB_Cancelada, 
		TN_MontoRemate,
		TB_Lista
	)
	Values
	(
		@CodigoFechaEvento,
		@CodigoEvento,
		@FechaInicio,
		@FechaFin,
		@CodigoSala,
		@Observaciones,
		@Cancelada,
		@MontoRemate,
		@Lista
	)

End

GO
