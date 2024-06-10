SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<23/01/2020>
-- Descripción :			<Permite Consultar los tipos de audiencia y oficina no asociados a una etiqueta  .
-- =================================================================================================================================================
-- Modificado por:			<Jose Gabriel Cordero Soto><13/02/2020><Agrega información sobre la Etiqueta Predefinida> 
-- =================================================================================================================================================
-- Modificado por:          <Jose Gabriel Cordero Soto><27/05/2020><Se modifica el valor de fecha asociacion a retornar>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEtiquetaPredefinidaTipoAudienciaTipoOficinaMateria]
    @CodTipoAudiencia	    smallint	 = Null,
	@CodTipoOficina		    smallint	 = Null,
	@CodMateria			    varchar(5)   = Null,
	@CodEtiquetaPredefinida smallint = Null,
	@FechaAsociacion		Datetime2(3) = Null
As
Begin
	Declare @L_CodTipoAudiencia		  smallint					= @CodTipoAudiencia
	Declare @L_CodTipoOficina	      smallint					= @CodTipoOficina
	Declare @L_CodMateria			  varchar(5)				= @CodMateria
	DECLARE @L_CodEtiquetaPredefinida smallint					= @CodEtiquetaPredefinida
	Declare @L_FechaAsociacion		  datetime2(3)				= @FechaAsociacion


	SELECT		A.TF_Inicio_Vigencia									AS FechaAsociacion,
				'SplitOtros'											AS SplitOtros, 
				C.TN_CodTipoAudiencia									AS CodigoAudiencia,
				C.TC_Descripcion										AS DescripcionAudiencia, 
				C.TF_Inicio_Vigencia									AS FechaActivacionAudiciencia, 
				C.TF_Fin_Vigencia										AS FechaDesactivacionAudiencia,				
       			E.TN_CodTipoOficina										AS CodigoTipoOficina, 
				E.TC_Descripcion										AS DescripcionTipoOficina,
				E.TF_Inicio_Vigencia									AS FechaActivacionTipoOficina,	
				E.TF_Fin_Vigencia										AS FechaDesactivacionTipoOficina,				
				F.TC_CodMateria											AS CodigoMateria,
				F.TC_Descripcion										AS DescripcionMateria, 
				F.TF_Inicio_Vigencia									AS FechaActivacionMateria,
				F.TF_Fin_Vigencia										AS FechaDesactivacionMateria,
				EP.TN_CodEtiquetaPredefinida							AS CodigoEtiqueta,
				EP.TC_Descripcion										AS DescripcionEtiqueta,
				EP.TF_Inicio_Vigencia									AS FechaActivacionEtiqueta,
				EP.TF_Fin_Vigencia										AS FechaDesactivacionEtiqueta

	FROM		Catalogo.EtiquetaPredefinidaTipoAudienciaTipoOficina    AS A WITH (Nolock) 
	INNER JOIN  Catalogo.EtiquetaPredefinida							AS EP WITH (Nolock)
	ON			EP.TN_CodEtiquetaPredefinida							=  A.TN_CodEtiquetaPredefinida
	INNER JOIN	Catalogo.TipoAudienciaTipoOficina	        			AS B WITH (Nolock)
	ON			B.TC_CodMateria											=  A.TC_CodMateria
	AND			B.TN_CodTipoAudiencia									=  A.TN_CodTipoAudiencia
	AND			B.TN_CodTipoOficina 									=  A.TN_CodTipoOficina
	INNER JOIN	Catalogo.TipoAudiencia				   				    AS C WITH (Nolock)
	ON			C.TN_CodTipoAudiencia									=  B.TN_CodTipoAudiencia
	INNER JOIN	Catalogo.TipoOficinaMateria			   				    AS D WITH (Nolock)
	ON			D.TC_CodMateria											=  B.TC_CodMateria
	AND			D.TN_CodTipoOficina										=  B.TN_CodTipoOficina
	INNER JOIN	Catalogo.TipoOficina									AS E WITH(Nolock)
	ON			E.TN_CodTipoOficina										= D.TN_CodTipoOficina
	INNER JOIN	Catalogo.Materia										AS F WITH(Nolock)
	ON			F.TC_CodMateria											= D.TC_CodMateria
	
	WHERE		(A.TN_CodTipoAudiencia								    = COALESCE(@L_CodTipoAudiencia, A.TN_CodTipoAudiencia)
	AND			 A.TN_CodTipoOficina									= COALESCE(@L_CodTipoOficina, A.TN_CodTipoOficina)
	AND			 A.TC_CodMateria										= COALESCE(@L_CodMateria, A.TC_CodMateria)
	AND			 A.TN_CodEtiquetaPredefinida							= COALESCE(@L_CodEtiquetaPredefinida, A.TN_CodEtiquetaPredefinida))
	AND			 A.TF_Inicio_Vigencia									<=COALESCE(@L_FechaAsociacion, A.TF_Inicio_Vigencia)
	
	ORDER BY	C.TC_Descripcion, E.TC_Descripcion;

End
GO
