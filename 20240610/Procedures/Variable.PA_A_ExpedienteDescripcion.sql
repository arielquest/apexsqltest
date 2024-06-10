SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Jore A. Harris R.>
-- Create date:					<02/06/2020>
-- Description:					<Traducción de la Variable del PJEditor Descripcion de la carpeta para LibreOffice>
--								226		A_Lugar				SELECT DESCRIP FROM DCAR WHERE CARPETA = '%Carpeta%'
--								826		A_NormasImpugnadas  SELECT dcar.DESCRIP FROM dcar WHERE (DCAR.CARPETA = '%Carpeta%')
--								1363	A_DescCarpeta       SELECT dcar.DESCRIP FROM dcar WHERE (DCAR.CARPETA = '%Carpeta%')
-- ====================================================================================================================================================================================
-- Modificación:				<20/01/2022> <Aida Elena Siles R> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_ExpedienteDescripcion]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4) 
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)     = @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
@L_Contexto             AS VARCHAR(4)   = @Contexto;

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT		A.TC_Descripcion				AS Descripcion
		FROM		Expediente.Expediente			A WITH(NOLOCK)
		WHERE		A.TC_NumeroExpediente			= @L_NumeroExpediente
		AND			A.TC_CodContexto				= @L_Contexto
	END
	ELSE
	BEGIN
		SELECT		A.TC_Descripcion				AS Descripcion
		FROM		Expediente.Legajo				A WITH(NOLOCK)
		WHERE		A.TU_CodLegajo					= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			A.TC_CodContexto				= @L_Contexto
	END

END
GO
