SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:				<Roger LAra>
-- Fecha Creación:		<11/09/2015>
-- Descripcion:			<Modificar un intervininte a un expediente legajo>
-- Modificación:		<Johan Acosta>
-- Fecha Modificación:	<18/09/2015>
-- Descripcion:			<Indentación compelta del SP>
-- Modificado por:		<Gerardo Lopez>
-- Fecha de creación:	<26/10/2015>
-- Descripción :		<Se incluye fecha de actualizacion del registro.> 
-- Modificado por:		<Gerardo Lopez> <16/11/2015> 	<Se elimina campo CodigoVulnerabilidad.> 
-- Modificado por:		<Henry Mendez> <23/11/2015> 	<Se elimina campo TC_CodSituacionLibertad y TF_SituacionLibertad.> 
-- Modificado por:		<Johan Acosta> <26/11/2015> 	<Se cambia campo TC_Observaciones pot TC_Caracteristicas.> 
-- Modificado por:		<Alejandro Villalta> <03/12/2015><Se elimina campo TC_Discapacidad.> 
-- Modificado por:		<Alejandro Villalta><10/12/2015> <Se cambia tipo de dato del codigo de situación laboral.> 
-- Modificado por:		<Olger Gamboa C><14/12/2015> <Se cambia tipo de dato del codigo de escolariad.> 
-- Modificado por:		<Gerardo><15/12/2015><se modifica para que el codigo Profesion sea smallint> 
-- Modificado por:		<Sigifredo Leiton Luna>
-- Fecha:				<15/12/2015>
-- Descripción:			<Se modifica para que el @CodigoTipoIntervencion sea smallint - item 5999>
-- Modificado por:		<Donald Vargas Zúñiga>
-- Fecha:				<02/12/2016>
-- Descripción:			<Se corrige el nombre de los campos TC_CodTipoIntervencion, TC_CodEstadoCivil, TC_CodProfesion, TC_CodEscolaridad y TC_CodSituacionLaboral a TN_CodTipoIntervencion, TN_CodEstadoCivil, TN_CodProfesion, TN_CodEscolaridad y TN_CodSituacionLaboral de acuerdo al tipo de dato>
-- Modificado por:		<Juan Ramírez><14/01/2019><Se modifica para adaptar a la nueva estructura de intervenciones> 
-- Modificación:		<Jonathan Aguilar Navarro> <31/07/2020> <Se agrega el campo turista>
-- Modificación:		<Jonathan Aguilar Navarro> <03/08/2020> <Se agrega las variables locales>
-- Modificación:		<Jonathan Aguilar Navarro> <11/03/2021> <Se agrgar el campo TC_LugarTrabajo al modificar>
-- =============================================
CREATE PROCEDURE [Expediente].[PA_ModificarInterviniente] 
		  @CodigoInterviniente		uniqueidentifier,
          @CodigoTipoIntervencion	smallint,          
          @CodigoPais				varchar(3)=null,
          @CodigoProfesion			smallint=null,
          @CodigoEscolaridad		smallint=null,        
          @FechaComisionDelito		DateTime2=null,
          @Caracteristicas			varchar(255)=null,
          @CodigoSituacionLaboral	smallint=null,
          @Alias					varchar(50)=null,             
          @Droga					bit=null,
		  @Rebeldia					bit=null,
		  @CodigoParentezco			VARCHAR(2) = null,
		  @Turista					bit = null,
		  @LugarTrabajo				varchar(255)
AS
BEGIN

		Declare @L_CodigoIntervinente		uniqueidentifier	= @CodigoInterviniente
		Declare @L_CodigoPais				varchar(3)			= @CodigoPais
		Declare @L_CodigoProfesion			smallint			= @CodigoProfesion
		Declare @L_CodigoEscolaridad		smallint			= @CodigoEscolaridad
		Declare @L_FechaComisionDelito		Datetime2			= @FechaComisionDelito
		Declare @L_Caracteristicas			varchar(255)		= @Caracteristicas
		Declare	@L_CodigoSituacionLaboral	smallint			= @CodigoSituacionLaboral
		Declare	@L_Alias					varchar(50)			= @Alias
		Declare @L_Droga					bit					= @Droga
		Declare	@L_CodigoTipoIntervencion	smallint			= @CodigoTipoIntervencion
		Declare @L_Rebeldia					bit					= @Rebeldia
		Declare	@L_CodigoParentezco			varchar(2)			= @CodigoParentezco
		Declare	@L_Turista					bit					= @Turista
		Declare	@L_LugarTrabajo				varchar(255)		= @LugarTrabajo
	
	Update	Expediente.Interviniente 
	Set		TN_CodTipoIntervencion			=	@L_CodigoTipoIntervencion,		
			TC_CodPais						=	@L_CodigoPais,
			TN_CodProfesion					=	@L_CodigoProfesion,
			TN_CodEscolaridad				=	@L_CodigoEscolaridad,
			TF_ComisionDelito				=	@L_FechaComisionDelito,
			TC_Caracteristicas				=	@L_Caracteristicas,
			TN_CodSituacionLaboral			=	@L_CodigoSituacionLaboral,
			TC_Alias						=	@L_Alias,				
			TB_Droga						=	@L_Droga,
			TB_Rebeldia						=	@L_Rebeldia,
			TB_Turista						=	@L_Turista,
			TU_CodParentesco				=	@L_CodigoParentezco,
			TC_LugarTrabajo					=	@L_LugarTrabajo,
			TF_Actualizacion                =   GETDATE()
	Where	TU_CodInterviniente		    	=	@L_CodigoIntervinente
	
END


GO
