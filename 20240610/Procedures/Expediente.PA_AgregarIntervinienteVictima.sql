SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================================================================================================================
-- Autor:				<Sigifredo Leitón Luna>
-- Fecha Creación:		<22/01/2016>
-- Descripcion:			<Agregar un intervininte a un expediente legajo>
-- =====================================================================================================================================================
-- Modificado por:		<Esteban Cordero Benavides><08 de marzo de 2016.><Se agrega el campo de lugar de denuncia.>
-- Modificado por:		<Donald Vargas Zúñiga><02/12/2016><Se corrige el nombre de los campos TC_CodPeriodoAntirretro, TC_CodPuebloIndigena, 
--						TC_CodDiversidadSexual, TC_CodLugarAtencion y TC_CodLugarDenuncia a TN_CodPeriodoAntirretro, TN_CodPuebloIndigena, 
--						TN_CodDiversidadSexual, TN_CodLugarAtencion y TN_CodLugarDenuncia de acuerdo al tipo de dato>
-- Modificado por:		<Juan Ramirez><24/08/2018><Se agregan nuevos campos en la intervencion>
-- Modificado por:		<31/08/2021><Ronny Ram­rez R.><Se agregan campos ApoyoPsicosocial, ExamenMedForense y Contexto que faltaban>
-- =====================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarIntervinienteVictima] 
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
	@Actualizacion				datetime2,
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
	@ExamenMedForense			bit,
	@CodContexto				varchar(4)		= NULL
AS
BEGIN
	INSERT INTO Expediente.IntervinienteVictima
	(		
		 TU_CodVictima			,TU_CodInterviniente		,TB_EsViolacion				,TN_CodPeriodoAntirretro
		,TN_CodPuebloIndigena	,TB_EsPrivadoLibertad		,TN_CodDiversidadSexual		,TN_CodLugarAtencion
		,TN_CodLugarDenuncia	,TC_Observaciones			,TF_Actualizacion			,TB_DepSolApliRetro
		,TB_ERRVS				,TB_EsIndigena				,TB_TrabSocial				,TB_PerMedHosp
		,TB_MedForense			,TB_Fiscal					,TB_OfOIJ					,TB_OfFuerzaPub
		,TB_RepPani				,TB_Otros					,TC_Otros					,TB_CamGessel
		,TC_PersAtendio			,TN_CodIdioma				,TC_ProFatiende				,TC_HoraInicio
		,TC_HoraFinal			,TB_ApoyoPsicosocial		,TB_ExamenMedForense		,TC_CodContexto
	)
	VALUES
	(
		 @CodigoVictima			,@CodigoInterviniente		,@EsViolacion				,@CodigoPeriodoAntirretro
		,@CodigPuebloIndigena	,@EsPrivadoLibertad			,@CodigoDiversidadSexual	,@CodigoLugarAtencion
		,@CodigoLugarDenuncia	,@Observaciones				,@Actualizacion				,@DepSolApliRetro
		,@ERRVS					,@EsPersonaIndigena			,@TrabSocial				,@PerMedHosp
		,@MedForense			,@Fiscal					,@OfOIJ						,@OfFuerzaPub
		,@RepPANI				,@Otroscheck				,@Otros						,@CamGessel
		,@PersAtendio			,@CodigoIdioma				,@ProfAtiende				,@HoraInicio
		,@HoraFinal				,@ApoyoPsicosocial			,@ExamenMedForense			,@CodContexto
	)	
END
GO
