SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================  
-- Versión:				<1.0>  
-- Creado por:			<Isaac Dobles Mata>  
-- Fecha de creación:	<29/10/2020>  
-- Descripción :		<Permite consultar las tareas que tiene asociadas contexto y tipo de puesto de trabajo.
-- =================================================================================================================================================   
-- Modificación:		<07/07/2021> <Aida Elena Siles R> <Se agrega a la consulta el PasoFallo de la tarea>
-- ================================================================================================================================================= 

CREATE PROCEDURE [Catalogo].[PA_ConsultarTareaContextoTipoPuestoTrabajo]  
	@CodContexto						VARCHAR(4)		,
	@CodTipoPuestoTrabajo			    SMALLINT		,
	@CodTipoOficina						SMALLINT		= NULL,
	@CodMateria							VARCHAR(5)		= NULL,
	@CodTarea							SMALLINT		= NULL,
	@Asociadas							BIT				= 0
AS
BEGIN
	DECLARE 
	@L_TC_CodContexto				VARCHAR(4)					= @CodContexto,
	@L_TN_CodTipoPuestoTrabajo		SMALLINT					= @CodTipoPuestoTrabajo,
	@L_TN_CodTipoOficina			SMALLINT					= @CodTipoOficina,
	@L_TN_CodTarea					SMALLINT					= @CodTarea,
	@L_TC_CodMateria				VARCHAR(5)					= @CodMateria

	If(@Asociadas = 1)
	BEGIN
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
					E.TF_Fin_Vigencia										AS FechaDesactivacionMateria,
					G.TN_CodTipoPuestoTrabajo								AS CodigoTipoPuestoTrabajo,
					G.TC_Descripcion										AS DescripcionTipoPuestoTrabajo,
					G.TF_Inicio_Vigencia									AS FechaInicioTipoPuestoTrabajo,
					G.TF_Fin_Vigencia										AS FechaFinTipoPuestoTrabajo,
					H.TC_CodContexto										AS CodigoContexto,
					H.TC_Descripcion										AS DescripcionContexto,
					H.TF_Inicio_Vigencia									AS FechaInicioContexto,
					H.TF_Fin_Vigencia										AS FechaFinContexto
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
		INNER JOIN	Catalogo.TareaContextoTipoPuestoTrabajo					AS F WITH(Nolock)
		ON			A.TN_CodTarea											= F.TN_CodTarea
		AND			F.TN_CodTipoPuestoTrabajo								= @L_TN_CodTipoPuestoTrabajo
		AND			F.TC_CodContexto										= @L_TC_CodContexto
		INNER JOIN	Catalogo.TipoPuestoTrabajo								AS G WITH(NoLock)
		ON			G.TN_CodTipoPuestoTrabajo								= F.TN_CodTipoPuestoTrabajo
		INNER JOIN  Catalogo.Contexto										AS H WITH(NoLock)
		ON			H.TC_CodContexto										= F.TC_CodContexto
		WHERE		A.TN_CodTarea											= COALESCE(@L_TN_CodTarea, A.TN_CodTarea)
		AND			A.TN_CodTipoOficina										= COALESCE(@L_TN_CodTipoOficina, A.TN_CodTipoOficina)
		AND			A.TC_CodMateria											= COALESCE(@L_TC_CodMateria, A.TC_CodMateria)
		ORDER BY	B.TC_Descripcion, D.TC_Descripcion;
	END
	ELSE
	BEGIN
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
					E.TF_Fin_Vigencia										AS FechaDesactivacionMateria,
					G.TN_CodTipoPuestoTrabajo								AS CodigoTipoPuestoTrabajo,
					G.TC_Descripcion										AS DescripcionTipoPuestoTrabajo,
					G.TF_Inicio_Vigencia									AS FechaInicioTipoPuestoTrabajo,
					G.TF_Fin_Vigencia										AS FechaFinTipoPuestoTrabajo,
					H.TC_CodContexto										AS CodigoContexto,
					H.TC_Descripcion										AS DescripcionContexto,
					H.TF_Inicio_Vigencia									AS FechaInicioContexto,
					H.TF_Fin_Vigencia										AS FechaFinContexto
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
		LEFT JOIN	Catalogo.TareaContextoTipoPuestoTrabajo					AS F WITH(Nolock)
		ON			A.TN_CodTarea											= F.TN_CodTarea
		AND			F.TN_CodTipoPuestoTrabajo								= @L_TN_CodTipoPuestoTrabajo
		AND			F.TC_CodContexto										= @L_TC_CodContexto
		LEFT JOIN	Catalogo.TipoPuestoTrabajo								AS G WITH(NoLock)
		ON			G.TN_CodTipoPuestoTrabajo								= F.TN_CodTipoPuestoTrabajo
		LEFT JOIN	Catalogo.Contexto										AS H WITH(NoLock)
		ON			H.TC_CodContexto										= F.TC_CodContexto
		WHERE		A.TN_CodTarea											= COALESCE(@L_TN_CodTarea, A.TN_CodTarea)
		AND			A.TN_CodTipoOficina										= COALESCE(@L_TN_CodTipoOficina, A.TN_CodTipoOficina)
		AND			A.TC_CodMateria											= COALESCE(@L_TC_CodMateria, A.TC_CodMateria)
		AND			A.TN_CodTarea	NOT IN
		(
			SELECT  TN_CodTarea
			FROM	Catalogo.TareaContextoTipoPuestoTrabajo
			WHERE	TN_CodTarea									=	F.TN_CodTarea
			AND		TC_CodContexto								=	@L_TC_CodContexto
			AND		TN_CodTipoPuestoTrabajo						=	@L_TN_CodTipoPuestoTrabajo
		)
		ORDER BY	B.TC_Descripcion, D.TC_Descripcion;
	END
End
GO
