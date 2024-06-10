SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--=======================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<28/05/2021>
-- Descripción:				<Obtiene el registro de ConfiguracionContextoBizTalk solicitado por código de contexto> 
-- =======================================================================================================================
-- Modificación:			<Olger Gamboa Castillo> <06/06/2021> <Se cambian alias de nombre ocj y correo ocj>
-- Modificación:			<Isaac Dobles Mata> <02-11-2021> <Se modifica obtención de descripción de oficina>
-- =======================================================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultarConfiguracionXContexto]
(
	@CodigoContexto			VARCHAR(4)
)
AS 
BEGIN
	--Variables.
	Declare 
		@L_TC_CodigoContexto	VARCHAR(4)	= @CodigoContexto
	
	--Lógica.	
	SELECT	C.TC_CodContexto	AS	CodigoContexto,
			'NoAPLICA'			AS	CadenaConexion,
			C.TC_Email			AS	CorreoElectronicoContexto,
			'NoAplica'			AS	FtpConexion,
			'NoAplica'			AS	FtpDominio,
			'NoAplica'			AS	FtpUsuario,
			'NoAplica'			AS	FtpClave,
			
			'OficinaOCJ'		AS	OficinaOCJ,
			OCJ.TC_CodContexto	AS	CodigoOCJ,
			CASE WHEN LOWER(OFI.TC_Nombre) = LOWER(OCJ.TC_Descripcion) THEN OCJ.TC_Descripcion ELSE OCJ.TC_Descripcion + '-' + OFI.TC_Nombre END AS	NombreOOCJ,
			P.TC_Descripcion	AS	ProvinciaOCJ,
			OCJ.TC_Email		AS	CorreoElectronico,
			'NoAplica'			AS	'ConexionBD'
	
	FROM		Catalogo.Contexto		C	WITH(NOLOCK)
	INNER JOIN	Catalogo.Provincia		P	WITH (NOLOCK)
	ON			C.TN_CodProvincia		=	P.TN_CodProvincia
	INNER JOIN	Catalogo.Contexto		OCJ WITH (NOLOCK)
	ON			C.TC_CodContextoOCJ		=	OCJ.TC_CodContexto
	INNER JOIN  Catalogo.Oficina		OFI WITH (NOLOCK)
	ON			OCJ.TC_CodOficina		=   OFI.TC_CodOficina
	
	WHERE C.TC_CodContexto				=	@CodigoContexto
END
GO
