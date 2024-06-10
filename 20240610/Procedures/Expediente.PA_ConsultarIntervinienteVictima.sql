SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<22/01/2016>
-- Descripción :			<Permite Consultar un perfil de victima de un intervinientes
-- =================================================================================================================================================
-- Modificado por:			<Esteban Cordero Benavides.><08 de marzo de 2016.><Se agrega el campo lugar de denuncia.>
-- Modificado por:			<Donald Vargas><10/05/2016><Se agrega fechas de inicio y fin de vigencia de los catálogos en los datos que se retornan>
-- Modificado por:			<Donald Vargas Zúñiga><02/12/2016><Se corrige el nombre de los campos TC_CodPeriodoAntirretro, TC_CodPuebloIndigena, 
--							TC_CodDiversidadSexual, TC_CodLugarAtencion y TC_CodLugarDenuncia a TN_CodPeriodoAntirretro, TN_CodPuebloIndigena, 
--							TN_CodDiversidadSexual, TN_CodLugarAtencion y TN_CodLugarDenuncia de acuerdo al tipo de dato>
-- Modificado por:			<Juan Ramirez><24/08/2018><Se agregan nuevos campos para consultar la intervencion>
-- Modificado por:			<31/08/2021><Ronny Ram­rez R.><Se agregan campos ApoyoPsicosocial, ExamenMedForense y Contexto que faltaban>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervinienteVictima]
	@CodigoInterviniente uniqueidentifier
As
Begin
	Select		
				A.TF_Actualizacion					AS	Actualizacion,
				A.TB_CamGessel						AS	CamGessel,
				TU_CodVictima						AS	CodigoVictima,
				A.TB_DepSolApliRetro				AS	DepSolApliRetro,
				A.TB_ERRVS							AS	ERRVS,
				A.TB_EsIndigena						AS	EsIndigena,
				TU_CodInterviniente					AS	CodigoInterviniente,
				TB_EsViolacion						AS	EsViolacion,
				TB_EsPrivadoLibertad				AS	EsPrivadoLibertad, 
				A.TB_Fiscal							AS	Fiscal,
				A.TC_HoraInicio						AS	HoraInicio,
				A.TC_HoraFinal						AS	HoraFinal,
				a.TB_MedForense						AS	MedForense,
				A.TB_OfFuerzaPub					AS	OfFuerzaPub,
				A.TB_OfOIJ							AS	OfOIJ,
				A.TC_Otros							AS	Otros,
				A.TB_PerMedHosp						AS	PerMedHosp,
				A.TC_PersAtendio					AS	PersAtendio,
				A.TC_ProfAtiende					AS	ProFatiende,
				A.TB_RepPani						AS	RepPani,
				A.TB_TrabSocial						AS	TrabSocial,
				TC_Observaciones					AS	Observaciones,
				TB_ApoyoPsicosocial					AS	ApoyoPsicosocial,
				TB_ExamenMedForense					AS	ExamenMedForense,
				'Split'								AS	Split,
				A.TN_CodPeriodoAntirretro			AS	CodigoPeriodoAntirretro,
				B.TC_Descripcion					AS	PeriodoAntirretroDescrip,	
				B.TF_Inicio_Vigencia				AS	FechaInicioPeriodoAntirretro, 
				B.TF_Fin_Vigencia					AS	FechaFinPeriodoAntirretro,				
				A.TN_CodPuebloIndigena				AS	CodigoPuebloIndigena,
				C.TC_Descripcion					AS	PuebloIndigenaDescrip,			
				C.TF_Inicio_Vigencia				AS	FechaInicioPuebloIndigena, 
				C.TF_Fin_Vigencia					AS	FechaFinPuebloIndigena,				
				A.TN_CodDiversidadSexual			AS	CodigoDiversidadSexual,     
				D.TC_Descripcion					AS	DiversidadSexualDescrip,				
				D.TF_Inicio_Vigencia				AS	FechaInicioDiversidadSexual, 
				D.TF_Fin_Vigencia					AS	FechaFinDiversidadSexual,
				A.TN_CodLugarAtencion				AS	CodigoLugarAtencion,		
				E.TC_Descripcion					AS	LugarAtencionDescrip,
				E.TF_Inicio_Vigencia				AS	FechaInicioLugarAtencion, 
				E.TF_Fin_Vigencia					AS	FechaFinLugarAtencion,				
				A.TN_CodLugarDenuncia				AS	CodigoLugarDenuncia,
				F.TC_Descripcion					AS	LugarDenunciaDescrip,
				F.TF_Inicio_Vigencia				AS	FechaInicioLugarDenuncia, 
				F.TF_Fin_Vigencia					AS	FechaFinLugarDenuncia,
				A.TN_CodIdioma						AS	CodigoIdioma,
				G.TC_Descripcion					AS  IdiomaDescrip,
				G.TF_Inicio_Vigencia				AS	FechaInicioIdioma,
				G.TF_Fin_Vigencia					AS	FechaFinIdioma,
				A.TC_CodContexto					AS	CodContexto	
	From		Expediente.IntervinienteVictima		AS	A With(NoLock)
	Left Join	Catalogo.PeriodoAntirretroviral		AS	B With(NoLock)
	On			A.TN_CodPeriodoAntirretro			=	B.TN_CodPeriodoAntirretro
	Left Join	Catalogo.PuebloIndigena				AS	C With(NoLock)
	On			A.TN_CodPuebloIndigena				=	C.TN_CodPuebloIndigena
	Left Join	Catalogo.DiversidadSexual			AS	D With(NoLock)
	On			A.TN_CodDiversidadSexual			=	D.TN_CodDiversidadSexual
	Left Join	Catalogo.LugarAtencion				AS	E With(NoLock)
	On			A.TN_CodLugarAtencion				=	E.TN_CodLugarAtencion
	Left Join	Catalogo.LugarAtencion				AS	F With(NoLock)
	On			A.TN_CodLugarDenuncia				=	F.TN_CodLugarAtencion
	Left Join	Catalogo.Idioma						AS	G With(NoLock)
	On			A.TN_CodIdioma						=	G.TN_CodIdioma
	Where		TU_CodInterviniente					=	@CodigoInterviniente
End
GO
