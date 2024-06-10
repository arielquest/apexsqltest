SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Daniel Ruiz Hernández>
-- Fecha de creación:		<15/07/2021>
-- Descripción :			<Permite modificar un motivo de devolución para el pase a fallo> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarMotivoDevolucionPaseFallo] 
	@CodMotivoDevolucion	SMALLINT, 
	@Descripcion			VARCHAR(150),
	@TipoMotivo				CHAR(1),
	@FechaVencimiento		DATETIME2
AS
BEGIN
	UPDATE	Catalogo.MotivoDevolucionPaseFallo
	SET		TC_Descripcion			=	@Descripcion,
			TC_TipoMotivo			=	@TipoMotivo,
			TF_Fin_Vigencia			=	@FechaVencimiento
	WHERE	TN_CodMotivoDevolucion	=	@CodMotivoDevolucion
END
GO
