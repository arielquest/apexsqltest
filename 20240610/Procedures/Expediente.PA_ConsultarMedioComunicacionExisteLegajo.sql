SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<17/09/2019>
-- Descripción :			<Permite consultar si un medio de comunicacion existe en un legajo.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarMedioComunicacionExisteLegajo]
	@CodigoMedioComunicacion	uniqueidentifier	= Null
AS
BEGIN

	SELECT		COUNT (B.TU_CodMedioComunicacion)	
	FROM		Expediente.IntervencionMedioComunicacion		As A With(NoLock)
	Inner Join	Expediente.IntervencionMedioComunicacionLegajo	As B With(NoLock)
	On			A.TU_CodMedioComunicacion						= B.TU_CodMedioComunicacion
	WHERE		B.TU_CodMedioComunicacion						= @CodigoMedioComunicacion
		
END

GO
