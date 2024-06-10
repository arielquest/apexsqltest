SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta I>
-- Fecha de creación:		<11/07/2016>
-- Descripción :			<Permite consultar puestos un grupo de trabajo>
-- ============================================================================================================================================================================================================
-- Modificación:			<21/09/2017> <Juan Ramirez> <Se agrega en la consulta los datos de los funcionarios que pertenecen a dicho puesto de trabajo>
-- Modificación:			<2017-11-27> <Andrés Díaz> <Se agrega filtro por código de oficina.>
-- Modificación:			<2018-03-12> <Andrés Díaz> <Se tabula la consulta.>
-- Modificación:			<2018-04-12> <Jonathan Aguilar Navarro> <Se agrega el filtro por código de contexto>
-- Modificación				<Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- Modificación:			<09/12/2020> <Aida Elena Siles R> <Se agrega a la consulta el catalogo tipo puesto de trabajo para poder el obtener el tipo funcionario.>
-- Modificación:			<11/03/2021> <Jose Gabriel Cordero Soto> <Se agrega la información referente al TipoPuestoTrabajo en la consulta de retorno.>
-- Modificación:			<22/06/2021> <Aida Elena Siles R> <Se agrega parámetro de VigenciaCompleta para consultar los registros activos de Catalogo.GrupoTrabajoPuesto como Catalogo.PuestoTrabajo>
-- Modificación:			<16/06/2022> <Jose Gabriel Cordero Soto> <Se agregan parametros de fecha vencimiento de puestotrabajo, grupotrabajo y grupotrabajopuesto en la consulta de registros activos y vigenciacompleta es 0>
-- ============================================================================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarGrupoTrabajoPuesto]
    @CodGrupoTrabajo	SMALLINT	= NULL,
	@CodPuestoTrabajo	VARCHAR(14)	= NULL,
	@CodOficina			VARCHAR(4)	= NULL,
	@CodContexto		VARCHAR(4)	= NULL,
	@FechaAsociacion	DATETIME2	= NULL,
	@VigenciaCompleta   BIT         = 0
 AS
 BEGIN 	
	DECLARE	@L_CodGrupoTrabajo		SMALLINT	= @CodGrupoTrabajo,
			@L_CodPuestoTrabajo		VARCHAR(14)	= @CodPuestoTrabajo,
			@L_CodOficina			VARCHAR(4)	= @CodOficina,
			@L_CodContexto			VARCHAR(4)	= @CodContexto,
			@L_FechaAsociacion		DATETIME2	= @FechaAsociacion,
			@L_VigenciaCompleta		BIT			= @VigenciaCompleta 

	--Registros activos
	IF @FechaAsociacion IS NULL
		IF @L_VigenciaCompleta = 0 --Se consultan solo los activos en Catalogo.GrupoTrabajoPuesto
		BEGIN
		SELECT			A.TC_CodPuestoTrabajo			AS	Codigo,
						A.TC_Descripcion				AS	Descripcion,
						A.TF_Inicio_Vigencia			AS	FechaActivacion,
						A.TF_Fin_Vigencia				AS	FechaDesactivacion,
						E.TF_Inicio_Vigencia			AS	FechaAsociacion,
						'Split'							AS	Split,
						B.TC_CodOficina					AS	Codigo,
						B.TC_Nombre						AS	Descripcion,
						'Split'							AS	Split,
						H.TC_CodContexto				AS	Codigo,
						H.TC_Descripcion				AS	Descripcion,
						'Split'							AS	Split,
						D.TN_CodTipoFuncionario			AS	Codigo,
						D.TC_Descripcion				AS	Descripcion,
						'Split'							AS	Split,
						F.TN_CodGrupoTrabajo			AS	Codigo,
						F.TC_Descripcion				AS	Descripcion, 
						F.TF_Inicio_Vigencia			AS	FechaActivacion,
						F.TF_Fin_Vigencia				AS	FechaDesactivacion,
						'Split'							AS	Split,
						G.UsuarioRed					AS	UsuarioRed,
						G.Nombre						AS	Nombre,
						G.PrimerApellido				AS	PrimerApellido,
						G.SegundoApellido				AS	SegundoApellido,
						G.CodigoPlaza					AS	CodigoPlaza,
						G.FechaActivacion				AS	FechaActivacion,
						G.FechaDesactivacion			AS	FechaDesactivacion,
						P.TN_CodTipoPuestoTrabajo		AS  CodigoTipoPuesto,
						P.TC_Descripcion				AS  DescripcionTipoPuesto,
						P.TF_Inicio_Vigencia			AS  FechaActivacionTipoPuesto,
						P.TF_Fin_Vigencia				AS  FechaDesactivacionTipoPuesto
		FROM			Catalogo.PuestoTrabajo			AS	A WITH(NOLOCK)
		INNER JOIN		Catalogo.Oficina				AS	B WITH(NOLOCK)
		ON				B.TC_CodOficina					=	A.TC_CodOficina
		INNER JOIN		Catalogo.TipoPuestoTrabajo		AS	P WITH(NOLOCK)
		ON				A.TN_CodTipoPuestoTrabajo		=	P.TN_CodTipoPuestoTrabajo
		INNER JOIN		Catalogo.TipoFuncionario		AS	D WITH(NOLOCK)
		ON				D.TN_CodTipoFuncionario			=	P.TN_CodTipoFuncionario	
		INNER JOIN		Catalogo.GrupoTrabajoPuesto		AS	E WITH(NOLOCK)
		ON				E.TC_CodPuestoTrabajo			=	A.TC_CodPuestoTrabajo
		INNER JOIN		Catalogo.GrupoTrabajo			AS	F WITH(NOLOCK)
		ON				F.TN_CodGrupoTrabajo			=	E.TN_CodGrupoTrabajo
		INNER JOIN		Catalogo.Contexto				AS	H WITH(NOLOCK)
		ON				H.TC_CodContexto				=   E.TC_CodContexto  
		OUTER APPLY		Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) AS G			
		WHERE			E.TN_CodGrupoTrabajo			=	ISNULL(@L_CodGrupoTrabajo, E.TN_CodGrupoTrabajo)
		AND				E.TC_CodPuestoTrabajo			=	ISNULL(@L_CodPuestoTrabajo, E.TC_CodPuestoTrabajo)
		AND				A.TC_CodOficina					=	ISNULL(@L_CodOficina,	A.TC_CodOficina)
		AND				H.TC_CodContexto				=	ISNULL(@L_CodContexto, H.TC_CodContexto)
		AND				E.TF_Inicio_Vigencia			<=	GETDATE()
		AND				(A.TF_Fin_Vigencia				IS NULL 
		OR				 A.TF_Fin_Vigencia				>=	GETDATE())
		AND				(F.TF_Fin_Vigencia				IS NULL 
		OR				 F.TF_Fin_Vigencia				>=	GETDATE())
		
		ORDER BY		F.TC_Descripcion;

		END
		ELSE --Se consultan los activos tanto en Catalogo.GrupoTrabajoPuesto como en Catalogo.PuestoTrabajo
		BEGIN
		SELECT			A.TC_CodPuestoTrabajo			AS	Codigo,
						A.TC_Descripcion				AS	Descripcion,
						A.TF_Inicio_Vigencia			AS	FechaActivacion,
						A.TF_Fin_Vigencia				AS	FechaDesactivacion,
						E.TF_Inicio_Vigencia			AS	FechaAsociacion,
						'Split'							AS	Split,
						B.TC_CodOficina					AS	Codigo,
						B.TC_Nombre						AS	Descripcion,
						'Split'							AS	Split,
						H.TC_CodContexto				AS	Codigo,
						H.TC_Descripcion				AS	Descripcion,
						'Split'							AS	Split,
						D.TN_CodTipoFuncionario			AS	Codigo,
						D.TC_Descripcion				AS	Descripcion,
						'Split'							AS	Split,
						F.TN_CodGrupoTrabajo			AS	Codigo,
						F.TC_Descripcion				AS	Descripcion, 
						F.TF_Inicio_Vigencia			AS	FechaActivacion,
						F.TF_Fin_Vigencia				AS	FechaDesactivacion,
						'Split'							AS	Split,
						G.UsuarioRed					AS	UsuarioRed,
						G.Nombre						AS	Nombre,
						G.PrimerApellido				AS	PrimerApellido,
						G.SegundoApellido				AS	SegundoApellido,
						G.CodigoPlaza					AS	CodigoPlaza,
						G.FechaActivacion				AS	FechaActivacion,
						G.FechaDesactivacion			AS	FechaDesactivacion,
						P.TN_CodTipoPuestoTrabajo		AS  CodigoTipoPuesto,
						P.TC_Descripcion				AS  DescripcionTipoPuesto,
						P.TF_Inicio_Vigencia			AS  FechaActivacionTipoPuesto,
						P.TF_Fin_Vigencia				AS  FechaDesactivacionTipoPuesto
		FROM			Catalogo.PuestoTrabajo			AS	A WITH(NOLOCK)
		INNER JOIN		Catalogo.Oficina				AS	B WITH(NOLOCK)
		ON				B.TC_CodOficina					=	A.TC_CodOficina
		INNER JOIN		Catalogo.TipoPuestoTrabajo		AS	P WITH(NOLOCK)
		ON				A.TN_CodTipoPuestoTrabajo		=	P.TN_CodTipoPuestoTrabajo
		INNER JOIN		Catalogo.TipoFuncionario		AS	D WITH(NOLOCK)
		ON				D.TN_CodTipoFuncionario			=	P.TN_CodTipoFuncionario	
		INNER JOIN		Catalogo.GrupoTrabajoPuesto		AS	E WITH(NOLOCK)
		ON				E.TC_CodPuestoTrabajo			=	A.TC_CodPuestoTrabajo
		INNER JOIN		Catalogo.GrupoTrabajo			AS	F WITH(NOLOCK)
		ON				F.TN_CodGrupoTrabajo			=	E.TN_CodGrupoTrabajo
		INNER JOIN		Catalogo.Contexto				AS	H WITH(NOLOCK)
		ON				H.TC_CodContexto				=   E.TC_CodContexto  
		OUTER APPLY		Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) AS G			
		WHERE			E.TN_CodGrupoTrabajo			=	ISNULL(@L_CodGrupoTrabajo, E.TN_CodGrupoTrabajo)
		AND				E.TC_CodPuestoTrabajo			=	ISNULL(@L_CodPuestoTrabajo, E.TC_CodPuestoTrabajo)
		AND				A.TC_CodOficina					=	ISNULL(@L_CodOficina,	A.TC_CodOficina)
		AND				H.TC_CodContexto				=	ISNULL(@L_CodContexto, H.TC_CodContexto)
		AND				A.TF_Inicio_Vigencia			<	GETDATE()
		AND				(A.TF_Fin_Vigencia				IS NULL OR A.TF_Fin_Vigencia >= GETDATE())
		AND				E.TF_Inicio_Vigencia			<	GETDATE()
		ORDER BY		F.TC_Descripcion;
		END
	--Todos
	ELSE
	BEGIN
		SELECT			A.TC_CodPuestoTrabajo			AS	Codigo,
						A.TC_Descripcion				AS	Descripcion,
						A.TF_Inicio_Vigencia			AS	FechaActivacion,
						A.TF_Fin_Vigencia				AS	FechaDesactivacion,
						E.TF_Inicio_Vigencia			AS	FechaAsociacion,
						'Split'							AS	Split,
						B.TC_CodOficina					AS	Codigo,
						B.TC_Nombre						AS	Descripcion,
						B.TC_Nombre						AS	Descripcion,
						'Split'							AS	Split,
						H.TC_CodContexto				AS	Codigo,
						H.TC_Descripcion				AS	Descripcion,
						'Split'							AS	Split,
						D.TN_CodTipoFuncionario			AS	Codigo,
						D.TC_Descripcion				AS	Descripcion,
						'Split'							AS	Split,
						F.TN_CodGrupoTrabajo			AS	Codigo,
						F.TC_Descripcion				AS	Descripcion, 
						F.TF_Inicio_Vigencia			AS	FechaActivacion,
						F.TF_Fin_Vigencia				AS	FechaDesactivacion,
						'Split'							AS	Split,
						G.UsuarioRed					AS	UsuarioRed,
						G.Nombre						AS	Nombre,
						G.PrimerApellido				AS	PrimerApellido,
						G.SegundoApellido				AS	SegundoApellido,
						G.CodigoPlaza					AS	CodigoPlaza,
						G.FechaActivacion				AS	FechaActivacion,
						G.FechaDesactivacion			AS	FechaDesactivacion
		FROM			Catalogo.PuestoTrabajo			AS	A WITH(NOLOCK)
		INNER JOIN		Catalogo.Oficina				AS	B WITH(NOLOCK)
		ON				B.TC_CodOficina					=	A.TC_CodOficina
		INNER JOIN		Catalogo.TipoPuestoTrabajo		AS	P WITH(NOLOCK)
		ON				A.TN_CodTipoPuestoTrabajo		=	P.TN_CodTipoPuestoTrabajo
		INNER JOIN		Catalogo.TipoFuncionario		AS	D WITH(NOLOCK)
		ON				D.TN_CodTipoFuncionario			=	P.TN_CodTipoFuncionario	
		INNER JOIN		Catalogo.GrupoTrabajoPuesto		AS	E WITH(NOLOCK)
		ON				E.TC_CodPuestoTrabajo			=	A.TC_CodPuestoTrabajo
		INNER JOIN		Catalogo.GrupoTrabajo			AS	F WITH(NOLOCK)
		ON				F.TN_CodGrupoTrabajo			=	E.TN_CodGrupoTrabajo
		INNER JOIN		Catalogo.Contexto				AS	H WITH(NOLOCK)
		ON				H.TC_CodContexto				=   E.TC_CodContexto  
		OUTER APPLY		Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) AS G			
		WHERE			E.TN_CodGrupoTrabajo			=	ISNULL(@L_CodGrupoTrabajo, E.TN_CodGrupoTrabajo)
		AND				E.TC_CodPuestoTrabajo			=	ISNULL(@L_CodPuestoTrabajo, E.TC_CodPuestoTrabajo)
		AND				A.TC_CodOficina					=	ISNULL(@L_CodOficina,	A.TC_CodOficina)
		AND				H.TC_CodContexto				=	ISNULL(@L_CodContexto, H.TC_CodContexto)
		ORDER BY		F.TC_Descripcion;
	END
 END

GO
