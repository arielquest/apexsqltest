SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Juan Ramírez>
-- Fecha Creación:	<05/10/2018>
-- Descripcion:		<Asociar una intervención a una comunicación>
-- =============================================
CREATE PROCEDURE [Comunicacion].[PA_AsociarIntervencionComunicacion]   
    @CodComunicacion         	uniqueidentifier,
	@CodInterviniente         	uniqueidentifier,
	@Principal					bit
AS
BEGIN

	IF EXISTS (SELECT 1 FROM [Comunicacion].[ComunicacionIntervencion] WHERE TU_CodComunicacion = @CodComunicacion and TU_CodInterviniente =@CodInterviniente)
		BEGIN
			-- Actualiza el registro si existe
			UPDATE  [Comunicacion].[ComunicacionIntervencion]
			SET  	TB_Principal = @Principal
			WHERE	TU_CodComunicacion = @CodComunicacion AND TU_CodInterviniente =@CodInterviniente
		END
		ELSE
		BEGIN
		   -- Inserta el registro
			INSERT INTO [Comunicacion].[ComunicacionIntervencion]
			(
			   TU_CodComunicacion           ,TU_CodInterviniente            ,TB_Principal
			) 
			VALUES
			(
				@CodComunicacion			,@CodInterviniente				,@Principal
			)
		END
	END	
GO
