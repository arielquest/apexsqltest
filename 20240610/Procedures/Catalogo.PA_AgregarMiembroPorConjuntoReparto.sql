SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<21/07/2021>
-- Descripción :			<Registra un miembro a un conjunto de reparto> 
-- Modificación:			<10/02/2023> <Josué Quirós Batista> <Actualización del tipo de dato del campo CodUbicacion.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarMiembroPorConjuntoReparto]   
	@CodConjunto				UNIQUEIDENTIFIER,
	@CodMiembro					UNIQUEIDENTIFIER,
	@Puesto						VARCHAR(14),
	@Prioridad				    SMALLINT,
	@Limite						SMALLINT,
	@CodUbicacion				INT
AS  
BEGIN  
	DECLARE 
			@L_CodConjunto					UNIQUEIDENTIFIER = @CodConjunto,
			@L_Puesto						VARCHAR(14)      = @Puesto,
			@L_CodMiembro					UNIQUEIDENTIFIER = @CodMiembro,
			@L_Prioridad				    SMALLINT		 = @Prioridad,
			@L_Limite						SMALLINT		 = @Limite,
			@L_CodUbicacion					INT				 = @CodUbicacion		

			

	INSERT INTO Catalogo.MiembrosPorConjuntoReparto(
				TU_CodMiembroReparto,	TU_CodConjutoReparto,	TC_CodPuestoTrabajo,	TN_Prioridad,
				TN_Limite,				TN_CodUbicacion,		TF_FechaCreacion,		TF_FechaParticion) 
	VALUES (
				@L_CodMiembro,			@L_CodConjunto,			@L_Puesto,				@L_Prioridad,

				@L_Limite,				@L_CodUbicacion,		GETDATE(),				GETDATE())
END	SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
