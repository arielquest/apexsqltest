SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<30/04/2021>
-- Descripción :			<Consulta el criterio de reparto> 
-- Modificado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<01/06/2021>
-- Descripción :			<Se agrega la funcionalidad si se hac por un puesto de trabajo específico> 
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Creado por:				<Xinia Soto>
-- Fecha de creación:		10/09/2021>
-- Descripción :			<Se agrega columna de TU_CodConjuntoReparto a la tabla Catalogo.CriterioAsignacion> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ObtenerMiembrosParaRepartir]
	@CodConfiguracionReparto  uniqueidentifier,
    @CodCriterio			  uniqueidentifier,
	@CodPuestoTrabajo		  varchar(14) = null
AS  
BEGIN  
	Declare 
			@L_CodCriterio						uniqueidentifier	=	@CodCriterio,
			@L_CodConfiguracionReparto			uniqueidentifier	=	@CodConfiguracionReparto,
			@L_CodPuestoTrabajo					varchar(14)			=	@CodPuestoTrabajo

			Select	A.TU_CodCriterio						As	Codigo,
					A.TC_CodPuestoTrabajo					As	CodigoPuestoTrabajo,
					A.TF_UltimaAsignacion					As	FechaUltimaAsignacion,
					A.TN_Asignaciones						As	Asignados, 
					A.TN_Adicionales						As	Adicionales,
					M.TN_Prioridad							As	PrioridadMiembro,
					C.TB_UbicaExpedientesNuevos				As	UbicaExpedientesNuevos,
					M.TN_CodUbicacion						As	CodigoUbicacion,
					P.TC_UsuarioRed							As	UsuarioRed,
					M.TN_Limite								As	Limite,
					T.TN_CodTipoPuestoTrabajo				As	TipoPuestoTrabajo,
					EU.TU_CodEquipo							As	CodigoEquipo,
					0										As	NumeroRonda,
					'split'									As	split,
					C.TC_Prioridad							As	PrioridadConjunto
			 From		Catalogo.EquipoCriterio				As	EU	with(nolock)
			 Inner Join Catalogo.ConjuntosReparto			As	C	with(nolock)           
			 On			C.TU_CodEquipo						=	EU.TU_CodEquipo
			 Inner Join Catalogo.MiembrosPorConjuntoReparto As	M	with(nolock) 
			 On			M.TU_CodConjutoReparto				=	C.TU_CodConjutoReparto
			 Inner Join Catalogo.CriterioAsignacion			As	A	with(nolock)        
			 On			A.TU_CodCriterio					=	EU.TU_CodCriterio 
			 And		A.TC_CodPuestoTrabajo				=	M.TC_CodPuestoTrabajo
			 And		A.TU_CodConjuntoReparto             =   C.TU_CodConjutoReparto
			 Inner Join Catalogo.PuestoTrabajoFuncionario	As	P	with(nolock)   
			 On			P.TC_CodPuestoTrabajo				=	M.TC_CodPuestoTrabajo 
			 And		P.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
			 Inner Join Catalogo.PuestoTrabajo				As	T  with(nolock)             
			 On			T.TC_CodPuestoTrabajo				=	P.TC_CodPuestoTrabajo 
			 Where		EU.TU_CodCriterio					=	@L_CodCriterio 
			 And		(P.TF_Fin_Vigencia					Is	Null 
			 Or			P.TF_Fin_Vigencia					>=	GETDATE()) 
			 And        C.TC_Prioridad						<>	'S'
			 And		P.TC_CodPuestoTrabajo				=	Coalesce(@L_CodPuestoTrabajo,	P.TC_CodPuestoTrabajo)


			 Union

			 Select	A.TU_CodCriterio						As	Codigo,
					A.TC_CodPuestoTrabajo					As	CodigoPuestoTrabajo,
					A.TF_UltimaAsignacion					As	FechaUltimaAsignacion,
					A.TN_Asignaciones						As	Asignados, 
					A.TN_Adicionales						As	Adicionales,
					R.TN_Prioridad							As	PrioridadMiembro,
					C.TB_UbicaExpedientesNuevos				As	UbicaExpedientesNuevos,
					M.TN_CodUbicacion						As	CodigoUbicacion,
					P.TC_UsuarioRed							As	UsuarioRed,
					M.TN_Limite								As	Limite,
					T.TN_CodTipoPuestoTrabajo				As	TipoPuestoTrabajo,
					EU.TU_CodEquipo							As	CodigoEquipo,
					R.TN_NumeroRonda						As	NumeroRonda,
					'split'									As	split,
					C.TC_Prioridad							As	PrioridadConjunto
			 From		Catalogo.EquipoCriterio				As	EU	with(nolock)
			 Inner Join Catalogo.ConjuntosReparto			As	C	with(nolock)           
			 On			C.TU_CodEquipo						=	EU.TU_CodEquipo
			 Inner Join Catalogo.MiembrosPorConjuntoReparto As	M	with(nolock) 
			 On			M.TU_CodConjutoReparto				=	C.TU_CodConjutoReparto
			 Inner Join Catalogo.CriterioAsignacion			As	A	with(nolock)       
			 On			A.TU_CodCriterio					=	EU.TU_CodCriterio 
			 And		A.TC_CodPuestoTrabajo				=	M.TC_CodPuestoTrabajo
			 And		A.TU_CodConjuntoReparto             =   C.TU_CodConjutoReparto
			 Inner Join Catalogo.PuestoTrabajoFuncionario	As	P	with(nolock)   
			 On			P.TC_CodPuestoTrabajo				=	M.TC_CodPuestoTrabajo 
			 And		P.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
			 Inner Join Catalogo.PuestoTrabajo				As	T	with(nolock)             
			 On			T.TC_CodPuestoTrabajo				=	P.TC_CodPuestoTrabajo 
			 Inner Join Catalogo.ControlRondasReparto		As	R	with(nolock)      
			 On			R.TC_CodPuestoTrabajo				=	P.TC_CodPuestoTrabajo  
			 And		R.TU_CodCriterioReparto				=	A.TU_CodCriterio
			 Where		EU.TU_CodCriterio					=	@L_CodCriterio 
			 And		(P.TF_Fin_Vigencia					Is Null 
			 or			P.TF_Fin_Vigencia					>=	GETDATE()) 
			 And        C.TC_Prioridad						=	'S'
			 And		P.TC_CodPuestoTrabajo				=	Coalesce(@L_CodPuestoTrabajo,	P.TC_CodPuestoTrabajo)
		     Order by	M.TN_Prioridad asc, 
						A.TF_UltimaAsignacion asc

END
GO
