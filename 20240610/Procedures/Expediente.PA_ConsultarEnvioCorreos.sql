SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Creado por:				<Jose Miguel Avendaño Rosales>
-- Fecha de creación:		<12/10/2021>
-- Descripción :			<Permite Consultar los correos enviados de un expediente o legajo>
-- =================================================================================================================================================
-- Modificación:			<13/10/2021><Karol Jiménez Sánchez><Se agrega búsqueda por CodEnvioCorreo.>
-- Modificación:			<15/10/2021><Miguel Avendaño Rosales><Se retorna CodPuestoTrabajo, UsuarioRed, CodContexto y CodTipoOficina cuando se consulta por un envio de correo especifico>
-- Modificación:			<18/10/2021><Karol Jiménez Sánchez><Se agrega consulta de expediente y legajo>
-- Modificación:			<20/10/2021><Jose Miguel Avendaño Rosales><Se modifica para que devuelva tambien el mensaje de error de envio>
-- Modificación:			<21/10/2021><Karol Jiménez Sánchez><Se agrega consulta de contexto envío>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarEnvioCorreos]
	@NumeroExpediente	VarChar(14),
	@CodigoLegajo		uniqueidentifier = NULL,
	@Codigo				uniqueidentifier = NULL
AS
BEGIN
	--Variables
	DECLARE			@L_CodigoLegajo				uniqueidentifier	= @CodigoLegajo;
	DECLARE			@L_NumeroExpediente			VarChar(14)			= @NumeroExpediente;
	DECLARE			@L_Codigo					uniqueidentifier	= @Codigo;
	
	IF (@Codigo IS NULL)
	BEGIN
		SELECT	A.TU_CodEnvioCorreo				Codigo,
				A.TC_CorreoPara					CorreoPara,
				A.TC_CorreosCopia				CorreosCopia,
				A.TC_Asunto						Asunto,
				A.TB_IncluirDatosGenerales		IncluirDatosGenerales,
				A.TB_IncluirIntervenciones		IncluirIntervenciones,
				A.TB_IncluirNotificaciones		IncluirNotificaciones,
				A.TB_IncluirDocumentosEscritos	IncluirDocumentosEscritos,
				A.TC_Mensaje					Mensaje,
				A.TF_FechaEnvio					FechaEnvio,
				A.TF_FechaRecepcion				FechaRecepcion,
				A.TC_MensajeErrorEnvio			MensajeErrorEnvio,
				'Split'							Split,
				A.TC_Estado						Estado,
				A.TU_CodLegajo					CodigoLegajo,
				'Split'							Split,
				'Split'							Split,
				'Split'							Split,
				A.TC_CodContexto				Codigo,
				'Split'							Split,
				'Split'							Split,
				A.TC_NumeroExpediente			Numero
		FROM	Expediente.EnvioCorreo			A WITH(NOLOCK)
		WHERE	A.TC_NumeroExpediente			= @L_NumeroExpediente
		AND		( (@L_CodigoLegajo				IS NULL 
					AND A.TU_CodLegajo			IS NULL)
				OR 
					(@L_CodigoLegajo			IS NOT NULL
					AND	A.TU_CodLegajo			= @L_CodigoLegajo)
				)
	END
	ELSE
	BEGIN
		SELECT		A.TU_CodEnvioCorreo				Codigo,
					A.TC_CorreoPara					CorreoPara,
					A.TC_CorreosCopia				CorreosCopia,
					A.TC_Asunto						Asunto,
					A.TB_IncluirDatosGenerales		IncluirDatosGenerales,
					A.TB_IncluirIntervenciones		IncluirIntervenciones,
					A.TB_IncluirNotificaciones		IncluirNotificaciones,
					A.TB_IncluirDocumentosEscritos	IncluirDocumentosEscritos,
					A.TC_Mensaje					Mensaje,
					A.TF_FechaEnvio					FechaEnvio,
					A.TF_FechaRecepcion				FechaRecepcion,
					A.TC_MensajeErrorEnvio			MensajeErrorEnvio,
					'Split'							Split,
					A.TC_Estado						Estado,
					A.TU_CodLegajo					CodigoLegajo,
					'Split'							Split,
					A.TC_CodPuestoTrabajo			Codigo,
					'Split'							Split,
					A.TC_UsuarioRed					UsuarioRed,
					'Split'							Split,
					A.TC_CodContexto				Codigo,
					'Split'							Split,
					E.TN_CodTipoOficina				Codigo,
					'Split'							Split,
					A.TC_NumeroExpediente			Numero
		FROM		Expediente.EnvioCorreo			A WITH(NOLOCK)
		LEFT JOIN	Catalogo.Contexto				D WITH(NOLOCK)
		ON			D.TC_CodContexto				= A.TC_CodContexto
		LEFT JOIN	Catalogo.Oficina				E WITH(NOLOCK)
		ON			E.TC_CodOficina					= D.TC_CodOficina
		WHERE		A.TU_CodEnvioCorreo				= @L_Codigo
	END
END
GO
