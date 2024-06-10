SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================================================================================
-- Autor:				<Xinia Soto V.>
-- Fecha Creación:		<11/11/2021>
-- Descripcion:			<Elimina el paso de un encadenamiento>
-- =========================================================================================================================================
-- Modificacion:        <21/04/2022><Jose Gabriel Cordero Soto><Se ajusta para eliminar los pasos de operacion, en caso de existir >
-- =========================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ElimininarPasosEncadenamientoFormatoJuridico] 
	@CodEncadenamiento	INT
AS
BEGIN

	--Variables locales
	DECLARE @L_CodEncadenamiento	INT			= @CodEncadenamiento

	IF EXISTS (SELECT COUNT(TN_CodEncadenamientoFormatoJuridico) FROM Catalogo.PasoEncadenamientoOperacionParametro WHERE TN_CodEncadenamientoFormatoJuridico = @L_CodEncadenamiento)
	BEGIN
		DELETE FROM Catalogo.PasoEncadenamientoOperacionParametro
		WHERE	    TN_CodEncadenamientoFormatoJuridico = @L_CodEncadenamiento 
	END

	--Aplicación de eliminación
	DELETE	FROM Catalogo.PasoEncadenamientoFormatoJuridico
	WHERE		 TN_CodEncadenamientoFormatoJuridico = @L_CodEncadenamiento 


END
GO
