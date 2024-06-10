SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Jeffry Hernández>
-- Fecha Creación:		<12/07/2017>
-- Descripcion:			<Permite consultar los registros de la tabla Catalogo.TipoOficinaMateria >
-- =================================================================================================================================================
-- Modificación:		<04/01/2018> <Andrés Díaz> <Se tabula el PA.>
-- Modificación:		<06/11/2018> <Andrés Díaz> <Se renombra 'TF_InicioVigencia' a 'TF_Inicio_Vigencia'.>
-- Modificación:		<05/07/2022> <Jose Gabriel Cordero Soto> <Se agrega parametro de FechaActivacion con el fin de obtener los registros activos entre Materia, TipoOficina y TipoOficinaMateria>
-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarTipoOficinaMateria]
	@CodTipoOficina			SmallInt	= NULL,
	@CodMateria				Varchar(5)	= NULL,
	@InicioVigencia		    DateTime2	= NULL,
@FechaActivacion		Datetime2   = NULL
As
BEGIN

	DECLARE @L_CodTipoOficina			SmallInt	= @CodTipoOficina,
			@L_CodMateria				Varchar(5)	= @CodMateria,
			@L_InicioVigencia		    DateTime2	= @InicioVigencia,
			@L_FechaActivacion			Datetime2   = @FechaActivacion 

	IF (@FechaActivacion IS NULL) --EN CASO DE QUE LA FECHA ASOCIACION ESTE NULO, EJECUTA EL SELECT SEGÚN CONSULTA ORIGINAL
	BEGIN
		SELECT		A.TF_Inicio_Vigencia			As	FechaAsociacion,
					B.TN_CodTipoOficina				As  Codigo, 
					B.TC_Descripcion				As	Descripcion,
					B.TF_Inicio_Vigencia			As  FechaActivacion, 
					B.TF_Fin_Vigencia				As	FechaDesactivacion,
					'SplitMateria'					As  SplitMateria,
					C.TC_CodMateria					As	Codigo,
					C.TC_Descripcion				As	Descripcion,
					C.TB_EjecutaRemate				As	EjecutaRemate,
					C.TF_Inicio_Vigencia			As	FechaActivacion,	
					C.TF_Fin_Vigencia				As	FechaDesactivacion

		FROM		Catalogo.TipoOficinaMateria		As	A
		INNER JOIN	Catalogo.TipoOficina			As	B
		ON			A.TN_CodTipoOficina				= 	B.TN_CodTipoOficina
		INNER JOIN	Catalogo.Materia				As	C
		ON			A.TC_CodMateria					=	C.TC_CodMateria

		WHERE		A.TC_CodMateria					=	COALESCE(@L_CodMateria, A.TC_CodMateria)
		AND			A.TN_CodTipoOficina				=	COALESCE(@L_CodTipoOficina, A.TN_CodTipoOficina)
		AND			A.TF_Inicio_Vigencia			<=	CASE WHEN @L_InicioVigencia IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
		
		ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
END
	ELSE
	BEGIN 
		SELECT		A.TF_Inicio_Vigencia			As	FechaAsociacion,
					B.TN_CodTipoOficina				As  Codigo, 
					B.TC_Descripcion				As	Descripcion,
					B.TF_Inicio_Vigencia			As  FechaActivacion, 
					B.TF_Fin_Vigencia				As	FechaDesactivacion,
					'SplitMateria'					As  SplitMateria,
					C.TC_CodMateria					As	Codigo,
					C.TC_Descripcion				As	Descripcion,
					C.TB_EjecutaRemate				As	EjecutaRemate,
					C.TF_Inicio_Vigencia			As	FechaActivacion,	
					C.TF_Fin_Vigencia				As	FechaDesactivacion

		FROM		Catalogo.TipoOficinaMateria		As	A WITH(NOLOCK)
		INNER JOIN	Catalogo.TipoOficina			As	B WITH(NOLOCK)
		ON			A.TN_CodTipoOficina				= 	B.TN_CodTipoOficina
		INNER JOIN	Catalogo.Materia				As	C WITH(NOLOCK)
		ON			A.TC_CodMateria					=	C.TC_CodMateria

		Where		A.TC_CodMateria					=	COALESCE(@L_CodMateria, A.TC_CodMateria)
		AND			A.TN_CodTipoOficina				=	COALESCE(@L_CodTipoOficina, A.TN_CodTipoOficina)
		AND			A.TF_Inicio_Vigencia			<=	CASE WHEN @L_InicioVigencia IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
		AND			(B.TF_Fin_Vigencia				IS  NULL
		OR			 B.TF_Fin_Vigencia				<=  @L_FechaActivacion)
		AND			(C.TF_Fin_Vigencia				IS  NULL
		OR			 C.TF_Fin_Vigencia				<=  @L_FechaActivacion)
		
		ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
	END	
END
GO
