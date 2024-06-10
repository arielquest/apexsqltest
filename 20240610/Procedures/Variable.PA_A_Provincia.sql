SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:                      <Fabian Sequeira>
-- Create date:                 <10/06/2021>
-- Description:                 <Traducción de las Variable del PJEditor relacionadas para la provinicia para un contexto para LibreOffice>
-- ====================================================================================================================================================================================
-- Modificación:				<21/06/2021> <Isaac Santiago Méndez Castillo> <Se comprueba si la descripción del cantón es el mismo que la descripción del distrito.
--																			   Si estas son iguales, solo se muestra el distrito.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_Provincia]
    @Contexto                As VarChar(4)
AS
BEGIN
    Declare        @L_Contexto             As VarChar(4)   = @Contexto;


	Select CONCAT(B.TC_Descripcion, ', ',D.TC_Descripcion,(CASE WHEN D.TC_Descripcion = C.TC_Descripcion THEN '' ELSE CONCAT(' de ' , C.TC_Descripcion) END))
	From			Catalogo.Contexto       A	With(NoLock)
	INNER JOIN		Catalogo.Provincia		B 	With(NoLock)
	ON				A.TN_CodProvincia		=	B.TN_CodProvincia
	INNER JOIN		Catalogo.Canton			C 	With(NoLock)
	ON				A.TN_CodCanton			=	C.TN_CodCanton
	AND				B.TN_CodProvincia		=	C.TN_CodProvincia
	INNER JOIN		Catalogo.Distrito		D 	With(NoLock) 
	On				A.TN_CodDistrito		=	D.TN_CodDistrito
	AND				A.TN_CodCanton			=	D.TN_CodCanton
	AND				A.TN_CodProvincia		=	D.TN_CodProvincia
	WHERE           TC_CodContexto          =   @L_Contexto

END
GO
