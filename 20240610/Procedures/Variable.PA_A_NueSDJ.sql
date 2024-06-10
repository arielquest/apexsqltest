SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño.>
-- Create date:					<22/05/2020>
-- Description:					<Traducción de las Variable del PJEditor relacionadas para obtener el digito verificador del SDJ>
-- NOTA:	Como parametro para formato de salida usar los siguientes valores
--			1. NUE + Digito Verificador
--			2. Digito verificador
-- <Modificacion> <09/06/2021> <Jose Miguel Avendaño Rosales> <Se modifica para que no de problemas al retornar el resultado cuando el FormatoSalida es 2>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_NueSDJ]
	@NumeroExpediente		As Char(14),
	@FormatoSalida			As Char(1)
AS
BEGIN
	DECLARE		@L_NumeroExpediente     As Char(14)     = @NumeroExpediente,
				@L_NueNumerico          As VarChar(12)  = '',
				@L_Valor				As Integer		= 0,
				@L_Indice				As Integer		= 13,
				@L_Contador				As Integer		= 1,
				@L_FormatoSalida		As Char(1)		= @FormatoSalida;

	SET			@L_NueNumerico 			= SUBSTRING(@L_NumeroExpediente, 1, 12);

	WHILE		@L_Contador < LEN(@L_NueNumerico) + 1
	BEGIN
				SET		@L_Valor	= @L_Valor + (@L_Indice * (SUBSTRING(@L_NueNumerico, @L_Contador, 1)));
				SET		@L_Contador = @L_Contador + 1;
				SET		@L_Indice	= @L_Indice - 1;
	END;

	SET			@L_Valor			= 11 - (SELECT @L_Valor % 11);

	If			@L_Valor > 9
				SET @L_Valor = 0


	SELECT		CASE
					When @L_FormatoSalida = '1' Then CONCAT(@L_NueNumerico, '-', @L_Valor)
					When @L_FormatoSalida = '2' Then CONVERT(VarChar(7), @L_Valor)
				End As DigitoSDJ
END
GO
