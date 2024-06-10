SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================================================================================
-- Autor:				<Mario Camacho Flores>
-- Fecha Creación:		<29/05/2023>
-- Descripcion:			<Consulta de seguimientos>
-- ======================================================================================================================================================
	
CREATE   PROCEDURE [Expediente].[PA_ConsultarSeguimientos]
	@CodInstitucion				UNIQUEIDENTIFIER,
	@ConsecutivoComunicacion	VARCHAR(35),
	@Expediente					VARCHAR(20),
	@CodContexto				VARCHAR(4),
	@CodMateria					VARCHAR(5),
	@CodTipoOficina				SMALLINT
AS
	DECLARE 
	@L_CodInstitucion			UNIQUEIDENTIFIER = @CodInstitucion,
	@L_ConsecutivoComunicacion	VARCHAR(35) = @ConsecutivoComunicacion,
	@L_Expediente				VARCHAR(20) = @Expediente,
	@L_CodContexto				VARCHAR(4) = @CodContexto,
	@L_CodMateria				VARCHAR(5) = @CodMateria,
	@L_CodTipoOficina			SMALLINT = @CodTipoOficina

BEGIN

	IF @L_CodInstitucion IS NULL AND @L_ConsecutivoComunicacion IS NULL AND @L_Expediente IS NULL
	BEGIN
		SELECT	S.TU_CodSeguimiento					AS Codigo,	
				S.TF_FechaRegistro					AS FechaRegistro,
				S.TN_Plazo							AS Plazo,
				S.TF_FechaVencimiento				AS FechaVencimiento,
				'splitInstitucion'					AS splitInstitucion,
				I.TC_Descripcion					AS Descripcion,
				I.TU_CodInstitucion					AS Codigo,
				I.TC_Siglas							AS Siglas,
				'splitExpediente'					AS splitExpediente,
				S.TC_NumeroExpediente				AS Numero,
				'splitComunicacion'					AS splitComunicacion,
				NULL								As ConsecutivoComunicacion
		FROM [Expediente].[Seguimiento]				AS S WITH(NOLOCK)
		INNER JOIN [Catalogo].[Institucion]			AS I WITH(NOLOCK) 
		ON I.TU_CodInstitucion						= S.TU_CodInstitucion
		WHERE S.TN_Estado							= 1
		  AND S.TC_CodContexto						= @L_CodContexto
		  AND S.TC_CodMateria						= @L_CodMateria
		  AND S.TN_CodTipoOficina					= @L_CodTipoOficina
		UNION
		SELECT	S.TU_CodSeguimiento					AS Codigo,
				S.TF_FechaRegistro					AS FechaRegistro,
				S.TN_Plazo							AS Plazo,
				S.TF_FechaVencimiento				AS FechaVencimiento,
				'splitInstitucion'					AS splitInstitucion,
				NULL								AS Descripcion,
				NULL								AS Codigo,
				NULL								AS Siglas,
				'splitExpediente'					AS splitExpediente,
				S.TC_NumeroExpediente				AS Numero,
				'splitComunicacion'					AS splitComunicacion,
				C.TC_ConsecutivoComunicacion		As ConsecutivoComunicacion
		FROM [Expediente].[Seguimiento]				AS S WITH(NOLOCK)	
		INNER JOIN Comunicacion.Comunicacion		AS C WITH(NOLOCK)
		ON C.TU_CodComunicacion						= S.TU_CodComunicacion
		WHERE S.TN_Estado							= 1
		AND S.TC_CodContexto						= @L_CodContexto
		AND S.TC_CodMateria							= @L_CodMateria
		AND S.TN_CodTipoOficina						= @L_CodTipoOficina
		ORDER BY S.TF_FechaRegistro					DESC	
	END
	ELSE IF @L_CodInstitucion IS NOT NULL AND @L_ConsecutivoComunicacion IS NULL AND @L_Expediente IS NULL
	BEGIN
		SELECT 	S.TU_CodSeguimiento					AS Codigo,
				S.TF_FechaRegistro					AS FechaRegistro,
				S.TN_Plazo							AS Plazo,
				S.TF_FechaVencimiento				AS FechaVencimiento,
				'splitInstitucion'					AS splitInstitucion,
				I.TC_Descripcion					AS Descripcion,
				I.TU_CodInstitucion					AS Codigo,
				I.TC_Siglas							AS Siglas,
				'splitExpediente'					AS splitExpediente,
				S.TC_NumeroExpediente				AS Numero,
				'splitComunicacion'					AS splitComunicacion,
				NULL								As ConsecutivoComunicacion
		FROM [Expediente].[Seguimiento]				AS S WITH(NOLOCK)
		INNER JOIN [Catalogo].[Institucion]			AS I WITH(NOLOCK) 
		ON I.TU_CodInstitucion						= S.TU_CodInstitucion
		WHERE S.TN_Estado							= 1
		AND S.TU_CodInstitucion						= @L_CodInstitucion
		AND S.TC_CodContexto						= @L_CodContexto
		AND S.TC_CodMateria							= @L_CodMateria
	    AND S.TN_CodTipoOficina						= @L_CodTipoOficina

	END
	ELSE IF @L_CodInstitucion IS NULL AND @L_ConsecutivoComunicacion IS NOT NULL AND @L_Expediente IS NULL
	BEGIN
		SELECT	S.TU_CodSeguimiento					AS Codigo,
				S.TF_FechaRegistro					AS FechaRegistro,
				S.TN_Plazo							AS Plazo,
				S.TF_FechaVencimiento				AS FechaVencimiento,
				'splitInstitucion'					AS splitInstitucion,
				NULL								AS Descripcion,
				NULL								AS Codigo,
				NULL								AS Siglas,
				'splitExpediente'					AS splitExpediente,
				S.TC_NumeroExpediente				AS Numero,
				'splitComunicacion'					AS splitComunicacion,
				C.TC_ConsecutivoComunicacion		As ConsecutivoComunicacion
		FROM [Expediente].[Seguimiento]				AS S WITH(NOLOCK)	
		INNER JOIN Comunicacion.Comunicacion		AS C WITH(NOLOCK)
		ON C.TU_CodComunicacion						= S.TU_CodComunicacion
		WHERE S.TN_Estado							= 1
		AND C.TC_ConsecutivoComunicacion			= @L_ConsecutivoComunicacion
		AND S.TC_CodContexto						= @L_CodContexto
		AND S.TC_CodMateria							= @L_CodMateria
		AND S.TN_CodTipoOficina						= @L_CodTipoOficina
		ORDER BY S.TF_FechaRegistro					DESC
	END
	ELSE IF @L_CodInstitucion IS NULL AND @L_ConsecutivoComunicacion IS NULL AND @L_Expediente IS NOT NULL
	BEGIN 
		SELECT	S.TU_CodSeguimiento					AS Codigo,
				S.TF_FechaRegistro					AS FechaRegistro,
				S.TN_Plazo							AS Plazo,
				S.TF_FechaVencimiento				AS FechaVencimiento,
				'splitInstitucion'					AS splitInstitucion,
				I.TC_Descripcion					AS Descripcion,
				I.TU_CodInstitucion					AS Codigo,
				I.TC_Siglas							AS Siglas,
				'splitExpediente'					AS splitExpediente,
				S.TC_NumeroExpediente				AS Numero,
				'splitComunicacion'					AS splitComunicacion,
				NULL								As ConsecutivoComunicacion
		FROM [Expediente].[Seguimiento]				AS S WITH(NOLOCK)
		INNER JOIN [Catalogo].[Institucion]			AS I WITH(NOLOCK) 
		ON I.TU_CodInstitucion						= S.TU_CodInstitucion
		WHERE S.TN_Estado							= 1
		AND S.TC_NumeroExpediente					= @L_Expediente
		AND S.TC_CodContexto						= @L_CodContexto
		AND S.TC_CodMateria							= @L_CodMateria
		AND S.TN_CodTipoOficina						= @L_CodTipoOficina
		UNION
		SELECT	S.TU_CodSeguimiento					AS Codigo,
				S.TF_FechaRegistro					AS FechaRegistro,
				S.TN_Plazo							AS Plazo,
				S.TF_FechaVencimiento				AS FechaVencimiento,
				'splitInstitucion'					AS splitInstitucion,
				NULL								AS Descripcion,
				NULL								AS Codigo,
				NULL								AS Siglas,
				'splitExpediente'					AS splitExpediente,
				S.TC_NumeroExpediente				AS Numero,
				'splitComunicacion'					AS splitComunicacion,
				C.TC_ConsecutivoComunicacion		As ConsecutivoComunicacion
		FROM [Expediente].[Seguimiento]				AS S WITH(NOLOCK)	
		INNER JOIN Comunicacion.Comunicacion		AS C WITH(NOLOCK)
		ON C.TU_CodComunicacion						= S.TU_CodComunicacion
		WHERE S.TN_Estado							= 1
		AND S.TC_NumeroExpediente					= @L_Expediente
		AND S.TC_CodContexto						= @L_CodContexto
		AND S.TC_CodMateria							= @L_CodMateria
		AND S.TN_CodTipoOficina						= @L_CodTipoOficina
		ORDER BY S.TF_FechaRegistro					DESC
	END
END;
GO
