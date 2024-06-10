SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<21/10/2022>
-- Descripción :			<Permite eliminar las resoluciones asociadas a una medida de una intervención>
-- ===========================================================================================
CREATE   PROCEDURE [Expediente].[PA_EliminarIntervinienteMedidaResolucion]
	@CodMedida				UNIQUEIDENTIFIER
AS
BEGIN
	--Variables.
	DECLARE	@L_CodMedida	UNIQUEIDENTIFIER	=	@CodMedida
	BEGIN
		DELETE	
		FROM	[Expediente].[IntervinienteMedidaResolucion]
		WHERE	[TU_CodMedida]		=	@L_CodMedida
	END 
END
GO
