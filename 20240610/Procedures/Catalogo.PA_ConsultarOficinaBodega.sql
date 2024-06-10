SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
---Creado por:              <Ronny Ramírez Rojas>
-- Fecha Modificado         <07-11-2019>
-- Descripción :			<Permite Consultar la relacion Oficina Bodega de la tabla intermedia
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarOficinaBodega]
	@CodOficina Varchar(4),
	@CodBodega smallint=null,
	@FechaAsociacion Datetime2= Null 
 As
 Begin 	
	
	--Registros activos
   If @FechaAsociacion  Is Null 
	Begin
		SELECT		C.TN_CodBodega				AS Codigo, 
					C.TC_Descripcion			AS Descripcion, 
					C.TF_Inicio_Vigencia		AS FechaActivacion, 
					C.TF_Fin_Vigencia			AS FechaDesactivacion, 
					A.TF_Inicio_Vigencia		AS FechaAsociacion, 
					'SplitOficina'		   		AS SplitOficina, 
					B.TC_CodOficina				AS Codigo, 
					B.TC_Nombre					AS Descripcion, 
					B.TF_Inicio_Vigencia		AS FechaActivacion, 
					B.TF_Fin_Vigencia			AS FechaDesactivacion					
		FROM		Catalogo.OficinaBodega		AS A WITH (Nolock) INNER JOIN
					Catalogo.Oficina			AS B WITH (Nolock) ON A.TC_CodOficina = B.TC_CodOficina INNER JOIN
					Catalogo.Bodega				AS C WITH (Nolock) ON A.TN_CodBodega = C.TN_CodBodega
		
		WHERE		A.TN_CodBodega 				= isnull( @CodBodega, A.TN_CodBodega )
		And			A.TC_CodOficina  			= isnull( @CodOficina, A.TC_CodOficina  )
		And			A.TF_Inicio_Vigencia		< GETDATE ()
		And			C.TF_Inicio_Vigencia  		< GETDATE ()
		And			(
					 C.TF_Fin_Vigencia 			Is Null 
		OR 			 C.TF_Fin_Vigencia  		>= GETDATE ()
					)
		
		Order By	B.TC_Nombre, C.TC_Descripcion;
	 End
	
	Else
	-- todos registros 
		SELECT		C.TN_CodBodega				AS Codigo, 
					C.TC_Descripcion			AS Descripcion, 
					C.TF_Inicio_Vigencia		AS FechaActivacion, 
					C.TF_Fin_Vigencia			AS FechaDesactivacion, 
					A.TF_Inicio_Vigencia		AS FechaAsociacion, 
					'SplitOficina'		   		AS SplitOficina, 
					B.TC_CodOficina				AS Codigo, 
					B.TC_Nombre					AS Descripcion, 
					B.TF_Inicio_Vigencia		AS FechaActivacion, 
					B.TF_Fin_Vigencia			AS FechaDesactivacion					
		FROM		Catalogo.OficinaBodega		AS A WITH (Nolock) INNER JOIN
					Catalogo.Oficina			AS B WITH (Nolock) ON A.TC_CodOficina = B.TC_CodOficina INNER JOIN
					Catalogo.Bodega				AS C WITH (Nolock) ON A.TN_CodBodega = C.TN_CodBodega
		WHERE		A.TN_CodBodega 				= isnull( @CodBodega,A.TN_CodBodega  )
		And			A.TC_CodOficina  			= isnull( @CodOficina  , A.TC_CodOficina  )
		And			C.TF_Inicio_Vigencia  		< GETDATE ()
		And			(
					 C.TF_Fin_Vigencia 			Is Null 
		OR 			 C.TF_Fin_Vigencia  		>= GETDATE ()
					)
		Order By	B.TC_Nombre, C.TC_Descripcion;
 End
GO
