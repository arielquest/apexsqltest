SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida Elena Siles Rojas>
-- Fecha de creación:		<22/10/2020>
-- Descripción :			<Permite Consultar los funcionarios activos de un contexto específico.> 
-- ===========================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarFuncionariosActivosXContexto]
 @CodContexto			VARCHAR(4)
 AS
 BEGIN
	--Variables
	DECLARE	@L_Contexto	VARCHAR(4)	= @CodContexto

	--Lógica
		SELECT		C.TC_UsuarioRed						AS	UsuarioRed, 
					C.TC_Nombre							AS  Nombre,
					C.TC_PrimerApellido					AS	PrimerApellido,
					C.TC_SegundoApellido				AS	SegundoApellido,
					C.TC_CodPlaza						AS  CodigoPlaza,
					C.TF_Inicio_Vigencia				AS	FechaActivacion,
					C.TF_Fin_Vigencia					AS	FechaDesactivacion,
					'split'								AS	split,
					E.TC_CodSexo						AS  Codigo,
					E.TC_Descripcion					AS	Descripcion
	FROM			Catalogo.ContextoPuestoTrabajo		A	WITH(NOLOCK)
	INNER JOIN		Catalogo.PuestoTrabajoFuncionario	B	WITH(NOLOCK)
	ON				B.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
	AND				B.TF_Inicio_Vigencia               <=	GETDATE()
	AND				(
						B.TF_Fin_Vigencia					IS NULL
						OR
						B.TF_Fin_Vigencia              >=	GETDATE()
					)
	INNER JOIN		Catalogo.Funcionario				C	WITH(NOLOCK)
	ON				C.TC_UsuarioRed						=	B.TC_UsuarioRed
	AND				C.TF_Inicio_Vigencia                <=	GETDATE()
	AND				(
						C.TF_Fin_Vigencia					IS NULL
						OR
						C.TF_Fin_Vigencia               >=	GETDATE()
					)	
	INNER JOIN		Catalogo.PuestoTrabajo				D	WITH(NOLOCK)
	ON				D.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
	AND				D.TC_CodOficina						=	(SELECT TC_CodOficina FROM Catalogo.Contexto WHERE TC_CodContexto = @L_Contexto)
	LEFT JOIN		Catalogo.Sexo						E	WITH(NOLOCK)
	ON				C.TC_CodSexo						=	E.TC_CodSexo

	WHERE			A.TC_CodContexto					=	@L_Contexto
END
GO
