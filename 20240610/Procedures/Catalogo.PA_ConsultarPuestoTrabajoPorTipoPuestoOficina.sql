SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<01/10/2020>
-- Descripción:			<Permite obtener la lista de puesto de trabajo basados en el tipo de puesto de trabajo seleccionado y la oficina donde se encuentre el usuario logueado>
-- ==================================================================================================================================================================================
-- Modificado por:		<19-01-2021><Jose Gabriel Cordero Soto><Se realiza ajuste en parametros de consulta y se agrega condición de fecha del puestotrabajofuncionario en WHERE>
--Modificado por:		<04-03-2021><Roger Lara><Se realiza WHERE para que consulte todos los puestos de una oficina sin necesidad de un tipo puesto de trabajo>
--Modificado por:		<08/07/2021><Fabian Sequeira><Se incluye la jornada laboral al puesto de trabajo>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarPuestoTrabajoPorTipoPuestoOficina]
	@CodTipoPuestoTrabajo		  SMALLINT=null,
	@CodOficina					  VARCHAR(4)=null	
AS
BEGIN
	--Variables
	DECLARE		    @L_CodTipoPuestoTrabajo				SMALLINT	 = @CodTipoPuestoTrabajo
	DECLARE			@L_CodOficina						VARCHAR(4)	 = @CodOficina
		
	--Logica
	SELECT			P.TC_CodPuestoTrabajo				AS Codigo,
					P.TC_Descripcion 					AS Descripcion,
					P.TF_Inicio_Vigencia				AS FechaActivacion,
					P.TF_Fin_Vigencia					AS FechaDesactivacion,
					'splitOtros'						AS splitOtros,
					F.TC_UsuarioRed						AS CodigoUsuarioRed,
					F.TC_Nombre							AS NombreFuncionario,
					F.TC_PrimerApellido					AS PrimerApellido,
					F.TC_SegundoApellido				AS SegundoApellido,
					TP.TN_CodTipoPuestoTrabajo			AS CodigoTipoPuestoTrabajo,
					TP.TC_Descripcion					AS DescripcionTipoPuestoTrabajo,
					G.TC_CodOficina						AS CodigoOficina,
					G.TC_Nombre							AS DescripcionOficina,
					H.TN_CodTipoFuncionario		        AS CodigoTipoFuncionario,
					H.TC_Descripcion				    AS DescripcionTipoFuncionario,
					I.TN_CodJornadaLaboral				AS CodigoJornada,
					I.TC_Descripcion					AS DescripcionJornada,
					I.TF_HoraInicio						AS HoraInicioJornada,
					I.TF_HoraFin						AS HoraFinJornada
	FROM			Catalogo.PuestoTrabajo				P	WITH (NOLOCK)
	INNER JOIN		Catalogo.TipoPuestoTrabajo			TP  WITH (NOLOCK)
	ON				P.TN_CodTipoPuestoTrabajo			= TP.TN_CodTipoPuestoTrabajo
	INNER JOIN		Catalogo.PuestoTrabajoFuncionario	PF	WITH (NOLOCK)
	ON				PF.TC_CodPuestoTrabajo				= P.TC_CodPuestoTrabajo
	INNER JOIN		Catalogo.Funcionario				F	WITH (NOLOCK)
	ON				F.TC_UsuarioRed						= PF.TC_UsuarioRed
	Inner JOIN		Catalogo.Oficina					G WITH (NOLOCK)
	ON				G.TC_CodOficina						=P.TC_CodOficina
	Inner Join		Catalogo.TipoFuncionario			H WITH (NOLOCK)
	ON				H.TN_CodTipoFuncionario				=TP.TN_CodTipoFuncionario
	Inner Join		Catalogo.JornadaLaboral				I WITH (NOLOCK)
	ON				I.TN_CodJornadaLaboral				=P.TN_CodJornadaLaboral
	WHERE			P.TN_CodTipoPuestoTrabajo			= COALESCE(@L_CodTipoPuestoTrabajo, P.TN_CodTipoPuestoTrabajo)
	AND				P.TC_CodOficina						= COALESCE(@L_CodOficina, P.TC_CodOficina)
	AND			   (P.TF_Fin_Vigencia					is null or P.TF_Fin_Vigencia  >= GETDATE ())
	AND			   (PF.TF_Fin_Vigencia					is null or PF.TF_Fin_Vigencia  >= GETDATE ())

	GROUP BY		P.TC_CodPuestoTrabajo,
					P.TC_Descripcion,
					P.TF_Inicio_Vigencia,
					P.TF_Fin_Vigencia,					
					F.TC_UsuarioRed,
					F.TC_Nombre,
					F.TC_PrimerApellido,
					F.TC_SegundoApellido,
					TP.TC_Descripcion,
					TP.TN_CodTipoPuestoTrabajo,
					G.TC_CodOficina,
					G.TC_Nombre,
					H.TN_CodTipoFuncionario,
					H.TC_Descripcion, 
					I.TN_CodJornadaLaboral,
					I.TC_Descripcion,
					I.TF_HoraInicio,						
					I.TF_HoraFin
END
GO
