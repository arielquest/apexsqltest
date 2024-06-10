SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado pOr:				<Tatiana Flores>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Permite eliminar lAs fechAs de evento >
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_EliminarFechaEvento]
@CodigoFechaEvento Uniqueidentifier,
@CodigoEvento Uniqueidentifier

As
Begin

	Delete 
	From		[AgEnda].[FechaEvento] 
	Where		TU_CodEvento=@CodigoEvento 
	And         [TU_CodFechaEvento]=@CodigoFechaEvento
	
End

GO
