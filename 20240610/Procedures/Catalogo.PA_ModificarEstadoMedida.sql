SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Descripción :			<Permite modificar el estado de una medida> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_ModificarEstadoMedida]
	@CodEstado				SMALLINT,
	@Descripcion			VARCHAR(150),
	@FinVigencia			DATETIME2(7)
AS  
BEGIN  
	DECLARE
	@L_CodEstado			SMALLINT		= @CodEstado,
	@L_Descripcion			VARCHAR(150)	= @Descripcion,
	@L_FinVigencia			DATETIME2(7)	= @FinVigencia

	UPDATE	[Catalogo].[EstadoMedida]
	SET		
	[TC_Descripcion]						= @L_Descripcion,
	[TF_Fin_Vigencia]						= @L_FinVigencia,
	[TF_Actualizacion]						= GETDATE()
	WHERE
	[TN_CodEstado]							= @L_CodEstado
END
GO
