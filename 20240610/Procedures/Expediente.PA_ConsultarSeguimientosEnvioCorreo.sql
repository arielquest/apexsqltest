SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Version:					<1.0>
-- Creado por:				<Mario Camacho Flores>
-- Fecha de creacion:		<06/09/2023>
-- Descripcion :			<Permite consultar los seguimientos para envio de correo electronico.>
-- =================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_ConsultarSeguimientosEnvioCorreo]
AS  
BEGIN     
	SELECT	TC_NumeroExpediente					AS NumeroExpediente,
			ISNULL(i.TC_Descripcion,'OCJ')		AS NombreInstitucion,
			S.TF_FechaRegistro					AS FechaEnvio, 
			TF_FechaVencimiento					AS FechaVencimiento,
			CASE 
				WHEN s.TC_TipoEnvio				= 'CO' THEN 'Correo electrónico'
				WHEN s.TC_TipoEnvio				= 'MN' THEN 'Manual'
				WHEN s.TC_TipoEnvio				= 'CM' THEN 'OCJ'
			END									AS MedioNotificacion,
			CVC.TC_Valor						AS CorreoDestinatario
	FROM Expediente.Seguimiento					AS S
	LEFT JOIN Catalogo.Institucion				AS I
		ON S.TU_CodInstitucion 					= I.TU_CodInstitucion
	INNER JOIN (SELECT TC_Valor,TC_CodContexto FROM Configuracion.ConfiguracionValor WHERE TC_CodConfiguracion = 'U_CorreoEnvioSeguimientos') AS CVC
		ON S.TC_CodContexto						= CVC.TC_CodContexto
	INNER JOIN (SELECT TC_Valor,TC_CodContexto FROM Configuracion.ConfiguracionValor WHERE TC_CodConfiguracion = 'U_PlazoSeguimientoAntVencer') AS CVP
		ON S.TC_CodContexto						= CVC.TC_CodContexto
	WHERE CONVERT(DATE,TF_FechaVencimiento,103)	= DATEADD (DAY, CAST(CVP.TC_Valor AS NUMERIC), CONVERT(DATE, GETDATE(), 103)) 
		AND S.TN_Estado	= 1
		AND CVC.TC_CodContexto = S.TC_CodContexto
		AND CVP.TC_CodContexto = S.TC_CodContexto
	ORDER BY CVC.TC_CodContexto, S.TC_NumeroExpediente, i.TC_Descripcion 
END
GO
