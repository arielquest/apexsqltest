SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================================================
--	Autor:				<Isaac Dobles Mata> 
--	Fecha Creación:		<22/06/2022> 
--	Descripcion:		<Consultar los parámetros de operaciones en un paso de encadenamientos de trámites>
-- =========================================================================================================================================
CREATE     PROCEDURE [Catalogo].[PA_ConsultarEncadenamientoTramitePasoOperacionParametro] 
	@CodEncadenamientoPaso			uniqueidentifier
AS
BEGIN

	-- Variables locales
	DECLARE @L_CodEncadenamientoPaso			Varchar(500)	= @CodEncadenamientoPaso

	SELECT  OTP.TC_CampoIdentificador							CampoIdentificador,
			OTP.TC_Nombre										Nombre,
			OTP.TC_NombreEstructura								NombreEstructura,
			OTP.TC_CampoIdentificador							CampoIdentificador,
			OTP.TC_CampoMostrar									CampoMostrar,
			OTP.TF_Inicio_Vigencia								FechaActivacion,
			OTP.TF_Fin_Vigencia									FechaDesactivacion,
			'Split'												Split,
			PP.TC_Valor											Valor
	FROM	Catalogo.EncadenamientoTramitePasoParametro			PP	WITH(NOLOCK)
			INNER JOIN
			Catalogo.EncadenamientoTramitePaso					P	WITH(NOLOCK)
	ON		PP.TU_CodEncadenamientoTramitePaso				=	P.TU_CodEncadenamientoTramitePaso
			INNER JOIN
			Catalogo.OperacionTramite							OP	WITH(NOLOCK)
	ON		OP.TN_CodOperacionTramite						=	P.TN_CodOperacionTramite
			INNER JOIN
			Catalogo.OperacionTramiteParametro					OTP WITH(NOLOCK)
	ON		OP.TN_CodOperacionTramite						=	OTP.TN_CodOperacionTramite
	WHERE	PP.TU_CodEncadenamientoTramitePaso				=   @L_CodEncadenamientoPaso

END


GO
