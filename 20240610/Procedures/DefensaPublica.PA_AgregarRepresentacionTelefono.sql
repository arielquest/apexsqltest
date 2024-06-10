SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Adrián Arias Abarca>
-- Fecha Creación:	<22/10/2019>
-- Descripcion:		<Crear un nuevo registro de tipo teléfono para la Defensa Pública.>
-- =============================================

CREATE Procedure [DefensaPublica].[PA_AgregarRepresentacionTelefono]
	@CodTelefono        uniqueidentifier,	
    @CodTipoTelefono    smallint,
	@CodArea		    varchar(5),
	@Numero				varchar(8),	
	@Extension          varchar(3),
	@SMS				bit,
	@CodRepresentacion	uniqueidentifier
As
Begin
	Insert Into DefensaPublica.RepresentacionTelefono
		(
			TU_CodTelefono,		TN_CodTipoTelefono,		TC_CodArea,				TC_Numero,
			TC_Extension,		TB_SMS,					TU_CodRepresentacion,	TF_Actualizacion
		)
	Values
		(
			@CodTelefono,		@CodTipoTelefono,		@CodArea,				@Numero,
			@Extension,			@SMS,					@CodRepresentacion,		GETDATE()
		)
End
GO
