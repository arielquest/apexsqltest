SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


       



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Kirvin Bennett Mathurin>
-- Fecha de creación:		<14/10/2021>
-- Descripción :			<Permite modificar los campos [TB_Leido] y [TF_FechaLeido] de la comunicación intervencion>
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ModificarComunicacionIntervencion]
	@CodigoComunicacion				uniqueidentifier,
	@CodigoInterviniente			uniqueidentifier,
	@Leido							bit,
	@FechaLeido						datetime2

As
BEGIN
	--Variables
	DECLARE	@L_TU_CodComunicacion		UNIQUEIDENTIFIER		= @CodigoComunicacion,
			@L_TU_CodInterviniente		UNIQUEIDENTIFIER		= @CodigoInterviniente,
			@L_TB_Leido					bit						= @Leido,
			@L_TF_FechaLeido			datetime2				= @FechaLeido

	Update	[Comunicacion].[ComunicacionIntervencion] 
	Set		[TB_Leido]					= @L_TB_Leido,
			[TF_FechaLeido]				= @L_TF_FechaLeido
	Where	TU_CodComunicacion			= @L_TU_CodComunicacion
	AND		TU_CodInterviniente			= @L_TU_CodInterviniente;
END

GO
