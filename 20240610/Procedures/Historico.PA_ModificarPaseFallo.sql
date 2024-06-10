SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Daniel Ruiz Hernández>
-- Fecha de creación:	<03/08/2021>
-- Descripción:			<Permite modificar un registro en la tabla: PaseFallo.>
-- ==================================================================================================================================================================================
-- Modificación:		<06/08/2021> <Aida Elena Siles R> <Se agregan los campos de fecha devolución, archivo y motivo devolución para poder modificarlos.>
-- ==================================================================================================================================================================================

CREATE PROCEDURE	[Historico].[PA_ModificarPaseFallo]
	@CodPaseFallo				UNIQUEIDENTIFIER,
	@CodTareaDevuelve			UNIQUEIDENTIFIER	= NULL,
	@CodMotivoDevolucion		SMALLINT			= NULL,
	@FechaDevolucion			DATETIME2(7)		= NULL,
	@CodArchivo					UNIQUEIDENTIFIER	= NULL
AS
BEGIN
--Variables
	DECLARE @L_CodPaseFallo				UNIQUEIDENTIFIER	= @CodPaseFallo,
			@L_CodTareaDevuelve			UNIQUEIDENTIFIER	= @CodTareaDevuelve,
			@L_CodMotivoDevolucion		SMALLINT			= @CodMotivoDevolucion,
			@L_FechaDevolucion			DATETIME2(7)		= @FechaDevolucion,
			@L_CodArchivo				UNIQUEIDENTIFIER	= @CodArchivo

	IF (@L_FechaDevolucion IS NULL)
	BEGIN
	SET @L_FechaDevolucion = IIF(@L_CodTareaDevuelve IS NULL, NULL , GETDATE())
	END
		
    UPDATE Historico.PaseFallo	WITH(ROWLOCK)
	SET 
		TF_FechaDevolucion		= ISNULL (@L_FechaDevolucion, TF_FechaDevolucion),
		TU_CodTareaDevuelve		= ISNULL (@L_CodTareaDevuelve, TU_CodTareaDevuelve),
		TN_CodMotivoDevolucion	= ISNULL (@L_CodMotivoDevolucion, TN_CodMotivoDevolucion),
		TU_CodArchivo			= ISNULL (@L_CodArchivo, TU_CodArchivo)
    WHERE 
	    TU_CodPaseFallo			= @L_CodPaseFallo
END
GO
