SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================  
-- Versión:				<1.0>  
-- Creado por:			<Isaac Dobles Mata>  
-- Fecha de creación:	<22/10/2020>  
-- Descripción :		<Permite consultar las tareas que tiene un tipo de oficina y materia.
-- =================================================================================================================================================   
-- Modificacion:		<07/07/2021><Daniel Ruiz Hernández><Se agrega la consulta del pase a fallo.> 
-- =================================================================================================================================================   

CREATE PROCEDURE [Catalogo].[PA_ConsultarTareaTipoOficinaMateria]  
	@CodTipoOficina		    smallint		= Null,
	@CodTarea				smallint		= Null,
	@CodMateria			    varchar(5)		= Null
AS
BEGIN
	DECLARE @L_TN_CodTipoOficina			smallint					= @CodTipoOficina
	DECLARE @L_TN_CodTarea					smallint					= @CodTarea
	DECLARE @L_TC_CodMateria				varchar(5)					= @CodMateria


	SELECT		A.TF_Inicio_Vigencia									AS FechaAsociacion,
				A.TN_CantidadHoras										AS CantidadHoras,
				'Split'													AS Split, 
				A.TC_PaseFallo											AS PaseFallo,
				B.TN_CodTarea											AS CodigoTarea,
				B.TC_Descripcion										AS DescripcionTarea, 
				B.TF_Inicio_Vigencia									AS FechaActivacionTarea, 
				B.TF_Fin_Vigencia										AS FechaDesactivacionTarea,				
       			D.TN_CodTipoOficina										AS CodigoTipoOficina, 
				D.TC_Descripcion										AS DescripcionTipoOficina,
				D.TF_Inicio_Vigencia									AS FechaActivacionTipoOficina,	
				D.TF_Fin_Vigencia										AS FechaDesactivacionTipoOficina,				
				E.TC_CodMateria											AS CodigoMateria,
				E.TC_Descripcion										AS DescripcionMateria, 
				E.TF_Inicio_Vigencia									AS FechaActivacionMateria,
				E.TF_Fin_Vigencia										AS FechaDesactivacionMateria

	FROM		Catalogo.TareaTipoOficinaMateria						AS A WITH (Nolock) 
	INNER JOIN  Catalogo.Tarea											AS B WITH (Nolock)
	ON			A.TN_CodTarea											=  B.TN_CodTarea
	INNER JOIN	Catalogo.TipoOficinaMateria			   				    AS C WITH (Nolock)
	ON			C.TC_CodMateria											=  A.TC_CodMateria
	AND			C.TN_CodTipoOficina										=  A.TN_CodTipoOficina
	INNER JOIN	Catalogo.TipoOficina									AS D WITH(Nolock)
	ON			D.TN_CodTipoOficina										= C.TN_CodTipoOficina
	INNER JOIN	Catalogo.Materia										AS E WITH(Nolock)
	ON			E.TC_CodMateria											= C.TC_CodMateria
	
	WHERE		A.TN_CodTarea											= COALESCE(@L_TN_CodTarea, A.TN_CodTarea)
	AND			A.TN_CodTipoOficina										= COALESCE(@L_TN_CodTipoOficina, A.TN_CodTipoOficina)
	AND			A.TC_CodMateria											= COALESCE(@L_TC_CodMateria, A.TC_CodMateria)
	
	ORDER BY	B.TC_Descripcion, D.TC_Descripcion;

End
GO
