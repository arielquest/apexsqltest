SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan  Manuel Acosta Ibañez>
-- Fecha de creación:	<22/04/2021>
-- Descripción:			<Permite Consultar los registros en la tabla: RepartoEvento.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Historico].[PA_ConsultarRepartoEvento]
	@CodContexto				VARCHAR(4),
	@CodPuestoTrabajo			VARCHAR(14) = NULL
AS
BEGIN

	--Variables
	DECLARE			@L_TC_CodContexto		            VARCHAR(4)		    = @CodContexto,
					@L_TC_CodPuestoTrabajo				VARCHAR(14)			= @CodPuestoTrabajo

	SELECT 	TN_CantidadCitas			As	CantidadCitas, 
			TF_Actualizacion			As	Actualizacion,
			'SplitContexto'				As	SplitContexto,
			TC_CodContexto				As	Codigo,
			'SplitPuestoTrabajo'		As	SplitPuestoTrabajo,
			TC_CodPuestoTrabajo			As	Codigo
	FROM	[Historico].[RepartoEvento]	WITH(NOLOCK)
	WHERE	TC_CodContexto				=	@L_TC_CodContexto
	AND		TC_CodPuestoTrabajo			=	COALESCE(@CodPuestoTrabajo, TC_CodPuestoTrabajo)
END
GO
