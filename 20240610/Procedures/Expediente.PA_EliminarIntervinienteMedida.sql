SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<21/10/2022>
-- Descripción :			<Permite eliminar una medida asociada a una intervención>
-- ===========================================================================================
CREATE   PROCEDURE [Expediente].[PA_EliminarIntervinienteMedida]
	@CodMedida				UNIQUEIDENTIFIER
AS
BEGIN
	--Variables.
	DECLARE	@L_CodMedida	UNIQUEIDENTIFIER	=	@CodMedida
	BEGIN
		DELETE	
		FROM	[Expediente].[IntervinienteMedida]
		WHERE	[TU_CodMedida]		=	@L_CodMedida
	END 
END
GO
