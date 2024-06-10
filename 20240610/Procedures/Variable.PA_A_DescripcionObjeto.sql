SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<08/06/2020>
-- Description:					<Traducción de la Variable del PJEditor A_DescripObj para LibreOffice>
-- ====================================================================================================================================================================================
-- NOTA:						<27/05/2020> <El parametro @Salida debe recibir los siguientes valores:>
--											 <1: Muestra Descripcion>
--											 <2: Muestra Referencia>
--											 <3: Muestra Referencia + Descripcion>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_DescripcionObjeto]                 
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4),
	@Salida					As Char(1)
AS
BEGIN
	Declare		@L_NumeroExpediente     As Char(14)     = @NumeroExpediente,
				@L_Contexto             As VarChar(4)   = @Contexto,
				@L_Salida				As Char(1)		= @Salida;
	
	SELECT		CASE 
					WHEN @L_Salida='1' THEN A.TC_Observacion
					WHEN @L_Salida='2' THEN A.TC_Descripcion
					WHEN @L_Salida='3' THEN CONCAT(A.TC_Descripcion, ': ', A.TC_Observacion)
				END As Descripcion
	FROM		Objeto.Objeto						A With(NoLock)
	LEFT JOIN	Expediente.ExpedienteDetalle		G With(NoLock) 
	ON			A.TC_NumeroExpediente				= G.TC_NumeroExpediente  
	WHERE		G.TC_NumeroExpediente				= @L_NumeroExpediente
	AND			G.TC_CodContexto					= @L_Contexto				
END
GO
