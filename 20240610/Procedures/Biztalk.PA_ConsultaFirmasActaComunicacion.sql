SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=======================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<12/09/2017>
-- Descripción:				<Consulta las firmas holográficas que se deben estampar en el acta de la comunicación> 
-- =======================================================================================================================
-- Modificación:			<Aida Elena Siles R> <27/11/2020> <En la tabla funcionario se cambio el nombre del campo TI_FirmaHolografica por TU_CodFirma>
-- =======================================================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultaFirmasActaComunicacion]
(
	@CodigoComunicacion UNIQUEIDENTIFIER
)
AS
BEGIN
--VARIABLES
DECLARE		@L_CodigoComunicacion		UNIQUEIDENTIFIER = @CodigoComunicacion

--LÓGICA
	SELECT	I.TI_FirmaDestinatario				AS	FirmaDestinatario,	
			F.TU_CodFirma						AS	FirmaFuncionario
	FROM	Comunicacion.IntentoComunicacion	I 	WITH(NOLOCK)
	JOIN	Catalogo.Funcionario				F 	WITH(NOLOCK)
	ON		I.TC_UsuarioRed						=	F.TC_UsuarioRed
	WHERE	I.TU_CodComunicacion				=	@L_CodigoComunicacion

END


GO
