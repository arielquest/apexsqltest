SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado pOr:				Juan Ramirez
-- Fecha de creación:		<05/11/2018>
-- Descripción:				<Permite eliminar una intervención asociada a la comunicacion registrada>
-- ===========================================================================================

CREATE PROCEDURE [Comunicacion].[PA_EliminarIntervencionAsociadaComunicacion]
@CodComunicacion Uniqueidentifier,
@CodigoInterviniente Uniqueidentifier

As
Begin
  BEGIN TRY
    BEGIN TRANSACTION;
		Delete  
		From	[Comunicacion].[ComunicacionIntervencion]
		Where	TU_CodComunicacion  = @CodComunicacion
		AND		TU_CodInterviniente = @CodigoInterviniente

      COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
		THROW;
  END CATCH
End



GO
