SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Miguel Avendaño>
-- Fecha de creación:		<07/01/2021>
-- Descripción :			<Permite consultar las materias asociadas a los tipos de evento.
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEstadoEventoTipoOficina]
	@CodEstadoEvento	SMALLINT,
	@CodTipoOficina		SMALLINT,
	@CodMateria			VARCHAR(5),
	@Inicio_Vigencia	DATETIME2(7)	= NULL
 AS
 BEGIN
 --VARIABLES
 DECLARE
 	@L_CodEstadoEvento		SMALLINT		= @CodEstadoEvento,
	@L_CodTipoOficina		SMALLINT		= @CodTipoOficina,
	@L_CodMateria			VARCHAR(5)		= @CodMateria,
	@L_Inicio_Vigencia		DATETIME2(7)	= @Inicio_Vigencia

	--Registros activos
	IF @Inicio_Vigencia  IS NOT NULL 
	BEGIN
		SELECT		A.TF_Inicio_Vigencia				AS  FechaAsociacion,
					'Split'								As	Split, 	
					C.TN_CodEstadoEvento				As	Codigo, 
					C.TC_Descripcion					As	Descripcion, 
					C.TB_FinalizaEvento					As	FinalizaEvento,
					C.TF_Inicio_Vigencia				As	FechaActivacion, 
					C.TF_Fin_Vigencia					As	FechaDesactivacion,
					'Split'								As	Split,
					D.TN_CodTipoOficina					AS	Codigo,
					D.TC_Descripcion					AS  Descripcion,
					D.TF_Inicio_Vigencia				AS	FechaActivacion,
					D.TF_Fin_Vigencia					AS	FechaDesactivacion,
					'Split'								As	Split,
					B.TC_CodMateria						As	Codigo, 
					B.TC_Descripcion					As	Descripcion, 
					B.TF_Inicio_Vigencia				As	FechaActivacion, 
					B.TF_Fin_Vigencia					As	FechaDesactivacion
		FROM		Catalogo.EstadoEventoTipoOficina	As	A WITH(NOLOCK)
		INNER JOIN	Catalogo.Materia					As	B WITH(NOLOCK) 
		ON			B.TC_CodMateria						=	A.TC_CodMateria 
		INNER JOIN	Catalogo.EstadoEvento				As	C WITH(NOLOCK)
		On			C.TN_CodEstadoEvento				=	A.TN_CodEstadoEvento
		INNER JOIN	Catalogo.TipoOficina				AS	D WITH(NOLOCK)
		ON			D.TN_CodTipoOficina					=	A.TN_CodTipoOficina
		WHERE		A.TN_CodEstadoEvento				=	COALESCE(@L_CodEstadoEvento, A.TN_CodEstadoEvento)
		AND			A.TN_CodTipoOficina					=	COALESCE(@L_CodTipoOficina, A.TN_CodTipoOficina)
		AND			A.TC_CodMateria						=	COALESCE(@L_CodMateria, A.TC_CodMateria)
		AND			A.TF_Inicio_Vigencia				<	GETDATE ()
		ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
	END
	-- Todos registros
	ELSE
	BEGIN
		SELECT		A.TF_Inicio_Vigencia				AS  FechaAsociacion,
					'Split'								As	Split, 	
					C.TN_CodEstadoEvento					As	Codigo, 
					C.TC_Descripcion					As	Descripcion, 
					C.TF_Inicio_Vigencia				As	FechaActivacion, 
					C.TF_Fin_Vigencia					As	FechaDesactivacion,
					C.TB_FinalizaEvento					As	FinalizaEvento,
					'Split'								As	Split,
					D.TN_CodTipoOficina					AS	Codigo,
					D.TC_Descripcion					AS  Descripcion,
					D.TF_Inicio_Vigencia				AS	FechaActivacion,
					D.TF_Fin_Vigencia					AS	FechaDesactivacion,
					'Split'								As	Split,
					B.TC_CodMateria						As	Codigo, 
					B.TC_Descripcion					As	Descripcion, 
					B.TF_Inicio_Vigencia				As	FechaActivacion, 
					B.TF_Fin_Vigencia					As	FechaDesactivacion
		FROM		Catalogo.EstadoEventoTipoOficina	As	A WITH(NOLOCK)
		INNER JOIN	Catalogo.Materia					As	B WITH(NOLOCK) 
		ON			B.TC_CodMateria						=	A.TC_CodMateria 
		INNER JOIN	Catalogo.EstadoEvento				As	C WITH(NOLOCK)
		On			C.TN_CodEstadoEvento				=	A.TN_CodEstadoEvento
		INNER JOIN	Catalogo.TipoOficina				AS	D WITH(NOLOCK)
		ON			D.TN_CodTipoOficina					=	A.TN_CodTipoOficina
		WHERE		A.TN_CodEstadoEvento				=	COALESCE(@L_CodEstadoEvento, A.TN_CodEstadoEvento)
		AND			A.TN_CodTipoOficina					=	COALESCE(@L_CodTipoOficina, A.TN_CodTipoOficina)
		AND			A.TC_CodMateria						=	COALESCE(@L_CodMateria, A.TC_CodMateria)
		ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
	End

End
GO
