SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<10/03/2020>
-- Descripción:			<Permite consultar un registro en la tabla: RechazoSolicitudDefensorInterviniente.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ConsultarRechazoSolicitudDefensorInterviniente]
	@CodSolicitudDefensor							UNIQUEIDENTIFIER = NULL,	
	@CodInterviniente								UNIQUEIDENTIFIER = NULL,	
	@CodTipoRechazoSolicitudDefensor				SMALLINT = NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodSolicitudDefensor				UNIQUEIDENTIFIER		= @CodSolicitudDefensor,
			@L_TU_CodInterviniente					UNIQUEIDENTIFIER		= @CodInterviniente,
			@L_TN_CodTipoRechazoSolicitudDefensor	SMALLINT				= @CodTipoRechazoSolicitudDefensor

	--Lógica
	SELECT	A.TC_Observaciones		Observaciones,
			A.TF_FechaCreacion		FechaCreacion
			
	FROM	DefensaPublica.RechazoSolicitudDefensorInterviniente		A WITH (NOLOCK)

	WHERE	TU_CodSolicitudDefensor					= COALESCE(@L_TU_CodSolicitudDefensor, A.TU_CodSolicitudDefensor)
	AND		TU_CodInterviniente						= COALESCE(@L_TU_CodInterviniente, A.TU_CodInterviniente)
	AND		TN_CodTipoRechazoSolicitudDefensor		= COALESCE(@L_TN_CodTipoRechazoSolicitudDefensor, A.TN_CodTipoRechazoSolicitudDefensor)
END
GO
