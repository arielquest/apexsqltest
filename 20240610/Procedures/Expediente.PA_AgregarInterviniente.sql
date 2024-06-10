SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Roger LAra>
-- Fecha Creación:	<11/09/2015>
-- Descripcion:		<Agregar un intervininte a un expediente legajo>
-- Modificado por:	<Gerardo Lopez> <26/10/2015> 	<Se incluye fecha de actualizacion del registro.> 
-- Modificado por:	<Gerardo Lopez> <16/11/2015> 	<Se elimina campo CodigoVulnerabilidad.> 
-- Modificado por:	<Henry Mendez> <23/11/2015> 	<Se elimina campo TC_CodSituacionLibertad y TF_SituacionLibertad.> 
-- Modificado por:	<Johan Acosta> <26/11/2015> 	<Se cambia el nombre del campo observaciones a caracteristicas.> 
-- Modificado por:	<Alejandro Villalta><03/12/2015> <Se cambia elimina el campo observaciones discapacidad.> 
-- Modificado por:	<Alejandro Villalta><10/12/2015> <Se cambia el tipo de dato del codigo de situación laboral.> 
-- Modificado por:	<Olger Gamboa><14/12/2015><se modifica para que el @CodEscolaridad sea smallint> 
-- Modificado por:	<Gerardo><15/12/2015><se modifica para que el @CodigoProfesion sea smallint> 
-- Modificado por:	<Sigifredo Leiton Luna>
-- Fecha:			<15/12/2015>
-- Descripción:		<Se modifica para que el @CodigoTipoIntervencion sea smallint - item 5999>
-- Modificado por:	<Donald Vargas Zúñiga>
-- Fecha:			<02/12/2016>
-- Descripción:		<Se corrige el nombre de los campos TC_CodTipoIntervencion, TC_CodEstadoCivil, TC_CodProfesion, TC_CodEscolaridad y TC_CodSituacionLaboral a TN_CodTipoIntervencion, TN_CodEstadoCivil, TN_CodProfesion, TN_CodEscolaridad y TN_CodSituacionLaboral de acuerdo al tipo de dato>
-- Modificación:	<Jonathan Aguilar Navarro> <31/07/2020> <Se agrega el campo turista>
-- Modificación:	<Jonathan Aguilar Navarro> <03/08/2020> <Se agrega variables loales>
-- Modificación:	<Jonathan Aguilar Navarro> <11/03/2021> <Se agrega el campo TC_LugarTrabajo al insert>
-- =============================================
CREATE PROCEDURE [Expediente].[PA_AgregarInterviniente] 
		@CodigoInterviniente	uniqueidentifier,
		@CodigoPais				varchar(3)=null,
		@CodigoProfesion		smallint=null,
		@CodigoEscolaridad		smallint=null,
		@FechaComisionDelito	DateTime2=null,
		@Caracteristicas		varchar(255)=null,
		@CodigoSituacionLaboral	smallint=null,
		@Alias					varchar(50)=null,  
		@Droga					bit=null,
		@FechaActualizacion		DateTime2=null,
		@CodigoTipoIntervencion	smallint,
		@Rebeldia				bit=null,
		@CodigoParentezco		VARCHAR(2)=null,
		@Turista				bit = NULL,
		@LugarTrabajo			varchar(255) = null
AS
BEGIN
	Declare @L_CodigoIntevinente		uniqueidentifier	= @CodigoInterviniente
	Declare @L_CodigoPais				varchar(3)			= @CodigoPais
	Declare @L_CodigoProfesion			smallint			= @CodigoProfesion
	Declare @L_CodigoEscolaridad		smallint			= @CodigoEscolaridad
	Declare @L_FechaComisionDelito		Datetime2			= @FechaComisionDelito
	Declare @L_Caracteristicas			varchar(255)		= @Caracteristicas
	Declare	@L_CodigoSituacionLaboral	smallint			= @CodigoSituacionLaboral
	Declare	@L_Alias					varchar(50)			= @Alias
	Declare @L_Droga					bit					= @Droga
	Declare @L_FechaActualizacion		Datetime2			= @FechaActualizacion;
	Declare	@L_CodigoTipoIntervencion	smallint			= @CodigoTipoIntervencion
	Declare @L_Rebeldia					bit					= @Rebeldia
	Declare	@L_CodigoParentezco			varchar(2)			= @CodigoParentezco
	Declare	@L_Turista					bit					= @Turista
	Declare	@L_LugarTrabajo				varchar(255)		= @LugarTrabajo



	INSERT INTO Expediente.Interviniente
	(
		TU_CodInterviniente,	TC_CodPais,	
		TN_CodProfesion,		TN_CodEscolaridad,								
		TF_ComisionDelito,		TC_Caracteristicas,				TN_CodSituacionLaboral,	
		TC_Alias,				TB_Droga,						TF_Actualizacion,
		TN_CodTipoIntervencion,	TB_Rebeldia,					TB_Turista,	
		TU_CodParentesco,		TC_LugarTrabajo
	)
	VALUES
	(
		@L_CodigoIntevinente,		@L_CodigoPais,			
		@L_CodigoProfesion,			@L_CodigoEscolaridad,						  
		@L_FechaComisionDelito,		@L_Caracteristicas,				@L_CodigoSituacionLaboral,			
		@L_Alias, 					@L_Droga,						@L_FechaActualizacion,
		@L_CodigoTipoIntervencion,	@L_Rebeldia,					@L_Turista,
		@L_CodigoParentezco,		@L_LugarTrabajo
	)
	
END


GO
