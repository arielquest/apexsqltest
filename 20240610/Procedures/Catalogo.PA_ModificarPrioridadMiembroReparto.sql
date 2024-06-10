SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<23/07/2021>
-- Descripción :			<Modifica la prioridad del miembro de reparto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarPrioridadMiembroReparto]    
	@CodMiembro					UNIQUEIDENTIFIER ,
	@Prioridad					SMALLINT
AS  
BEGIN  
	DECLARE 
			@L_CodMieMbro		UNIQUEIDENTIFIER = @CodMiembro,
			@L_Prioridad		SMALLINT	     = @Prioridad

			

	UPDATE  Catalogo.MiembrosPorConjuntoReparto
	SET		TN_Prioridad		 = @L_Prioridad

	WHERE   TU_CodMiembroReparto = @L_CodMieMbro
END
GO
