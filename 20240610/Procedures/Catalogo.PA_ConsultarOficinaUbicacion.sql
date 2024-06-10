SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
---Creado por:              <Pablo Alvarez>
-- Fecha Modificado         <10-9-2015>
-- Descripción :			<Permite Consultar la relacion Oficina Ubicacion de la tabla intermedia
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarOficinaUbicacion]
	@CodOficina Varchar(4),
	@CodUbicacion smallint=null,
	@FechaAsociacion Datetime2= Null 
 As
 Begin 	
	
	--Registros activos
   If @FechaAsociacion  Is Null 
	Begin
		SELECT		C.TN_CodUbicacion			AS Codigo, 
					C.TC_Descripcion				AS Descripcion, 
					C.TF_Inicio_Vigencia			AS FechaActivacion, 
					C.TF_Fin_Vigencia			AS FechaDesactivacion, 
					A.TF_Inicio_Vigencia			AS FechaAsociacion, 
					'Split'		   AS Split, 
					B.TC_CodOficina				AS Codigo, 
					B.TC_Nombre					AS Descripcion, 
					B.TF_Inicio_Vigencia			AS FechaActivacion, 
					B.TF_Fin_Vigencia			AS FechaDesactivacion,
					'Split'	  as SplitP,
					D.TN_CodPerfilPuesto        AS Codigo, 
					D.TC_Descripcion            AS Descripcion
		FROM		Catalogo.OficinaUbicacion	AS A WITH (Nolock) INNER JOIN
					Catalogo.Oficina				AS B WITH (Nolock) ON A.TC_CodOficina = B.TC_CodOficina INNER JOIN
					Catalogo.Ubicacion			AS C WITH (Nolock) ON A.TN_CodUbicacion = C.TN_CodUbicacion   LEFT JOIN
					Catalogo.PerfilPuesto        AS D  WITH (Nolock) ON A.TN_CodPerfilPuesto  = D.TN_CodPerfilPuesto 
		WHERE		A.TN_CodUbicacion = isnull( @CodUbicacion,A.TN_CodUbicacion  )
		and			A.TC_CodOficina  = isnull( @CodOficina  , A.TC_CodOficina  )
		And			A.TF_Inicio_Vigencia			< GETDATE ()
		Order By	B.TC_Nombre, C.TC_Descripcion;
	 End
	Else
	-- todos registros 
		SELECT		C.TN_CodUbicacion			AS Codigo, 
					C.TC_Descripcion				AS Descripcion, 
					C.TF_Inicio_Vigencia			AS FechaActivacion, 
					C.TF_Fin_Vigencia			AS FechaDesactivacion, 
					A.TF_Inicio_Vigencia			AS FechaAsociacion, 
					'Split'		   AS Split, 
					B.TC_CodOficina				AS Codigo, 
					B.TC_Nombre					AS Descripcion, 
					B.TF_Inicio_Vigencia			AS FechaActivacion, 
					B.TF_Fin_Vigencia			AS FechaDesactivacion,
					'Split'	  as SplitP,
					D.TN_CodPerfilPuesto        AS Codigo, 
					D.TC_Descripcion            AS Descripcion
		FROM		Catalogo.OficinaUbicacion	AS A WITH (Nolock) INNER JOIN
					Catalogo.Oficina				AS B WITH (Nolock) ON A.TC_CodOficina = B.TC_CodOficina INNER JOIN
					Catalogo.Ubicacion			AS C WITH (Nolock) ON A.TN_CodUbicacion = C.TN_CodUbicacion  LEFT JOIN
					Catalogo.PerfilPuesto        AS D  WITH (Nolock) ON A.TN_CodPerfilPuesto  = D.TN_CodPerfilPuesto 
		WHERE		A.TN_CodUbicacion = isnull( @CodUbicacion,A.TN_CodUbicacion  )
		and			A.TC_CodOficina  = isnull( @CodOficina  , A.TC_CodOficina  )
		Order By	B.TC_Nombre, C.TC_Descripcion;

 End
GO
