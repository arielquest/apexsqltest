SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<31/08/2021>
-- Descripción :			<Agrega un criterio de asignación> 
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Creado por:				<Xinia Soto>
-- Fecha de creación:		10/09/2021>
-- Descripción :			<Se agrega columna de TU_CodConjuntoReparto a la tabla Catalogo.CriterioAsignacion> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_AgregarCriterioAsignacion]
	@CodCriterio				UNIQUEIDENTIFIER,
	@CodPuestoTrabajo			VARCHAR(14),
	@Asignaciones				SMALLINT,
	@Adicionales				SMALLINT,
	@TotalAcumulado				SMALLINT,
	@CodConjunto                UNIQUEIDENTIFIER
AS  
BEGIN  
	DECLARE 		@L_CodCriterio		UNIQUEIDENTIFIER	= @CodCriterio,
					@L_CodConjunto		UNIQUEIDENTIFIER	= @CodConjunto,
					@L_CodPuestoTrabajo	VARCHAR(14)			= @CodPuestoTrabajo,	
					@L_Asignaciones		SMALLINT			= @Asignaciones,		
					@L_Adicionales		SMALLINT			= @Adicionales,		
					@L_TotalAcumulado	SMALLINT			= @TotalAcumulado		


			
	
	INSERT INTO		Catalogo.CriterioAsignacion
					(TU_CodCriterio,	TC_CodPuestoTrabajo,	TN_Asignaciones,	TN_Adicionales,
					TN_TotalAcumulado,	TF_UltimaAsignacion,	TU_CodConjuntoReparto)
	VALUES			(@L_CodCriterio,	@L_CodPuestoTrabajo,	@L_Asignaciones,	@L_Adicionales,		
					 @L_TotalAcumulado,	GETDATE(),				@L_CodConjunto)	
END
GO
