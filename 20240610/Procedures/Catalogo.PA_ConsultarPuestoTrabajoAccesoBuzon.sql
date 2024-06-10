SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================
-- Autor:			<Luis Alonso Leiva Tames>
-- Fecha Creación:	<27/10/2018>
-- Descripcion:		<Consultar todos los permisos por puestos de trabajo>
-- ==================================================================================================================
-- Modificación:	<19/11/2020> <Ronny Ramírez R.> <Se agrega parámetro de consulta por @CodPuestoTrabajoSecundario> 
-- ==================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarPuestoTrabajoAccesoBuzon]
	 @CodPuestoTrabajo				varchar(14),
	 @CodPuestoTrabajoSecundario	varchar(14) = NULL
 As
 Begin

	 Declare	@L_CodPuestoTrabajo varchar(14)				=	@CodPuestoTrabajo,
				@L_CodPuestoTrabajoSecundario varchar(14)	=	@CodPuestoTrabajoSecundario

SELECT
			A.TN_CodPuestosTrabajoAccesoBuzon as Codigo,
			A.TF_FechaRegistro as FechaRegistro,
			'Split' As Split,
			A.TC_CodPuestoTrabajo as Codigo, 
			'Split' As Split,
			TC_CodPuestoTrabajoSecundario as Codigo,
			B.TC_Descripcion as Descripcion,
			'Split' As Split,
			D.TC_UsuarioRed						As	UsuarioRed,				
			D.TC_Nombre							As	Nombre,					
			D.TC_PrimerApellido					As	PrimerApellido,			
			D.TC_SegundoApellido				As	SegundoApellido,		
			D.TC_CodPlaza						As	CodigoPlaza,			
			D.TF_Inicio_Vigencia				As	FechaActivacion,		
			D.TF_Fin_Vigencia					As	FechaDesactivacion,
			'Split' As Split,
			A.TC_UsuarioRedAsignaPermiso as UsuarioRegistra, 
			'Split' As Split,
			E.TN_CodTipoPuestoTrabajo			As	CodigoTPT,
			E.TC_Descripcion					As	DescripcionTPT,
			E.TF_Inicio_Vigencia				As	FechaActivacionTPT,
			E.TF_Fin_Vigencia					As	FechaDesactivacionTPT
		FROM			Catalogo.PuestoTrabajoAccesoBuzon	A 
		INNER JOIN		Catalogo.PuestoTrabajo				As B With(Nolock) 
		ON				A.TC_CodPuestoTrabajoSecundario		= B.TC_CodPuestoTrabajo
		LEFT JOIN		Catalogo.PuestoTrabajoFuncionario	As C With(Nolock) 
		ON				(
							B.TC_CodPuestoTrabajo			= C.TC_CodPuestoTrabajo 
							and C.TF_Inicio_Vigencia			< GETDATE() 
							and (
								C.TF_Fin_Vigencia			> GETDATE() 
								or C.TF_Fin_Vigencia		is null
							)
						)
		LEFT JOIN		Catalogo.Funcionario				As	D With(Nolock)
		ON				C.TC_UsuarioRed						= D.TC_UsuarioRed
		INNER JOIN		Catalogo.TipoPuestoTrabajo			As	E With(Nolock)
		ON				E.TN_CodTipoPuestoTrabajo			=	B.TN_CodTipoPuestoTrabajo
		WHERE	A.TC_CodPuestoTrabajo				= 	Coalesce(@L_CodPuestoTrabajo, A.TC_CodPuestoTrabajo)
		AND		A.TC_CodPuestoTrabajoSecundario		= 	Coalesce(@L_CodPuestoTrabajoSecundario, A.TC_CodPuestoTrabajoSecundario)
		AND		B.TF_Inicio_Vigencia				<	Getdate() AND (B.TF_Fin_Vigencia > GETDATE() OR B.TF_Fin_Vigencia IS NULL)
 
 End 
GO
