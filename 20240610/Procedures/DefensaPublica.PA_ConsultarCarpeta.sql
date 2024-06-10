SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles Rojas>
-- Fecha de creación:	<13/11/2019>
-- Descripción:			<Permite consultar un registro en la tabla: Carpeta.>
-- ==================================================================================================================================================================================
-- Modificación:		<07/04/2021> <Aida Elena Siles R> <Se agrega el tipo de caso a la consulta>
-- ==================================================================================================================================================================================
-- Modificación:		<08/07/2021> <Josué Quirós Batista> <Se agrega la consulta de las observaciones de la carpeta a la consulta.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [DefensaPublica].[PA_ConsultarCarpeta]
	@TC_NRD					VARCHAR(14) = NULL,
	@TC_NumeroExpediente	CHAR(14)	= NULL,
	@TC_CodContexto			VARCHAR(4)
AS
BEGIN
	--Variables
	DECLARE	@L_TC_NRD				VARCHAR(14)	= @TC_NRD,
			@L_TC_NumeroExpediente	CHAR(14)	= @TC_NumeroExpediente,
			@L_TC_CodContexto		VARCHAR(4)	= @TC_CodContexto

	--Lógica
	IF(@L_TC_NRD IS NULL)
		BEGIN
			SELECT		A.TC_NRD					AS	NRD,
						A.TC_NumeroExpediente		AS	NumeroExpediente,
						A.TF_Creacion				AS	FechaCreacion,
						A.TC_Observaciones          As  Observaciones,
						'Split'						AS	Split,
						B.TC_CodContexto			AS	CodigoContexto,
						B.TC_Descripcion			AS	ContextoDescrip,
						C.TN_CodTipoCaso			AS	CodigoTipoCaso,
						C.TC_Descripcion			AS  TipoCasoDescrip,
						A.TC_Observaciones          As  Observaciones
			FROM		DefensaPublica.Carpeta		A	WITH(NOLOCK)
			INNER JOIN	Catalogo.Contexto			B	WITH(NOLOCK)
			ON			A.TC_CodContexto			=	B.TC_CodContexto
			INNER JOIN	Catalogo.TipoCaso			C	WITH(NOLOCK)
			ON			A.TN_CodTipoCaso			=	C.TN_CodTipoCaso
			WHERE		A.TC_NumeroExpediente		=	@L_TC_NumeroExpediente
			AND			A.TC_CodContexto			=	@L_TC_CodContexto
		END		
	ELSE
		BEGIN
			SELECT		A.TC_NRD					AS	NRD,
						A.TC_NumeroExpediente		AS	NumeroExpediente,
						A.TF_Creacion				AS	FechaCreacion,
						A.TC_Observaciones          As  Observaciones,
						'Split'						AS	Split,
						B.TC_CodContexto			AS	CodigoContexto,
						B.TC_Descripcion			AS	ContextoDescrip,
						C.TN_CodTipoCaso			AS	CodigoTipoCaso,
						C.TC_Descripcion			AS  TipoCasoDescrip
			FROM		DefensaPublica.Carpeta		A	WITH(NOLOCK)
			INNER JOIN	Catalogo.Contexto			B	WITH(NOLOCK)
			ON			A.TC_CodContexto			=	B.TC_CodContexto
			INNER JOIN	Catalogo.TipoCaso			C	WITH(NOLOCK)
			ON			A.TN_CodTipoCaso			=	C.TN_CodTipoCaso
			WHERE		A.TC_NRD					=	@L_TC_NRD
			AND			A.TC_CodContexto			=	@L_TC_CodContexto
		END 
END
GO
