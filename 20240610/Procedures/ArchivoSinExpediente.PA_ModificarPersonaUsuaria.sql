SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<13/11/2018>
-- Descripción :			<Permite modificar la persona usuaria de un documento sin expediente> 
-- =================================================================================================================================================

CREATE PROCEDURE [ArchivoSinExpediente].[PA_ModificarPersonaUsuaria]
	@CodArchivo				uniqueidentifier,
	@CodTipoIdentificacion	smallint,
	@Identificacion			varchar(21),
	@TipoFirma				char(1)
AS  
BEGIN  
	UPDATE	ArchivoSinExpediente.PersonaUsuaria
	SET
		[TC_TipoFirma] = @TipoFirma
	WHERE
		[TU_CodArchivo] = @CodArchivo
		AND	[TN_CodTipoIdentificacion]	=	@CodTipoIdentificacion
		AND [TC_Identificacion]			=	@Identificacion
END
GO
