SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================
-- Autor:		   <Rafa Badilla> Fecha Creación: <29/06/2022> Descripcion: <Consultar Materia y oficina relacionados a un encadenamiento trámite>
-- =========================================================================================================================================
-- Modificación:   <Fecha> <Usuario> <Descripción del cambio>

-- =========================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarEncadenamientoTramiteMateriaOficina] 
	@CodEncadenamientoTramite			uniqueidentifier
AS
BEGIN

	-- Variables locales
	DECLARE @L_CodEncadenamientoTramite			Varchar(500)		= @CodEncadenamientoTramite

	--Consulta las materias y oficinas relacionadas a un encadenamiento trámite
	BEGIN
				SELECT	
				EMO.TU_CodEncadenamientoTramite							    AS Codigo,
				EMO.TF_Actualizacion										AS FechaActualizacion,
				'SplitMateria'									            AS SplitMateria,
				B.TC_CodMateria											    AS Codigo,
				B.TC_Descripcion											AS Descripcion,
				'SplitTipoOficina'									        AS SplitTipoOficina,
				A.TN_CodTipoOficina										    AS Codigo,
				A.TC_Descripcion											AS Descripcion	
				
				FROM	[Catalogo].[EncadenamientoTramiteMateriaOficina]	AS EMO	WITH(NOLOCK)
				Inner Join	Catalogo.TipoOficina							As	A  WITH(NOLOCK)
				On			EMO.TN_CodTipoOficina							= 	A.TN_CodTipoOficina
				Inner Join	Catalogo.Materia								As	B WITH(NOLOCK)
				On			EMO.TC_CodMateria								=	B.TC_CodMateria

				WHERE	EMO.TU_CodEncadenamientoTramite						= @L_CodEncadenamientoTramite
				AND		A.TF_Inicio_Vigencia								<= getdate()
				AND		(A.TF_Fin_Vigencia									>= getdate() or A.TF_Fin_Vigencia is null)
				AND		B.TF_Inicio_Vigencia								<= getdate()
				AND		(B.TF_Fin_Vigencia									>= getdate() or B.TF_Fin_Vigencia is null)
				ORDER BY B.TC_Descripcion
	END
END


GO
