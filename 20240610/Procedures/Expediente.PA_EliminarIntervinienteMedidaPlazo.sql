SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<21/10/2022>
-- Descripción :			<Permite eliminar los plazos asociados a una medida de una intervención>
-- ===========================================================================================
CREATE   PROCEDURE [Expediente].[PA_EliminarIntervinienteMedidaPlazo]
	@CodMedida				UNIQUEIDENTIFIER
AS
BEGIN
	--Variables.
	DECLARE	@L_CodMedida	UNIQUEIDENTIFIER	=	@CodMedida
	BEGIN
		DELETE	
		FROM	[Expediente].[IntervinienteMedidaPlazo]
		WHERE	[TU_CodMedida]		=	@L_CodMedida
	END 
END
GO
