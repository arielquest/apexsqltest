SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================
-- Autor:				<Xinia Soto V.>
-- Fecha Creación:		<04/11/2021>
-- Descripcion:			<Consulta encadenamientos de formato jurídico>
-- =========================================================================================================================================
-- Modificado :			<Johan Manuel Acosta Ibañez>
-- Fecha modificación:	<10/11/2021>
-- Descripcion:			<Se actualiza los parámetros a null por default use de with(nolock) y coalesce>
-- =========================================================================================================================================
-- Modificado :			<Xinia Soto Valerio>
-- Fecha modificación:	<11/11/2021>
-- Descripcion:			<Se pasa a int el código del encadenamiento>
-- =========================================================================================================================================
-- Modificado :			<Xinia Soto Valerio>
-- Fecha modificación:	<22/11/2021>
-- Descripcion:			<Se pasa a varchar(5) la materia>
-- =========================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEncadenamientoFormatoJuridico] 
	@CodTipoOficina		SMALLINT	= NULL,
	@CodMateria			VARCHAR(5)	= NULL,
	@CodFormatoJuridico	VARCHAR(8)	= NULL,
	@CodEncadenamiento	INT			= NULL
AS
BEGIN

	--Variables locales
	DECLARE @L_CodTipoOficina		SMALLINT   = @CodTipoOficina,
			@L_CodMateria			VARCHAR(5) = @CodMateria,
			@L_CodFormatoJuridico	VARCHAR(8) = @CodFormatoJuridico,
			@L_CodEncadenamiento	INT		   = @CodEncadenamiento


	--Aplicación de inserción
	SELECT  E.TN_CodEncadenamientoFormatoJuridico	Codigo,
			E.TF_Actualizacion						FechaActualizacion,	
			'Split'									Split,
			E.TN_CodTipoOficina						Codigo,
			O.TC_Descripcion						Descripcion,
			'Split'									Split,
			E.TC_CodMateria							Codigo,
			M.TC_Descripcion						Descripcion,
			'Split'									Split,
			E.TC_CodFormatoJuridico					Codigo,
			F.TC_Nombre								Nombre
	FROM	Catalogo.EncadenamientoFormatoJuridico	E	WITH(NOLOCK)
			INNER JOIN Catalogo.TipoOficina			O	WITH(NOLOCK)
	ON		O.TN_CodTipoOficina						=	E.TN_CodTipoOficina
			INNER JOIN Catalogo.Materia				M	WITH(NOLOCK)
	ON		M.TC_CodMateria							=	E.TC_CodMateria
			INNER JOIN Catalogo.FormatoJuridico		F	WITH(NOLOCK)
	ON		F.TC_CodFormatoJuridico					=	E.TC_CodFormatoJuridico
	WHERE	E.TN_CodTipoOficina						= COALESCE(@L_CodTipoOficina,		E.TN_CodTipoOficina)					
	AND		E.TC_CodFormatoJuridico					= COALESCE(@L_CodFormatoJuridico,	E.TC_CodFormatoJuridico)				
	AND		E.TC_CodMateria  						= COALESCE(@L_CodMateria,		    E.TC_CodMateria)					
	AND		E.TN_CodEncadenamientoFormatoJuridico	= COALESCE(@L_CodEncadenamiento,	E.TN_CodEncadenamientoFormatoJuridico)
	

END

GO
