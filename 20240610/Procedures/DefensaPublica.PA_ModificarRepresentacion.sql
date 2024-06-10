SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<30/08/2019>
-- Descripción :			<Permite modificar los datos de una representación>
-- Modificación:			<21/06/2021><Roger Lara><Se actualiza para que permita modificar el codigo de la persona>
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_ModificarRepresentacion]
	@CodRepresentacion		uniqueidentifier,
	@NRD					varchar(14),
	@CodPersona				uniqueidentifier,	
	@CodPais				varchar(3)	= null,
	@Alias					varchar(50) = null,
	@CodEstadoCivil			smallint	= null,
	@CodSexo				char(1)		= null,
	@CodProfesion			smallint	= null,
	@CodSituacionLaboral	smallint	= null,
	@CodEscolaridad			smallint	= null,
	@LugarTrabajo			varchar(255) = null,
	@Descripcion			varchar(255) = null				
As
Begin
	Update	DefensaPublica.Representacion
	Set		TU_CodPersona			=	@CodPersona,
			TC_CodPais				=	@CodPais,
			TC_Alias				=	@Alias,
			TN_CodEstadoCivil		=	@CodEstadoCivil,
			TC_CodSexo				=	@CodSexo,
			TN_CodProfesion			=	@CodProfesion,
			TN_CodSituacionLaboral	=	@CodSituacionLaboral,
			TN_CodEscolaridad		=	@CodEscolaridad,
			TC_LugarTrabajo			=	@LugarTrabajo,
			TC_Descripcion			=	@Descripcion,
			TF_Actualizacion		=	GETDATE()
	Where	TU_CodRepresentacion	=	@CodRepresentacion
	And		TC_NRD					=	@NRD
End
GO
