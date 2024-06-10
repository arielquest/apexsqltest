SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de creación:	<19/07/2021>
-- Descripción:			<Permite modificar un registro en la tabla: CriterioRepartoManual.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarCriterioRepartoManual]
	@CodCriterioRepartoManual		INT,
	@Descripcion					VARCHAR(200),
	@FechaVencimiento				DATETIME2(3)	= Null
AS
BEGIN
	--Variables.
	DECLARE	@L_TN_CodCriterioRepartoManual		INT				= @CodCriterioRepartoManual,
			@L_TC_Descripcion					VARCHAR(120)	= @Descripcion,
			@L_TF_Fin_Vigencia					DATETIME2(3)	= @FechaVencimiento
	--Lógica.
	UPDATE	Catalogo.CriterioRepartoManual		WITH(ROWLOCK)
	SET		TC_Descripcion						= @L_TC_Descripcion,
			TF_Fin_Vigencia						= @L_TF_Fin_Vigencia
	WHERE	TN_CodCriterioRepartoManual			= @L_TN_CodCriterioRepartoManual
END
GO
