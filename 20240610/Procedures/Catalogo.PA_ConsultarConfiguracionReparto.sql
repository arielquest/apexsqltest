SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<30/04/2021>
-- Descripción :			<Consulta la configuración de reparto de un contexto dado> 
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Modificado por:			<Johan Acosta>
-- Fecha de creación:		<19/05/2021>
-- Descripción :			<Modificación de estándares y agregar el campo RecordarAsignaciones> 
-- =================================================================================================================================================
-- Versión:					<3.0>
-- Modificado por:			<Johan Manuel Acosta ibañez>
-- Fecha de creación:		<08/09/2021>
-- Descripción :			<Se agregaron los campos para el manejo de los campos de asignaciones de responsables> 
-- =================================================================================================================================================
-- Versión:					<4.0>
-- Modificado por:			<Xinia Soto Valerio>
-- Fecha de creación:		<09/09/2021>
-- Descripción :			<Se agregaron filtros de fecha fin de la tabla de Catalogo.PuestoTrabajoFuncionario> 
-- =================================================================================================================================================
--exec Catalogo.PA_ConsultarConfiguracionReparto ''0295''

CREATE PROCEDURE [Catalogo].[PA_ConsultarConfiguracionReparto]	
	@CodContexto      varchar(4)
AS  
BEGIN  
	DECLARE		@L_CodContexto								VARCHAR(4) = @CodContexto

	SELECT		C.TU_CodConfiguracionReparto				Codigo,
				C.TC_CodContexto							CodigoContexto,
				C.TB_Habilitado								RepartoHabilitado,
				C.TB_LimiteTiempoHabilitado					LimiteTiempoHabilitado,
				C.TN_DiasHabiles							DiasHabilesLimite,
				C.TN_CodUbicacionError						CodigoUbicacionError,
				C.TC_CodPuestoTrabajoError					PuestoTrabajoError,
				C.TN_CodTareaError							CodigoTareaError,
				C.TN_CodTareaExpedientesNuevos				CodigoTareaNuevos,
				C.TB_RecordarAsignaciones					RecordarAsignaciones, 
				T.TN_CantidadHoras							HorasTareaNuevo,
				E.TN_CantidadHoras							HorasTareaError,
				F.TC_UsuarioRed								UsuarioRedError,
				C.TB_AsignacionReparto						AsignacionReparto,
				C.TB_AsignacionManual						AsignacionManual,
				C.TB_AsignacionHerencia						AsignacionHerencia,
				'split'										split,
				C.TC_CriterioReparto						CriterioReparto 
	FROM		Catalogo.ConfiguracionGeneralReparto		C WITH(NOLOCK)
	INNER JOIN	Catalogo.TareaTipoOficinaMateria			T WITH(NOLOCK) 
	ON			T.TN_CodTarea							=	C.TN_CodTareaExpedientesNuevos 
	INNER JOIN	Catalogo.TareaTipoOficinaMateria			E WITH(NOLOCK) 
	ON			E.TN_CodTarea							=	C.TN_CodTareaError
	INNER JOIN  Catalogo.Contexto							M WITH(NOLOCK) 
	ON			M.TC_CodContexto						=	C.TC_CodContexto
	INNER JOIN  Catalogo.Oficina							O WITH(NOLOCK) 
	ON			O.TC_CodOficina							=	M.TC_CodOficina
	INNER JOIN  Catalogo.PuestoTrabajoFuncionario			F WITH(NOLOCK) 
	ON			F.TC_CodPuestoTrabajo					=	C.TC_CodPuestoTrabajoError
	WHERE		C.TC_CodContexto						=	@L_CodContexto 
	AND			T.TC_CodMateria							=	M.TC_CodMateria 
	AND			E.TC_CodMateria							=	M.TC_CodMateria 
	AND			O.TN_CodTipoOficina						=	E.TN_CodTipoOficina 
	AND			O.TN_CodTipoOficina						=	T.TN_CodTipoOficina 
	AND			(F.TF_Fin_Vigencia						IS  NULL 
	OR			F.TF_Fin_Vigencia						>= GETDATE())
END
GO
