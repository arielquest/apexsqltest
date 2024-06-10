SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Miguel Avendaño Rosales>
-- Fecha de creación:		<21/07/2021>
-- Descripción :			<Permite consultar los motivos de devolucion de pase a fallo asociados a materia> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarMotivoDevolucionPaseFalloMateria]
	@CodMotivoDevolucion	SMALLINT		=	NULL,
	@CodMateria				VARCHAR(5)		=	NULL,
	@InicioVigencia			DATETIME2(7)	=	NULL
 AS
 BEGIN
 -- VARIABLES
 DECLARE	@L_CodMotivoDevolucion		SMALLINT		= @CodMotivoDevolucion,
			@L_CodMateria				VARCHAR(5)		= @CodMateria,
			@L_InicioVigencia			DATETIME2(7)	= @InicioVigencia

--Registros activos
	IF @L_InicioVigencia IS NOT NULL
	BEGIN
		SELECT		A.TN_CodMotivoDevolucion					AS	Codigo,
					B.TC_Descripcion							AS	Descripcion,
					B.TF_Inicio_Vigencia						AS	FechaActivacion,
					B.TF_Fin_Vigencia							AS	FechaDesactivacion,
					A.TF_Inicio_Vigencia						AS  FechaAsociacion,
					'Split'										AS	SplitMateria,
					C.TC_CodMateria								AS  Codigo,
					C.TC_Descripcion							AS	Descripcion,
					'Split'										AS	SplitOtros,
					B.TC_TipoMotivo								AS	TipoMotivo
		FROM		Catalogo.MotivoDevolucionPaseFalloMateria	AS	A	WITH(NOLOCK) 	
		INNER JOIN	Catalogo.MotivoDevolucionPaseFallo			AS	B	WITH(NOLOCK) 	
		ON			B.TN_CodMotivoDevolucion					=	A.TN_CodMotivoDevolucion
		INNER JOIN	Catalogo.Materia							AS	C	WITH(NOLOCK) 	
		ON			C.TC_CodMateria								= 	A.TC_CodMateria		
		WHERE		A.TN_CodMotivoDevolucion					=	COALESCE(@L_CodMotivoDevolucion, A.TN_CodMotivoDevolucion)
		AND			A.TC_CodMateria								=	COALESCE(@L_CodMateria, A.TC_CodMateria)
		AND			A.TF_Inicio_Vigencia						< GETDATE()
		ORDER BY	B.TC_Descripcion
	END
	ELSE
	BEGIN
		SELECT		A.TN_CodMotivoDevolucion					AS	Codigo,
					B.TC_Descripcion							AS	Descripcion,
					B.TF_Inicio_Vigencia						AS	FechaActivacion,
					B.TF_Fin_Vigencia							AS	FechaDesactivacion,
					A.TF_Inicio_Vigencia						AS  FechaAsociacion,
					'Split'										AS	SplitMateria,
					C.TC_CodMateria								AS  Codigo,
					C.TC_Descripcion							AS	Descripcion,
					'Split'										AS	SplitOtros,
					B.TC_TipoMotivo								AS	TipoMotivo
		FROM		Catalogo.MotivoDevolucionPaseFalloMateria	AS	A	WITH(NOLOCK) 	
		INNER JOIN	Catalogo.MotivoDevolucionPaseFallo			AS	B	WITH(NOLOCK) 	
		ON			B.TN_CodMotivoDevolucion					=	A.TN_CodMotivoDevolucion
		INNER JOIN	Catalogo.Materia							AS	C	WITH(NOLOCK) 	
		ON			C.TC_CodMateria								= 	A.TC_CodMateria		
		WHERE		A.TN_CodMotivoDevolucion					=	COALESCE(@L_CodMotivoDevolucion, A.TN_CodMotivoDevolucion)
		AND			A.TC_CodMateria								=	COALESCE(@L_CodMateria, A.TC_CodMateria)
		ORDER BY	B.TC_Descripcion
	END
 END
GO
