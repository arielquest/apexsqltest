SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================
-- Creado por :			<Johan Manuel Acosta Ibañez>
-- Fecha modificación:	<22/11/2021>
-- Descripcion:			<Procedimiento que retorna los grupos y subgrupos recursivos para un tipo de oficina y materia>
-- =========================================================================================================================================
-- Modificado por :		<Johan Manuel Acosta Ibañez>
-- Fecha modificación:	<30/11/2021>
-- Descripcion:			<Se agrega la consulta a un formato jurídico específico>
-- =========================================================================================================================================
-- Modificado por:      <Jose Gabriel Cordero Soto> <15/03/2022> <Se realiza ajuste en consulta para retornar el Proceso si es que tiene el formato juridico un proceso asociado>
-- =========================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarFormatoJuridicoTipoOficinaMateria] 
	@CodTipoOficina						SMALLINT,
	@CodMateria							VARCHAR(5),
	@CodFormatoJuridicoEncadenamiento	VARCHAR(8),
	@CodFormatoJuridico					VARCHAR(8) = NULL
AS
BEGIN
	
	DECLARE	@L_CodTipoOficina					SMALLINT		=	@CodTipoOficina,
			@L_CodMateria						VARCHAR(5)		=	@CodMateria,
			@L_CodFormatoJuridicoEncadenamiento	VARCHAR(8)		=	@CodFormatoJuridicoEncadenamiento,
			@L_CodFormatoJuridico				VARCHAR(8)		=	@CodFormatoJuridico,	
			@L_FechaActual						DATETIME2(7)	=	SYSDATETIME();
			
	WITH 
	Recursividad 
	AS
	(
		SELECT				A.TN_CodGrupoFormatoJuridico					CodGrupoFormatoJuridico, 
							A.TN_CodGrupoFormatoJuridicoPadre				CodGrupoFormatoJuridicoPadre, 
							A.TC_Nombre										NombreGrupo,
							A.TC_Descripcion								DescripcionGrupo, 
							A.TN_Ordenamiento								OrdenGrupo,
							B.TC_CodFormatoJuridico							CodFormatoJuridico, 
							B.TC_Nombre										NombreMachote,
							B.TC_Descripcion								DescripcionMachote,
							B.TN_Ordenamiento								OrdenMachote,
							B.TU_IDArchivoFSActual							IDArchivoFSActual,
							C.TC_CodMateria									CodMateria, 
							C.TN_CodTipoOficina								CodTipoOficina,
							'M'												Nivel
		FROM				Catalogo.GrupoFormatoJuridico			A		WITH(NOLOCK)
		INNER JOIN			Catalogo.FormatoJuridico				B		WITH(NOLOCK)	
		ON					B.TN_CodGrupoFormatoJuridico			=		A.TN_CodGrupoFormatoJuridico AND B.TF_Inicio_Vigencia  < @L_FechaActual AND	(B.TF_Fin_Vigencia Is Null OR B.TF_Fin_Vigencia  >= @L_FechaActual) AND A.TF_Inicio_Vigencia  < @L_FechaActual	And	(A.TF_Fin_Vigencia Is Null OR A.TF_Fin_Vigencia  >= @L_FechaActual)
		INNER JOIN			Catalogo.FormatoJuridicoTipoOficina		C		WITH(NOLOCK)	
		ON					C.TC_CodFormatoJuridico					=		B.TC_CodFormatoJuridico	AND C.TF_Inicio_Vigencia  < @L_FechaActual
		WHERE				C.TC_CodMateria							=		@L_CodMateria
		AND					C.TN_CodTipoOficina						=		@L_CodTipoOficina
		AND					B.TC_CodFormatoJuridico					=		COALESCE(@L_CodFormatoJuridico, B.TC_CodFormatoJuridico)
		UNION ALL
		SELECT				D.TN_CodGrupoFormatoJuridico					CodGrupoFormatoJuridico,
							D.TN_CodGrupoFormatoJuridicoPadre				CodGrupoFormatoJuridicoPadre, 
							D.TC_Nombre										NombreGrupo,
							D.TC_Descripcion								DescripcionGrupo,
							D.TN_Ordenamiento								OrdenGrupo,
							E.CodFormatoJuridico							CodFormatoJuridico, 
							E.NombreMachote,
							E.DescripcionMachote, 
							E.OrdenMachote,
							NULL											IDArchivoFSActual,
							E.CodMateria, 
							E.CodTipoOficina,
							'G'												Nivel
		FROM				Catalogo.GrupoFormatoJuridico			D		WITH(NOLOCK)
		INNER JOIN			Recursividad							E  
		ON					E.CodGrupoFormatoJuridicoPadre		=		D.TN_CodGrupoFormatoJuridico
	), TablaAcumulada AS ( 
		SELECT DISTINCT		F.CodGrupoFormatoJuridico, 
							F.CodGrupoFormatoJuridicoPadre,
							F.NombreGrupo,
							F.DescripcionGrupo, 
							F.OrdenGrupo,
							F.CodFormatoJuridico, 
							F.NombreMachote,
							F.DescripcionMachote,
							F.OrdenMachote,
							F.IDArchivoFSActual,
							F.CodMateria, 
							F.CodTipoOficina,
							F.Nivel
		FROM				Recursividad							F
		LEFT JOIN			Catalogo.FormatoJuridicoProceso			G		WITH(NOLOCK)
		ON					G.TC_CodFormatoJuridico					=		F.CodFormatoJuridico 
		AND					G.TN_CodTipoOficina						=		F.CodTipoOficina 
		AND					G.TC_CodMateria							=		F.CodMateria
		WHERE				G.TC_CodFormatoJuridico					IS		NULL
		UNION
		SELECT DISTINCT		H.CodGrupoFormatoJuridico, 
							H.CodGrupoFormatoJuridicoPadre,
							H.NombreGrupo,
							H.DescripcionGrupo, 
							H.OrdenGrupo,
							H.CodFormatoJuridico, 
							H.NombreMachote,
							H.DescripcionMachote,
							H.OrdenMachote,
							H.IDArchivoFSActual,
							H.CodMateria, 
							H.CodTipoOficina,
							H.Nivel
		FROM				Recursividad							H
		INNER JOIN			Catalogo.FormatoJuridicoProceso			I		WITH(NOLOCK)
		ON					I.TC_CodFormatoJuridico					=		H.CodFormatoJuridico 
		AND					I.TN_CodTipoOficina						=		H.CodTipoOficina 
		AND					I.TC_CodMateria							=		H.CodMateria
		INNER JOIN			Catalogo.FormatoJuridicoProceso			J		WITH(NOLOCK)
		ON					J.TN_CodTipoOficina						=		I.TN_CodTipoOficina 
		AND					J.TC_CodMateria							=		I.TC_CodMateria
		AND					J.TN_CodProceso							=		I.TN_CodProceso
		WHERE				J.TC_CodMateria							=		@L_CodMateria
		AND					J.TN_CodTipoOficina						=		@L_CodTipoOficina
		AND					J.TC_CodFormatoJuridico					=		@L_CodFormatoJuridicoEncadenamiento
	)
	SELECT					CodGrupoFormatoJuridico, 
							CodGrupoFormatoJuridicoPadre,
							NombreGrupo,
							DescripcionGrupo, 
							OrdenGrupo,
							CodFormatoJuridico, 
							NombreMachote,
							DescripcionMachote,
							OrdenMachote,
							IDArchivoFSActual,
							CodMateria, 
							CodTipoOficina,
							Nivel,
							B.TN_CodProceso							CodProceso
	FROM					TablaAcumulada							A
	LEFT JOIN				Catalogo.FormatoJuridicoProceso			B	WITH(NOLOCK)
	ON						A.CodFormatoJuridico					=	B.TC_CodFormatoJuridico
END


GO
