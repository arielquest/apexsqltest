SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Jorge A. Harris R.>
-- Create date:					<15/05/2020>
-- Description:					<Traducci¢n de las Variable del PJEditor relacionadas para Identificar el nombre del despacho para LibreOffice>
-- Modificacio:					<03/06/2021> <Miguel Avendaño> <Se modifica para que traiga el nombre del despacho del catalogo de contexto y no del de oficina>
-- ====================================================================================================================================================================================
-- Modificaci¢n:				<21/06/2021> <Isaac Santiago M‚ndez Castillo> <Se comprueba si el contexto es el mismo que la oficina y muestra £nicamente el nombre de la oficina
--																			   si son iguales. Si son diferentes muestra el nombre de la oficina y el contexto separados por
--																			   un gu¡on ( - )>
-- Modificaci¢n:				<30/07/2021> <Isaac Santiago M‚ndez Castillo> <Se cambia el orden en el cual aparece el despacho, si los despachos son iguales
--																			   se muestra el nombre del contexto y no de la oficina. Esto a solicitud del incidente 202980>
-- Moficiación:					<30/06/2023> <Gabriel Leandro Arnáez Hodgson> <Se elimina la validación y se muestra solo la descripción del contexto, incidente 363936>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_Despacho]
	@Contexto				As VarChar(4)
AS
BEGIN
	Declare		@L_Contexto             As VarChar(4)   = @Contexto;

	SELECT		TC_Descripcion
	FROM		Catalogo.Contexto
	WHERE		TC_CodContexto = @L_Contexto

END
SET ANSI_NULLS ON
GO
