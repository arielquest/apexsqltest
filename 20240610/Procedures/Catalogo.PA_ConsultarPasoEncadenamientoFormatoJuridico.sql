SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================
-- Autor:				<Xinia Soto V.>
-- Fecha Creación:		<04/11/2021>
-- Descripcion:			<Consulta los pasos de un encadenamientos de formato jurídico>
-- =========================================================================================================================================
-- Modificacion:		<02/12/2021><Miguel Avendaño> <Se modifica para que retorne tambien si el formato juridico genera voto automatico.>
-- Modificacion:		<10/01/2022><Karol Jiménez Sánchez><Se modifica para que retorne tambien la descripción del formato jurídico.>
-- Modificacion:		<05/04/2022><Daniel Ruiz Hernández><Se modifica para que retorne tambien las opreciones.>
-- Modificacion:		<18/04/2022><Jose Gabriel Cordero Soto><Se retorna el calor de pantalla para la Operacion.>
-- =========================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarPasoEncadenamientoFormatoJuridico] 
	@CodEncadenamiento	INT	
AS
BEGIN

	--Variables locales
	DECLARE @L_CodEncadenamiento	INT		   = @CodEncadenamiento

	SELECT  P.TN_Orden								Orden,
			P.TF_Actualizacion						FechaActualizacion,	
			'Split'									Split,
			E.TN_CodEncadenamientoFormatoJuridico	Codigo,
			E.TF_Actualizacion						FechaActualizacion,	
			'Split'									Split,
			P.TN_CodTipoOficina						Codigo,
			O.TC_Descripcion						Descripcion,
			'Split'									Split,
			P.TC_CodMateria							Codigo,
			M.TC_Descripcion						Descripcion,
			'Split'									Split,
			P.TC_CodFormatoJuridico					Codigo,
			F.TC_Nombre								Nombre,
			F.TC_Descripcion						Descripcion,
			F.TU_IDArchivoFSActual					ArchivoFSActual,
			F.TB_GenerarVotoAutomatico				GenerarVotoAutomatico,
			'Split'									Split,
			NULL									Pantalla
	FROM	Catalogo.PasoEncadenamientoFormatoJuridico	P	WITH(NOLOCK)
			INNER JOIN
			Catalogo.EncadenamientoFormatoJuridico		E	WITH(NOLOCK)
	ON		P.TN_CodEncadenamientoFormatoJuridico   =   E.TN_CodEncadenamientoFormatoJuridico
			INNER JOIN Catalogo.TipoOficina				O	WITH(NOLOCK)
	ON		O.TN_CodTipoOficina						=	P.TN_CodTipoOficina
			INNER JOIN Catalogo.Materia					M	WITH(NOLOCK)
	ON		M.TC_CodMateria							=	P.TC_CodMateria
			INNER JOIN Catalogo.FormatoJuridico		    F	WITH(NOLOCK)
	ON		F.TC_CodFormatoJuridico					=	P.TC_CodFormatoJuridico
	WHERE	E.TN_CodEncadenamientoFormatoJuridico	=   @L_CodEncadenamiento
	
	UNION

	SELECT  P.TN_Orden								Orden,
			P.TF_Actualizacion						FechaActualizacion,	
			'Split'									Split,
			E.TN_CodEncadenamientoFormatoJuridico	Codigo,
			E.TF_Actualizacion						FechaActualizacion,	
			'Split'									Split,
			P.TN_CodTipoOficina						Codigo,
			O.TC_Descripcion						Descripcion,
			'Split'									Split,
			P.TC_CodMateria							Codigo,
			M.TC_Descripcion						Descripcion,
			'Split'									Split,
			T.TN_CodOperacionTramite		 		Codigo,
			T.TC_Nombre								Nombre,
			T.TC_Descripcion						Descripcion,
			NULL									ArchivoFSActual,
			CAST(0 AS bit)							GenerarVotoAutomatico,
			'Split'									Split,
			T.TN_Pantalla							Pantalla
	FROM	Catalogo.PasoEncadenamientoFormatoJuridico	P	WITH(NOLOCK)
			INNER JOIN
			Catalogo.EncadenamientoFormatoJuridico		E	WITH(NOLOCK)
	ON		P.TN_CodEncadenamientoFormatoJuridico   =   E.TN_CodEncadenamientoFormatoJuridico
			INNER JOIN Catalogo.TipoOficina				O	WITH(NOLOCK)
	ON		O.TN_CodTipoOficina						=	P.TN_CodTipoOficina
			INNER JOIN Catalogo.Materia					M	WITH(NOLOCK)
	ON		M.TC_CodMateria							=	P.TC_CodMateria
			INNER JOIN Catalogo.OperacionTramite		T	WITH(NOLOCK)
	ON		P.TN_CodOperacionTramite				=	T.TN_CodOperacionTramite
	WHERE	E.TN_CodEncadenamientoFormatoJuridico	=   @L_CodEncadenamiento

END

GO
