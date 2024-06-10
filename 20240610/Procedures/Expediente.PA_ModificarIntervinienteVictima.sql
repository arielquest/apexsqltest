SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================================================================================================================
-- Autor:				<Sigifredo Leitón Luna>
-- Fecha Creación:		<22/01/2016>
-- Descripcion:			<Modfificar los datos delitos sexuales de un interviniente.>
-- =====================================================================================================================================================
-- Modificado por:		<Esteban Cordero Benavides><08 de marzo de 2016.><Se agrega el campo del lugar de la denuncia.>
-- Modificado por:		<Donald Vargas Zúñiga><02/12/2016><Se corrige el nombre de los campos TC_CodPeriodoAntirretro, TC_CodPuebloIndigena, 
--						TC_CodDiversidadSexual, TC_CodLugarAtencion y TC_CodLugarDenuncia a TN_CodPeriodoAntirretro, 
--						TN_CodPuebloIndigena, TN_CodDiversidadSexual, TN_CodLugarAtencion y TN_CodLugarDenuncia de acuerdo al tipo de dato>
-- Modificado por:		<31/08/2021><Ronny Ram­rez R.><Se agregan campos ApoyoPsicosocial y ExamenMedForense que faltaban>
-- =====================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarIntervinienteVictima]   
    @CodigoIdioma				smallint,
	@CodigoVictima				uniqueidentifier,
	@CodigoInterviniente		uniqueidentifier, 
	@EsViolacion				bit, 
	@CodigoPeriodoAntirretro	smallint, 
	@CodigPuebloIndigena		smallint, 
	@EsPrivadoLibertad			bit, 
	@CodigoDiversidadSexual		smallint, 
	@CodigoLugarAtencion		smallint, 
	@CodigoLugarDenuncia		smallint,
	@Observaciones				Varchar(250),
	@DepSolApliRetro			bit,
	@ERRVS						bit,
	@EsPersonaIndigena			bit,
	@TrabSocial					bit,
	@PerMedHosp					bit,
	@MedForense					bit,
	@Fiscal						bit,
	@OfOIJ						bit,
	@OfFuerzaPub				bit,
	@RepPANI					bit,
	@Otroscheck					bit,
	@Otros						varchar(250),
	@CamGessel					bit,
	@PersAtendio				varchar(250),
	@ProfAtiende				varchar(250),
	@HoraInicio					time(7),
	@HoraFinal					time(7),
	@ApoyoPsicosocial			bit,
	@ExamenMedForense			bit
AS
BEGIN
	 Update Expediente.IntervinienteVictima
	 Set	TU_CodInterviniente		=	@CodigoInterviniente,	
			TB_EsViolacion			=	@EsViolacion,			
			TN_CodPeriodoAntirretro =	@CodigoPeriodoAntirretro, 
			TN_CodPuebloIndigena	=	@CodigPuebloIndigena,	
			TB_EsPrivadoLibertad	=	@EsPrivadoLibertad,	
			TN_CodDiversidadSexual	=	@CodigoDiversidadSexual, 
			TN_CodLugarAtencion		=	@CodigoLugarAtencion,
			TN_CodLugarDenuncia		=	@CodigoLugarDenuncia,	
			TC_Observaciones		=	@Observaciones, 
			TF_Actualizacion		=	getdate(),
			TB_DepSolApliRetro		=	@DepSolApliRetro,								
			TB_ERRVS				=	@ERRVS,
			TB_EsIndigena			=	@EsPersonaIndigena,
			TB_TrabSocial			=	@TrabSocial,
			TB_PerMedHosp			=	@PerMedHosp,
			TB_MedForense			=	@MedForense,		
			TB_Fiscal				=	@Fiscal,
			TB_OfOIJ				=	@OfOIJ,
			TB_OfFuerzaPub			=	@OfFuerzaPub,
			TB_RepPani				=	@RepPANI,
			TB_Otros				=	@Otroscheck,
			TC_Otros				=	@Otros,
			TB_CamGessel			=	@CamGessel,
			TC_PersAtendio			=	@PersAtendio,
			TN_CodIdioma			=	@CodigoIdioma,
			TC_ProFatiende			=	@ProfAtiende,
			TC_HoraInicio			=	@HoraInicio,
			TC_HoraFinal			=	@HoraFinal,
			TB_ApoyoPsicosocial		=	@ApoyoPsicosocial,
			TB_ExamenMedForense		=	@ExamenMedForense
	 Where  TU_CodVictima			=	@CodigoVictima 
END
GO
