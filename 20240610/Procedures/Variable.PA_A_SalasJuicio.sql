SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<09/09/2020>
-- Description:					<Traducción de las Variable del PJEditor para obtener la lista de salas de juicio>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_SalasJuicio]
	@Contexto				As VarChar(4)
AS
BEGIN
	Declare		@L_Contexto             As VarChar(4)   = @Contexto
	
	Select		C.TC_Descripcion
	From		Catalogo.Contexto		A With(NoLock)
	Inner Join	Catalogo.Oficina		B With(NoLock)
	On			A.TC_CodOficina			= B.TC_CodOficina
	And			A.TC_CodContexto		= @L_Contexto
	Inner Join	Catalogo.SalaJuicio		C With(NoLock)
	On			B.TN_CodCircuito		= C.TN_CodCircuito
END
GO
