SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Daniel Ruiz Hernández>
-- Fecha de creación:		<15/07/2021>
-- Descripción :			<Permite agregar un motivo de devolución para el pase a fallo> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarMotivoDevolucionPaseFallo]
   @Descripcion			VARCHAR(150),
   @TipoMotivo			CHAR(1),
   @InicioVigencia		DATETIME2(3),
   @FinVigencia			DATETIME2(3)
 
AS 
    BEGIN
		INSERT INTO Catalogo.MotivoDevolucionPaseFallo
			(TC_Descripcion,	TC_TipoMotivo,		TF_Inicio_Vigencia      ,TF_Fin_Vigencia)
		VALUES
			(@Descripcion,		@TipoMotivo,		@InicioVigencia,		@FinVigencia)
    END

GO
