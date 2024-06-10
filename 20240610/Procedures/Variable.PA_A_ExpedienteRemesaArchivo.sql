SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Jore A. Harris R.>
-- Create date:					<02/06/2020>
-- Description:					<Traducción de la Variable del PJEditor Descripcion de la carpeta para LibreOffice>
--								71	A_Remesa SELECT SUBSTRING(Descrip, CHARINDEX('Remesa:', Descrip) + 8, CHARINDEX('Archivo:', Descrip) - CHARINDEX('Remesa:', Descrip) - 10) FROM DCAR WHERE CARPETA = '%Carpeta%'
--								345 A_Archivo SELECT SUBSTRING(Descrip, CHARINDEX('Archivo:', Descrip) + 9, 6) FROM DCAR WHERE CARPETA = '%Carpeta%'
--								<El parametro @Retorno debe recibir dos valores: <R> para remesa y <A> para archivo, si recibe otro valor devuelve NULO >
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_ExpedienteRemesaArchivo]                 
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4),
	@Retorno				As Varchar(1)			
AS
BEGIN
	Declare		@L_NumeroExpediente     As Char(14)     = @NumeroExpediente,
				@L_Contexto             As VarChar(4)   = @Contexto,
				@L_Retorno				As Varchar(1)	= UPPER(@Retorno),
				@L_Descripcion		    As Varchar(255) ='';

	SELECT	 	@L_Descripcion					= A.TC_Descripcion
	FROM		Expediente.Expediente			A With(NoLock)
	WHERE		A.TC_NumeroExpediente			= @L_NumeroExpediente
	AND			A.TC_CodContexto				= @L_Contexto

	IF @L_Retorno NOT IN ('A','R') SET @L_Descripcion=NULL
	IF @L_Retorno='A'
	BEGIN
		IF	CHARINDEX('Archivo',@L_Descripcion) = 0 SET @L_Retorno=NULL

		IF	CHARINDEX('Archivo',@L_Descripcion) > 0 
			BEGIN
				SELECT @L_Descripcion= SUBSTRING( @L_Descripcion,
                   CHARINDEX('ARCHIVO', @L_Descripcion) + 7,
                   PATINDEX('%[0-9]%',@L_Descripcion)                   )
			END
	END
	IF @L_Retorno='R'
	BEGIN
		IF	CHARINDEX('Remesa',@L_Descripcion) = 0 OR 
			CHARINDEX('Archivo',@L_Descripcion) = 0 SET @L_Retorno=NULL

		IF	CHARINDEX('Remesa',@L_Descripcion) > 0 AND
			CHARINDEX('Archivo',@L_Descripcion) > 0 
			BEGIN
				SELECT @L_Descripcion= SUBSTRING(
                 @L_Descripcion,
                 PATINDEX('%[0-9]%', @L_Descripcion),
                 CHARINDEX('ARCHIVO', @L_Descripcion) - 
				 PATINDEX('%[0-9]%', @L_Descripcion))
			END
	END
	SELECT @L_Descripcion AS ValorRetornado
END
GO
