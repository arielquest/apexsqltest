SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado pOr:				<Tatiana Flores>
-- Fecha de creación:		<27/12/2016>
-- Descripción:				<Permite eliminar la lIsta de Intervinientes AsociadAs a un evento>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_EliminarIntervinienteEvento]
@CodigoEvento Uniqueidentifier
	
As
Begin
 
   Delete
   From		[AgEnda].[IntervinienteEvento] 
   Where	TU_CodEvento=@CodigoEvento

 End

GO
