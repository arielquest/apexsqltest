SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<17/09/2019>
-- Descripción :			<Permite eliminar lógicamente un medio de comunicacion del interviniente.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarIntervinienteMedioComunicacionLogico] 
	@CodMedioComunicacion	uniqueidentifier
AS
BEGIN
	UPDATE	Expediente.IntervencionMedioComunicacion
	SET		TB_PerteneceExpediente						=	0
	WHERE	TU_CodMedioComunicacion						=	@CodMedioComunicacion;
END
GO
