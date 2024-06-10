SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================================================
--	Autor:				<Isaac Dobles Mata> 
--	Fecha Creación:		<21/06/2022> 
--	Descripcion:		<Consultar pasos de encadenamientos de trámites>
-- =========================================================================================================================================
--	Modifica:<Rafa Badilla Alvarado> Fecha Creación:<15/07/2022> Descripcion:<Incluir código de pantalla relacionado al paso>
-- =========================================================================================================================================

CREATE    PROCEDURE [Catalogo].[PA_ConsultarEncadenamientoTramitePaso] 
	@CodEncadenamientoTramite			uniqueidentifier
AS
BEGIN

	-- Variables locales
	DECLARE @L_CodEncadenamientoTramite			Varchar(500)		= @CodEncadenamientoTramite

	SELECT  P.TN_Orden								Orden,
			P.TF_Actualizacion						FechaActualizacion,
			P.[TU_CodEncadenamientoTramitePaso]     Codigo,
			'Split'									Split,
			E.TU_CodEncadenamientoTramite			Codigo,
			E.TF_Actualizacion						FechaActualizacion,
			'Split'									Split,
			O.TN_CodOperacionTramite				Codigo,
			O.TC_Descripcion						Descripcion,
			O.TC_Nombre								Nombre,
			O.TN_Pantalla							Pantalla
	FROM	Catalogo.EncadenamientoTramitePaso			P	WITH(NOLOCK)
			INNER JOIN
			Catalogo.EncadenamientoTramite				E	WITH(NOLOCK)
	ON		P.TU_CodEncadenamientoTramite				=	E.TU_CodEncadenamientoTramite
			INNER JOIN
			Catalogo.OperacionTramite					O	WITH(NOLOCK)
	ON		O.TN_CodOperacionTramite					=	P.TN_CodOperacionTramite
	WHERE	E.TU_CodEncadenamientoTramite				=   @L_CodEncadenamientoTramite

END


GO
