SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ========================================================================================================================================================
-- Autor:				<Jonathan Aguilar Navarro>
-- Fecha Creación:		<23/03/2018>
-- Descripcion:			<Permite consultar los registros de la tabla Catalogo.ContextoPuestoTrabajo>
-- ========================================================================================================================================================
-- Modificación			<Jonathan Aguilar Navarro> <03/08/2018> <Se agrega el tipooficina a la consulta>
-- Modificación			<Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- Modificación:		<06/11/2018> <Andrés Díaz> <Se renombra 'TF_InicioVigencia' a 'TF_Inicio_Vigencia'.>
-- Modificación:		<03/06/2020> <Aida E Siles> <Se agrega validación cuando el parametro del usuario se envia nulo>
-- Modificación:		<12/08/2020> <Isaac Dobles Mata> <Se cambia a LEFT JOIN con el tipo de funcionario>
-- Modificación:		<17/12/2020> <Aida Elena Siles R> <Se agrega inner join con tabla Catalogo.TipoPuestoTrabajo para obtener el tipo funcionario. Adicionalmente
--						se detecta un problema en el SP que no esta validando los puestos de trabajo activos. Reportado por Olger. Se hace la corrección.>
-- Modificación:		<28/04/2021> <Isaac Dobles Mata> <Se agrega validacion para que se obtenga los puestos de trabajo vigentes y con funcionario asignado.>
-- ========================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarContextoPuestoTrabajo]
	@CodContexto			VARCHAR(4)		= NULL,
	@CodOficina				VARCHAR(4)		= NULL,
	@CodPuestoTrabajo		VARCHAR(14)		= NULL,
	@UsuarioRed				VARCHAR(30)		= NULL,
	@CatalogoIntermedio		BIT				= 0,
	@InicioVigencia		    DATETIME2		= NULL	
AS
BEGIN
--VARIABLES
DECLARE	@L_CodContexto				VARCHAR(4)		= @CodContexto,
		@L_CodOficina				VARCHAR(4)		= @CodOficina,
		@L_CodPuestoTrabajo			VARCHAR(14)		= @CodPuestoTrabajo,
		@L_UsuarioRed				VARCHAR(30)		= @UsuarioRed,
		@L_CatalogoIntermedio		BIT				= @CatalogoIntermedio,
		@L_InicioVigencia		    DATETIME2		= @InicioVigencia	
