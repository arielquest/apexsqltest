SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida Elena Siles Rojas>
-- Fecha de creación:		<02/03/2021>
-- Descripción :			<Permite consultar el legajodetalle de un legajo.> 
-- =================================================================================================================================================================================
-- Modificación:	<Luis Alonso Leiva Tames> <30/4/2021> <Se agrega los campos de descripcion y prioridad del legajo>
-- Modificación:	<Roger Lara> <26/05/2021> <Se devuelve el proceso asociado al legajo>



CREATE PROCEDURE [Expediente].[PA_ConsultarLegajoDetalle]
	@CodLegajo					UNIQUEIDENTIFIER	= NULL,
	@CodContexto				VARCHAR(4)			= NULL,
	@ObtenerUltimoLD			BIT					= 0
AS
BEGIN
--Declaración de variables
DECLARE @L_CodLegajo			UNIQUEIDENTIFIER	= @CodLegajo
DECLARE @L_CodContexto			VARCHAR(4)			= @CodContexto
DECLARE @L_ObtenerUltimoLD		BIT					= @ObtenerUltimoLD

IF (@L_ObtenerUltimoLD = 0)
	BEGIN
		SELECT		A.TU_CodLegajo					AS Codigo,
					A.TF_Entrada					AS FechaEntrada, 
					L.TC_Descripcion				AS Descripcion,
					'SplitOtrosDatos'				AS SplitOtrosDatos,
					L.TN_CodPrioridad				AS CodigoPrioridad,
					A.TC_CodContexto				AS CodContexto,
					B.TC_Descripcion				AS ContextoDescrip,
					A.TN_CodAsunto					AS CodAsunto,
					E.TC_Descripcion				AS AsuntoDescrip,
					A.TN_CodClaseAsunto				AS CodigoClaseAsunto,
					D.TC_Descripcion				AS ClaseAsuntoDescrip,
					A.TC_CodContextoProcedencia		AS CodContextoProcedencia,
					C.TC_Descripcion				AS ContextoProcedenciaDescrip,
					A.TN_CodGrupoTrabajo			AS CodGrupoTrabajo,
					F.TC_Descripcion				AS GrupoTrabajoDescrip,
					A.TB_Habilitado					AS Habilitado,
					PO.TN_CodProceso				AS  CodigoProceso,
					PO.TC_Descripcion				AS  DescripcionProceso
		FROM		Expediente.LegajoDetalle		A WITH(NOLOCK)
		INNER JOIN	Catalogo.Contexto				B WITH(NOLOCK)
		ON			A.TC_CodContexto				= B.TC_CodContexto
		INNER JOIN Expediente.Legajo				L WITH(NOLOCK)
		ON			A.TU_CodLegajo					= L.TU_CodLegajo
		LEFT JOIN	Catalogo.Contexto				C WITH(NOLOCK)
		ON			C.TC_CodContexto				= A.TC_CodContextoProcedencia
		LEFT JOIN	Catalogo.ClaseAsunto			D WITH(NOLOCK)
		ON			D.TN_CodClaseAsunto				= A.TN_CodClaseAsunto
		LEFT JOIN	Catalogo.Asunto					E WITH(NOLOCK)
		ON			E.TN_CodAsunto					= A.TN_CodAsunto	
		LEFT JOIN	Catalogo.GrupoTrabajo			F WITH(NOLOCK)
		ON			F.TN_CodGrupoTrabajo			= A.TN_CodGrupoTrabajo
        LEFT JOIN	Catalogo.Proceso				AS  PO WITH (NOLOCK)
	    ON			PO.TN_CodProceso				=	A.TN_CodProceso
		WHERE		A.TU_CodLegajo					= @L_CodLegajo
		AND			A.TC_CodContexto				= COALESCE(@L_CodContexto, A.TC_CodContexto)
	END
ELSE
	BEGIN
		SELECT		TOP 1
					A.TU_CodLegajo					AS Codigo,
					A.TF_Entrada					AS FechaEntrada,
					L.TC_Descripcion				AS Descripcion,
					'SplitOtrosDatos'				AS SplitOtrosDatos,
					L.TN_CodPrioridad				AS CodigoPrioridad,A.TC_CodContexto				AS CodContexto,
					B.TC_Descripcion				AS ContextoDescrip,
					A.TN_CodAsunto					AS CodAsunto,
					E.TC_Descripcion				AS AsuntoDescrip,
					A.TN_CodClaseAsunto				AS CodigoClaseAsunto,
					D.TC_Descripcion				AS ClaseAsuntoDescrip,
					A.TC_CodContextoProcedencia		AS CodContextoProcedencia,
					C.TC_Descripcion				AS ContextoProcedenciaDescrip,
					A.TN_CodGrupoTrabajo			AS CodGrupoTrabajo,
					F.TC_Descripcion				AS GrupoTrabajoDescrip,
					A.TB_Habilitado					AS Habilitado,
					PO.TN_CodProceso				AS  CodigoProceso,
					PO.TC_Descripcion				AS  DescripcionProceso
		FROM		Expediente.LegajoDetalle		A WITH(NOLOCK)
		INNER JOIN	Catalogo.Contexto				B WITH(NOLOCK)
		ON			A.TC_CodContexto				= B.TC_CodContexto
		INNER JOIN Expediente.Legajo				L WITH(NOLOCK)
		ON			A.TU_CodLegajo					= L.TU_CodLegajo
		LEFT JOIN	Catalogo.Contexto				C WITH(NOLOCK)
		ON			C.TC_CodContexto				= A.TC_CodContextoProcedencia
		LEFT JOIN	Catalogo.ClaseAsunto			D WITH(NOLOCK)
		ON			D.TN_CodClaseAsunto				= A.TN_CodClaseAsunto
		LEFT JOIN	Catalogo.Asunto					E WITH(NOLOCK)
		ON			E.TN_CodAsunto					= A.TN_CodAsunto	
		LEFT JOIN	Catalogo.GrupoTrabajo			F WITH(NOLOCK)
		ON			F.TN_CodGrupoTrabajo			= A.TN_CodGrupoTrabajo
        LEFT JOIN	Catalogo.Proceso				AS  PO WITH (NOLOCK)
	    ON			PO.TN_CodProceso				=	A.TN_CodProceso
		WHERE		A.TU_CodLegajo					= @L_CodLegajo
		ORDER BY	A.TF_Entrada					DESC
	END
END


GO
