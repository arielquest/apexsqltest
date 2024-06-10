SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ===========================================================================================
-- Versión:					<1.0>
-- Creado pOr:				Diego Navarrete
-- Fecha de creación:		<18/05/2017>
-- Descripción:				<Permite eliminar la comunicacion registrada>
-- ===========================================================================================
-- Modificación:			<22/09/2021> <Aida Elena Siles R> <Se agrega la tabla Comunicacion.ComunicacionIntervencion>
-- ===========================================================================================

CREATE   PROCEDURE [Comunicacion].[PA_EliminarComunicacion]
@CodComunicacion UNIQUEIDENTIFIER

AS
BEGIN
--Variables
	DECLARE	@L_CodComunicacion		UNIQUEIDENTIFIER		= @CodComunicacion

  BEGIN TRY
    BEGIN TRANSACTION;
		DELETE  
		FROM	[Comunicacion].[CambioEstadoComunicacion] WITH (ROWLOCK)
		WHERE	TU_CodComunicacion  =	@L_CodComunicacion

		DELETE 
		FROM	[Comunicacion].[ArchivoComunicacion] WITH (ROWLOCK)
		WHERE	TU_CodComunicacion	=	@L_CodComunicacion

		DELETE 
		FROM	[Comunicacion].[ComunicacionIntervencion] WITH (ROWLOCK)
		WHERE	TU_CodComunicacion	=	@L_CodComunicacion

		DELETE 
		FROM	[Comunicacion].[Comunicacion] WITH (ROWLOCK)
		WHERE	TU_CodComunicacion	=	@L_CodComunicacion 

      COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
		THROW;
  END CATCH
END
GO