--LÓGICA
	IF @L_InicioVigencia IS NOT NULL
	BEGIN
		SELECT		A.TF_Inicio_Vigencia			AS	FechaAsociacion,
				B.TC_CodPuestoTrabajo			AS  Codigo, 
				B.TC_Descripcion				AS	Descripcion,
				B.TF_Inicio_Vigencia			AS  FechaActivacion, 
				B.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'SplitContexto'					AS  SplitContexto,
				C.TC_CodContexto				AS	Codigo,
				C.TC_Descripcion				AS	Descripcion,
				C.TF_Inicio_Vigencia			AS	FechaActivacion,	
				C.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'SplitMateria'					AS  SplitMateria,
				C.TC_CodMateria					AS	Codigo,
				'SplitOficina'					AS	SplitOficina,
				D.TC_CodOficina					AS	Codigo,
				D.TC_Nombre						AS	Descripcion,
				'SplitTipoOficina'				AS	SplitTipoOficina,
				F.TN_CodTipoOficina				AS	Codigo,
				F.TC_Descripcion				AS	Descripcion,
				'SplitPuesto'					AS	SplitPuesto,	
				B.TC_CodPuestoTrabajo			AS	Codigo,
				B.TC_Descripcion				AS	Descripcion,
				'SplitFuncionario'				AS	SplitFuncionario,
				G.TN_CodTipoFuncionario			AS	Codigo,
				G.TC_Descripcion				AS	Descripcion,
				E.UsuarioRed					AS	UsuarioRed,
				E.Nombre						AS	Nombre,
				E.PrimerApellido				AS	PrimerApellido,
				E.SegundoApellido				AS	SegundoApellido,
				E.CodigoPlaza					AS	CodigoPlaza,
				E.FechaActivacion				AS	FechaActivacion,
				E.FechaDesactivacion			AS	FechaDesactivacion
	FROM		Catalogo.ContextoPuestoTrabajo	AS	A WITH(NOLOCK)
	INNER JOIN	Catalogo.PuestoTrabajo			AS	B WITH(NOLOCK)
	ON			B.TC_CodPuestoTrabajo			=	A.TC_CodPuestoTrabajo
	INNER JOIN	Catalogo.Contexto				AS	C WITH(NOLOCK)
	ON			C.TC_CodContexto				=	A.TC_CodContexto
	INNER JOIN	Catalogo.Oficina				AS	D WITH(NOLOCK)
	ON			D.TC_CodOficina					=	C.TC_CodOficina
	INNER JOIN	Catalogo.TipoOficina			AS	F WITH(NOLOCK)
	ON			F.TN_CodTipoOficina				=	D.TN_CodTipoOficina
	OUTER APPLY	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) AS E
	INNER JOIN	Catalogo.TipoPuestoTrabajo		AS	TP WITH(NOLOCK)
	ON			TP.TN_CodTipoPuestoTrabajo		=	B.TN_CodTipoPuestoTrabajo
	INNER JOIN	Catalogo.TipoFuncionario		AS	G WITH(NOLOCK)
	ON			G.TN_CodTipoFuncionario			=	TP.TN_CodTipoFuncionario
	WHERE		A.TC_CodContexto				=	COALESCE(@L_CodContexto, A.TC_CodContexto) 
	AND			A.TC_CodPuestoTrabajo			=	COALESCE(@L_CodPuestoTrabajo, A.TC_CodPuestoTrabajo)
	AND			D.TC_CodOficina					=	COALESCE(@L_CodOficina, D.TC_CodOficina)
	And			A.TF_Inicio_Vigencia			<=	CASE WHEN @L_InicioVigencia IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END			
	AND			B.TF_Inicio_Vigencia			<	GETDATE()
	AND			(	
					B.TF_Fin_Vigencia				IS NULL
				 OR
					B.TF_Fin_Vigencia			>=	GETDATE()
				)
	AND			E.Codigo						IS NOT NULL
	ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
	END
	ELSE IF @L_UsuarioRed IS NULL AND @L_CatalogoIntermedio = 0
	BEGIN
		SELECT		A.TF_Inicio_Vigencia			AS	FechaAsociacion,
				B.TC_CodPuestoTrabajo			AS  Codigo, 
				B.TC_Descripcion				AS	Descripcion,
				B.TF_Inicio_Vigencia			AS  FechaActivacion, 
				B.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'SplitContexto'					AS  SplitContexto,
				C.TC_CodContexto				AS	Codigo,
				C.TC_Descripcion				AS	Descripcion,
				C.TF_Inicio_Vigencia			AS	FechaActivacion,	
				C.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'SplitMateria'					AS  SplitMateria,
				C.TC_CodMateria					AS	Codigo,
				'SplitOficina'					AS	SplitOficina,
				D.TC_CodOficina					AS	Codigo,
				D.TC_Nombre						AS	Descripcion,
				'SplitTipoOficina'				AS	SplitTipoOficina,
				F.TN_CodTipoOficina				AS	Codigo,
				F.TC_Descripcion				AS	Descripcion,
				'SplitPuesto'					AS	SplitPuesto,	
				B.TC_CodPuestoTrabajo			AS	Codigo,
				B.TC_Descripcion				AS	Descripcion,
				'SplitFuncionario'				AS	SplitFuncionario,
				G.TN_CodTipoFuncionario			AS	Codigo,
				G.TC_Descripcion				AS	Descripcion,
				E.UsuarioRed					AS	UsuarioRed,
				E.Nombre						AS	Nombre,
				E.PrimerApellido				AS	PrimerApellido,
				E.SegundoApellido				AS	SegundoApellido,
				E.CodigoPlaza					AS	CodigoPlaza,
				E.FechaActivacion				AS	FechaActivacion,
				E.FechaDesactivacion			AS	FechaDesactivacion
	FROM		Catalogo.ContextoPuestoTrabajo	AS	A WITH(NOLOCK)
	INNER JOIN	Catalogo.PuestoTrabajo			AS	B WITH(NOLOCK)
	ON			B.TC_CodPuestoTrabajo			=	A.TC_CodPuestoTrabajo
	INNER JOIN	Catalogo.Contexto				AS	C WITH(NOLOCK)
	ON			C.TC_CodContexto				=	A.TC_CodContexto
	INNER JOIN	Catalogo.Oficina				AS	D WITH(NOLOCK)
	ON			D.TC_CodOficina					=	C.TC_CodOficina
	INNER JOIN	Catalogo.TipoOficina			AS	F WITH(NOLOCK)
	ON			F.TN_CodTipoOficina				=	D.TN_CodTipoOficina
	OUTER APPLY	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) AS E
	INNER JOIN	Catalogo.TipoPuestoTrabajo		AS	TP WITH(NOLOCK)
	ON			TP.TN_CodTipoPuestoTrabajo		=	B.TN_CodTipoPuestoTrabajo
	INNER JOIN	Catalogo.TipoFuncionario		AS	G WITH(NOLOCK)
	ON			G.TN_CodTipoFuncionario			=	TP.TN_CodTipoFuncionario
	WHERE		A.TC_CodContexto				=	COALESCE(@L_CodContexto, A.TC_CodContexto) 
	AND			A.TC_CodPuestoTrabajo			=	COALESCE(@L_CodPuestoTrabajo, A.TC_CodPuestoTrabajo)
	AND			D.TC_CodOficina					=	COALESCE(@L_CodOficina, D.TC_CodOficina)
	And			A.TF_Inicio_Vigencia			<=	CASE WHEN @L_InicioVigencia IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END			
	AND			B.TF_Inicio_Vigencia			<	GETDATE()
	AND			(	
					B.TF_Fin_Vigencia				IS NULL
				 OR
					B.TF_Fin_Vigencia			>=	GETDATE()
				)
	ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
	END
	ELSE IF @L_UsuarioRed IS NOT NULL AND @L_CatalogoIntermedio = 0
	BEGIN
		SELECT	A.TF_Inicio_Vigencia			AS	FechaAsociacion,
				B.TC_CodPuestoTrabajo			AS  Codigo, 
				B.TC_Descripcion				AS	Descripcion,
				B.TF_Inicio_Vigencia			AS  FechaActivacion, 
				B.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'SplitContexto'					AS  SplitContexto,
				C.TC_CodContexto				AS	Codigo,
				C.TC_Descripcion				AS	Descripcion,
				C.TF_Inicio_Vigencia			AS	FechaActivacion,	
				C.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'SplitMateria'					AS  SplitMateria,
				C.TC_CodMateria					AS	Codigo,
				'SplitOficina'					AS	SplitOficina,
				D.TC_CodOficina					AS	Codigo,
				D.TC_Nombre						AS	Descripcion,
				'SplitTipoOficina'				AS	SplitTipoOficina,
				F.TN_CodTipoOficina				AS	Codigo,
				F.TC_Descripcion				AS	Descripcion,
				'SplitPuesto'					AS	SplitPuesto,	
				B.TC_CodPuestoTrabajo			AS	Codigo,
				B.TC_Descripcion				AS	Descripcion,
				'SplitFuncionario'				AS	SplitFuncionario,
				G.TN_CodTipoFuncionario			AS	Codigo,
				G.TC_Descripcion				AS	Descripcion,
				E.UsuarioRed					AS	UsuarioRed,
				E.Nombre						AS	Nombre,
				E.PrimerApellido				AS	PrimerApellido,
				E.SegundoApellido				AS	SegundoApellido,
				E.CodigoPlaza					AS	CodigoPlaza,
				E.FechaActivacion				AS	FechaActivacion,
				E.FechaDesactivacion			AS	FechaDesactivacion
	FROM		Catalogo.ContextoPuestoTrabajo	AS	A WITH(NOLOCK)
	INNER JOIN	Catalogo.PuestoTrabajo			AS	B WITH(NOLOCK)
	ON			B.TC_CodPuestoTrabajo			=	A.TC_CodPuestoTrabajo
	INNER JOIN	Catalogo.Contexto				AS	C WITH(NOLOCK)
	ON			C.TC_CodContexto				=	A.TC_CodContexto
	INNER JOIN	Catalogo.Oficina				AS	D WITH(NOLOCK)
	ON			D.TC_CodOficina					=	C.TC_CodOficina
	INNER JOIN	Catalogo.TipoOficina			AS	F WITH(NOLOCK)
	ON			F.TN_CodTipoOficina				=	D.TN_CodTipoOficina
	OUTER APPLY	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) AS E
	INNER JOIN	Catalogo.TipoPuestoTrabajo		AS	TP WITH(NOLOCK)
	ON			TP.TN_CodTipoPuestoTrabajo		=	B.TN_CodTipoPuestoTrabajo
	INNER JOIN	Catalogo.TipoFuncionario		AS	G WITH(NOLOCK)
	ON			G.TN_CodTipoFuncionario			=	TP.TN_CodTipoFuncionario
	WHERE		A.TC_CodContexto				=	COALESCE(@L_CodContexto, A.TC_CodContexto) 
	AND			A.TC_CodPuestoTrabajo			=	COALESCE(@L_CodPuestoTrabajo, A.TC_CodPuestoTrabajo)
	AND			D.TC_CodOficina					=	COALESCE(@L_CodOficina, D.TC_CodOficina)
	AND			E.UsuarioRed					=	COALESCE(@L_UsuarioRed, E.UsuarioRed)
	And			A.TF_Inicio_Vigencia			<=	CASE WHEN @L_InicioVigencia IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
	AND			B.TF_Inicio_Vigencia			<	GETDATE()
	AND			(	
					B.TF_Fin_Vigencia				IS NULL
				 OR
					B.TF_Fin_Vigencia			>=	GETDATE()
				)
	ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
	END
	ELSE IF @L_UsuarioRed IS NULL AND @L_CatalogoIntermedio = 1
	BEGIN
		SELECT		A.TF_Inicio_Vigencia			AS	FechaAsociacion,
				B.TC_CodPuestoTrabajo			AS  Codigo, 
				B.TC_Descripcion				AS	Descripcion,
				B.TF_Inicio_Vigencia			AS  FechaActivacion, 
				B.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'SplitContexto'					AS  SplitContexto,
				C.TC_CodContexto				AS	Codigo,
				C.TC_Descripcion				AS	Descripcion,
				C.TF_Inicio_Vigencia			AS	FechaActivacion,	
				C.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'SplitMateria'					AS  SplitMateria,
				C.TC_CodMateria					AS	Codigo,
				'SplitOficina'					AS	SplitOficina,
				D.TC_CodOficina					AS	Codigo,
				D.TC_Nombre						AS	Descripcion,
				'SplitTipoOficina'				AS	SplitTipoOficina,
				F.TN_CodTipoOficina				AS	Codigo,
				F.TC_Descripcion				AS	Descripcion,
				'SplitPuesto'					AS	SplitPuesto,	
				B.TC_CodPuestoTrabajo			AS	Codigo,
				B.TC_Descripcion				AS	Descripcion,
				'SplitFuncionario'				AS	SplitFuncionario,
				G.TN_CodTipoFuncionario			AS	Codigo,
				G.TC_Descripcion				AS	Descripcion,
				E.UsuarioRed					AS	UsuarioRed,
				E.Nombre						AS	Nombre,
				E.PrimerApellido				AS	PrimerApellido,
				E.SegundoApellido				AS	SegundoApellido,
				E.CodigoPlaza					AS	CodigoPlaza,
				E.FechaActivacion				AS	FechaActivacion,
				E.FechaDesactivacion			AS	FechaDesactivacion
	FROM		Catalogo.ContextoPuestoTrabajo	AS	A WITH(NOLOCK)
	INNER JOIN	Catalogo.PuestoTrabajo			AS	B WITH(NOLOCK)
	ON			B.TC_CodPuestoTrabajo			=	A.TC_CodPuestoTrabajo
	INNER JOIN	Catalogo.Contexto				AS	C WITH(NOLOCK)
	ON			C.TC_CodContexto				=	A.TC_CodContexto
	INNER JOIN	Catalogo.Oficina				AS	D WITH(NOLOCK)
	ON			D.TC_CodOficina					=	C.TC_CodOficina
	INNER JOIN	Catalogo.TipoOficina			AS	F WITH(NOLOCK)
	ON			F.TN_CodTipoOficina				=	D.TN_CodTipoOficina
	OUTER APPLY	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) AS E
	INNER JOIN	Catalogo.TipoPuestoTrabajo		AS	TP WITH(NOLOCK)
	ON			TP.TN_CodTipoPuestoTrabajo		=	B.TN_CodTipoPuestoTrabajo
	INNER JOIN	Catalogo.TipoFuncionario		AS	G WITH(NOLOCK)
	ON			G.TN_CodTipoFuncionario			=	TP.TN_CodTipoFuncionario
	WHERE		A.TC_CodContexto				=	COALESCE(@L_CodContexto, A.TC_CodContexto) 
	AND			A.TC_CodPuestoTrabajo			=	COALESCE(@L_CodPuestoTrabajo, A.TC_CodPuestoTrabajo)
	AND			D.TC_CodOficina					=	COALESCE(@L_CodOficina, D.TC_CodOficina)
	ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
	END
	ELSE IF @L_UsuarioRed IS NOT NULL AND @L_CatalogoIntermedio = 1
	BEGIN
		SELECT	A.TF_Inicio_Vigencia			AS	FechaAsociacion,
				B.TC_CodPuestoTrabajo			AS  Codigo, 
				B.TC_Descripcion				AS	Descripcion,
				B.TF_Inicio_Vigencia			AS  FechaActivacion, 
				B.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'SplitContexto'					AS  SplitContexto,
				C.TC_CodContexto				AS	Codigo,
				C.TC_Descripcion				AS	Descripcion,
				C.TF_Inicio_Vigencia			AS	FechaActivacion,	
				C.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'SplitMateria'					AS  SplitMateria,
				C.TC_CodMateria					AS	Codigo,
				'SplitOficina'					AS	SplitOficina,
				D.TC_CodOficina					AS	Codigo,
				D.TC_Nombre						AS	Descripcion,
				'SplitTipoOficina'				AS	SplitTipoOficina,
				F.TN_CodTipoOficina				AS	Codigo,
				F.TC_Descripcion				AS	Descripcion,
				'SplitPuesto'					AS	SplitPuesto,	
				B.TC_CodPuestoTrabajo			AS	Codigo,
				B.TC_Descripcion				AS	Descripcion,
				'SplitFuncionario'				AS	SplitFuncionario,
				G.TN_CodTipoFuncionario			AS	Codigo,
				G.TC_Descripcion				AS	Descripcion,
				E.UsuarioRed					AS	UsuarioRed,
				E.Nombre						AS	Nombre,
				E.PrimerApellido				AS	PrimerApellido,
				E.SegundoApellido				AS	SegundoApellido,
				E.CodigoPlaza					AS	CodigoPlaza,
				E.FechaActivacion				AS	FechaActivacion,
				E.FechaDesactivacion			AS	FechaDesactivacion
	FROM		Catalogo.ContextoPuestoTrabajo	AS	A WITH(NOLOCK)
	INNER JOIN	Catalogo.PuestoTrabajo			AS	B WITH(NOLOCK)
	ON			B.TC_CodPuestoTrabajo			=	A.TC_CodPuestoTrabajo
	INNER JOIN	Catalogo.Contexto				AS	C WITH(NOLOCK)
	ON			C.TC_CodContexto				=	A.TC_CodContexto
	INNER JOIN	Catalogo.Oficina				AS	D WITH(NOLOCK)
	ON			D.TC_CodOficina					=	C.TC_CodOficina
	INNER JOIN	Catalogo.TipoOficina			AS	F WITH(NOLOCK)
	ON			F.TN_CodTipoOficina				=	D.TN_CodTipoOficina
	OUTER APPLY	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) AS E
	INNER JOIN	Catalogo.TipoPuestoTrabajo		AS	TP WITH(NOLOCK)
	ON			TP.TN_CodTipoPuestoTrabajo		=	B.TN_CodTipoPuestoTrabajo
	INNER JOIN	Catalogo.TipoFuncionario		AS	G WITH(NOLOCK)
	ON			G.TN_CodTipoFuncionario			=	TP.TN_CodTipoFuncionario
	WHERE		A.TC_CodContexto				=	COALESCE(@L_CodContexto, A.TC_CodContexto) 
	AND			A.TC_CodPuestoTrabajo			=	COALESCE(@L_CodPuestoTrabajo, A.TC_CodPuestoTrabajo)
	AND			D.TC_CodOficina					=	COALESCE(@L_CodOficina, D.TC_CodOficina)
	AND			E.UsuarioRed					=	COALESCE(@L_UsuarioRed, E.UsuarioRed)
	ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
	END
END
GO
