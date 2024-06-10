SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<12/04/2018>
-- Descripción :			<Permite Consultar puesto(s) de trabajo de un contexto> 	
-- Modificación:			<Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- Modificación:            <Jose Gabriel Cordero Soto><01/11/2019> <Se agrega Funcionario Activo a la consulta>
-- Modificación:			<Aida Elena Siles R> <13/01/2021> <Se agrega a la consulta la tabla TipoPuestoTrabajo para obtener correctamente el tipo funcionario>
-- Modificación:			<Jose Gabriel Cordero> <15/06/2021> <Se agrega en consulta el campo de TC_UsuarioRed por tema de validación en la itineración>
-- Modificación:			<Elías González Porras> <30/03/2023> <se crea una variable local @FechaActivacion Datetime2 = Null para poder filtrar los puestos de 
--							trabajo por la fecha de Fin_Vigencia de la tabla Catalogo.PuestoTrabajoFuncionario.>
-- =================================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarPuestoTrabajoContexto] 	
	@CodContexto			VARCHAR(4),
	@FechaActivacion		Datetime2			= Null
AS
	BEGIN
--Variable locales
DECLARE @L_CodContexto				VARCHAR(4)			= @CodContexto,
		@L_FechaActivacion			Datetime2			= @FechaActivacion

			
			SELECT		B.TC_CodPuestoTrabajo			AS	Codigo,				
						B.TC_Descripcion				AS	Descripcion,
						B.TF_Inicio_Vigencia			AS	FechaActivacion,	
						B.TF_Fin_Vigencia				AS	FechaDesactivacion,												
						'Split'							AS	Split,			
						D.TN_CodTipoFuncionario			AS	Codigo,
						D.TC_Descripcion				AS	Descripcion,
						'Split'                         AS  Split,
                        F.TN_CodJornadaLaboral          AS  Codigo,
						F.TC_Descripcion                AS  Descripcion,
						F.TF_HoraInicio					AS	HoraInicio,
						F.TF_HoraFin					AS	HoraFin,
						'Split'                         AS  Split,
						CF.TC_Nombre					AS  Nombre,
						CF.TC_PrimerApellido		    AS  PrimerApellido,
						CF.TC_SegundoApellido			AS  SegundoApellido,
						CF.TC_UsuarioRed				AS  UsuarioRed
			FROM		Catalogo.ContextoPuestoTrabajo	AS	CPT	WITH(NOLOCK)
			INNER JOIN	Catalogo.PuestoTrabajo			AS	B	WITH(NOLOCK)
			ON			B.TC_CodPuestoTrabajo			=	CPT.TC_CodPuestoTrabajo 
			INNER JOIN	Catalogo.Contexto				AS	G	WITH(NOLOCK)
			ON			G.TC_CodContexto				=	CPT.TC_CodContexto
			INNER JOIN	Catalogo.JornadaLaboral 		AS	F	WITH(NOLOCK)
			ON			B.TN_CodJornadaLaboral			=	F.TN_CodJornadaLaboral		
			INNER JOIN	Catalogo.TipoPuestoTrabajo		AS	TP	WITH(NOLOCK)
			ON			B.TN_CodTipoPuestoTrabajo		=	TP.TN_CodTipoPuestoTrabajo
			INNER JOIN	Catalogo.TipoFuncionario		AS	D	WITH(NOLOCK)			
			ON			D.TN_CodTipoFuncionario			=	TP.TN_CodTipoFuncionario	
			INNER JOIN Catalogo.PuestoTrabajoFuncionario AS PTF WITH(NOLOCK)
			ON			PTF.TC_CodPuestoTrabajo         =	B.TC_CodPuestoTrabajo
			INNER JOIN Catalogo.Funcionario				AS	CF	WITH(NOLOCK)
			ON			PTF.TC_UsuarioRed				=	CF.TC_UsuarioRed
			WHERE		CPT.TC_CodContexto				=	@L_CodContexto	
			AND			B.TF_Inicio_Vigencia			<	GETDATE()
			AND			( 
							B.TF_Fin_Vigencia				IS NULL 
						  OR 
							B.TF_Fin_Vigencia			>=	GETDATE ()
						)
			AND
			(
						@L_FechaActivacion							IS NULL
						OR
						(
							@L_FechaActivacion						IS NOT NULL
			
							AND	    PTF.TF_Inicio_Vigencia			<	GETDATE()
							AND			
							( 
									PTF.TF_Fin_Vigencia				IS NULL 
								OR 
									PTF.TF_Fin_Vigencia				>=	GETDATE ()
							)
						)
			)
END
GO
