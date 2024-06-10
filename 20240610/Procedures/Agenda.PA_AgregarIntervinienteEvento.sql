SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Permite agregar un registro a [AgEnda].[PA_AgregarIntervinienteEvento].>
-- ===========================================================================================

CREATE PROCEDURE [Agenda].[PA_AgregarIntervinienteEvento]
	 @CodigoEvento Uniqueidentifier,
	 @CodigoInterviniente Uniqueidentifier
As
Begin

	Insert Into [AgEnda].[IntervinienteEvento]
	(
		TU_CodEvento,
		TU_CodInterviniente
	)
	Values
	(
		 @CodigoEvento,
		 @CodigoInterviniente
	)

End


GO
