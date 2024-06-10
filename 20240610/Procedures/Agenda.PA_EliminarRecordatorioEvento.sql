SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado pOr:				Tatiana Flores
-- Fecha de creación:		<27/12/2016>
-- Descripción:				<Permite eliminar los recordatorios asociados a un evento[AgEnda].[PA_EliminarRecordatorioEvento].>
-- ===========================================================================================

CREATE PROCEDURE [Agenda].[PA_EliminarRecordatorioEvento]

@CodigoEvento Uniqueidentifier
	
As
Begin

   Delete 
   From		[Agenda].[Recordatorio] 
   Where	[TU_CodEvento]	=	@CodigoEvento

End


GO
