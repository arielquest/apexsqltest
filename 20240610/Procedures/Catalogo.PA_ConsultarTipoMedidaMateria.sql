SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>  
-- Creado por:			<Rafa Badilla Alvarado> 
-- Fecha de creación:	<29/09/2022> 
-- Descripción :		<Permite consultar las materias asociadas a un tipo de medida. 
-- =================================================================================================================================================
-- Modificado por:		<24/10/2022> <Rafa Badilla Alvarado> <Se modifica para filtrar los registros activos> 
-- Modificado por:      <02/11/2022> <Jose Gabriel Cordero Soto> <Se modifica nombre de TipoMedidaCautelar a TipoMedida>
-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarTipoMedidaMateria]
   @CodTipoMedida			smallint	= Null,
   @CodMateria				varchar(4)	= Null,
   @FechaAsociacion			Datetime2	= Null,
   @FechaActivacion			Datetime2	= null,
   @FechaDesactivacion		Datetime2	= null

As
Begin

--Trae todos los registros activos o no 
	 IF @FechaActivacion IS NULL AND @FechaDesactivacion IS NULL   
	 BEGIN   
		SELECT		A.TF_Fecha_Asociacion			    FechaAsociacion, 			
					B.TN_CodTipoMedida				    Codigo, 
					B.TC_Descripcion					Descripcion, 
					B.TF_Inicio_Vigencia				FechaActivacion, 
					B.TF_Fin_Vigencia					FechaDesactivacion,				
					'Split'								Split,
					C.TC_CodMateria						Codigo,				
					C.TC_Descripcion					Descripcion,
					C.TB_EjecutaRemate					EjecutaRemate,
					C.TF_Inicio_Vigencia				FechaActivacion,	
					C.TF_Fin_Vigencia					FechaDesactivacion

		FROM		Catalogo.TipoMedidaMateria			A WITH (Nolock) 
		INNER JOIN	Catalogo.TipoMedida					B WITH (Nolock)
		ON			B.TN_CodTipoMedida				    =	A.TN_CodTipoMedida
		INNER JOIN  Catalogo.Materia					C WITH (Nolock)
		ON			C.TC_CodMateria						=	A.TC_CodMateria				
		WHERE		A.TN_CodTipoMedida				    =	COALESCE(@CodTipoMedida, A.TN_CodTipoMedida)
		AND			A.TC_CodMateria						=	COALESCE(@CodMateria, A.TC_CodMateria)
		AND			A.TF_Fecha_Asociacion				<=	CASE WHEN @FechaAsociacion IS NULL THEN GETDATE() ELSE A.TF_Fecha_Asociacion END
	
		ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
	END

		--Trae únicamente registros activos
	 IF @FechaActivacion IS NOT NULL AND @FechaDesactivacion IS NOT NULL   
	 BEGIN   
		SELECT		A.TF_Fecha_Asociacion			    FechaAsociacion, 			
					B.TN_CodTipoMedida				    Codigo, 
					B.TC_Descripcion					Descripcion, 
					B.TF_Inicio_Vigencia				FechaActivacion, 
					B.TF_Fin_Vigencia					FechaDesactivacion,				
					'Split'								Split,
					C.TC_CodMateria						Codigo,				
					C.TC_Descripcion					Descripcion,
					C.TB_EjecutaRemate					EjecutaRemate,
					C.TF_Inicio_Vigencia				FechaActivacion,	
					C.TF_Fin_Vigencia					FechaDesactivacion

		FROM		Catalogo.TipoMedidaMateria			A WITH (Nolock) 
		INNER JOIN	Catalogo.TipoMedida					B WITH (Nolock)
		ON			B.TN_CodTipoMedida				    =	A.TN_CodTipoMedida
		INNER JOIN  Catalogo.Materia					C WITH (Nolock)
		ON			C.TC_CodMateria						=	A.TC_CodMateria				
		WHERE		A.TN_CodTipoMedida				    =	COALESCE(@CodTipoMedida, A.TN_CodTipoMedida)
		AND			A.TC_CodMateria						=	COALESCE(@CodMateria, A.TC_CodMateria)
		AND			A.TF_Fecha_Asociacion				<=	CASE WHEN @FechaAsociacion IS NULL THEN GETDATE() ELSE A.TF_Fecha_Asociacion END
		AND		   (B.TF_Inicio_Vigencia				<= @FechaDesactivacion	
	    AND		    B.TF_Inicio_Vigencia				>= @FechaActivacion or B.TF_Fin_Vigencia is null) 
		AND		   (C.TF_Inicio_Vigencia				<= @FechaDesactivacion	
	    AND		    C.TF_Inicio_Vigencia				>= @FechaActivacion or C.TF_Fin_Vigencia is null)
	
		ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
	END

End

GO
