SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero>
-- Fecha de creación:	<27/10/2022>
-- Descripción:			<Permite consultar un registro en la tabla: IntervinienteMedidaPlazo por Codigo Plazo o por Codigo Medida>
-- ==================================================================================================================================================================================
CREATE   PROCEDURE	[Expediente].[PA_ConsultarIntervinienteMedidaPlazo]
@CodPlazo			UNIQUEIDENTIFIER = NULL,
@CodMedida			UNIQUEIDENTIFIER = NULL
AS
BEGIN
	--Variables
	DECLARE		@L_TU_CodPlazo							UNIQUEIDENTIFIER = @CodPlazo,
				@L_TU_CodMedida							UNIQUEIDENTIFIER = @CodMedida

	--Lógica
	SELECT		A.TU_CodMedida							Codigo,
				A.TF_FechaInicio						FechaInicio,
				A.TF_FechaFin							FechaFin			  
				
	FROM		Expediente.IntervinienteMedidaPlazo		A WITH (NOLOCK)	
	
	WHERE	    A.TU_CodPlazo							= COALESCE(@L_TU_CodPlazo, A.TU_CodPlazo)
	AND			A.TU_CodMedida							= COALESCE(@L_TU_CodMedida, A.TU_CodMedida)					
END
GO
