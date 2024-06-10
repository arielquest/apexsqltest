SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================================================================================
-- Versión:				<1.0>	
-- Autor:				<Isaac Dobles Mata.>
-- Fecha Creación:		<05/05/2022>
-- Descripcion:			<Elimina todas los valores de parámetros de operaciones en un encadenamiento>
-- =========================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarPasoEncadenamientoOperacionParametro] 
	@CodEncadenamientoFormatoJuridico			SMALLINT,
	@Orden										SMALLINT
AS
BEGIN

	--Variables locales
	DECLARE	@L_CodEncadenamientoFormatoJuridico		SMALLINT	=	@CodEncadenamientoFormatoJuridico,
			@L_Orden								SMALLINT	=	@Orden


	--Aplicación del update
	DELETE FROM	[Catalogo].[PasoEncadenamientoOperacionParametro]
	WHERE	[TN_CodEncadenamientoFormatoJuridico]		=	@L_CodEncadenamientoFormatoJuridico
	AND		[TN_Orden]									=	@L_Orden

END


GO
