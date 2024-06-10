SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================================================
-- Creado por :			<Karol Jiménez Sánchez>
-- Fecha modificación:	<22/11/2021>
-- Descripcion:			<Procedimiento que retorna los formatos jurídicos, y los grupos y subgrupos recursivos para un tipo de oficina y materia, 
--						además, valida que sean formatos jurídicos que en dicho tipo de oficina y materia, no tengan vinculado ningún proceso 
--						o tengan vinculado el proceso por parámetro>
-- =========================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto><Se realiza validacion de fecha de vigencia en la consulta recursiva para la lista de grupos>
-- =========================================================================================================================================
-- Modificación         <07/03/2024> <Yesenia Araya Sánchez><Se agrega el campo GenerarVotoAutomatico>	
-- =========================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarFormatoJuridicoTipoOficinaMateriaProceso] 
	@CodTipoOficina		SMALLINT,
	@CodMateria			VARCHAR(5),
	@CodProceso			SMALLINT
AS
BEGIN
	
	DECLARE	@L_CodTipoOficina		SMALLINT		=	@CodTipoOficina,
			@L_CodMateria			VARCHAR(5)		=	@CodMateria,
			@L_CodProceso			SMALLINT		=	@CodProceso,
			@L_FechaActual			DATETIME2(7)	=	SYSDATETIME();
			
	WITH 
	Recursividad 
	AS
	(
		SELECT				G.TN_CodGrupoFormatoJuridico				CodGrupoFormatoJuridico, 
							G.TN_CodGrupoFormatoJuridicoPadre			CodGrupoFormatoJuridicoPadre, 
							G.TC_Nombre									NombreGrupo,
							G.TC_Descripcion							DescripcionGrupo, 
							G.TN_Ordenamiento							OrdenGrupo,
							F.TC_CodFormatoJuridico						CodFormatoJuridico, 
							F.TC_Nombre									NombreMachote,
							F.TC_Descripcion							DescripcionMachote,
							F.TN_Ordenamiento							OrdenMachote,
							F.TU_IDArchivoFSActual						IDArchivoFSActual,
							T.TC_CodMateria								CodMateria, 
							T.TN_CodTipoOficina							CodTipoOficina,
							F.TB_GenerarVotoAutomatico					GenerarVotoAutomatico,
							'M'											Nivel
		FROM				Catalogo.GrupoFormatoJuridico			G	WITH(NOLOCK)
		INNER JOIN			Catalogo.FormatoJuridico				F	WITH(NOLOCK)	
		ON					F.TN_CodGrupoFormatoJuridico			=	G.TN_CodGrupoFormatoJuridico 
		AND					F.TF_Inicio_Vigencia					<	@L_FechaActual 
		AND					(F.TF_Fin_Vigencia						Is	Null 
						OR F.TF_Fin_Vigencia						>=	@L_FechaActual) 
		AND					G.TF_Inicio_Vigencia					<	@L_FechaActual	
		AND					(G.TF_Fin_Vigencia						Is	Null 
						OR	G.TF_Fin_Vigencia						>=	@L_FechaActual)
		INNER JOIN			Catalogo.FormatoJuridicoTipoOficina		T	WITH(NOLOCK)	
		ON					T.TC_CodFormatoJuridico					=	F.TC_CodFormatoJuridico	
		AND					T.TF_Inicio_Vigencia					<	@L_FechaActual
		WHERE				T.TC_CodMateria							=	@L_CodMateria
		AND					T.TN_CodTipoOficina						=	@L_CodTipoOficina
		UNION ALL
		SELECT				G.TN_CodGrupoFormatoJuridico				CodGrupoFormatoJuridico,
							G.TN_CodGrupoFormatoJuridicoPadre			CodGrupoFormatoJuridicoPadre, 
							G.TC_Nombre									NombreGrupo,
							G.TC_Descripcion							DescripcionGrupo,
							G.TN_Ordenamiento							OrdenGrupo,
							R.CodFormatoJuridico						CodFormatoJuridico, 
							R.NombreMachote,
							R.DescripcionMachote, 
							R.OrdenMachote,
							R.IDArchivoFSActual,
							R.CodMateria, 
							R.CodTipoOficina,
							R.GenerarVotoAutomatico,						
							'G'											Nivel
		FROM				Catalogo.GrupoFormatoJuridico			G	WITH(NOLOCK)
		INNER JOIN			Recursividad							R  
		ON					R.CodGrupoFormatoJuridicoPadre			=	G.TN_CodGrupoFormatoJuridico
		AND					G.TF_Inicio_Vigencia					<	@L_FechaActual	
		AND					(G.TF_Fin_Vigencia						Is	Null 
							OR	G.TF_Fin_Vigencia					>=	@L_FechaActual)
	), TablaAcumulada AS ( 
		SELECT DISTINCT		R.CodGrupoFormatoJuridico, 
							R.CodGrupoFormatoJuridicoPadre,
							R.NombreGrupo,
							R.DescripcionGrupo, 
							R.OrdenGrupo,
							R.CodFormatoJuridico, 
							R.NombreMachote,
							R.DescripcionMachote,
							R.OrdenMachote,
							R.IDArchivoFSActual,
							R.CodMateria, 
							R.CodTipoOficina,
							R.GenerarVotoAutomatico,				
							R.Nivel
		FROM				Recursividad							R
		LEFT JOIN			Catalogo.FormatoJuridicoProceso			F	WITH(NOLOCK)
		ON					F.TC_CodFormatoJuridico					=	R.CodFormatoJuridico 
		AND					F.TN_CodTipoOficina						=	R.CodTipoOficina 
		AND					F.TC_CodMateria							=	R.CodMateria
		WHERE				F.TC_CodFormatoJuridico					IS	NULL
		UNION
		SELECT DISTINCT		R.CodGrupoFormatoJuridico, 
							R.CodGrupoFormatoJuridicoPadre,
							R.NombreGrupo,
							R.DescripcionGrupo, 
							R.OrdenGrupo,
							R.CodFormatoJuridico, 
							R.NombreMachote,
							R.DescripcionMachote,
							R.OrdenMachote,
							R.IDArchivoFSActual,
							R.CodMateria, 
							R.CodTipoOficina,
							R.GenerarVotoAutomatico,
							R.Nivel
		FROM				Recursividad							R
		INNER JOIN			Catalogo.FormatoJuridicoProceso			P	WITH(NOLOCK)
		ON					P.TC_CodFormatoJuridico					=	R.CodFormatoJuridico 
		AND					P.TN_CodTipoOficina						=	R.CodTipoOficina 
		AND					P.TC_CodMateria							=	R.CodMateria
		WHERE				P.TC_CodMateria							=	@L_CodMateria
		AND					P.TN_CodTipoOficina						=	@L_CodTipoOficina
		AND					P.TN_CodProceso							=	@L_CodProceso
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
							GenerarVotoAutomatico,
							Nivel
	FROM					TablaAcumulada
END


GO
