SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<04/08/2021>
-- Descripción :			<Modifica un miembro de un conjunto de reparto> 
-- Modificación:			<10/02/2023> <Josué Quirós Batista> <Actualización del tipo de dato del campo CodUbicacion.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarMiembroPorConjuntoReparto]   
	@CodMiembro					UNIQUEIDENTIFIER,
	@Prioridad				    SMALLINT,
	@Limite						SMALLINT,
	@CodUbicacion				INT
AS  
BEGIN  
	DECLARE 
			@L_CodMiembro					UNIQUEIDENTIFIER = @CodMiembro,
			@L_Prioridad				    SMALLINT		 = @Prioridad,
			@L_Limite						SMALLINT		 = @Limite,
			@L_CodUbicacion					INT				 = @CodUbicacion		

			

		UPDATE Catalogo.MiembrosPorConjuntoReparto
		SET		TN_Prioridad	= @L_Prioridad,
				TN_Limite		= @L_Limite,
				TN_CodUbicacion = @L_CodUbicacion
		WHERE	TU_CodMiembroReparto = @L_CodMiembro
END
GO
